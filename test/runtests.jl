using secp256k1, Test

tests = ["helper", "primefield", "infinity", "point", "secp256k1"]

for t ∈ tests
  include("$(t)_tests.jl")
end
