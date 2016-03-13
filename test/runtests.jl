# This file is a part of AstroLib.jl. License is MIT "Expat".

using AstroLib
using Base.Test

# Test airtovac
@test AstroLib.airtovac([1234 2100 6056.125]) ==
    [1234.0 2100.666421596007 6057.801930991426]

# Test aitoff
@test AstroLib.aitoff([227.23, 130], [-8.890, -35]) ==
    ([-137.92196683723276, 115.17541338020645], [-11.772527357473054, -44.491889962090085])
@test AstroLib.aitoff([375], [2.437]) ==
    ([16.63760711611838],[2.712427279646118])

# Test altaz2hadec
@test AstroLib.altaz2hadec(59.086111, 133.30806, 43.07833) ==
    (336.68286017949157, 19.182449588316555)
@test AstroLib.altaz2hadec([10, 20, 30],
                           [25.12, 45.32, -20.3],
                           [-23.44, 45.0, 52.5]) ==
    ([320.8772112014799, 251.3608647587611, 138.53400829191696],
     [48.50445814614302, 45.15845663208642, 63.01614313759156])

# Test daycnv with Gregorian Calendar in force.
@test AstroLib.daycnv(2440000.0) == DateTime(1968, 05, 23, 12)

# Test daycnv with Julian Calendar in force (same result as IDL AstroLib's
# daycnv).
@test AstroLib.daycnv(2000000.0) == DateTime(763, 09, 18, 12)
@test AstroLib.daycnv(0.0) == DateTime(-4713, 11, 24, 12)

# Test get_date with mixed keywords.
@test AstroLib.get_date(DateTime(2001,09,25,14,56,14), old=true,timetag=true) ==
    "25/09/2001:T14:56:14"

# Test juldate with Gregorian Calendar in force.  This also makes sure precision
# of the result is high enough.  Note that "juldate(dt::DateTime) =
# Dates.datetime2julian(dt)-2.4e6" would not be precise.
@test (rjd=57388.5 + 1.0/3.0;
       abs(AstroLib.juldate(DateTime(2016, 1, 1, 8)) - rjd) < eps(rjd))

# Test juldate with Julian Calendar in force, for different centuries.  This
# also makes sure precision of the result is high enough.
@test (rjd=-100843.0 + 1.0/3.0;
       abs(AstroLib.juldate(DateTime(1582, 10, 1, 20)) - rjd) < eps(rjd))
@test (rjd=-313692.0 + 1.0/3.0;
       abs(AstroLib.juldate(DateTime(1000, 1, 1, 20)) - rjd) < eps(rjd))
@test (rjd=-642119.0 + 1.0/3.0;
       abs(AstroLib.juldate(DateTime(100, 10, 25, 20)) - rjd) < eps(rjd))
@test (rjd=-2.4e6;
       abs(AstroLib.juldate(DateTime(-4713, 1, 1, 12)) - rjd) < eps(rjd))

# Test daycnv and juldate together, with Gregorian Calendar in force.  Note that
# they are not expected to be one the inverse of the other during Julian
# Calendar.
@test (dt=DateTime(2016, 1, 1, 20);
       AstroLib.daycnv(AstroLib.juldate(dt) + 2.4e6) == dt)

# Test "ten".  Always make sure string and numerical inputs are consistent (IDL
# implementation of "ten" is not).
@test AstroLib.ten(0, -23, 34) == AstroLib.ten("0   -23 :: 34") == -0.37388888888888894
@test AstroLib.ten(-0.0, 60) == AstroLib.ten("-0.0 60") == -1.0
@test AstroLib.ten(-5, -60, -3600) == AstroLib.ten("-5:-60: -3600") == -3.0
@test AstroLib.ten([0, -0.0, -5], [-23, 60, -60], [34, 0, -3600]) ==
    AstroLib.ten(["0   -23 :: 34", "-0.0 60", "-5:-60: -3600"]) ==
    [-0.37388888888888894, -1.0, -3.0]
