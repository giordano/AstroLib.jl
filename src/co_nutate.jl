# This file is a part of AstroLib.jl. License is MIT "Expat".

function _co_nutate(jd::T, ra::T, dec::T) where {T<:AbstractFloat}
    t = (jd - J2000) / (JULIANYEAR*100)
    d_psi, d_eps = nutate(jd)
    eps0 = @evalpoly t 84381.406 -46.836769 -0.0001831 0.0020034 -0.576e-6 -4.34e-8
    eps = sec2rad(eps0 + d_eps)
    ce = cos(eps)
    se = sin(eps)
    x = cosd(ra) * cosd(dec)
    y = sind(ra) * cosd(dec)
    z = sind(dec)
    x2 = x - sec2rad(y * ce + z * ce) * d_psi
    y2 = y + sec2rad(x * ce * d_psi - z * d_eps)
    z2 = z + sec2rad(x * se * d_psi + y * d_eps)
    r = sqrt(x2^2 + y2^2 + z2^2)
    xyproj = sqrt(x2^2 + y2^2)
    ra2 = atan2(y2, x2)
    dec2 = asin(z2/r)
    ra2 = rad2deg(ra2)

    if ra2 < 0
        ra2 += 360
    end
    d_ra = ra2 - ra
    d_dec = rad2deg(dec2) - dec
    return d_ra, d_dec, eps, d_psi, d_eps
end

"""
    co_nutate(jd, ra, dec) -> d_ra, d_dec, eps, d_psi, d_eps

### Purpose ###

Calculate changes in RA and Dec due to nutation of the
Earth's rotation

### Explanation ###

Calculates necessary changes to ra and dec due to the nutation of the
Earth's rotation axis, as described in Meeus, Chap 23. Uses formulae
from Astronomical Almanac, 1984, and does the calculations in equatorial
rectangular coordinates to avoid singularities at the celestial poles.

### Arguments ###

* `jd`: julian date, scalar or vector
* `ra`: right ascension in degrees, scalar or vector
* `dec`: declination in degrees, scalar or vector

### Output ###

The 5-tuple `(d_ra, d_dec, eps, d_psi, d_eps)`:

* `d_ra`: correction to right ascension due to nutation, in degrees
* `d_dec`: correction to declination due to nutation, in degrees
* `eps`: the true obliquity of the ecliptic
* `d_psi`: nutation in the longitude of the ecliptic
* `d_eps`: nutation in the obliquity of the ecliptic

### Example ###

Example 23a in Meeus: On 2028 Nov 13.19 TD the mean position of Theta
Persei is 2h 46m 11.331s 49d 20' 54.54''. Determine the shift in
position due to the Earth's nutation.

```julia
julia> jd = jdcnv(2028,11,13,4,56)
2.4620887055555554e6

julia> co_nutate(jd,ten(2,46,11.331)*15,ten(49,20,54.54))
(0.006058053578186673, 0.002650870610381162, 0.40904016038217567,
 14.8593894278967, 2.7038090372351267)
```

### Notes ###

Code of this function is based on IDL Astronomy User's Library.

This function calls [obliquity](@ref).
"""
co_nutate(jd::Real, ra::Real, dec::Real) =
    _co_nutate(promote(float(jd), float(ra), float(dec))...)

function co_nutate(jd::AbstractVector{R}, ra::AbstractVector{R},
                   dec::AbstractVector{R}) where {R<:Real}
    @assert length(jd) == length(ra) == length(dec) "jd, ra and dec vectors
                                                     should be of the same length"
    typejd = float(R)
    ra_out  = similar(jd,  typejd)
    dec_out = similar(dec, typejd)
    eps_out = similar(dec, typejd)
    d_psi_out = similar(dec, typejd)
    d_eps_out = similar(dec, typejd)
    for i in eachindex(jd)
        ra_out[i], dec_out[i],eps_out[i], d_psi_out[i], d_eps_out[i]  =
        co_nutate(jd[i], ra[i], dec[i])
    end
    return ra_out, dec_out, eps_out, d_psi_out, d_eps_out
end