# This file is a part of AstroLib.jl. License is MIT "Expat".

const dcfel = [ 1.7400353  6.2833195099091e2  5.2796e-6 ;
                6.2565836  6.2830194572674e2 -2.6180e-6 ;
                4.7199666  8.3997091449254e3 -1.9780e-5 ;
                0.19636505 8.4334662911720e3 -5.6044e-5 ;
                4.1547339  5.2993466764997e1  5.8845e-6 ;
                4.6524223  2.1354275911213e1  5.6797e-6 ;
                4.2620486  7.5025342197656    5.5317e-6 ;
                1.4740694  3.8377331909193    5.6093e-6 ]

const ccsel = [ 1.675104e-2 -4.179579e-5 -1.260516e-7 ;
                2.220221e-1  2.809917e-2  1.852532e-5 ;
                1.589963     3.418075e-2  1.430200e-5 ;
                2.994089     2.590824e-2  4.155840e-6 ;
                8.155457e-1  2.486352e-2  6.836840e-6 ;
                1.735614     1.763719e-2  6.370440e-6 ;
                1.968564     1.524020e-2 -2.517152e-6 ;
                1.282417     8.703393e-3  2.289292e-5 ;
                2.28082      1.918010e-2  4.484520e-6 ;
                4.833473e-2  1.641773e-4 -4.654200e-7 ;
                5.589232e-2 -3.455092e-4 -7.388560e-7 ;
                4.634443e-2 -2.658234e-5  7.757000e-8 ;
                8.997041e-3  6.329728e-6 -1.939256e-9 ;
                2.284178e-2 -9.941590e-5  6.787400e-8 ;
                4.350267e-2 -6.839749e-5 -2.714956e-7 ;
                1.348204e-2  1.091504e-5  6.903760e-7 ;
                3.106570e-2 -1.665665e-4 -1.590188e-7 ]

const dcargs = [ 5.0974222 -7.8604195454652e2 ;
                 3.9584962 -5.7533848094674e2 ;
                 1.633807  -1.1506769618935e3 ;
                 2.5487111 -3.9302097727326e2 ;
                 4.9255514 -5.8849265665348e2 ;
                 1.3363463 -5.5076098609303e2 ;
                 1.6072053 -5.2237501616674e2 ;
                 1.362948  -1.1790629318198e3 ;
                 5.5657014 -1.0977134971135e3 ;
                 5.0708205 -1.5774000881978e2 ;
                 3.9318944  5.296346478e1     ;
                 4.8989497  3.9809289073258e1 ;
                 1.3097446  7.7540959633708e1 ;
                 3.5147141  7.9618578146517e1 ;
                 3.5413158 -5.4868336758022e2 ]

const ccamps = [-2.279594e-5  1.407414e-5  8.273188e-6  1.340565e-5 -2.490817e-7 ;
                -3.494537e-5  2.860401e-7  1.289448e-7  1.627237e-5 -1.823138e-7 ;
                 6.593466e-7  1.322572e-5  9.258695e-6 -4.674248e-7 -3.646275e-7 ;
                 1.140767e-5 -2.049792e-5 -4.747930e-6 -2.638763e-6 -1.245408e-7 ;
                 9.516893e-6 -2.748894e-6 -1.319381e-6 -4.549908e-6 -1.864821e-7 ;
                 7.310990e-6 -1.924710e-6 -8.772849e-7 -3.334143e-6 -1.745256e-7 ;
                -2.603449e-6  7.359472e-6  3.168357e-6  1.119056e-6 -1.655307e-7 ;
                -3.228859e-6  1.308997e-7  1.013137e-7  2.403899e-6 -3.736225e-7 ;
                 3.442177e-7  2.671323e-6  1.832858e-6 -2.394688e-7 -3.478444e-7 ;
                 8.702406e-6 -8.421214e-6 -1.372341e-6 -1.455234e-6 -4.998479e-8 ;
                -1.488378e-6 -1.251789e-5  5.226868e-7 -2.049301e-7  0           ;
                -8.043059e-6 -2.991300e-6  1.473654e-7 -3.154542e-7  0           ;
                 3.699128e-6 -3.316126e-6  2.901257e-7  3.407826e-7  0           ;
                 2.550120e-6 -1.241123e-6  9.901116e-8  2.210482e-7  0           ;
                -6.351059e-7  2.341650e-6  1.061492e-6  2.878231e-7  0           ]

