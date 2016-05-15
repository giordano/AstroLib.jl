# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

import Base.show

immutable Observatory
    name::AbstractString
    latitude::AbstractFloat
    longitude::AbstractFloat
    altitude::AbstractFloat
    tz::AbstractFloat # There are non-integer time zones
    # Define constructor that automatically converts longitude and latitude with
    # "ten", for convenience.
    Observatory(name, lat, long, alt, tz) =
        new(name, ten(lat), ten(long), float(alt), ten(tz))
end

# New type representation
function show(io::IO, obs::Observatory)
    println(io, "Observatory: ", obs.name)
    println(io, "latitude:    ", obs.latitude, "°N")
    println(io, "longitude:   ", obs.longitude, "°E")
    println(io, "altitude:    ", obs.altitude, " m")
    tzdec, tzint = modf(obs.tz)
    print(io, "time zone:   ", @sprintf("UTC%+d", tzint),
          tzdec == 0 ? "" : @sprintf(":%d", abs(tzdec*60)))
end

export Observatory
