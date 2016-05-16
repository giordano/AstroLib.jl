# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

module AstroLib
using Compat
using Base.Dates
import Compat.String

# Core functions
include("misc.jl")
include("utils.jl")
# New types
include("types.jl")
# Common constants
include("common.jl")

end # module
