"""Supertype of physical Hamiltonian terms and backend-specific operators."""
abstract type Operator end
"""Supertype of potential-energy terms."""
abstract type PotentialTerm <: Operator end
"""Supertype of kinetic-energy terms."""
abstract type KineticTerm <: Operator end
