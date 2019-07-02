"""
KeyPair(𝑑) represents a Point 𝑃 determined by 𝑃 = 𝑑G,
where 𝑑 is an integer and G the scep256k1 generator point.
"""
struct KeyPair{T}
    𝑑::Integer
    𝑄::Point
end

"""
Signature(𝑟, 𝑠) represents a Signature for 𝑧 in which
`𝑠 = (𝑧 + 𝑟𝑑) / 𝑘`, 𝑘 being a random integer.
"""
struct Signature{T}
    𝑟::BigInt
    𝑠::BigInt
end

"Formats Signature as (r, s) in hexadecimal format"
function show(io::IO, z::Signature)
    print(io, "scep256k1 signature(𝑟, 𝑠):\n", string(z.𝑟, base = 16), ",\n", string(z.𝑠, base = 16))
end

==(x::Signature, y::Signature) = x.𝑟 == y.𝑟 && x.𝑠 == y.𝑠
