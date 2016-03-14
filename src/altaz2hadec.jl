# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

"""
    altaz2hadec(alt, az, lat) -> (Float64, Float64)

### Purpose ###

Convert Horizon (Alt-Az) coordinates to Hour Angle and Declination.

### Explanation ###

Can deal with the NCP singularity.  Intended mainly to be used by program
`hor2eq`.

### Arguments ###

Input coordinates may be either a scalar or an array, of the same dimension N,
the output coordinates are always Float64 and have the same type (scalar or
array) as the input coordinates.

* `alt`: local apparent altitude, in degrees, scalar or array.
* `az`: the local apparent azimuth, in degrees, scalar or vector, measured
 *east* of *north*!!!  If you have measured azimuth west-of-south (like the book
 Meeus does), convert it to east of north via: `az = (az + 180) % 360`.
* `lat`: the local geodetic latitude, in degrees, scalar or array.

### Output ###

Tuple `(ha, dec)`

* `ha`: the local apparent hour angle, in degrees.  The hour angle is the time
  that right ascension of 0 hours crosses the local meridian.  It is
  unambiguously defined.
* `dec`: the local apparent declination, in degrees.

### Example ###

Arcturus is observed at an apparent altitude of 59d,05m,10s and an azimuth
(measured east of north) of 133d,18m,29s while at the latitude of +43.07833
degrees.  What are the local hour angle and declination of this object?
```
julia>  ha, dec = altaz2hadec(ten(59,05,10), ten(133,18,29), 43.07833)
(336.6828582472844,19.182450965120402)
```
The widely available XEPHEM code gets:

    Hour Angle = 336.683
    Declination = 19.1824

### Notes ###

Code of this function is based on IDL Astronomy User's Library.
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
