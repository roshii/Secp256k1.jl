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


"""
    serialize(x::Signature) -> Vector{UInt8}

Serialize a Signature to DER format
"""
function serialize(x::Signature)
    rbin = bytes(x.𝑟)
    # if rbin has a high bit, add a 00
    if rbin[1] >= 128
        rbin = pushfirst!(rbin, 0x00)
    end
    prepend!(rbin, bytes(length(rbin)))
    pushfirst!(rbin, 0x02)

    sbin = bytes(x.𝑠)
    # if sbin has a high bit, add a 00
    if sbin[1] >= 128
        sbin = pushfirst!(sbin, 0x00)
    end
    prepend!(sbin, bytes(length(sbin)))
    pushfirst!(sbin, 0x02)

    result = sbin
    prepend!(result, rbin)
    prepend!(result, bytes(length(result)))
    return pushfirst!(result, 0x30)
end

"""
    parse(x::Vector{UInt8}; scheme::Symbol) -> Signature

Parse a DER binary to a Signature{scheme}.
`scheme` is optional and set to `:ECDSA` by default.
"""
function parse(x::Vector{UInt8}; scheme::Symbol=:ECDSA)
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
    r = Int(read(io, rlength))
    prefix = read(io, 1)[1]
    if prefix != 0x02
        throw(PrefixError())
    end
    slength = Int(read(io, 1)[1])
    s = Int(read(io, slength))
    if length(x) != 6 + rlength + slength
        throw(LengthError())
    end
    return Signature{scheme}(r, s)
end
