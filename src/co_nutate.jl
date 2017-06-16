# This file is a part of AstroLib.jl. License is MIT "Expat".

function _co_nutate{T<:AbstractFloat}(jd::T, ra::T, dec::T)
    

end

"""
    co_nutate()

### Purpose ###

Calculate changes in RA and Dec due to nutation of the
Earth's rotation

### Explanation ###

Calculates necessary changes to ra and dec due to the nutation of the Earth's rotation
axis, as described in Meeus, Chap 23. Uses formulae from Astronomical Almanac, 1984,
and does the calculations in equatorial rectangular coordinates to avoid singularities
at the celestial poles.

### Arguments ###

* `jd`: julian date, scalar or vector
* `ra`: right ascension in degrees, scalar or vector
* `dec`: declination in degrees, scalar or vector

### Output ###

The 5-tuple `(d_ra, d_dec, eps, d_psi, d_eps)`:

* `d_ra`: correction to right ascension due to nutation
* `d_dec`: correction to declination due to nutation
* `eps`: the obliquity of the ecliptic
* `d_psi`: nutation in the longitude of the ecliptic
* `d_eps`: nutation in the obliquity of the ecliptic

### Example ###

```julia

```

### Notes ###

Code of this function is based on IDL Astronomy User's Library.

This function calls [nutate](@ref).
"""
