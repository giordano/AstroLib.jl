# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

# Test adstring
@test adstring((30.4, -1.23), truncate=true) ==
    adstring([30.4, -1.23], truncate=true) == " 02 01 35.9  -01 13 48"
@test adstring(19.19321, truncate=true) == "+19 11 35.5"
@test adstring([30.4, -15.63], [-1.23, 48.41], precision=2) ==
    [" 02 01 36.000  -01 13 48.00", "-22 57 28.800  +48 24 36.00"]
@test adstring([(-58, 24)]) == ["-20 08 00.0  +24 00 00"]

# Test airtovac
@test_approx_eq airtovac([1234 6056.125]) [1234.0 6057.801930991426]
@test_approx_eq airtovac(2100) 2100.666421596007

# Test aitoff
@test aitoff([227.23, 130], [-8.890, -35]) ==
    ([-137.92196683723276, 115.17541338020645], [-11.772527357473054, -44.491889962090085])
@test aitoff([375], [2.437]) ==
    ([16.63760711611838],[2.712427279646118])
@test aitoff((227.23, -8.890)) ==
    (-137.92196683723276,-11.772527357473054)

# Test altaz2hadec
@test altaz2hadec(59.086111, 133.30806, 43.07833) ==
    altaz2hadec((59.086111, 133.30806), 43.07833) ==
    (336.68286017949157, 19.182449588316555)
@test altaz2hadec([15, 25, 35],
                  [25.12, 45.32, -20.3],
                  [-23.44, 45.0, 52.5]) ==
                      ([324.9881067314537, 256.7468302330436, 132.4919217875949],
                       [44.38225395397647, 48.542947077386664, 67.33061196497327])

# Test calz_unred
@test_approx_eq calz_unred(reshape(900:1000:9900, 10, 1), ones(Float64, 10), -0.1) [1.0,                0.43189326452379095,
                                                                                    0.5203675483533704, 0.594996469192435,
                                                                                    0.6569506252451913, 0.7080829505773865,
                                                                                    0.7502392743978797, 0.7861262388745882,
                                                                                    0.8151258710444882, 0.8390325371659836]

# Test daycnv with Gregorian Calendar in force.
@test daycnv(2440000.0) == DateTime(1968, 05, 23, 12)

# Test daycnv with Julian Calendar in force (same result as IDL AstroLib's
# daycnv).
@test daycnv(2000000.0) == DateTime(763, 09, 18, 12)
@test daycnv(0.0) == DateTime(-4713, 11, 24, 12)

# Test flux2mag
@test_approx_eq flux2mag([1.5e-12, 8.7e-15, 4.4e-10]) [8.459771852360795,
                                                       14.051201868453454,
                                                       2.291368308784527]
@test_approx_eq flux2mag(1) -21.1

# Test get_date with mixed keywords.
@test get_date(DateTime(2001,09,25,14,56,14), old=true,timetag=true) ==
    "25/09/2001T14:56:14"
@test get_date(DateTime(2001,09,25,14,56,14)) == "2001-09-25"

# Test gcirc.
@test_approx_eq gcirc(0, [0,1,2], [1,2,3], [2,3,4], [3,4,5]) [1.222450611061632,
                                                              2.500353926443337,
                                                              1.5892569925227757]
@test_approx_eq gcirc(0,  120, -43,   175, +22)  1.590442261600714
@test_approx_eq gcirc(1, (120, -43),  175, +22)  415908.56615322345
@test_approx_eq gcirc(2,  120, -43,  (175, +22)) 296389.3666794745
@test_approx_eq gcirc(0, (120, -43), (175, +22)) 1.590442261600714
@test_approx_eq gcirc(1, [120], [-43],  175, +22)  [415908.56615322345]
@test_approx_eq gcirc(2,  120, -43,  [175], [+22]) [296389.3666794745]
@test_throws ErrorException gcirc(3, 0, 0, 0, 0)

# Test jdcnv.
@test_approx_eq jdcnv(DateTime(-4713, 11, 24, 12)) 0.0
@test_approx_eq jdcnv(DateTime(763, 09, 18, 12)) 2000000.0
@test (jd=1234567.89; jdcnv(daycnv(jd)) == jd)

