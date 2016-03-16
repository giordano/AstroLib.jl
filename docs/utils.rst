adstring
~~~~~~~~

.. function:: adstring(ra::Number, dec::Number[, precision::Int=2, truncate::Bool=true]) -> ASCIIString
    adstring([ra, dec]) -> ASCIIString
    adstring(dec) -> ASCIIString
    adstring([ra], [dec]) -> AbstractArray{ASCIIString}

Purpose
'''''''

Returns right ascension and declination as string(s) in sexagesimal
format.

Explanation
'''''''''''

Takes right ascension and declination expressed in decimal format,
converts them to sexagesimal and return a formatted string. The
precision of right ascension and declination can be specified.

Arguments
'''''''''

Arguments of this function are:

-  ``ra``: right ascension in decimal degrees. It is converted to hours
   before printing.
-  ``dec``: declination in decimal degrees.

The function can be called in different ways:

-  Two numeric arguments: first is ``ra``, the second is ``dec``.
-  One 2-element numeric array: ``[ra, dec]``. A single string is
   returned.
-  One numeric argument: it is assumed only ``dec`` is provided.
-  Two numeric arrays of the same length: ``ra`` and ``dec`` arrays. An
   array of strings is returned.

Optional keywords affecting the output format are always available:

-  ``precision`` (optional integer keyword): specifies the number of
   digits of declination seconds. The number of digits for righ
   ascension seconds is always assumed to be one more ``precision``. If
   the function is called with only ``dec`` as input, ``precision``
   default to 1, in any other case defaults to 0.
