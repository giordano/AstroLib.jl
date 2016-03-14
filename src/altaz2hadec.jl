# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

# This function is based on IDL Astronomy User's Library.

"""
    altaz2hadec(alt, az, lat) -> (Float64, Float64)

Convert Horizon (Alt-Az) coordinates to Hour Angle and Declination.

Input coordinates may be either a scalar or an array, of the same dimension N,
the output coordinates are always Float64 and have the same type (scalar or
array) as the input coordinates.

INPUTS
  alt - the local apparent altitude, in DEGREES, scalar or vector
  az  - the local apparent azimuth, in DEGREES, scalar or vector,
        measured EAST of NORTH!!!  If you have measured azimuth west-of-south
        (like the book MEEUS does), convert it to east of north via:
                      az = (az + 180) % 360

  lat -  the local geodetic latitude, in DEGREES, scalar or vector.

OUTPUTS
  ha  -  the local apparent hour angle, in DEGREES.  The hour angle is the
         time that right ascension of 0 hours crosses the local meridian.
         It is unambiguously defined.
  dec -  the local apparent declination, in DEGREES.
"""
function altaz2hadec(alt::Number, az::Number, lat::Number)
    # Convert to radians.
    alt_r = deg2rad(alt)
    az_r = deg2rad(az)
    lat_r = deg2rad(lat)
    # Find local hour angle (in degrees, from 0. to 360.).
    ha = rad2deg(atan2(-sin(az_r)*cos(alt_r),
                       -cos(az_r)*sin(lat_r)*cos(alt_r) +
                       sin(alt_r)*cos(lat_r)))
    ha < 0.0 && (ha += 360.0)
    ha = ha.%360.0
    # Find declination (positive if north of Celestial Equator, negative if
    # south)
    sindec = sin(lat_r)*sin(alt_r) + cos(lat_r)*cos(alt_r)*cos(az_r)
    dec = rad2deg(asin(sindec))  # convert dec to degrees
    return ha, dec
end
function altaz2hadec{N1<:Number, N2<:Number, N3<:Number}(alt::AbstractArray{N1},
                                                         az::AbstractArray{N2},
                                                         lat::AbstractArray{N3})
    @assert length(alt) == length(az) == length(lat)
    ha  = similar(alt, Float64)
    dec = similar(alt, Float64)
    for i in eachindex(alt)
        ha[i], dec[i] = altaz2hadec(alt[i], az[i], lat[i])
    end
    return ha, dec
end
