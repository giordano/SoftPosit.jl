@testset "Arithmetics" begin
    f0,f1,f2,f3,f4 = 0.125,-0.5,1.75,2.5,0.0

    # basic arithmetic operations
    @test Posit8(f0+f1*f2-f3) == Posit8(f0)+Posit8(f1)*Posit8(f2)-Posit8(f3)
    @test Posit16(f0/f1) == Posit16(f0)/Posit16(f1)
    @test Posit32(sqrt(f0)*f1/f3) == sqrt(Posit32(f0))*Posit32(f1)/Posit32(f3)

    # triggering complex infinity and conversion to inf
    @test Inf == Float64(Posit24_2(1.0)/Posit24_2(0.0))
end
