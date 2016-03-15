# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

# Test adstring
@test AstroLib.adstring(30.4, -1.23, truncate=true) ==
    AstroLib.adstring([30.4, -1.23], truncate=true) == " 02 01 35.9  -01 13 48"
@test AstroLib.adstring(19.19321, truncate=true) == "+19 11 35.5"
@test AstroLib.adstring([30.4, -15.63], [-1.23, 48.41], precision=2) ==
    [" 02 01 36.000  -01 13 48.00", "-22 57 28.800  +48 24 36.00"]

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
@test AstroLib.altaz2hadec([15, 25, 35],
                           [25.12, 45.32, -20.3],
                           [-23.44, 45.0, 52.5]) ==
                               ([324.9881067314537, 256.7468302330436, 132.4919217875949],
                                [44.38225395397647, 48.542947077386664, 67.33061196497327])

# Test calz_unred
@test AstroLib.calz_unred(reshape(1200:200:3000, 10, 1), ones(Float64, 10), -0.1) ==
    [0.3275103090302725, 0.3706688594333945, 0.3992066520267901,
     0.42172386610064166, 0.44163446679589663, 0.46026961834331576,
     0.4781384142299673, 0.49542409215100497, 0.5121824744205304,
     0.5284227515508443]

# Test daycnv with Gregorian Calendar in force.
@test AstroLib.daycnv(2440000.0) == DateTime(1968, 05, 23, 12)

# Test daycnv with Julian Calendar in force (same result as IDL AstroLib's
# daycnv).
@test AstroLib.daycnv(2000000.0) == DateTime(763, 09, 18, 12)
@test AstroLib.daycnv(0.0) == DateTime(-4713, 11, 24, 12)

# Test get_date with mixed keywords.
@test AstroLib.get_date(DateTime(2001,09,25,14,56,14), old=true,timetag=true) ==
    "25/09/2001:T14:56:14"

# Test jdcnv.
@test AstroLib.jdcnv(DateTime(-4713, 11, 24, 12)) == 0.0
@test AstroLib.jdcnv(DateTime(763, 09, 18, 12)) == 2000000.0
@test (jd=1234567.89; AstroLib.jdcnv(AstroLib.daycnv(jd)) == jd)

# Test juldate with Gregorian Calendar in force.  This also makes sure precision
# of the result is high enough.  Note that "juldate(dt::DateTime) =
# Dates.datetime2julian(dt)-2.4e6" would not be precise.
@test (rjd=57388.5 + 1.0/3.0;
       abs(AstroLib.juldate(DateTime(2016, 1, 1, 8)) - rjd) <= eps(rjd))

# Test juldate with Julian Calendar in force, for different centuries.  This
# also makes sure precision of the result is high enough.
@test (rjd=-100843.0 + 1.0/3.0;
       abs(AstroLib.juldate(DateTime(1582, 10, 1, 20)) - rjd) <= eps(rjd))
@test (rjd=-313692.0 + 1.0/3.0;
       abs(AstroLib.juldate(DateTime(1000, 1, 1, 20)) - rjd) <= eps(rjd))
@test (rjd=-642119.0 + 1.0/3.0;
       abs(AstroLib.juldate(DateTime(100, 10, 25, 20)) - rjd) <= eps(rjd))
@test (rjd=-2.4e6;
       abs(AstroLib.juldate(DateTime(-4713, 1, 1, 12)) - rjd) <= eps(rjd))

# Test daycnv and juldate together, with Gregorian Calendar in force.  Note that
# they are not expected to be one the inverse of the other during Julian
# Calendar.
@test (dt=DateTime(2016, 1, 1, 20);
       AstroLib.daycnv(AstroLib.juldate(dt) + 2.4e6) == dt)

# Test radec
@test AstroLib.radec(15.90, -0.85) == (1.0, 3.0, 36.0, -0.0, 51.0, 0.0)
@test AstroLib.radec(-0.85,15.9) == (23.0,56.0,36.0,15.0,54.0,0.0)


# Test "sixty".  Test also it's the reverse of ten.
@test AstroLib.sixty(-51.36) == [-51.0, 21.0, 36.0]
@test (result=-0.10934835545824395;
       abs(AstroLib.ten(AstroLib.sixty(result)) - result) <= eps(result))

# Test "ten" and "tenv".  Always make sure string and numerical inputs are
# consistent (IDL implementation of "ten" is not).
@test AstroLib.ten(0, -23, 34) == AstroLib.ten("0   -23 :: 34") == -0.37388888888888894
@test AstroLib.ten(-0.0, 60) == AstroLib.ten("-0.0 60") == -1.0
@test AstroLib.ten([-5, -60, -3600]) == AstroLib.ten("-5:-60: -3600") == -3.0
@test AstroLib.ten("") == 0.0
@test AstroLib.tenv([0, -0.0, -5], [-23, 60, -60], [34, 0, -3600]) ==
    AstroLib.tenv(["0   -23 :: 34", "-0.0 60", "-5:-60: -3600"]) ==
    [-0.37388888888888894, -1.0, -3.0]
