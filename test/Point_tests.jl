@testset "Point Operations" begin
    import secp256k1: 𝐹, NotOnCurve
    points = (
        Point(𝐹(big"0xa2d3161994ca49dba5f6a26d8b19d37b00cca173e73a78fa1944e1456b4bf99c"),
              𝐹(big"0x5da5a4f7198635acaadc75141fa096e0606a17e819743456a33f1fe185dfb7a9")),
        Point(𝐹(big"0x4bd9529fd874db685c9252657a389ffdc75602f66abbd37d0a31eb693a918ea"),
              𝐹(big"0x7748d379a9da6ba667bcda3052a6a368e787a72fdf2664ca3933fc8d5fd01167")),
        Point(𝐹(big"0xf13e238add1d7981c3f466f8a3c20500538bd15d822b3e8474bb790be17da072"),
              𝐹(big"0x5b76f0a236fba0234a208522ecbe7f3ce4f537a42885ee466f7eca6e1d2d5cbc"))
    )
    @testset "On curve?" begin
        invalid_points = ((200, 119), (42, 99))
        for 𝑃 ∈ invalid_points
            @test_throws NotOnCurve Point(𝑃[1], 𝑃[2])
        end
    end
    @testset "Addition" begin
        want = (
            Point(𝐹(big"0xb2c90a144ac8d9f1ef3b006966fae31fd309f1cad77c8e1eeba97066618de0ba"),
                  𝐹(big"0xd94824954468c2c9261c1e021d3c30a038f4528d5da85ff416b40185a891aa95")),
            Point(𝐹(big"0x74399cab4b7dabf48414e65528b4bfbacd83afc5762856fbaf3c37453ab587b8"),
                  𝐹(big"0x7bbc7eb7482b57783f496ecdcf07f2b25ac28b4bc76e5ec3976b7026c385407b")),
            Point(𝐹(big"0x3a4a73aa1176eb1ff4356e661bffc4030f02fbebd90e03d6eb9a8c2ebff0f199"),
                  𝐹(big"0xda3d13611988ebfb288a06561ab0addc8fccee33f1df7b9242fc44a7c3e64e03"))
        )

        @test points[1] + points[2] == want[1]
        @test points[1] + points[3] == want[2]
        @test points[2] + points[3] == want[3]
    end
    @testset "Scalar Multiplication" begin
        scalars = (1, 4 , 832)
        want = (
            Point(𝐹(big"0xa2d3161994ca49dba5f6a26d8b19d37b00cca173e73a78fa1944e1456b4bf99c"),
                  𝐹(big"0x5da5a4f7198635acaadc75141fa096e0606a17e819743456a33f1fe185dfb7a9")),
            Point(𝐹(big"0xd4d85a3f5562fc262365cf78103e5f5ba0ef3d64918ea2063747ae541bd2030f"),
                  𝐹(big"0xb5512fb7bc50c34f7029f5a87c8ea46bd7a2ea14c6ec1c6bffed28f8252f7492")),
            Point(𝐹(big"0xc49e8f1f66265158c48b65e26fb4e65b1802830134b544be62934d0c1fec1ef3"),
                  𝐹(big"0xc23915cfc9adc4871d5d84ad0d8363f138593ca918ae1c8c5ace312d3afc99e6"))
        )
        for i in 1:3
            @test scalars[i] * points[i] == want[i]
        end
    end
end
