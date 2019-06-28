@testset "Elliptic Curve Point Operations" begin
    @testset "Integer Type" begin
        @testset "Not Equal" begin
            a = secp256k1.Point(3, -7, 5, 7)
            b = secp256k1.Point(18, 77, 5, 7)
            @test a != b
            @test !(a != a)
        end
        @testset "On Curve?" begin
            @test_throws DomainError secp256k1.Point(-2, 4, 5, 7)
            @test typeof(secp256k1.Point(3, -7, 5, 7)) <: secp256k1.Point
            @test typeof(secp256k1.Point(18, 77, 5, 7)) <: secp256k1.Point
        end
        @testset "Addition" begin
            @testset "Base Case" begin
                a = secp256k1.Point(∞, ∞, 5, 7)
                b = secp256k1.Point(2, 5, 5, 7)
                c = secp256k1.Point(2, -5, 5, 7)
                @test a + b == b
                @test b + a == b
                @test b + c == a
            end

            @testset "Case 1" begin
                a = secp256k1.Point(3, 7, 5, 7)
                b = secp256k1.Point(-1, -1, 5, 7)
                @test a + b == secp256k1.Point(2, -5, 5, 7)
            end

            @testset "Case 2" begin
                a = secp256k1.Point(-1, 1, 5, 7)
                @test a + a == secp256k1.Point(18, -77, 5, 7)
            end
        end
    end;

    @testset "FiniteElement Type" begin
        @testset "On curve?" begin
            𝑝 = 223
            𝑎, 𝑏 = secp256k1.FieldElement(0, 𝑝), secp256k1.FieldElement(7, 𝑝)

            valid_points = ((192, 105), (17, 56), (1, 193))
            invalid_points = ((200, 119), (42, 99))

            for 𝑃 ∈ valid_points
                𝑥 = secp256k1.FieldElement(𝑃[1], 𝑝)
                𝑦 = secp256k1.FieldElement(𝑃[2], 𝑝)
                @test typeof(secp256k1.Point(𝑥, 𝑦, 𝑎, 𝑏)) <: secp256k1.Point
            end

            for 𝑃 ∈ invalid_points
                𝑥 = secp256k1.FieldElement(𝑃[1], 𝑝)
                𝑦 = secp256k1.FieldElement(𝑃[2], 𝑝)
                @test_throws DomainError secp256k1.Point(𝑥, 𝑦, 𝑎, 𝑏)
            end
        end
        @testset "Addition" begin
            𝑝 = 223
            𝑎 = secp256k1.FieldElement(0, 𝑝)
            𝑏 = secp256k1.FieldElement(7, 𝑝)

            additions = (
                (192, 105, 17, 56, 170, 142),
                (47, 71, 117, 141, 60, 139),
                (143, 98, 76, 66, 47, 71),
                )

            for 𝑛 ∈ additions
                𝑃 = secp256k1.Point(secp256k1.FieldElement(𝑛[1],𝑝),secp256k1.FieldElement(𝑛[2],𝑝),𝑎,𝑏)
                𝑄 = secp256k1.Point(secp256k1.FieldElement(𝑛[3],𝑝),secp256k1.FieldElement(𝑛[4],𝑝),𝑎,𝑏)
                𝑅 = secp256k1.Point(secp256k1.FieldElement(𝑛[5],𝑝),secp256k1.FieldElement(𝑛[6],𝑝),𝑎,𝑏)
                @test 𝑃 + 𝑄 == 𝑅
            end
        end
        @testset "Scalar Multiplication" begin
            𝑝 = 223
            𝑎 = secp256k1.FieldElement(0, 𝑝)
            𝑏 = secp256k1.FieldElement(7, 𝑝)

            multiplications = (
                (2, 192, 105, 49, 71),
                (2, 143, 98, 64, 168),
                (2, 47, 71, 36, 111),
                (4, 47, 71, 194, 51),
                (8, 47, 71, 116, 55),
                (21, 47, 71, ∞, ∞)
                )

            for 𝑛 ∈ multiplications
                λ = 𝑛[1]
                i = 2
                fieldelements = []
                while i < 6
                    if 𝑛[i] == ∞
                        push!(fieldelements, ∞)
                    else
                        push!(fieldelements, secp256k1.FieldElement(𝑛[i],𝑝))
                    end
                    i += 1
                end
                𝑃 = secp256k1.Point(fieldelements[1],fieldelements[2],𝑎,𝑏)
                𝑅 = secp256k1.Point(fieldelements[3],fieldelements[4],𝑎,𝑏)
                @test λ * 𝑃 == 𝑅
            end
        end
    end;
end
