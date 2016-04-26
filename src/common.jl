# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

"""
List of Solar System planets and their equatorial and polar radii.

The key is the lower case of a Solar System planet, from "mercury" to "pluto",
the corresponding value is an array with the equatorial radius of the planet as
first element and its polar radius as second one.

Values from "Allen's Astrophysical Quantities", Fourth Ed., (2000).
"""
const PLANETSRADII = Dict("mercury"=>[ 2439.7,    2439.7],
                          "venus"=>  [ 6051.8,    6051.8],
                          "earth"=>  [ 6378.137,  6356.752],
                          "mars"=>   [ 3397.62,   3379.3845],
                          "jupiter"=>[71492.0,   67136.5562],
                          "saturn"=> [60268.0,   54890.7686],
                          "uranus"=> [25559.0,   24986.1354],
                          "neptune"=>[24764.0,   24347.6551],
                          "pluto"=>  [ 1195.0,    1195.0])

"""
List of locations of North Magnetic Pole since 1590.

This is provided by World Magnetic Model
(https://www.ngdc.noaa.gov/geomag/data/poles/NP.xy).
"""
POLELATLONG = Dict{AbstractFloat,Tuple{AbstractFloat,AbstractFloat}}()
let
    local polelatlong, rows
    polelatlong = readdlm(joinpath(dirname(@__FILE__), "..", "deps", "NP.xy"))
    rows = size(polelatlong, 1)
    for i = 1:rows
        merge!(POLELATLONG, Dict(polelatlong[2rows + i]=>
                                 (polelatlong[rows + i], polelatlong[i])))
    end
end
