# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

# Test cirrange
@test AstroLib.cirrange(12345) == 105.0
@test AstroLib.cirrange([3.0*e, 10, -86.95, 6.0*pi], 2.0*pi) ==
    [1.8716601781975495, 3.7168146928204138, 1.0145943005142044, 0.0]

