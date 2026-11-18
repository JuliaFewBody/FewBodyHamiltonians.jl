# Changelog

## 0.1.0

- Own the particle-indexed construction API previously defined in FewBodyECG:
  physical terms, unit labels, ordered Hamiltonian algebra and Gaussian products.
- Add public `kinetic`, `validate`, `exponent_matrix` and `unit_system` helpers
  for solver adapters, and export the operator extension supertypes.
- Preserve positional `Coulomb` and variadic `Hamiltonian` construction. Legacy
  `Kinetic(n, ℏ, m)` now returns the explicit `ParticleKinetic` compatibility type;
  full-system solvers use `Kinetic(masses)`.
- Validate particle indices, charge/unit consistency, matrix dimensions and
  custom quadrature hints. Support Julia 1.10 and later.
- Use Float64 physical coefficients consistently and reject conversion overflow;
  retain display support for legacy and backend-specific terms.
