# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

using AstroLib

if isdefined(Base, :Test) && !Base.isdeprecated(Base, :Test)
    using Base.Test
else
    using Test
end

include("utils-tests.jl")
include("misc-tests.jl")

# Dummy calls to "show" for new data types, just to increase code coverage.
show(DevNull, AstroLib.planets["mercury"])
show(DevNull, AstroLib.observatories["ca"])
show(DevNull, AstroLib.observatories["vbo"])