# Test juldate with Gregorian Calendar in force.  This also makes sure precision
# of the result is high enough.  Note that "juldate(dt::DateTime) =
# Dates.datetime2julian(dt)-2.4e6" would not be precise.
@test_approx_eq juldate(DateTime(2016, 1, 1, 8)) (57388.5 + 1.0/3.0)

# Test juldate with Julian Calendar in force, for different centuries.  This
# also makes sure precision of the result is high enough.
@test_approx_eq juldate(DateTime(1582, 10, 1, 20)) (-100843.0 + 1.0/3.0)
@test_approx_eq juldate(DateTime(1000, 1, 1, 20)) (-313692.0 + 1.0/3.0)
@test_approx_eq juldate(DateTime(100, 10, 25, 20)) (-642119.0 + 1.0/3.0)
@test_approx_eq juldate(DateTime(-4713, 1, 1, 12)) -2.4e6

# Test daycnv and juldate together, with Gregorian Calendar in force.  Note that
# they are not expected to be one the inverse of the other during Julian
# Calendar.
@test (dt=DateTime(2016, 1, 1, 20);
       daycnv(juldate(dt) + 2.4e6) == dt)

# Test mag2flux
@test_approx_eq mag2flux(4.83, 21.12) 4.1686938347033296e-11
@test_approx_eq mag2flux([4.83], 21.12) 4.1686938347033296e-11
@test_approx_eq flux2mag(mag2flux(15, ABwave=12.), ABwave=12) 15.0

# Test polrec
let
    local x=zeros(Float64, 3), y=zeros(Float64, 3)
    x, y = polrec([1, 2, 3], [pi, pi/2.0, pi/4.0])
    @test_approx_eq x [-1.0, 0.0, 1.5*sqrt(2.0)]
    @test_approx_eq y [ 0.0, 2.0, 1.5*sqrt(2.0)]
    x, y = polrec((2, 135), degrees=true)
    @test_approx_eq x -sqrt(2)
    @test_approx_eq y  sqrt(2)
end

# Test precess
let
    local ra1, dec1, ra2, dec2
    ra1, dec1 = precess((ten(2,31,46.3)*15, ten(89,15,50.6)), 2000, 1985)
    @test_approx_eq ra1  34.09470328718033
    @test_approx_eq dec1 89.19647174928589
    ra2, dec2 = precess([ten(21, 59, 33.053)*15], [ten(-56, 59, 33.053)], 1950, 1975, FK4=true)
    @test_approx_eq ra2  330.3144305418865
    @test_approx_eq dec2 -56.87186126487889
end

# Test precess_xyz
let
    local x1 ,y1, z1, x2, y2, z2
    x1, y1, z1 = precess_xyz((1.2, 2.3, 1.7), 2000, 2050)
    @test_approx_eq x1 1.165933061423247
    @test_approx_eq y1 2.313228746401996
    @test_approx_eq z1 1.7057470102860104
    x2, y2, z2 = precess_xyz([0.7, -2.4], [3.3, 6.6], [0, 4], 2000, 2016)
    @test_approx_eq x2 [0.688187142071843,   -2.429815562246262]
    @test_approx_eq y2 [3.3024835038223532,   6.591359330834213]
    @test_approx_eq z2 [0.001079105285993004, 3.9962455511755794]
end

# Test premat
@test_approx_eq premat(1967, 1982, FK4=true) [0.9999933170034135    -0.0033529069683496567 -0.0014573823699636742
                                              0.00335290696825777    0.9999943789886484    -2.443304965138481e-6
                                              0.0014573823701750721 -2.4431788671274868e-6  0.9999989380147651   ]

@test_approx_eq premat(1995, 2003) [ 0.9999980977132219    -0.0017889257711428855  -0.0007773766929507687
                                     0.0017889257711354528  0.9999983998707707     -6.953448226403318e-7
                                     0.0007773766929678732 -6.953257000046125e-7    0.9999996978424512  ]

