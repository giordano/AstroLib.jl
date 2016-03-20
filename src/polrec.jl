# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

"""
    polrec(radius, angle[, degrees=true]) -> x, y

### Purpose ###

Convert 2D polar coordinates to rectangular coordinates.

### Explanation ###

This is the partial inverse function of `recpol`.

### Arguments ###

* `radius`: radial coordinate of the point.  It may be a scalar or an array.
* `angle`: the angular coordinate of the point.  It may be a scalar or an array
  of the same lenth as `radius`.
* `degrees` (optional boolean keyword): if `true`, the `angle` is assumed to be
  in degrees, otherwise in radians.  It defaults to `false`.

Mandatory arguments can also be passed as the 2-tuple `(radius, angle)`, so that
it is possible to execute `recpol(polrec(radius, angle))`.

### Output ###

A 2-tuple `(x, y)` with the rectangular coordinate of the input.  If `radius`
and `angle` are arrays, `x` and `y` are arrays of the same length as `radius`
and `angle`.

### Example ###

Get rectangular coordinates \$(x, y)\$ of the point with polar coordinates \$(r,
\varphi) = (1.7, 227)\$, with angle \$\varphi\$ expressed in degrees.

``` julia
julia> x, y = polrec(1.7, 227, degrees=true)
(-1.1593972121062475,-1.2433012927525897)
```

"""
function polrec(radius::AbstractFloat, angle::AbstractFloat; degrees::Bool=false)
    if degrees
        return radius*cos(deg2rad(angle)), radius*sin(deg2rad(angle))
    else
        return radius*cos(angle), radius*sin(angle)
    end
end

polrec(radius::Real, angle::Real; degrees::Bool=false) =
    polrec(promote(float(radius), float(angle))..., degrees=degrees)

polrec(r_a::Tuple{Real, Real}; degrees::Bool=false) = polrec(r_a...,
                                                             degrees=degrees)

function polrec{R<:Real, A<:Real}(r::AbstractArray{R}, a::AbstractArray{A};
                                  degrees::Bool=false)
    @assert length(r) == length(a)
    x = similar(r, AbstractFloat)
    y = similar(a, AbstractFloat)
    for i in eachindex(r)
        x[i], y[i] = polrec(r[i], a[i], degrees=degrees)
    end
    return x, y
end
