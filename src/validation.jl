"""
    kinetic(H::Hamiltonian) -> Kinetic

Return the unique full-system kinetic term defining the particle masses and
unit labels. A potential-only sum or a legacy particle-kinetic Hamiltonian does
not define a full system and raises `ArgumentError`.
"""
function kinetic(H::Hamiltonian)
    count(t -> t isa Kinetic, H.terms) == 1 || throw(
        ArgumentError("the Hamiltonian needs exactly one Kinetic(masses) term to define the particles")
    )
    return H.terms[findfirst(t -> t isa Kinetic, H.terms)]::Kinetic
end

"""
    exponent_matrix(g::Gaussian, nparticles)

Return the particle-space matrix `G` such that the Gaussian product has exponent
`-x' * G * x` for each Cartesian component. Reject out-of-range particle indices.
"""
exponent_matrix(g::Gaussian, nparticles::Integer) = _pair_matrix(g.factors, nparticles)

function _check_charges(t::Coulomb, N, units)
    t.n_charges == N || throw(
        ArgumentError("Coulomb(charges) has $(t.n_charges) charges but Kinetic has $N masses")
    )
    units == _UNIT_PRESETS.atomic || throw(
        ArgumentError(
            "Coulomb(charges) uses couplings qᵢqⱼ, which assumes atomic units " *
                "(e²/4πε₀ = 1); this system uses $units. Write each pair as " *
                "Coulomb(i, j; coefficient = k * qᵢ * qⱼ) with k = e²/4πε₀ in your " *
                "units (k ≈ 1.44 MeV fm for :nuclear)."
        )
    )
    return nothing
end

_validate_term(::Operator, N, units) = nothing
function _validate_term(t::Union{Coulomb, Oscillator, Custom, Tensor, SpinOrbit}, N, units)
    _check_pair(t.i, t.j)
    max(t.i, t.j) ≤ N || throw(ArgumentError("particle index $(max(t.i, t.j)) out of range 1:$N"))
    t isa Coulomb && t.n_charges > 0 && _check_charges(t, N, units)
    return nothing
end
function _validate_term(t::Gaussian, N, units)
    for (i, j, γ) in t.factors
        _check_pair(i, j)
        _check_exponent(γ, "Gaussian")
        max(i, j) ≤ N || throw(ArgumentError("particle index $(max(i, j)) out of range 1:$N"))
    end
    return nothing
end
function _validate_term(t::ManyBodyGaussian, N, units)
    size(t.G) == (N, N) || throw(
        ArgumentError("ManyBodyGaussian G is $(size(t.G, 1))×$(size(t.G, 2)), but Kinetic has $N masses")
    )
    return nothing
end

"""
    validate(H::Hamiltonian) -> H

Check that a full-system Hamiltonian has exactly one `Kinetic(masses)` and
consistent particle indices, Gaussian matrix dimensions and charge shorthand.
`Coulomb(charges)` assumes atomic units; explicit pair couplings work with any
unit labels. Backends separately check which operator types they support.
"""
function validate(H::Hamiltonian)
    K = kinetic(H)
    for t in H
        _validate_term(t, length(K.masses), K.units)
    end
    return H
end