const ccsec = [ 1.289600e-6 5.550147e-1  2.076942    ;
                3.102810e-5 4.035027     3.525565e-1 ;
                9.124190e-6 9.990265e-1  2.622706    ;
                9.793240e-7 5.508259     1.559103e01 ]

const dcargm = [5.167983  8.3286911095275e3 ;
                5.491315 -7.2140632838100e3 ;
                5.959853  1.5542754389685e4 ]

const ccampm = [ 1.097594e-1 2.896773e-7 5.450474e-2  1.438491E-7 ;
                -2.223581e-2 5.083103e-8 1.002548e-2 -2.291823E-8 ;
                 1.148966e-2 5.658888e-8 8.249439e-3  4.063015E-8 ]

const ccpamv = [8.326827e-11, 1.843484e-11, 1.988712e-12, 1.881276e-12]

function _baryvel(dje::T, deq::T) where {T<:AbstractFloat}
    # Time arguments.
    dt = (dje - 2415020) / JULIANCENTURY
    tvec = [1; dt; dt*dt]

    temp = rem.(dcfel * tvec, 2 * T(pi))
    dml, g = temp[1:2]
    forbel = temp[2:8]
    deps = rem.(dot(tvec, [0.4093198; -2.271110e-4; -2.860401e-8]), 2 * T(pi))
    sorbel = rem.(ccsel * tvec, 2 * T(pi))
    e = sorbel[1]

    # Secular perturbations in longitude.
    sn = sin.(rem.(ccsec[:,2:3] * tvec[1:2], 2 * T(pi)))

    # Periodic perturbations of the emb (earth-moon barycenter).
    pertl = dot(ccsec[:,1], sn) + dt * sn[3] * -7.757020e-8
    a = rem.(dcargs[:,1] + dt * dcargs[:,2], 2 * T(pi))
    cosa = cos.(a)
    sina = sin.(a)
    pertr = zero(T)
    pertld = zero(T)
    pertrd = zero(T)
    for i = 1:14
        pertl += ccamps[i, 1] * cosa[i] + ccamps[i, 2] * sina[i]
        pertr += ccamps[i, 3] * cosa[i] + ccamps[i, 4] * sina[i]
        if i < 12
            pertld += (ccamps[i, 2] * cosa[i] - ccamps[i, 1] * sina[i]) * ccamps[i, 5]
            pertrd += (ccamps[i, 4] * cosa[i] - ccamps[i, 3] * sina[i]) * ccamps[i, 5]
        end
    end

    # Elliptic part of the motion of the emb
    f = ((e^2)/4) * (((8/e) - e) * sin(g) + 5 * sin(2 * g) + (13/3) * e * sin(3 * g)) + g
    sinf = sin(f)
    cosf = cos(f)
    dpsi = (1 - e^2) / (1 + e * cosf)
    phid = 2 * e * 1.990969e-7 * ((1 + 1.5 * e^2) * cosf + e * (1.25 - 0.5 * sinf^2))
    psid = (1.990969e-7 * e * sinf) / sqrt(1 - e^2)

    # Perturbed heliocentric motion of the emb.
    drd = (1 + pertr) * (psid + dpsi * pertrd)
    drld = (1 + pertr) * dpsi * (1.990987e-7  + phid + pertld)
    dtl = rem(dml + f - g + pertl, 2 * T(pi))
    dsinls = sin(dtl)
    dcosls = cos(dtl)
    dxhd = drd * dcosls - drld * dsinls
    dyhd = drd * dsinls + drld * dcosls

    # Influence of eccentricity, evection and variation on the geocentric
    a = rem.(dcargm[:, 1] + dt * dcargm[:, 2], 2 * T(pi))
    sina = sin.(a)
    cosa = cos.(a)
    pertl_m = zero(T)
    pertld_m = zero(T)
    pertp_m = zero(T)
    pertpd_m = zero(T)
    for i = 1:3
        pertl_m += ccampm[i, 1] * sina[i]
        pertld_m += ccampm[i, 2] * cosa[i]
        pertp_m += ccampm[i, 3] * cosa[i]
        pertpd_m += - ccampm[i, 4] * sina[i]
    end

    # Heliocentric motion of the earth.
    tl = forbel[2] + pertl_m
    sinlm = sin(tl)
    coslm = cos(tl)
    sigma = 3.122140e-5 / (1 + pertp_m)
    a = sigma * (2.661699e-6 + pertld_m)
    b = sigma * pertpd_m
    dxhd += a * sinlm + b * coslm
    dyhd -= a * coslm + b * sinlm
    dzhd= -sigma * cos(forbel[3]) * 2.399485e-7

    # Barycentric motion of the earth.
    dxbd = dxhd * 0.99999696
    dybd = dyhd * 0.99999696
    dzbd = dzhd * 0.99999696
    for i = 1:4
        plon = forbel[i+3]
        pomg = sorbel[i+1]
        pecc = sorbel[i+9]
        tl = rem(plon + 2 * pecc * sin(plon-pomg), 2 * T(pi))
        dxbd += ccpamv[i] * (sin(tl) + pecc * sin(pomg))
        dybd -= ccpamv[i] * (cos(tl) + pecc * cos(pomg))
        dzbd -= ccpamv[i] * sorbel[i+13] * cos(plon - sorbel[i+5])
    end

    # Transition to mean equator of date.
    dcosep = cos(deps)
    dsinep = sin(deps)
    dyahd = dcosep * dyhd - dsinep * dzhd
    dzahd = dsinep * dyhd + dcosep * dzhd
    dyabd = dcosep * dybd - dsinep * dzbd
    dzabd = dsinep * dybd + dcosep * dzbd

    if deq == 0
        dvelh = AU/1000 * ([dxhd, dyahd, dzahd])
        dvelb = AU/1000 * ([dxbd, dyabd, dzabd])
    else
        deqdat = ((dje - 2415020.313) / 365.24219572) + 1900
        prema = premat(deqdat, deq, FK4 = true)
        dvelh = AU/1000 * (prema * [dxhd, dyahd, dzahd])
        dvelb = AU/1000 * (prema * [dxbd, dyabd, dzabd])
    end
    return dvelh, dvelb
