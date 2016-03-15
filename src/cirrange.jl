# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

"""
    cirrange(number::Number[, max=2.0*pi]) -> Float64

### Purpose ###

Force a number into a given range `[0, max)`.

### Argument ###

* `number`: the number to modify.  Can be a scalar or an array.
* `max` (optional numerical keyword): specify the extremum of the range `[0, max)`
 into which the number should be restricted.  If omitted, defaults to `360.0`.

### Output ###

The converted number or array of numbers, as `Float64`.

### Example ###

Restrict an array of numbers in the range `[0, 2pi)` as if they are angles
expressed in radians:

``` julia
julia> cirrange([4pi, 10, -5.23], max=2.0*pi)
3-element Array{Float64,1}:
 0.0
 3.71681
 1.05319
```

### Notes ###

This function does not support the `radians` keyword like IDL implementation.
Use `max=2.0*pi` to restrict a number to the same interval.

Code of this function is based on IDL Astronomy User's Library.
"""
function cirrange(number::Number; max::Number=360.0)
    # Deal with the lower limit.
    result = mod(number, max)
    # Deal with negative values, if any
    return result < 0.0 ? (result + max) : result
end

function cirrange{N<:Number}(numbers::AbstractArray{N}; max::Number=360.0)
    result = similar(numbers, Float64)
    for i in eachindex(numbers)
        result[i] = cirrange(numbers[i], max=max)
    end
    return result
end
