# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

"""
    flux2mag(flux[, zero_point, ABwave=number]) -> Float64

### Purpose ###

Convert from flux expressed in erg/(s cm² Å) to magnitudes.

### Explanation ###

This is the reverse of `mag2flux`.

### Arguments ###

* `flux`: the flux to be converted in magnitude, expressed in
  erg/(s cm² Å).  It can be either a scalar or an array.
* `zero_point`: scalar giving the zero point level of the magnitude.  If not
 supplied then defaults to 21.1 (Code et al 1976).  Ignored if the `ABwave`
 keyword is supplied
* `ABwave` (optional numeric keyword): wavelength scalar or vector in Angstroms.
 If supplied, then returns Oke AB magnitudes (Oke & Gunn 1983, ApJ, 266, 713;
 http://adsabs.harvard.edu/abs/1983ApJ...266..713O).

### Output ###

The magnitude.  It is of the same type, scalar or array, as `flux`.

If the `ABwave` keyword is set then magnitude is given by the expression

    ABmag = -2.5*log10(f) - 5*log10(ABwave) - 2.406 
            
Otherwise, magnitude is given by the expression

    mag = -2.5*log10(flux) - zero_point

### Notes ###

Code of this function is based on IDL Astronomy User's Library.
"""
function flux2mag(flux::Number, zero_point::Number=21.1; ABwave::Number=NaN)
    if isnan(ABwave)
        return -2.5*log10(flux) - zero_point
    else
        return -2.5*log10(flux) - 5.0*log10(ABwave) - 2.406
    end
end

function flux2mag{N<:Number}(flux::AbstractArray{N}, zero_point::Number=21.1;
                             ABwave::Number=NaN)
    mag = similar(flux, Float64)
    for i in eachindex(flux)
        mag[i] = flux2mag(flux[i], zero_point, ABwave=ABwave)
    end
    return mag
end
