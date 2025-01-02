# definitions.jl

@kwdef mutable struct URILib_structure
    scheme   :: Union{String, Nothing} = nothing
    userinfo :: Union{String, Nothing} = nothing
    host     :: Union{String, Nothing} = nothing
    port     :: String = "80"
    path     :: Union{String, Nothing} = nothing
    query    :: Union{String, Nothing} = nothing
    fragment :: Union{String, Nothing} = nothing
end

function is_digit(v :: Char)
    v |> in(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'])
end

function is_letter(v :: Char)
    lowercase(v) |> in(['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
                        'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u',
                        'w', 'x', 'y', 'z'])
end

function is_char(v :: Char)
    is_letter(v) || is_digit(v) || v == '_'
end


# definitions.jl ends here
