```@meta
CurrentModule = FewBodyHamiltonians
```

# FewBodyHamiltonians.jl

Documentation for [FewBodyHamiltonians.jl](https://github.com/JuliaFewBody/FewBodyHamiltonians.jl).

## Construct once, solve with a backend

```@example construction
using FewBodyHamiltonians
H = Kinetic([1.0e15, 1.0, 1.0]) + Coulomb([2, -1, -1])
validate(H)
```

`Kinetic(masses)` fixes the particle ordering and removes center-of-mass motion
in each backend. Add pair terms using the same indices:

```@example construction
V = -10 * Gaussian(1, 2; exponent = 0.5) + 0.25 * Oscillator(2, 3)
H2 = Kinetic([2.0, 1.0, 1.0]) + V
threebody = Gaussian(1, 2; exponent = 0.5) * Gaussian(2, 3; exponent = 0.5)
validate(H2 + threebody)
```

Unit labels do not convert values. The kinetic convention is ℏ=1, so nuclear
masses are expressed as `mc²/(ℏc)²` when using MeV and fm. `Coulomb(charges)`
assumes atomic Coulomb couplings; for other units, write explicit pair
coefficients in those units.

## Backend capabilities

These integrations require consumer versions depending on FewBodyHamiltonians
0.1; earlier releases may still define separate construction types.

| Backend | Shared terms supported |
| --- | --- |
| FewBodyECG | All construction terms; spin terms require its spin-dependent matrix layer |
| FewBodyVMC | Atomic-unit `Kinetic` and `Coulomb` |
| TwoBody | Two-particle `Kinetic`, `Coulomb`, `Gaussian`, `ManyBodyGaussian`, `Oscillator`, `Custom` |

Each backend validates its numerical restrictions. `Custom` quadrature options
are hints honored by FewBodyECG; TwoBody uses its backend quadrature settings,
and VMC does not support `Custom`. FewBody re-exports construction without
providing an umbrella solver. Use qualified solver names when importing several
backends together.

## Legacy particle terms

`Kinetic(n, ℏ, m)` remains available as a compatibility constructor returning
`ParticleKinetic`. Its single-particle meaning differs from `Kinetic(masses)`;
full-system backends do not guess missing masses or remove center-of-mass motion
from legacy input. `Coulomb(i, j, coefficient)` and `Hamiltonian(terms...)` remain
available, with the same pair coefficients and insertion order.

```@index
```

```@autodocs
Modules = [FewBodyHamiltonians]
```
