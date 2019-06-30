__precompile__()

module secp256k1

import Base: +, -, *, ^, /, ==, inv, sqrt, show, div
export Point, Signature, PrivateKey,
       point2sec, sec2point, verify, pksign, sig2der, der2sig,
       ∞, int2bytes, bytes2int

include("lib/helper.jl")
include("lib/errors.jl")
include("lib/FieldElement.jl")
include("lib/Infinity.jl")
include("lib/Point.jl")
include("lib/ecdsa.jl")

end # module
