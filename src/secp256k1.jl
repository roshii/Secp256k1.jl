__precompile__()

module secp256k1

using BitConverter
import Base: +, -, *, ^, /, ==, inv, sqrt, show, div
export ∞, KeyPair, ECDSA

include("lib/errors.jl")
include("lib/FieldElement.jl")
include("lib/Infinity.jl")
include("lib/Point.jl")
include("lib/ECDSA.jl")

end # module
