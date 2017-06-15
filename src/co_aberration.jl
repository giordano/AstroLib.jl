# This file is a part of AstroLib.jl. License is MIT "Expat".

function _co_aberration{T<:AbstractFloat}(jd::T, ra::T, dec::T, eps::T)
    t = (jd -2451545)/36525
    if isnan(eps)
        eps0 = ten(23,26,21.448)*3600 - 46.815*t - 0.00058*(t^2) +
               0.001813*(t^3)
        eps = sec2rad(eps0 + nutate(jd)[2])
    end
    sunlong = T(sunpos(jd, radians=true)[3])
    e = 0.016708634 - 0.000042037*t - 0.0000001267*(t^2)
    pe = 102.93735 + 1.71946*t + 0.00046*(t^2)
    cd = cosd(dec)
    sd = sind(dec)
    ce = cos(eps)
    te = tan(eps)
    cp = cosd(pe)
    sp = sind(pe)
    cs = cos(sunlong)
    ss = sin(sunlong)
    ca = cosd(ra)
    sa = sind(ra)
    t1 = (cs*ce*(te*cd - sa*sd) + ca*sd*ss)
    t2 = (cp*ce*(te*cd - sa*sd) + ca*sd*sp)
    d_ra = 20.49552*(e*(ca*cp*ce + sa*sp) - ca*cs*ce - sa*ss)/cd
    d_dec = 20.49552*(e*t2 - t1)
    return d_ra, d_dec
end

"""


### Purpose ###

Calculate changes to right ascension and declination due to the effect
of annual aberration

### Explanation ###

With reference to Meeus, Chapter 23

### Arguments ###

* `jd`: julian date, scalar or vector
* `ra`: right ascension in degrees, scalar or vector
* `dec`: declination in degrees, scalar or vector
* `eps` (optional): true obliquity of the ecliptic (in radians). It will be
  calculated if no argument is specified.

### Output ###

The 2-tuple `(d_ra, d_dec)`:

* `d_ra`: correction to right ascension due to aberration, in arc seconds
* `d_dec`: correction to declination due to aberration, in arc seconds

### Example ###

Compute the change in RA and Dec of Theta Persei (RA = 2h46m,11.331s, Dec = 49d20',54.5'')
due to aberration on 2028 Nov 13.19 TD

```julia
julia> jd = jdcnv(2028,11,13,4, 56)
2.4620887055555554e6

julia> co_aberration(jd,ten(2,46,11.331)*15,ten(49,20,54.54))
(30.044044923858255, 6.699402837501943)

d_ra = 30.044044923858255'' (≈ 2.003s)
d_dec = 6.699402837501943''
```

### Notes ###

Code of this function is based on IDL Astronomy User's Library.

The output d_ra is *not* multiplied by cos(dec), so that
apparent_ra = ra + d_ra/3600.

These formula are from Meeus, Chapters 23.  Accuracy is much better than 1
arcsecond. The maximum deviation due to annual aberration is 20.49'' and occurs when the
Earth's velocity is perpendicular to the direction of the star.

This function calls [nutate](@ref), [ten](@ref) and [sunpos](@ref).
"""
co_aberration(jd::Real, ra::Real, dec::Real; eps::Real=NaN) =
    _co_aberration(promote(float(jd), float(ra), float(dec), float(eps))...)

function co_aberration{R<:Real}(jd::AbstractVector{R}, ra::AbstractVector{R},
                                dec::AbstractVector{R}; eps::Real=NaN)
    @assert length(jd) == length(ra) == length(dec) "jd, ra and dec vectors should be of the same length"
    typejd = typeof(float(one(R)))
    ra_out  = similar(ra,  typejd)
    dec_out = similar(dec, typejd)
    for i in eachindex(jd)
        ra_out[i], dec_out[i] = co_aberration(jd[i], ra[i], dec[i], eps=eps)
    end
    return ra_out, dec_out
end
