# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

# This function is based on IDL Astronomy User's Library.

# TODO: give sense to "-0" ("-0" is bitwise equal to "0").
ten(degrees::Number, minutes::Number=0.0, seconds::Number=0.0) =
    copysign(1, degrees)*(abs(degrees) + minutes/60.0 + seconds/3600.0)
# TODO: improve performance, if possible.  There are a couple of slow tests to
# make parsing of the string work.
function ten(strng::AbstractString)
    # Convert strings into numbers, empty strings into 0s.
    tmp = map(x-> x=="" ? 0 : parse(Float64, x),
              # Replace in the string multiple spaces or colons with a single
              # space and split the string using the space as separator.
              split(replace(strng, r"(\:| )+", s" "), " "))
    # Concatenate "tmp" with 3 zeros, so that "angle" has at least 3 elements
    # also with an empty string in input.
    angle = vcat(tmp, zeros(Float64, 3))
    ten(angle[1], angle[2], angle[3])
end
function ten{T<:Number}(vector::AbstractArray{T,1})
    vect = vcat(vector, zeros(Float64, 2))
    return ten(vect[1], vect[2], vect[3])
end
tenv{D<:Number,M<:Number,S<:Number}(deg::AbstractArray{D},
                                   min::AbstractArray{M}=zeros(Float64, deg),
                                   sec::AbstractArray{S}=zeros(Float64, deg)) =
                                       map(ten, deg, min, sec)
tenv{T<:AbstractString}(strings::AbstractArray{T}) = map(ten, strings)

"""
    ten(deg[, min, sec]) -> Float64
    ten("deg:min:sec") -> Float64
    tenv([deg], [min], [sec]) -> Float64
    tenv(["deg:min:sec"]) -> Float64

Converts a sexagesimal number or string to decimal.

The formula used for the conversion is

    sign(deg)·(|deg| + min/60 + sec/3600))

`ten` requires `deg`, `min`, and `sec` to be all scalars.  Also a one
dimensional array `[deg, min, sec]` is accepted.

The string should have the form `"deg:min:sec"` or `"deg min sec"`.

If minutes and seconds are not specified they default to zero.

`tenv` is the vectorial version of `ten`, it takes as input three numerical
arrays of numbers (minutes and seconds arrays default to null arrays if omitted)
or one array of strings.

`sixty` is the reverse of `ten`.

**NOTE:** These functions cannot deal with `-0` (negative integer zero) in
numeric input.  If it is important to give sense to negative zero, you can
either make sure to pass a floating point negative zero `-0.0` (this is the best
option), or use negative minutes and seconds, or non-integer negative degrees
and minutes.
"""
ten, tenv
