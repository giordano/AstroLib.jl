# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

"""
    gcirc(units, ra1, dec1, ra2, dec2) -> angular_distance

### Purpose ###

Computes rigorous great circle arc distances.

### Explanation ###

Input position can be either radians, sexagesimal right ascension and
declination, or degrees.

### Arguments ###

* `units`: integer, can be either 0, or 1, or 2.  Describes units of inputs and
 output:
    * 0: everything (input right ascensions and declinations, and output
      distance) is radians
    * 1: right ascensions are in decimal hours, declinations in decimal degrees,
      output distance in arc seconds
    * 2: right ascensions and declinations are in degrees, output distance in arc
      seconds
* `ra1`:  right ascension or longitude of point 1
* `dec1`: declination or latitude of point 1
* `ra2`: right ascension or longitude of point 2
* `dec2`: declination or latitude of point 2

Both `ra1` and `dec1`, and `ra2` and `dec2` can be given as 2-tuples `(ra1,
dec1)` and `(ra2, dec2)`.

### Output ###

Angular distance on the sky between points 1 and 2, as a `AbstractFloat`.  See
`units` argument above for the units.

### Method ###

"Haversine formula" see http://en.wikipedia.org/wiki/Great-circle_distance.

### Example ###

``` julia
julia> gcirc(0, 120, -43, 175, +22)
1.590442261600714
```

### Notes ###

* If `ra1`, `dec1` are scalars, and `ra2`, `dec2` are vectors, then the output
 is a vector giving the distance of each element of `ra2`, `dec2` to `ra1`,
 `dec1`.  Similarly, if `ra1`,`de1` are vectors, and `ra2`,` dec2` are scalars,
 then the output is a vector giving the distance of each element of `ra1`,
 `dec1` to `ra2`, `dec2`.  If both `ra1`, `dec1` and `ra2`, `dec2` are vectors
 then the output is a vector giving the distance of each element of `ra1`,
 `dec1` to the corresponding element of `ra2`, `dec2`.
* The function `sphdist` provides an alternate method of computing a spherical
 distance.
* The Haversine formula can give rounding errors for antipodal points.

Code of this function is based on IDL Astronomy User's Library.
"""
function gcirc(units::Integer, ra1::AbstractFloat, dec1::AbstractFloat,
               ra2::AbstractFloat, dec2::AbstractFloat)
    # Convert all quantities to radians.
    if units == 0
        # All radians
        ra1_rad  = ra1
        ra2_rad  = ra2
        dec1_rad = dec1
        dec2_rad = dec2
    elseif units == 1
        # Right ascensions are in hours, declinations in degrees.
        ra1_rad  = ra1*pi/12.0
        ra2_rad  = ra2*pi/12.0
        dec1_rad = deg2rad(dec1)
        dec2_rad = deg2rad(dec2)
    elseif units == 2
        # Right ascensions and declinations are in degrees.
        ra1_rad  = deg2rad(ra1)
        ra2_rad  = deg2rad(ra2)
        dec1_rad = deg2rad(dec1)
        dec2_rad = deg2rad(dec2)
    else
        # In any other case throw an error.
        error("units must be 0 (radians), 1 (hours, degrees) or 2 (degrees)")
    end
    deldec2 = (dec2_rad - dec1_rad)/2.0
    delra2  = (ra2_rad - ra1_rad)/2.0
    sindist = sqrt(sin(deldec2)*sin(deldec2) +
                   cos(dec1_rad)*cos(dec2_rad)*sin(delra2)*sin(delra2))
    if units == 0
        return 2.0*asin(sindist)
    else
        return 2.0*asin(sindist)*648000.0/pi
    end
end

gcirc(units::Integer, ra1::Real, dec1::Real, ra2::Real, dec2::Real) =
    gcirc(units, promote(float(ra1), float(dec1), float(ra2), float(dec2))...)

function gcirc{R1<:Real, D1<:Real}(units::Integer,
                                       ra1::AbstractArray{R1},
                                       dec1::AbstractArray{D1},
                                       ra2::Real,
                                       dec2::Real)
    @assert length(ra1) == length(dec1)
    dist = similar(ra1, typeof(float(one(R1))))
    for i in eachindex(ra1)
        dist[i] = gcirc(units, ra1[i], dec1[i], ra2, dec2)
    end
    return dist
end

function gcirc{R2<:Real, D2<:Real}(units::Integer,
                                       ra1::Real,
                                       dec1::Real,
                                       ra2::AbstractArray{R2},
                                       dec2::AbstractArray{D2})
    @assert length(ra2) == length(dec2)
    dist = similar(ra2, typeof(float(one(R2))))
    for i in eachindex(ra1)
        dist[i] = gcirc(units, ra1, dec1, ra2[i], dec2[i])
    end
    return dist
end

function gcirc{R1<:Real, D1<:Real, R2<:Real, D2<:Real}(units::Integer,
                                                       ra1::AbstractArray{R1},
                                                       dec1::AbstractArray{D1},
                                                       ra2::AbstractArray{R2},
                                                       dec2::AbstractArray{D2})
    @assert length(ra1) == length(dec1) == length(ra2) == length(dec2)
    dist = similar(ra1, typeof(float(one(R1))))
    for i in eachindex(ra1)
        dist[i] = gcirc(units, ra1[i], dec1[i], ra2[i], dec2[i])
    end
    return dist
end

### Tuples input
gcirc(units::Integer, radec1::Tuple{Real, Real}, ra2::Real, dec2::Real) =
    gcirc(units, radec1..., ra2, dec2)

gcirc(units::Integer, ra1::Real, dec1::Real, radec2::Tuple{Real, Real}) =
    gcirc(units, ra1, dec1, radec2...)

gcirc(units::Integer, radec1::Tuple{Real, Real}, radec2::Tuple{Real, Real}) =
    gcirc(units, radec1..., radec2...)
