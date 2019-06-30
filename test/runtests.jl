using secp256k1, Test

tests = ["helper", "FieldElement", "Infinity", "Point", "ecdsa"]

for t ∈ tests
  include("$(t)_tests.jl")
end
