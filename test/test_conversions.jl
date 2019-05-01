@testset "Conversions" begin
    x = 1.25
    i = 4

    # Floats test conversion back and forth
    @test x == Float64(Posit8(x))
    @test x == Float64(Posit16(x))
    @test x == Float64(Posit32(x))

    @test x == Float32(Posit8_2(x))
    @test x == Float32(Posit16_2(x))
    @test x == Float32(Posit24_2(x))

    # Posit to Posit back and forth
    @test Posit8(x) == Posit8(Posit16(x))
    @test Posit32(x) == Posit32(Posit16(Posit8_2(x)))

    # Int to posit back and forth
    @test i == Int64(Posit8(i))
    @test i == Int64(Posit16(i))
    @test i == Int64(Posit32(i))
end
