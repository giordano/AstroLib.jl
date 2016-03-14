# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

# This function is based on IDL Astronomy User's Library.

"""
    get_juldate() --> Float64

Return for current time the number of Julian calendar days since epoch
`-4713-11-24T12:00:00` as a `Float64`.
"""
get_juldate() = jdcnv(Dates.now())
