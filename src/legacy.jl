"""
    ParticleKinetic(n, ℏ, m)

Legacy single-particle term `-ℏ²∇ₙ²/(2m)`, also constructed by the pre-0.1
signature `Kinetic(n, ℏ, m)`. It is not a full-system `Kinetic(masses)` and is
not implicitly interpreted as a center-of-mass-free or reduced-mass operator.
"""
struct ParticleKinetic <: KineticTerm
    n::Int
    ℏ::Real
    m::Real
    function ParticleKinetic(n::Integer, ℏ::Real, m::Real)
        n > 0 || throw(ArgumentError("particle indices start at 1"))
        isfinite(ℏ) && ℏ > 0 || throw(ArgumentError("ℏ must be finite and positive"))
        isfinite(m) && m > 0 || throw(ArgumentError("mass must be finite and positive"))
        return new(n, ℏ, m)
    end
end

Kinetic(n::Integer, ℏ::Real, m::Real) = ParticleKinetic(n, ℏ, m)
Coulomb(i::Integer, j::Integer, coefficient::Real) = Coulomb(i, j; coefficient)

"""Evaluate a Coulomb term at pair distance `r` (legacy helper)."""
V(t::Coulomb, r) = t.coefficient / r
