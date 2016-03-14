# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

# This function is based on IDL Astronomy User's Library.

"""
    airtovac(wave_air) -> Float64

Converts air wavelengths to vacuum wavelengths.

`wave_air` can be either a scalar or an array of numbers.  Wavelengths are
corrected for the index of refraction of air under standard conditions.
Wavelength values below 2000 Å will *not* be altered, take care within [1 Å,
2000 Å].

Uses relation of Ciddor (1996), Applied Optics 62, 958.
"""
function airtovac(wave_air::Number)
    wave_vac = convert(Float64, wave_air)
    if wave_vac >= 2000.0
        for iter= 1:2
            sigma2 = (1e4/wave_vac)^2.0 # Convert to wavenumber squared
            # Computer conversion factor.
            fact = 1.0 + 5.792105e-2/(238.0185e0 - sigma2) +
                1.67917e-3/(57.362e0 - sigma2)
            wave_vac = wave_air*fact # Convert Wavelength
        end
    end
    return wave_vac
end
@vectorize_1arg Number airtovac
