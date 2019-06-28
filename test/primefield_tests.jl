@testset "Field Element Operations" begin
    @testset "Addition" begin
        a = secp256k1.FieldElement(2, 31)
        b = secp256k1.FieldElement(15, 31)
        @test a+b == secp256k1.FieldElement(17, 31)
        a = secp256k1.FieldElement(17, 31)
        b = secp256k1.FieldElement(21, 31)
        @test a+b == secp256k1.FieldElement(7, 31)
    end
    @testset "Substraction" begin
        a = secp256k1.FieldElement(29, 31)
        b = secp256k1.FieldElement(4, 31)
        @test a-b == secp256k1.FieldElement(25, 31)
        a = secp256k1.FieldElement(15, 31)
        b = secp256k1.FieldElement(30, 31)
        @test a-b == secp256k1.FieldElement(16, 31)
    end
    @testset "Multiplication" begin
        a = secp256k1.FieldElement(24, 31)
        b = secp256k1.FieldElement(19, 31)
        @test a*b == secp256k1.FieldElement(22, 31)
    end
    @testset "Power" begin
        a = secp256k1.FieldElement(17, 31)
        @test a^3 == secp256k1.FieldElement(15, 31)
        a = secp256k1.FieldElement(5, 31)
        b = secp256k1.FieldElement(18, 31)
        @test a^5 * b == secp256k1.FieldElement(16, 31)
    end
    @testset "Division" begin
        a = secp256k1.FieldElement(3, 31)
        b = secp256k1.FieldElement(24, 31)
        @test a/b == secp256k1.FieldElement(4, 31)
        a = secp256k1.FieldElement(17, 31)
        @test a^-3 == secp256k1.FieldElement(29, 31)
        a = secp256k1.FieldElement(4, 31)
        b = secp256k1.FieldElement(11, 31)
        @test a^-4*b == secp256k1.FieldElement(13, 31)
    end
end
