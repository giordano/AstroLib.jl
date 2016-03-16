# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

using Base.Dates

include("adstring.jl")
export adstring

include("airtovac.jl")
export airtovac

include("aitoff.jl")
export aitoff

include("altaz2hadec.jl")
export altaz2hadec

include("calz_unred.jl")
export calz_unred

include("daycnv.jl")
export daycnv

include("flux2mag.jl")
export flux2mag

include("get_date.jl")
export get_date

include("get_juldate.jl")
export get_juldate

# TODO: this function requires "bprecess" and "xyz".
# include("helio_jd.jl")
# export helio_jd

include("jdcnv.jl")
export jdcnv

include("juldate.jl")
export juldate

include("mag2flux.jl")
export mag2flux

include("radec.jl")
export radec

include("sixty.jl")
export sixty

include("ten.jl")
export ten, tenv
