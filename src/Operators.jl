export Operator, Hamiltonian, getindex, Kinetic, Coulomb

# type

abstract type Operator end
abstract type PotentialTerm <: Operator end
abstract type KineticTerm <: Operator end

# struct

struct Hamiltonian
  terms::Array{Operator,1}
  Hamiltonian(args...) = new([args...])
end

struct Kinetic <: KineticTerm
  n::Int
  ℏ::Real
  m::Real
end

struct Coulomb <: PotentialTerm
  i::Int
  j::Int
  coefficient::Real
end

# utility

Base.string(t::Operator) = "$(typeof(t))(" * join(["$(symbol)=$(getproperty(t,symbol))" for symbol in fieldnames(typeof(t))], ", ") * ")"
Base.string(H::Hamiltonian) = "Hamiltonian(" * join(["$(term)" for term in H.terms], ", ") * ")"
Base.show(io::IO, t::Operator) = print(io, Base.string(t))
Base.show(io::IO, H::Hamiltonian) = print(io, Base.string(H))
Base.getindex(H::Hamiltonian, index) = H.terms[index]
Base.length(H::Hamiltonian) = length(H.terms)

# function

V(p::Coulomb, r) = p.coefficient / r

# docstring

@doc raw"""
`Operator` is an abstract type.
""" Operator

@doc raw"""
`PotentialTerm <: Operator` is an abstract type.
""" PotentialTerm

@doc raw"""
`KineticTerm <: Operator` is an abstract type.
""" KineticTerm

@doc raw"""
`Hamiltonian(operator1, operator2, ...)`
```math
\hat{H} = \sum_i \hat{o}_i
```

The Hamiltonian is the input for each solver. This is an example for the non-relativistic Hamiltonian of hydrogen atom in atomic units:

```math
\hat{H} = 
- \frac{1}{2} \nabla^2
- \frac{1}{r}
```

```@example
H = Hamiltonian(
  NonRelativisticKinetic(ℏ =1 , m = 1),
  CoulombPotential(coefficient = -1),
)
```
""" Hamiltonian

@doc raw"""
`Kinetic(n::Int, ℏ::Real, m::Real)`
```math
-\frac{\hbar^2}{2m} \nabla^2_{n}
```
""" Kinetic

@doc raw"""
`Coulomb(i::Int, j::Int, coefficient::Real)`
```math
+ \frac{a}{r_{ij}}
```
| Arguments | Symbol |
| :-- | :-- |
| `i` | ``i`` |
| `j` | ``j`` |
| `coefficient` | ``a`` |
""" Coulomb