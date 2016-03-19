# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

"""
    aitoff(l, b) -> x, y

### Purpose ###

Convert longitude `l` and latitude `b` to `(x, y)` using an Aitoff projection.

### Explanation ###

This function can be used to create an all-sky map in Galactic coordinates with
an equal-area Aitoff projection.  Output map coordinates are zero longitude
centered.

### Arguments ###

* `l`: longitude, scalar or vector, in degrees.
* `b`: latitude, number of elements as `l`, in degrees.

Coordinates can be given also as a 2-tuple `(l, b)`.

### Output ###

2-tuple `(x, y)`.

* `x`: x coordinate, same number of elements as `l`.  `x` is normalized to be in
  \$[-180, 180]\$.
* `y`: y coordinate, same number of elements as `l`.  `y` is normalized to be in
  \$[-90, 90]\$.

### Example ###

``` julia
julia> x, y = aitoff(375, 2.437)
(16.63760711611838,2.712427279646118)
```

### Notes ###

See AIPS memo No. 46
(ftp://ftp.aoc.nrao.edu/pub/software/aips/TEXT/PUBL/AIPSMEMO46.PS), page 4, for
details of the algorithm.  This version of `aitoff` assumes the projection is
centered at b=0 degrees.

Code of this function is based on IDL Astronomy User's Library.
"""
function aitoff(l::AbstractFloat, b::AbstractFloat)
    l > 180.0 && (l -= 360.0)
    alpha2 = deg2rad(l/2.0)
    delta = deg2rad(b)
    r2 = sqrt(2.0)
    f = 2.0*r2/pi
    cdec = cos(delta)
    denom = sqrt(1.0 + cdec*cos(alpha2))
    return rad2deg(cdec*sin(alpha2)*2.0*r2/denom/f), rad2deg(sin(delta)*r2/denom/f)
end

aitoff(l::Real, b::Real) = aitoff(promote(float(l), float(b))...)

aitoff(lb::Tuple{Real, Real}) = aitoff(lb...)

function aitoff{L<:Real,B<:Real}(l::AbstractArray{L}, b::AbstractArray{B})
    @assert length(l) == length(b)
    x = similar(l, AbstractFloat)
    y = similar(b, AbstractFloat)
    for i in eachindex(l)
        x[i], y[i] = aitoff(l[i], b[i])
    end
    return x, y
end
