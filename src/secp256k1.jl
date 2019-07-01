__precompile__()

module secp256k1

import Base: +, -, *, ^, /, ==, inv, sqrt, show, div
export ECDSA, ∞, int2bytes, bytes2int

include("lib/helper.jl")
include("lib/errors.jl")
include("lib/FieldElement.jl")
include("lib/Infinity.jl")
include("lib/Point.jl")
include("lib/ECDSA.jl")

end # module
