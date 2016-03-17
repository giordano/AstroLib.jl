# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

"""
    polrec(radius, angle[, degrees=true]) -> Float64, Float64

### Purpose ###

Convert 2D polar coordinates to rectangular coordinates.

### Arguments ###

* `radius`: radial coordinate of the point.  It may be a scalar or an array.
* `angle`: the angular coordinate of the point.  It may be a scalar or an array
  of the same lenth as `radius`.
* `degrees` (optional boolean keyword): if `true`, the `angle` is assumed to be
  in degrees, otherwise in radians.  It defaults to `false`.

### Output ###

A 2-tuple `(x, y)` with the rectangular coordinate of the input.  If `radius`
and `angle` are arrays, `x` and `y` are arrays of the same length as `radius`
and `angle`.
"""
function polrec(radius::Number, angle::Number; degrees::Bool=false)
    if degrees
        return radius*cos(deg2rad(angle)), radius*sin(deg2rad(angle))
    else
        return radius*cos(angle), radius*sin(angle)
    end
end

function polrec{R<:Number, A<:Number}(r::AbstractArray{R}, a::AbstractArray{A};
                                      degrees::Bool=false)
    @assert length(r) == length(a)
    x = similar(r, Float64)
    y = similar(a, Float64)
    for i in eachindex(r)
        x[i], y[i] = polrec(r[i], a[i], degrees=degrees)
    end
    return x, y
end
