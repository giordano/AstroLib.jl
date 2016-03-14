# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

# This function is based on IDL Astronomy User's Library.

"""
    daycnv(julian_days) -> DateTime

Takes the number of Julian calendar days since epoch `-4713-11-24T12:00:00` and
returns the corresponding `DateTime` using proleptic Gregorian Calendar.

`jdcnv` is the inverse of this function.
"""
const daycnv=Dates.julian2datetime
