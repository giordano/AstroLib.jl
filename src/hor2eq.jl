# This file is a part of AstroLib.jl. License is MIT "Expat".

function _hor2eq(alt::T, az::T, jd::T, lat::T, lon::T, ws::Bool, obsname::T, FK4::Bool,
                 altitude::T, precess::Bool, nutate::Bool, abberation::Bool,
                 refract::Bool) where {T<:AbstractFloat}

    if isnan(obsname)
        # Using Pine Bluff Observatory values
        if isnan(lat)
            lat = T(43.0783)
        end

        if isnan(lon)
            lon = T(-89.865)
        end
    else
        lat = T(observatories[obsname].latitude)
        lon = -one(T) * observatories[obsname].longitude
        altitude = T(observatories[obsname].altitude)
    end
    
    if refract
        az_b = co_refract(alt, altitude)
    else
        az_b = az
    end

    if ws
        az_b -= 180
    end
    dra1, ddec1, eps, d_psi, _ = co_nutate(jd, 45, 45)
    last = 15 * ct2lst(lon, jd) + d_psi * cos(eps) / 3600
    
end

"""


### Purpose ###

Converts local horizon coordinates (alt-az) to equatorial (ra-dec) coordinates.

### Explanation ###

This is a function to calculate equatorial (ra,dec) coordinates from
horizon (alt,az) coords. It is accurate to about 1 arcsecond or better.
It performs precession, nutation, aberration, and refraction corrections.

### Arguments ###

* `alt`: altitude of horizon coords, in degrees
* `az`: azimuth angle measured East from North (unless ws is `true`), in degrees
* `jd`: julian date
* `lat`(optional keyword): north geodetic latitude of location, in degrees. Default
  is NaN
* `lon`(optional keyword): AST longitude of location, in degrees. You can specify west
  longitude with a negative sign. Dafualt is NaN.
* `ws` (optional boolean keyword): set this to `true` to get the azimuth measured
  westward from south
* `obsname`(optional keyword): set this to a valid observatory name to
  be used by the observatory type in [types](@ref), which will return
  the latitude and longitude to be used by this program. Default is NaN.
* `FK4`(optional boolean keyword): Set this to `true` if the ra and dec
  are specified in B1950 (FK4 coordinates) instead of J2000 (FK5)
* `altitude`(optional keyword): the altitude of the observing location, in meters.
  It it zero by default
* `precess`(optional keyword): set this to `false` for no precession, `true` by default
* `nutate`(optional keyword): set this to `false` for no nutation, `true` by default
* `abberation`(optional keyword): set this to `false` for no abberation correction,
  `true` by default
* `refract`(optional keyword): set this to `false` for no refraction correction,
  `true` by default

### Output ###

* `ra`: right ascension of object, in degrees (FK5)
* `dec`: declination of the object, in degrees (FK5)
* `ha`: hour angle, in degrees

### Example ###

```jldoctest

```

### Notes ###

Code of this function is based on IDL Astronomy User's Library.
"""
