@testset "ECDSA" begin

    import secp256k1: Point, G, N

    @testset "DER Signature Parsing and Serialization" begin
        @testset "Parse" begin
            der = hex2bytes("304402201f62993ee03fca342fcb45929993fa6ee885e00ddad8de154f268d98f083991402201e1ca12ad140c04e0e022c38f7ce31da426b8009d02832f0b44f39a6b178b7a1")
            sig = Signature{:ECDSA}(big"0x1f62993ee03fca342fcb45929993fa6ee885e00ddad8de154f268d98f0839914",
                                    big"0x1e1ca12ad140c04e0e022c38f7ce31da426b8009d02832f0b44f39a6b178b7a1")
            @test secp256k1.parse(der) == sig
        end
        @testset "Serialize" begin
            testcases = (
                (1, 2),
                (rand(big.(0:big(2)^255)), rand(big.(0:big(2)^255))),
                (rand(big.(0:big(2)^255)), rand(big.(0:big(2)^255))),
                (rand(big.(0:big(2)^255)), rand(big.(0:big(2)^223))))
            for x in testcases
                sig  = Signature{:ECDSA}(x[1], x[2])
                der  = secp256k1.serialize(sig)
                sig2 = secp256k1.parse(der)
                @test sig2 == sig
            end
        end
    end

    @testset "Signature Verification" begin
        kp = KeyPair{:ECDSA}(rand(big.(1:N-1)))
        𝑧  = rand(Int)
        𝑠  = ECDSA.sign(kp, 𝑧)
        @test ECDSA.verify(kp.𝑄, 𝑧, 𝑠)

        point = Point(
            big"0x887387e452b8eacc4acfde10d9aaf7f6d9a0f975aabb10d006e4da568744d06c",
            big"0x61de6d95231cd89026e286df3b6ae4a894a3378e393e93a0f45b666329a0ae34")
        z = big"0xec208baa0fc1c19f708a9ca96fdeff3ac3f230bb4a7ba4aede4942ad003c0f60"
        r = big"0xac8d1c87e51d0d441be8b3dd5b05c8795b48875dffe00b7ffcfac23010d3a395"
        s = big"0x68342ceff8935ededd102dd876ffd6ba72d6a427a3edb13d26eb0781cb423c4"
        @test ECDSA.verify(point, z, Signature{:ECDSA}(r, s))

        z = big"0x7c076ff316692a3d7eb3c3bb0f8b1488cf72e1afcd929e29307032997a838a3d"
        r = big"0xeff69ef2b1bd93a66ed5219add4fb51e11a840f404876325a1e8ffe0529a2c"
        s = big"0xc7207fee197d27c618aea621406f6bf5ef6fca38681d82b2f06fddbdce6feab6"
        @test ECDSA.verify(point, z, Signature{:ECDSA}(r, s))
    end
end
