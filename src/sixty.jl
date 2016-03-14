# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

# This function is based on IDL Astronomy User's Library.

"""
    sixty(number::Number) -> [deg::Float64, min::Float64, sec::Float64]

Converts a decimal number to sexagesimal.

This is the reverse of `ten`.
"""
# XXX: trailsign keyword not implemented, not sure it's worth the effort.
# Possible strategy: hold the sign of number in a variable (you can use
# copysign(1, number)), set result[1] equal to dd and multiply the first
# non-zero element (use findfirst for that) by the sign of number.
function sixty(number::Number)
    dd = trunc(abs(number))
    mm = abs(60.0*number)
    ss = abs(3600.0*number)
    result = zeros(Float64, 3)
    result[1] = trunc(number)
    result[2] = trunc(mm - 60.0*dd)
    result[3] = ss - 3600.0*dd - 60.0*result[2]
    return result
end
