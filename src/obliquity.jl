# This file is a part of AstroLib.jl. License is MIT "Expat".

"""
    obliquity(jd) -> eps

### Purpose ###

Return the obliquity of the ecliptic for a given Julian date

### Explanation ###

The function is used by the [co_nutate](@ref) and [co_aberration](@ref)
procedures.

### Arguments ###

* `jd`: julian date, scalar

### Output ###

* `eps`: obliquity of the ecliptic, in radians

### Example ###

```julia
julia> obliquity(jdcnv(1978,01,7,11, 01))
0.40909538962120523
```

### Notes ###

Code of this function is based on IDL Astronomy User's Library.

The algorithm used to find the mean obliquity is mentioned in
USNO Circular 179, but the canonical reference for the IAU adoption
is apparently Hilton et al., 2006, Celest.Mech.Dyn.Astron. 94, 351. 2000

"""
function obliquity(jd::Real)
    t = (jd - J2000) / (JULIANYEAR * 100)
    eps0 = @evalpoly t 84381.406 -46.836769 -0.0001831 0.0020034 0.567e-6 4.34e-8
    eps = sec2rad(eps0 + nutate(jd)[2])
    return eps
end
