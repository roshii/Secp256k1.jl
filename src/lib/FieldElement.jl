const P = big(2)^256 - 2^32 - 977
const N = big"0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141"

"`FieldElement` represents an element in 𝐹ₚ where `P = 2²⁵⁶ - 2³² - 977`"
struct FieldElement <: Number
     𝑛::BigInt
     FieldElement(𝑛) = 𝑛 < 0 || 𝑛 >= P ? throw(NotInField()) : new(𝑛)
end

FieldElement(x::FieldElement) = x
FieldElement(x::Union{Int128, Int64, Int32, Int16, Int8, Unsigned}) = FieldElement(big(x))
𝐹 = FieldElement

"Formats FieldElement showing 𝑛 in hexadecimal format"
function show(io::IO, z::FieldElement)
    print(io, string(z.𝑛, base = 16),"\n(in scep256k1 field)")
end

==(𝑋₁::FieldElement, 𝑋₂::FieldElement) = 𝑋₁.𝑛 == 𝑋₂.𝑛
==(::FieldElement, ::Integer) = false
+(𝑋₁::FieldElement, 𝑋₂::FieldElement) = 𝐹(mod(𝑋₁.𝑛 + 𝑋₂.𝑛, P))
-(𝑋₁::FieldElement, 𝑋₂::FieldElement) = 𝐹(mod(𝑋₁.𝑛 - 𝑋₂.𝑛, P))
*(𝑋₁::FieldElement, 𝑋₂::FieldElement) = 𝐹(mod(𝑋₁.𝑛 * 𝑋₂.𝑛, P))
*(𝑐::Integer, 𝑋::FieldElement) = 𝐹(mod(𝑐 * 𝑋.𝑛, P))
*(𝑋::FieldElement, 𝑐::Integer) = *(𝑐, 𝑋)
^(𝑋::FieldElement, 𝑘::Int) = 𝐹(powermod(𝑋.𝑛, mod(𝑘, (P - 1)), P))
/(𝑋₁::FieldElement, 𝑋₂::FieldElement) = 𝐹(mod(𝑋₁.𝑛 * powermod(𝑋₂.𝑛, P - 2, P), P))
div(𝑋₁::FieldElement, 𝑋₂::FieldElement) = 𝑋₁ / 𝑋₂
inv(𝑋::FieldElement) = 𝐹(powermod(𝑋.𝑛, mod(-1, (P - 1)), P))
sqrt(𝑋::FieldElement) = 𝑋^fld(P + 1, 4)
