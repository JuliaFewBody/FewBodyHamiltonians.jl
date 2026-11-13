module FewBodyHamiltonians

import LinearAlgebra

export Operator, PotentialTerm, KineticTerm, UnitSystem,
    Hamiltonian, Kinetic, Coulomb, Gaussian, ManyBodyGaussian, Oscillator, Custom,
    Tensor, SpinOrbit, ParticleKinetic, kinetic, validate, exponent_matrix, unit_system

include("Operators.jl")
include("units.jl")
include("construction.jl")
include("validation.jl")
include("legacy.jl")

end
