# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

"""
    kepler_solver(M, e) -> E

### Purpose ###

Solve Kepler's equation in the elliptic motion regime (\$0 \\leq e \\leq 1\$)
and return eccentric anomaly \$E\$.

### Explanation ###

In order to find the position of a body in elliptic motion (e.g., in the
two-body problem) at a given time \$t\$, one has to solve the [Kepler's
equation](https://en.wikipedia.org/wiki/Kepler%27s_equation)

\$\$ M(t) = E(t) - e\\sin E(t)\$\$

where \$M(t) = (t - t_{0})/P\$ is the mean anomaly, \$E(t)\$ the eccentric
anomaly, \$e\$ the eccentricity of the orbit, \$t_0\$ is the time of periapsis
passage, and \$P\$ is the period of the orbit.  Usually the eccentricity is
given and one wants to find the eccentric anomaly \$E(t)\$ at a specific time
\$t\$, so that also the mean anomaly \$M(t)\$ is known.

Once that the Kepler's equation is solved and \$E(t)\$ is determined, the polar
coordinates \$(r(t), θ(t))\$ of the body at time \$t\$ in the elliptic orbit are
given by

\$\$ θ(t) = 2\\arctan \\left(\\sqrt{\\frac{1 + e}{1 - e}} \\tan\\frac{E(t)}{2} \\right)\$\$
\$\$ r(t) = \\frac{a(1 - e^{2})}{1 + e\\cos(θ(t) - θ_{0})}\$\$

in which \$a\$ is the semi-major axis of the orbit, and \$θ_0\$ the value
of angular coordinate at time \$t = t_{0}\$.

### Arguments ###

* `M`: mean anomaly
* `e`: eccentricity, in the elliptic motion regime (\$0 \\leq e \\leq 1\$)

### Output ###

The eccentric anomaly \$E\$, restricted to the range \$[-π, π]\$.

### Method ###

Many different numerical methods exist to solve Kepler's equation.  This
function implements the algorithm proposed in Markley (1995) Celestial Mechanics
and Dynamical Astronomy, 63, 101
(DOI:[10.1007/BF00691917](http://dx.doi.org/10.1007/BF00691917)).  This method
is not iterative, requires only four transcendental function evaluations, and
has been proved to be fast and efficient over the entire range of elliptic
motion \$0 \\leq e \\leq 1\$.

### Example ###

Find the angular polar coordinate \$θ(t)\$ for an orbit with eccentricity \$e =
0.7\$ and for \$M(t) = 8π/3\$.

``` julia
julia> ecc = 0.7;

julia> E = kepler_solver(8pi/3, ecc)
2.5085279492864223

julia> θ = 2*atan(sqrt((1.0 + ecc)/(1.0 - ecc))*tan(E/2.0))
2.8681167800611607
```
"""
function kepler_solver{T<:AbstractFloat}(M::T, e::T)
    if 0 <= e <= 1
        # M is assumed to be in the range [-pi, pi], see Markley (1995), page 2.
        # First restrict it to [0, 2pi], then move values above pi to [-pi, 0].
        M = cirrange(M, 2.0*pi)
        M > pi && (M -= 2.0*pi)
        if M == 0
            return 0.0
        else
            # equation (20)
            α = (3.0*pi*pi + 1.6*pi*(pi - abs(M))/(1.0 + e))/(pi*pi - 6.0)
            # equation (5)
            d = 3.0*(1.0 - e) + α*e
            # equation (9)
            q = 2.0*α*d*(1.0 - e) - M*M
            # equation (10)
            r = 3.0*α*d*(d - 1.0 + e)*M + M*M*M
            # equation (14)
            w = (abs(r) + sqrt(q*q*q + r*r))^(2.0/3.0)
            # equation (15)
            E1 = (2.0*r*w/(w*w + w*q + q*q) + M)/d
            # equation (21)
            f0 = E1 - e*sin(E1) - M
            # equation (25)
            f1 = 1.0 - e*cos(E1)
            # equation (26)
            f2 = e*sin(E1)
            # equation (27)
            f3 = 1.0 - f1
            # equation (28)
            f4 = -f2
            # equation (22)
            δ3 = -f0/(f1 - f0*f2/(2.0*f1))
            # equation (23)
            δ4 = -f0/(f1 + δ3*f2/2.0 + δ3*δ3*f3/6.0)
            # equation (24)
            δ5 = -f0/(f1 + δ4*f2/2.0 + δ4*δ4*f3/6.0 + δ4*δ4*δ4*f4/24.0)
            return E1 + δ5 # equation 29
        end
    else
        error("eccentricity must be in the range [0, 1]")
    end
end

kepler_solver(M::Real, e::Real) =
    kepler_solver(promote(float(M), float(e))...)