end

"""
    baryvel(dje, deq) -> dvelh, dvelb

### Purpose ###

Calculates heliocentric and barycentric velocity components of Earth.

### Explanation ###

Baryvel takes into account the Earth-Moon motion, and is useful for radial velocity
work to an accuracy of ~1 m/s.

### Arguments ###

* `dje`: julian ephemeris date
* `deq`: epoch of mean equinox of `dvelh` and `dvelb`. If deq=0, then deq is
  assumed to be equal to `dje``

### Output ###

* `dvelh`: heliocentric velocity component. in km/s
* `dvelb`: barycentric velocity component. in km/s

### Example ###

Compute the radial velocity of the Earth toward Altair on 15-Feb-1994 using 
both the original Stumpf algorithm.

```jldoctest
julia> jd = jdcnv(1994, 2, 15, 0)
2.4493985e6

julia> baryvel(jd, 2000)
([-17.0725, -22.8111, -9.88926], [-17.0809, -22.8046, -9.88621])
```

### Notes ###

The 3-vectors outputs `dvelh` and `dvelb` are given in a right-handed coordinate
system with the +X axis toward the Vernal Equinox, and +Z axis toward the celestial pole.

Code of this function is based on IDL Astronomy User's Library.
"""
baryvel(dje::Real, deq::Real) = _baryvel(promote(float(dje), float(deq))...)