-  ``truncate`` (optional boolean keyword): if true, then the last
   displayed digit in the output is truncated in precision rather than
   rounded. This option is useful if ``adstring`` is used to form an
   official IAU name (see http://vizier.u-strasbg.fr/Dic/iau-spec.htx)
   with coordinate specification.

Output
''''''

The function returns one string if the function was called with scalar
``ra`` and ``dec`` (or only ``dec``) or a 2-element array ``[ra, dec]``.
If instead it was feeded with arrays of ``ra`` and ``dec``, an array of
strings will be returned. The format of strings can be specified with
``precision`` and ``truncate`` keywords, see above.

Example
'''''''

.. code:: julia

    julia> adstring(30.4, -1.23, truncate=true)
    " 02 01 35.9  -01 13 48"

    julia> adstring([30.4, -15.63], [-1.23, 48.41], precision=1)
    2-element Array{AbstractString,1}:
     " 02 01 36.00  -01 13 48.0"
     "-22 57 28.80  +48 24 36.0"

--------------

airtovac
~~~~~~~~

.. function:: airtovac(wave_air) -> Float64

Purpose
'''''''

Converts air wavelengths to vacuum wavelengths.

Explanation
'''''''''''

Wavelengths are corrected for the index of refraction of air under
standard conditions. Wavelength values below 2000 Å will not be altered.
Uses relation of Ciddor (1996).

Arguments
'''''''''

-  ``wave_air``: can be either a scalar or an array of numbers.
   Wavelengths are corrected for the index of refraction of air under
   standard conditions. Wavelength values below 2000 Å will *not* be
   altered, take care within [1 Å, 2000 Å].

Output
''''''

Vacuum wavelength in angstroms, same number of elements as ``wave_air``.

Method
''''''

Uses relation of Ciddor (1996), Applied Optics 62, 958
(http://adsabs.harvard.edu/abs/1996ApOpt..35.1566C).

Example
'''''''

If the air wavelength is ``w = 6056.125`` (a Krypton line), then
``airtovac(w)`` yields an vacuum wavelength of ``6057.8019``.

Notes
'''''

Code of this function is based on IDL Astronomy User's Library.

--------------

aitoff
~~~~~~

.. function:: aitoff(l, b) -> Float64, Float64

Purpose
'''''''

Convert longitude ``l`` and latitude ``b`` to ``(x, y)`` using an Aitoff
projection.

Explanation
'''''''''''

This function can be used to create an all-sky map in Galactic
coordinates with an equal-area Aitoff projection. Output map coordinates
are zero longitude centered.

Arguments
'''''''''

-  ``l``: longitude, scalar or vector, in degrees.
-  ``b``: latitude, number of elements as ``l``, in degrees.

Output
''''''

2-tuple ``(x, y)``.

-  ``x``: x coordinate, same number of elements as ``l``. ``x`` is
   normalized to be in [-180, 180].
-  ``y``: y coordinate, same number of elements as ``l``. ``y`` is
   normalized to be in [-90, 90].

Example
'''''''

.. code:: julia

    julia> x, y = aitoff(375, 2.437)
    (16.63760711611838,2.712427279646118)

Notes
'''''

See AIPS memo No. 46
(ftp://ftp.aoc.nrao.edu/pub/software/aips/TEXT/PUBL/AIPSMEMO46.PS), page
4, for details of the algorithm. This version of ``aitoff`` assumes the
projection is centered at b=0 degrees.

Code of this function is based on IDL Astronomy User's Library.

--------------

altaz2hadec
~~~~~~~~~~~

.. function:: altaz2hadec(alt, az, lat) -> Float64, Float64

Purpose
'''''''

Convert Horizon (Alt-Az) coordinates to Hour Angle and Declination.

Explanation
'''''''''''

Can deal with the NCP singularity. Intended mainly to be used by program
``hor2eq``.

Arguments
'''''''''

Input coordinates may be either a scalar or an array, of the same
dimension N, the output coordinates are always Float64 and have the same
type (scalar or array) as the input coordinates.

-  ``alt``: local apparent altitude, in degrees, scalar or array.
-  ``az``: the local apparent azimuth, in degrees, scalar or vector,
   measured *east* of *north*!!! If you have measured azimuth
   west-of-south (like the book Meeus does), convert it to east of north
   via: ``az = (az + 180) % 360``.
-  ``lat``: the local geodetic latitude, in degrees, scalar or array.

Output
''''''

2-tuple ``(ha, dec)``

-  ``ha``: the local apparent hour angle, in degrees. The hour angle is
   the time that right ascension of 0 hours crosses the local meridian.
   It is unambiguously defined.
-  ``dec``: the local apparent declination, in degrees.

Example
'''''''

Arcturus is observed at an apparent altitude of 59d,05m,10s and an
azimuth (measured east of north) of 133d,18m,29s while at the latitude
of +43.07833 degrees. What are the local hour angle and declination of
this object?

.. code:: julia

    julia>  ha, dec = altaz2hadec(ten(59,05,10), ten(133,18,29), 43.07833)
    (336.6828582472844,19.182450965120402)

The widely available XEPHEM code gets:

::

    Hour Angle = 336.683
    Declination = 19.1824

Notes
'''''

Code of this function is based on IDL Astronomy User's Library.

--------------

calz\_unred
~~~~~~~~~~~

.. function:: calz_unred(wave, flux, ebv[, r_v]) -> Float64

Purpose
'''''''

Deredden a galaxy spectrum using the Calzetti et al. (2000) recipe.

Explanation
'''''''''''

Calzetti et al. (2000, ApJ 533, 682;
http://adsabs.harvard.edu/abs/2000ApJ...533..682C) developed a recipe
for dereddening the spectra of galaxies where massive stars dominate the
radiation output, valid between 0.12 to 2.2 microns. (``calz_unred``
extrapolates between 0.12 and 0.0912 microns.)

Arguments
'''''''''

-  ``wave``: wavelength vector (Angstroms)
-  ``flux``: calibrated flux vector, same number of elements as
   ``wave``.
-  ``ebv``: color excess E(B-V), scalar. If a negative ``ebv`` is
   supplied, then fluxes will be reddened rather than deredenned. Note
   that the supplied color excess should be that derived for the stellar
   continuum, EBV(stars), which is related to the reddening derived from
   the gas, EBV(gas), via the Balmer decrement by EBV(stars) =
   0.44\*EBV(gas).
-  ``r_v`` (optional): scalar ratio of total to selective extinction,
   default = 4.05. Calzetti et al. (2000) estimate r\_v = 4.05 +/- 0.80
   from optical-IR observations of 4 starbursts.

Output
''''''

Unreddened flux vector, same units and number of elements as ``flux``.
Flux values will be left unchanged outside valid domain (0.0912 - 2.2
microns).

Example
'''''''

Estimate how a flat galaxy spectrum (in wavelength) between 1200 Å and
3200 Å is altered by a reddening of E(B-V) = 0.1.

.. code:: julia

    julia> wave = reshape(1200:50:3150,40);

    julia> flux = ones(wave);

    julia> AstroLib.calz_unred(wave, flux, -0.1);

Notes
'''''

Code of this function is based on IDL Astronomy User's Library.

--------------

daycnv
~~~~~~

.. function:: daycnv(julian_days) -> DateTime

Purpose
'''''''

Converts Julian days number to Gregorian calendar dates.

Explanation
'''''''''''

Takes the number of Julian calendar days since epoch
``-4713-11-24T12:00:00`` and returns the corresponding proleptic
Gregorian Calendar date.

Argument
''''''''

-  ``julian_days``: Julian days number, scalar or array.

Output
''''''

Proleptic Gregorian Calendar date, of type ``DateTime``, corresponding
to the given Julian days number.

Example
'''''''

.. code:: julia

    julia> daycnv(2440000)
    1968-05-23T12:00:00

Notes
'''''

``jdcnv`` is the inverse of this function.

--------------

flux2mag
~~~~~~~~

.. function:: flux2mag(flux[, zero_point, ABwave=number]) -> Float64

Purpose
'''''''

Convert from flux expressed in erg/s/cm²/Å to magnitudes.

Explanation
'''''''''''

This is the reverse of ``mag2flux``.

Arguments
'''''''''

-  ``flux``: the flux to be converted in magnitude, expressed in
   erg·cm\ :sup:`{-2}·s`\ {-1}·Å^{-1}. It can be either a scalar or an
   array.
-  ``zero_point``: scalar giving the zero point level of the magnitude.
   If not supplied then defaults to 21.1 (Code et al 1976). Ignored if
   the ``ABwave`` keyword is supplied
-  ``ABwave`` (optional numeric keyword): wavelength scalar or vector in
   Angstroms. If supplied, then returns Oke AB magnitudes (Oke & Gunn
   1983, ApJ, 266, 713;
   http://adsabs.harvard.edu/abs/1983ApJ...266..713O).

Output
''''''

The magnitude. It is of the same type, scalar or array, as ``flux``.

If the ``ABwave`` keyword is set then magnitude is given by the
expression

::

    ABmag = -2.5*log10(f) - 5*log10(ABwave) - 2.406

Otherwise, magnitude is given by the expression

::

    mag = -2.5*log10(flux) - zero_point

Notes
'''''

Code of this function is based on IDL Astronomy User's Library.

--------------

get\_date
~~~~~~~~~

.. function:: get_date([date::DateTime]) -> ASCIIString
    get_date([date::DateTime;] old=true) -> ASCIIString
    get_date([date::DateTime;] timetag=true) -> ASCIIString

Purpose
'''''''

Returns the UTC date in ``"CCYY-MM-DD"`` format for FITS headers.

Explanation
'''''''''''

This is the format required by the ``DATE`` and ``DATE-OBS`` keywords in
a FITS header.

Argument
''''''''

-  ``date`` (optional): the date in UTC standard, of ``DateTime`` type.
   If omitted, defaults to the current UTC time.
-  ``old`` (optional boolean keyword): see below.
-  ``timetag`` (optional boolean keyword): see below.

Output
''''''

A string with the date formatted according to the given optional
keywords.

-  When no optional keywords (``timetag`` and ``old``) are supplied, the
   format of the output string is ``"CCYY-MM-DD"`` (year-month-day part
   of the date), where represents a 4-digit calendar year, the 2-digit
   ordinal number of a calendar month within the calendar year, and

   .. raw:: html

      <DD>

   the 2-digit ordinal number of a day within the calendar month.
-  If the boolean keyword ``old`` is true (default: false), the
   year-month-day part of date has ``"DD/MM/YY"`` format. This is the
   formerly (pre-1997) recommended for FITS. Note that this format is
   now deprecated because it uses only a 2-digit representation of the
   year.
-  If the boolean keyword ``timetag`` is true (default: false),
   ``"Thh:mm:ss"`` is appended to the year-month-day part of the date,
   where represents the hour in the day, the minutes, the seconds, and
   the literal 'T' the ISO 8601 time designator.

Note that ``old`` and ``timetag`` keywords can be used together, so that
the output string will have ``"DD/MM/YYThh:mm:ss"`` format.

Example
'''''''

.. code:: julia

    julia> get_date(timetag=true)
    "2016-03-14:T11:26:23"

Notes
'''''

1. A discussion of the DATExxx syntax in FITS headers can be found in
   http://www.cv.nrao.edu/fits/documents/standards/year2000.txt

2. Those who wish to use need further flexibility in their date formats
   (e.g. to use TAI time) should look at Bill Thompson's time routines
   in http://sohowww.nascom.nasa.gov/solarsoft/gen/idl/time

--------------

get\_juldate
~~~~~~~~~~~~

.. function:: get_juldate() -> Float64

Purpose
'''''''

Return the number of Julian days for current time.

Explanation
'''''''''''

Return for current time the number of Julian calendar days since epoch
``-4713-11-24T12:00:00`` as a ``Float64``.

Example
'''''''

.. code:: julia

    julia> get_juldate()
    2.4574620222685183e6

    julia> daycnv(get_juldate())
    2016-03-14T12:32:13

Notes
'''''

Use ``jdcnv`` to get the number of Julian days for a different date.

--------------

jdcnv
~~~~~

.. function:: jdcnv(date::DateTime) -> Float64

Purpose
'''''''

Convert proleptic Gregorian Calendar date in UTC standard to number of
Julian days.

Explanation
'''''''''''

Takes the given proleptic Gregorian date in UTC standard and returns the
number of Julian calendar days since epoch ``-4713-11-24T12:00:00``.

Argument
''''''''

-  ``date``: date of ``DateTime`` type, in proleptic Gregorian Calendar.

Output
''''''

Number of Julian days, as a ``Float64``.

Example
'''''''

Find the Julian days number at 2009 August 23, 03:39:06.

.. code:: julia

    julia> jdcnv(DateTime(2009, 08, 23, 03, 39, 06))
    2.4550666521527776e6

Notes
'''''

This is the inverse of ``daycnv``.

``get_juldate`` returns the number of Julian days for current time. It
is equivalent to ``jdcnv(Dates.now())``.

For the conversion of Julian date to number of Julian days, use
``juldate``.

--------------

juldate
~~~~~~~

.. function:: juldate(date::DateTime) -> Float64

Purpose
'''''''

Convert from calendar to Reduced Julian Date.

Explanation
'''''''''''

Julian Day Number is a count of days elapsed since Greenwich mean noon
on 1 January 4713 B.C. The Julian Date is the Julian day number followed
by the fraction of the day elapsed since the preceding noon.

This function takes the given ``date`` and returns the number of Julian
calendar days since epoch ``1858-11-16T12:00:00`` (Reduced Julian Date =
Julian Date - 2400000).

Argument
''''''''

-  ``date``: date of ``DateTime`` type, in Julian Calendar.

Notes
'''''

Julian Calendar is assumed, thus before ``1582-10-15T00:00:00`` this
function is *not* the inverse of ``daycnv``. For the conversion
proleptic Gregorian date to number of Julian days, use ``jdcnv``, which
is the inverse of ``daycnv``.

Code of this function is based on IDL Astronomy User's Library.

--------------

mag2flux
~~~~~~~~

.. function:: mag2flux(mag[, zero_point, ABwave=number]) -> Float64

Purpose
'''''''

Convert from magnitudes to flux expressed in erg/s/cm²/Å.

Explanation
'''''''''''

This is the reverse of ``flux2mag``.

Arguments
'''''''''

-  ``mag``: the magnitude to be converted in flux. It can be either a
   scalar or an array.
-  ``zero_point``: scalar giving the zero point level of the magnitude.
   If not supplied then defaults to 21.1 (Code et al 1976). Ignored if
   the ``ABwave`` keyword is supplied
-  ``ABwave`` (optional numeric keyword): wavelength, scalar or array,
   in Angstroms. If supplied, then the input ``mag`` is assumed to
   contain Oke AB magnitudes (Oke & Gunn 1983, ApJ, 266, 713;
   http://adsabs.harvard.edu/abs/1983ApJ...266..713O).

Output
''''''

The flux. It is of the same type, scalar or array, as ``mag``.

If the ``ABwave`` keyword is set, then the flux is given by the
expression

::

    flux = 10^(-0.4*(mag +2.406 + 4*log10(ABwave)))

Otherwise the flux is given by

::

    f =  10^(-0.4*(mag + zero_point))

Notes
'''''

Code of this function is based on IDL Astronomy User's Library.

--------------

radec
~~~~~

.. function:: radec(ra::Number, dec::Number[, hours=true]) -> Float64, Float64, Float64, Float64, Float64, Float64

Purpose
'''''''

Convert right ascension and declination from decimal to sexagesimal
units.

Explanation
'''''''''''

The conversion is to sexagesimal hours for right ascension, and
sexagesimal degrees for declination.

Arguments
'''''''''

-  ``ra``: decimal right ascension, scalar or array. It is expressed in
   degrees, unless the optional keyword ``hours`` is set to ``true``.
-  ``dec``: declination in decimal degrees, scalar or array, same number
   of elements as ``ra``.
-  ``hours`` (optional boolean keyword): if ``false`` (the default),
   ``ra`` is assumed to be given in degrees, otherwise ``ra`` is assumed
   to be expressed in hours.

Output
''''''

A 6-tuple of ``Float64``:

::

    (ra_hours, ra_minutes, ra_seconds, dec_degrees, dec_minutes, dec_seconds)

If ``ra`` and ``dec`` are arrays, also each element of the output
6-tuple are arrays of the same dimension.

Example
'''''''

Position of Sirius in the sky is (ra, dec) = (6.7525, -16.7161), with
right ascension expressed in hours. Its sexagesimal representation is
given by

.. code:: julia

    julia> radec(6.7525, -16.7161, hours=true)
    (6.0,45.0,9.0,-16.0,42.0,57.9600000000064)

--------------

sixty
~~~~~

.. function:: sixty(number::Number) -> [deg::Float64, min::Float64, sec::Float64]

Purpose
'''''''

Converts a decimal number to sexagesimal.

Explanation
'''''''''''

The reverse of ``ten`` function.

Argument
''''''''

-  ``number``: decimal number to be converted to sexagesimal.

Output
''''''

An array of three ``Float64``, that are the sexagesimal counterpart
(degrees, minutes, seconds) of ``number``.

Notes
'''''

Code of this function is based on IDL Astronomy User's Library.

--------------

ten
~~~

.. function:: ten(deg[, min, sec]) -> Float64
    ten("deg:min:sec") -> Float64
    tenv([deg], [min], [sec]) -> Float64
    tenv(["deg:min:sec"]) -> Float64

Purpose
'''''''

Converts a sexagesimal number or string to decimal.

Explanation
'''''''''''

``ten`` is the inverse of the ``sixty`` function. ``tenv`` is the
vectorial version of ``ten``.

Arguments
'''''''''

``ten`` takes as argument either three scalars (``deg``, ``min``,
``sec``) or a string. The string should have the form ``"deg:min:sec"``
or ``"deg min sec"``. Also a one dimensional array ``[deg, min, sec]``
is accepted as argument.

If minutes and seconds are not specified they default to zero.

``tenv`` takes as input three numerical arrays of numbers (minutes and
seconds arrays default to null arrays if omitted) or one array of
strings.

Output
''''''

The decimal conversion of the sexagesimal numbers provided is returned.
The output has the same dimension as the input.

Method
''''''

The formula used for the conversion is

::

    sign(deg)·(|deg| + min/60 + sec/3600)

Notes
'''''

These functions cannot deal with ``-0`` (negative integer zero) in
numeric input. If it is important to give sense to negative zero, you
can either make sure to pass a floating point negative zero ``-0.0``
(this is the best option), or use negative minutes and seconds, or
non-integer negative degrees and minutes.
