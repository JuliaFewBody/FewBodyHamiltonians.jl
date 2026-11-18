@testset "Particle-indexed construction" begin
    masses = [4.0, 2.0, 1.0]
    H = Kinetic(masses) + Coulomb([2, -1, -1])
    @test H isa Hamiltonian
    @test length(H) == 4
    @test kinetic(H).masses == masses
    @test kinetic(H).units == UnitSystem("Ha", "bohr")
    @test [(t.i, t.j, t.coefficient) for t in H.terms[2:end]] ==
        [(1, 2, -2.0), (1, 3, -2.0), (2, 3, 1.0)]
    @test validate(H) === H
    @test collect(H) == H.terms
    @test length(Hamiltonian(Kinetic(masses), Coulomb(1, 2; coefficient = -2))) == 2
    @test length(Hamiltonian(H.terms)) == 4
    @test isempty(collect(Hamiltonian()))
    @test Kinetic(view(masses, :)).masses == masses

    V = -2 * Gaussian(1, 2; exponent = 0.5) + Oscillator(2, 3) / 4
    @test V[1].coefficient == -2.0
    @test V[2].coefficient == 0.25
    @test length(sum(Coulomb(i, j) for i in 1:3 for j in (i + 1):3)) == 3
    @test (-(2 * Coulomb(1, 2))).coefficient == -2.0
    @test (Coulomb(1, 2) * 3).coefficient == 3.0
    @test (2 * V)[2].coefficient == 0.5

    product = Gaussian(1, 2; exponent = 0.5) * Gaussian(2, 3; exponent = 2)
    G = [0.5 -0.5 0.0; -0.5 2.5 -2.0; 0.0 -2.0 2.0]
    @test exponent_matrix(product, 3) == G
    @test validate(Kinetic(masses) + product) isa Hamiltonian
    mb = ManyBodyGaussian(G; coefficient = -3)
    @test (mb * ManyBodyGaussian(G)).G == 2G
    @test (Gaussian(1, 2; exponent = 1) * mb).G == G + [1 -1 0; -1 1 0; 0 0 0]
    @test (mb * Gaussian(1, 2; exponent = 1)).G == G + [1 -1 0; -1 1 0; 0 0 0]
    @test (2 * mb).coefficient == -6
    @test (2 * Tensor(1, 2; exponent = 1, traceless = false)).traceless == false
    @test (-SpinOrbit(1, 2; exponent = 1)).coefficient == -1
    custom = -3 * Custom(r -> r^2, 1, 2)
    @test custom.coefficient * custom.f(2) == -12
    @test all(t.n_charges == 3 for t in 2 * Coulomb([2, -1, -1]))

    @test unit_system(:nuclear) == UnitSystem("MeV", "fm")
    u = UnitSystem("GeV", "GeV⁻¹")
    @test unit_system(u) === u
    @test occursin("3 particles; Ha, bohr", sprint(show, MIME"text/plain"(), H))
    @test occursin("- 2.0 Coulomb(1, 2)", sprint(show, MIME"text/plain"(), H))
end

@testset "Validation before backend conversion" begin
    @test_throws ArgumentError Kinetic([1.0])
    @test_throws ArgumentError Kinetic([1.0, -1.0])
    @test_throws ArgumentError Kinetic([Inf, 1.0])
    @test_throws ArgumentError Kinetic([1.0, 1.0]; units = :unknown)
    @test_throws ArgumentError Coulomb(1, 1)
    @test_throws ArgumentError Coulomb(0, 2)
    @test_throws ArgumentError Coulomb([1.0])
    @test_throws ArgumentError Coulomb(1, 2; coefficient = Inf)
    @test_throws ArgumentError Gaussian(1, 2)
    @test_throws ArgumentError Gaussian(1, 2; exponent = -1)
    @test_throws ArgumentError Coulomb(1, 2) / 0
    @test_throws ArgumentError (1 + im) * Coulomb(1, 2)
    @test_throws ArgumentError 2 * Kinetic([1.0, 1.0])
    @test_throws ArgumentError Coulomb(1, 2) * Oscillator(1, 2)
    @test_throws ArgumentError ManyBodyGaussian(zeros(0, 0))
    @test_throws ArgumentError ManyBodyGaussian(zeros(2, 3))
    @test_throws ArgumentError ManyBodyGaussian([1.0 0.0; 0.0 1.0])
    @test_throws ArgumentError ManyBodyGaussian([1.0 -1.0; 0.0 0.0])
    @test_throws ArgumentError Custom(identity, 1, 2; rtol = -1)
    @test_throws ArgumentError Custom(identity, 1, 2; atol = NaN)
    @test_throws ArgumentError Custom(identity, 1, 2; maxevals = 0)
    @test_throws ArgumentError Kinetic([1.0, 1.0]) + Kinetic([1.0, 1.0])
    @test_throws ArgumentError kinetic(Coulomb(1, 2) + Coulomb(1, 2))
    @test_throws ArgumentError validate(Hamiltonian())
    @test_throws ArgumentError validate(Kinetic([1.0, 1.0]) + Coulomb(1, 3))
    @test_throws ArgumentError validate(Kinetic([1.0, 1.0, 1.0]) + Coulomb([1, -1]))
    @test_throws ArgumentError validate(Kinetic([1.0, 1.0]; units = :nuclear) + Coulomb([1, -1]))
    @test validate(Kinetic([1.0, 1.0]; units = :nuclear) + Coulomb(1, 2; coefficient = 1.44)) isa Hamiltonian
    @test_throws ArgumentError validate(Kinetic([1.0, 1.0]) + ManyBodyGaussian([2.0 -1 -1; -1 2 -1; -1 -1 2]))
    @test_throws ArgumentError exponent_matrix(Gaussian(1, 3; exponent = 1), 2)
end

@testset "Legacy construction remains explicit" begin
    k = Kinetic(1, 1.0, 2.0)
    @test k isa KineticTerm
    @test (k.n, k.ℏ, k.m) == (1, 1.0, 2.0)
    c = Coulomb(1, 2, -1.0)
    @test (c.i, c.j, c.coefficient) == (1, 2, -1.0)
    @test length(Hamiltonian(k, c)) == 2
    @test_throws ArgumentError validate(Hamiltonian(k, c))
    @test FewBodyHamiltonians.V(c, 2.0) == -0.5
    @test occursin("ParticleKinetic", sprint(show, MIME"text/plain"(), Hamiltonian(k, c)))
    @test_throws ArgumentError Coulomb(1, 2, big"1e400")
    @test_throws ArgumentError Coulomb(1, 2; coefficient = big"1e400")
end
