using secp256k1, Test

tests = ["helper", "FieldElement", "Infinity", "Point", "ECDSA"]

for t ∈ tests
  include("$(t)_tests.jl")
end
