# FewBodyHamiltonians.jl

Shared, particle-indexed Hamiltonian construction for the JuliaFewBody solvers.
Define a system once, then pass the same value to a solver supporting its terms:

```julia
using FewBodyHamiltonians

H = Kinetic([1.0e15, 1.0, 1.0]) + Coulomb([2, -1, -1])  # helium
validate(H)
```

`Kinetic` defines the masses and particle ordering. Pair interactions use those
indices, for example `Coulomb(1, 2; coefficient = -2)` or
`-10 * Gaussian(1, 2; exponent = 0.5)`. Use `+`, `-`, scalar multiplication,
division and `sum`; Gaussian products describe many-body Gaussian forces.
`Hamiltonian(term1, term2, ...)` is equivalent to an ordered sum.

The construction API includes `UnitSystem`, `Hamiltonian`, `Kinetic`, `Coulomb`,
`Gaussian`, `ManyBodyGaussian`, `Oscillator`, `Custom`, `Tensor` and `SpinOrbit`.
Solvers keep their own numerical operators and explicitly reject unsupported
terms. Unit labels never convert masses or coefficients; `Coulomb(charges)`
assumes atomic units, while explicit pair coefficients support other conventions.

## Solver integration

Use consumer releases that depend on FewBodyHamiltonians 0.1. Earlier consumer
releases may still define their own construction types.

```julia
import FewBodyECG
result = FewBodyECG.solve(H, FewBodyECG.SVM(40))
```

FewBodyECG re-exports these exact shared types. FewBodyVMC accepts shared atomic
kinetic/Coulomb systems. TwoBody accepts two-particle spin-independent systems,
reducing the masses to the relative-coordinate mass. Each solver documents its
supported terms; a shared representation does not imply identical solver features.

## Migrating from 0.0.2

Version 0.1 moves the tested construction API from FewBodyECG into this package.
`Coulomb(i, j, coefficient)` and `Hamiltonian(terms...)` remain available.
The old `Kinetic(n, ℏ, m)` constructor returns `ParticleKinetic`, retaining the
legacy fields and meaning; code dispatching on its former concrete type must
use `ParticleKinetic`. Full-system solvers require `Kinetic(masses)` instead and
never interpret a legacy particle kinetic term as a reduced-mass term.
Physical terms use Float64 masses and couplings, matching the ECG construction
API; legacy Coulomb coefficients outside the finite Float64 range now raise an
argument error instead of being stored as a wider real value.

Julia 1.10 and later are supported. The package uses only the standard library.

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaFewBody.github.io/FewBodyHamiltonians.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaFewBody.github.io/FewBodyHamiltonians.jl/dev/)
[![Build Status](https://github.com/JuliaFewBody/FewBodyHamiltonians.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JuliaFewBody/FewBodyHamiltonians.jl/actions/workflows/CI.yml?query=branch%3Amain)

## Documentation

See https://juliafewbody.github.io/FewBodyHamiltonians.jl/.

## Citation

See [`CITATION.bib`](CITATION.bib) for the relevant reference(s).
