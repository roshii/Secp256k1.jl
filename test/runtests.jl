using secp256k1, Test

tests = ["FieldElement", "Infinity", "Point", "ECDSA"]

for t ∈ tests
  include("$(t)_tests.jl")
end
