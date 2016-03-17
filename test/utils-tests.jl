# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

# Test adstring
@test AstroLib.adstring(30.4, -1.23, truncate=true) ==
    AstroLib.adstring([30.4, -1.23], truncate=true) == " 02 01 35.9  -01 13 48"
@test AstroLib.adstring(19.19321, truncate=true) == "+19 11 35.5"
@test AstroLib.adstring([30.4, -15.63], [-1.23, 48.41], precision=2) ==
    [" 02 01 36.000  -01 13 48.00", "-22 57 28.800  +48 24 36.00"]

# Test airtovac
@test_approx_eq AstroLib.airtovac([1234 2100 6056.125]) [1234.0 2100.666421596007 6057.801930991426]

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

# Test flux2mag
@test_approx_eq AstroLib.flux2mag([1.5e-12, 8.7e-15, 4.4e-10]) [8.459771852360795,
                                                                14.051201868453454,
                                                                2.291368308784527]

# Test get_date with mixed keywords.
@test AstroLib.get_date(DateTime(2001,09,25,14,56,14), old=true,timetag=true) ==
    "25/09/2001:T14:56:14"

# Test gcirc.
@test_approx_eq gcirc(0, [0,1,2], [1,2,3], [2,3,4], [3,4,5]) [1.222450611061632,
                                                              2.500353926443337,
                                                              1.5892569925227757]

# Test jdcnv.
@test_approx_eq AstroLib.jdcnv(DateTime(-4713, 11, 24, 12)) 0.0
@test_approx_eq AstroLib.jdcnv(DateTime(763, 09, 18, 12)) 2000000.0
@test (jd=1234567.89; AstroLib.jdcnv(AstroLib.daycnv(jd)) == jd)

# Test juldate with Gregorian Calendar in force.  This also makes sure precision
# of the result is high enough.  Note that "juldate(dt::DateTime) =
# Dates.datetime2julian(dt)-2.4e6" would not be precise.
@test_approx_eq AstroLib.juldate(DateTime(2016, 1, 1, 8)) (57388.5 + 1.0/3.0)

# Test juldate with Julian Calendar in force, for different centuries.  This
# also makes sure precision of the result is high enough.
@test_approx_eq AstroLib.juldate(DateTime(1582, 10, 1, 20)) (-100843.0 + 1.0/3.0)
@test_approx_eq AstroLib.juldate(DateTime(1000, 1, 1, 20)) (-313692.0 + 1.0/3.0)
@test_approx_eq AstroLib.juldate(DateTime(100, 10, 25, 20)) (-642119.0 + 1.0/3.0)
@test_approx_eq AstroLib.juldate(DateTime(-4713, 1, 1, 12)) -2.4e6

# Test daycnv and juldate together, with Gregorian Calendar in force.  Note that
# they are not expected to be one the inverse of the other during Julian
# Calendar.
@test (dt=DateTime(2016, 1, 1, 20);
       AstroLib.daycnv(AstroLib.juldate(dt) + 2.4e6) == dt)

# Test mag2flux
@test_approx_eq AstroLib.mag2flux(4.83, 21.12) 4.1686938347033296e-11
@test_approx_eq AstroLib.flux2mag(AstroLib.mag2flux(15)) 15.0

# Test polrec
let
    local x=zeros(Float64, 3), y=zeros(Float64, 3)
    x, y = AstroLib.polrec([1, 2, 3], [pi, pi/2.0, pi/4.0])
    @test_approx_eq x [-1.0, 0.0, 1.5*sqrt(2.0)]
    @test_approx_eq y [ 0.0, 2.0, 1.5*sqrt(2.0)]
end

# Test radec
@test AstroLib.radec(15.90, -0.85) == (1.0, 3.0, 36.0, -0.0, 51.0, 0.0)
@test AstroLib.radec(-0.85,15.9) == (23.0,56.0,36.0,15.0,54.0,0.0)
@test AstroLib.radec([15.90, -0.85], [-0.85,15.9]) ==
    ([1.0, 23.0], [3.0, 56.0], [36.0, 36.0],
     [-0.0, 15.0], [51.0, 54.0], [0.0, 0.0])

# Test recpol
let
    local r = a = zeros(Float64, 3)
    r, a = AstroLib.recpol([0, sqrt(2.0), 2.0*sqrt(3.0)],
                           [0, sqrt(2.0), 2.0], degrees=true)
    @test_approx_eq r [0.0,  2.0,  4.0]
    @test_approx_eq a [0.0, 45.0, 30.0]
    # Test polrec is the inverse of recpol
    local xi = 6.3, yi = -2.7, x = y = r2 = a2 = 0.0
    r2, a2 = AstroLib.recpol(xi, yi, degrees=true)
    x, y = AstroLib.polrec(r2, a2, degrees=true)
    @test_approx_eq x xi
    @test_approx_eq y yi
end

# Test "sixty".  Test also it's the reverse of ten.
@test_approx_eq AstroLib.sixty(-51.36) [-51.0, 21.0, 36.0]
@test_approx_eq AstroLib.ten(AstroLib.sixty(-0.10934835545824395)) -0.10934835545824395

# Test "ten" and "tenv".  Always make sure string and numerical inputs are
# consistent (IDL implementation of "ten" is not).
@test AstroLib.ten(0, -23, 34) == AstroLib.ten(" : 0 -23 :: 34") == -0.37388888888888894
@test AstroLib.ten(-0.0, 60) == AstroLib.ten("-0.0 60") == -1.0
@test AstroLib.ten([-5, -60, -3600]) == AstroLib.ten("  -5: :-60: -3600") == -3.0
@test AstroLib.ten("") == 0.0
@test AstroLib.tenv([0, -0.0, -5], [-23, 60, -60], [34, 0, -3600]) ==
    AstroLib.tenv(["0   -23 :: 34", ":-0.0:60", " -5:-60: -3600"]) ==
    [-0.37388888888888894, -1.0, -3.0]