# Test radec
@test radec(15.90, -0.85) == (1.0, 3.0, 36.0, -0.0, 51.0, 0.0)
@test radec(-0.85,15.9) == (23.0,56.0,36.0,15.0,54.0,0.0)
@test radec(-20,4,hours=true) == (4.0,0.0,0.0,4.0,0.0,0.0)
@test radec([15.90, -0.85], [-0.85,15.9]) ==
    ([1.0, 23.0], [3.0, 56.0], [36.0, 36.0],
     [-0.0, 15.0], [51.0, 54.0], [0.0, 0.0])

# Test recpol
let
    local r = a = zeros(Float64, 3)
    r, a = recpol([0, sqrt(2.0), 2.0*sqrt(3.0)],
                  [0, sqrt(2.0), 2.0])
    @test_approx_eq r [0.0,  2.0,  4.0]
    @test_approx_eq a [0.0, pi/4.0, pi/6.0]
    r, a = recpol(1, 1)
    @test_approx_eq r sqrt(2.0)
    @test_approx_eq a pi/4.0
    # Test polrec is the inverse of recpol
    local xi = 6.3, yi = -2.7, x = y = 0.0
    x, y = polrec(recpol((xi, yi), degrees=true), degrees=true)
    @test_approx_eq x xi
    @test_approx_eq y yi
end

# Test rhotheta
let
    local ρ, θ
    ρ, θ = rhotheta(41.623, 1934.008, 0.2763, 0.907, 59.025, 23.717, 219.907, 1980)
    @test_approx_eq ρ 0.4110177665209899
    @test_approx_eq θ 318.4242565041763
end

# Test "sixty".  Test also it's the reverse of ten.
@test_approx_eq sixty(-51.36) [-51.0, 21.0, 36.0]
@test_approx_eq ten(sixty(-0.10934835545824395)) -0.10934835545824395
@test_approx_eq sixty(1) [1.0, 0.0, 0.0]

# Test sphdist.
@test_approx_eq sphdist([0,1,2], [1,2,3], [2,3,4], [3,4,5]) [1.222450611061632,
                                                             2.500353926443337,
                                                             1.5892569925227762]
@test_approx_eq sphdist(120, -43, 175, +22) 1.5904422616007134
@test_approx_eq sphdist([120], [-43], 175, +22) 1.5904422616007134
@test_approx_eq sphdist(120, -43, [175], [+22]) 1.5904422616007134

# Test "ten" and "tenv".  Always make sure string and numerical inputs are
# consistent (IDL implementation of "ten" is not).
@test ten(0, -23, 34) == ten(" : 0 -23 :: 34") == -0.37388888888888894
@test ten(-0.0, 60) == ten("-0.0 60") == -1.0
@test ten([-5, -60, -3600]) == ten("  -5: :-60: -3600") == -3.0
@test ten("") == 0.0
@test tenv([0, -0.0, -5], [-23, 60, -60], [34, 0, -3600]) ==
    tenv(["0   -23 :: 34", ":-0.0:60", " -5:-60: -3600"]) ==
    [-0.37388888888888894, -1.0, -3.0]
@test tenv([12.0, -0.0], [24, 30]) == tenv([" 12::24", " -0:30: "]) == [12.4, -0.5]

# Test vactoair and that airtovac is its inverse (it isn't true only around
# 2000, just avoid those values)
@test_approx_eq vactoair([2000]) [1999.3526230448367]
@test_approx_eq airtovac(vactoair(collect(1000:300:4000))) collect(1000:300:4000)

# Test xyz
let
    local x, y, z, vx, vy, vz
    x, y, z, vx, vy, vz = xyz([51200.5 + 64./86400.], equinox=2000)
    @test_approx_eq x  [0.5145687092402946]
    @test_approx_eq y  [-0.7696326261820777]
    @test_approx_eq z  [-0.33376880143026394]
    @test_approx_eq vx [0.014947267514081075]
    @test_approx_eq vy [0.008314838205475709]
    @test_approx_eq vz [0.003606857607574784]
end
