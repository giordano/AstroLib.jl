# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

try
    # Download a copy of https://www.ngdc.noaa.gov/geomag/data/poles/NP.xy in order to fix
    # issue #6 (https://github.com/JuliaAstro/AstroLib.jl/issues/6).
    download("https://bintray.com/giordano/AstroLib.jl-Data/download_file?file_path=NP.xy-2017-03-08",
             "NP.xy")
catch
    warn("""Could not download file `NP.xy', you will not be able to use
"geo2mag" and "mag2geo" functions, but you can use all other routines.""")
end
