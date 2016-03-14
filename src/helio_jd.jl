# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

# This function is based on IDL Astronomy User's Library.

# TODO: this function requires "bprecess" and "xyz".
function helio_jd(date::Number, ra::Number, dec::Number;
                  b1950::Bool=false, time_diff::Bool=false)
    if b1950
        ra, dec = bprecess(ra, dec)
    end
    delta_t = (date - 33282.42345905)/36525.0
    epsilon_sec = @evalpoly(delta_t, 44.836, -46.8495, -0.00429, 0.00181)
    epsilon = deg2rad(23.433333 + epsilon_sec/3600.0)
    ra = deg2rad(ra)
    dec = deg2rad(dec1)
    x, y, z = xyz(date)
    time = -499.00522*(cos(dec)*cos(ra)*x +
                       (tan(epsilon)*sin(dec) + cos(dec)*sin(ra))*y)
    if time_diff
        return time
    else
        return date + time/86400.0
    end
end
