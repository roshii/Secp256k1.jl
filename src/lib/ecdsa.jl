const G = Point(big"0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798",
                big"0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8")

"""
PrivateKey(𝑒) represents a Point 𝑃 determined by 𝑃 = 𝑒G,
where 𝑒 is an integer and G the scep256k1 generator point.
"""
struct PrivateKey
    𝑒::Integer
    𝑃::Point
    PrivateKey(𝑒) = new(𝑒, 𝑒 * G)
end

"""
Returns a Signature for a given PrivateKey and data 𝑧
    pksign(pk::PrivateKey, 𝑧::Integer) -> Signature
"""
function pksign(pk::PrivateKey, 𝑧::Integer)
    𝑘 = rand(big.(0:N))
    𝑟 = (𝑘 * G).𝑥.𝑛
    𝑘⁻¹ = powermod(𝑘, N - 2, N)
    𝑠 = mod((𝑧 + 𝑟 * pk.𝑒) * 𝑘⁻¹, N)
    if 𝑠 > N / 2
        𝑠 = N - 𝑠
    end
    return Signature(𝑟, 𝑠)
end

"""
Signature(𝑟, 𝑠) represents a Signature for 𝑧 in which
`𝑠 = (𝑧 + 𝑟𝑒) / 𝑘`, 𝑘 being a random integer.
"""
struct Signature
    𝑟::BigInt
    𝑠::BigInt
    Signature(𝑟, 𝑠) = new(𝑟, 𝑠)
end

"Formats Signature as (r, s) in hexadecimal format"
function show(io::IO, z::Signature)
    print(io, "scep256k1 signature(𝑟, 𝑠):\n", string(z.𝑟, base = 16), ",\n", string(z.𝑠, base = 16))
end

==(x::Signature, y::Signature) = x.𝑟 == y.𝑟 && x.𝑠 == y.𝑠

"""
    sig2der(x::Signature) -> Vector{UInt8}

Serialize a Signature to DER format
"""
function sig2der(x::Signature)
    rbin = int2bytes(x.𝑟)
    # if rbin has a high bit, add a 00
    if rbin[1] >= 128
        rbin = pushfirst!(rbin, 0x00)
    end
    prepend!(rbin, int2bytes(length(rbin)))
    pushfirst!(rbin, 0x02)

    sbin = int2bytes(x.𝑠)
    # if sbin has a high bit, add a 00
    if sbin[1] >= 128
        sbin = pushfirst!(sbin, 0x00)
    end
    prepend!(sbin, int2bytes(length(sbin)))
    pushfirst!(sbin, 0x02)

    result = sbin
    prepend!(result, rbin)
    prepend!(result, int2bytes(length(result)))
    return pushfirst!(result, 0x30)
end

"""
    der2sig(signature_bin::Vector{UInt8}) -> Signature

Parse a DER binary to a Signature
"""
function der2sig(x::Vector{UInt8})
    io = IOBuffer(x)
    prefix = read(io, 1)[1]
    if prefix != 0x30
        throw(PrefixError())
    end
    len = read(io, 1)[1]
    if len + 2 != length(x)
        throw(LengthError())
    end
    prefix = read(io, 1)[1]
    if prefix != 0x02
        throw(PrefixError())
    end
    rlength = Int(read(io, 1)[1])
    r = bytes2int(read(io, rlength))
    prefix = read(io, 1)[1]
    if prefix != 0x02
        throw(PrefixError())
    end
    slength = Int(read(io, 1)[1])
    s = bytes2int(read(io, slength))
    if length(x) != 6 + rlength + slength
        throw(LengthError())
    end
    return Signature(r, s)
end

"""
    verify(𝑃::Point, 𝑧::Integer, sig::Signature) -> Bool

Returns true if Signature is valid for 𝑧 given 𝑃, false if not
"""
function verify(𝑃::Point, 𝑧::Integer, sig::Signature)
    𝑠⁻¹ = powermod(sig.𝑠, N - 2, N)
    𝑢 = mod(𝑧 * 𝑠⁻¹, N)
    𝑣 = mod(sig.𝑟 * 𝑠⁻¹, N)
    𝑅 = 𝑢 * G + 𝑣 * 𝑃
    return 𝑅.𝑥.𝑛 == sig.𝑟
end
