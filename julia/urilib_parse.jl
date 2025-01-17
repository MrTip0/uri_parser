# parser.jl
# Nicolo' Luigi Allegris 909582

module URILib
export urilib_parse, urilib_scheme, urilib_userinfo, urilib_host,
    urilib_port, urilib_path, urilib_query, urilib_fragment,
    urilib_display, URILib_structure
include("definitions.jl")
include("default_protocol.jl")
include("scheme.jl")
include("mailtonews.jl")
include("telfax.jl")
include("zos.jl")
include("display.jl")

function urilib_parse(s :: String) :: Union{URILib_structure, Nothing}
    uri = URILib_structure(scheme = "")
    read_scheme(uri, s)
    if uri.path === nothing && uri.scheme === "query"
        error("Invalid URI")
    end
end

function urilib_scheme(uri :: URILib_structure) :: Union{String, Nothing}
    uri.scheme
end

function urilib_scheme(_ :: Nothing) :: Union{String, Nothing}
    nothing
end

function urilib_userinfo(uri :: URILib_structure
                         ) :: Union{String, Nothing}
    uri.userinfo
end

function urilib_userinfo(_ :: Nothing) :: Union{String, Nothing}
    nothing
end

function urilib_host(uri :: URILib_structure) :: Union{String, Nothing}
    uri.host
end

function urilib_host(_ :: Nothing) :: Union{String, Nothing}
    nothing
end

function urilib_port(uri :: URILib_structure) :: Union{String, Nothing}
    uri.port
end

function urilib_port(_ :: Nothing) :: Union{String, Nothing}
    nothing
end

function urilib_path(uri :: URILib_structure) :: Union{String, Nothing}
    uri.path
end

function urilib_path(_ :: Nothing) :: Union{String, Nothing}
    nothing
end

function urilib_query(uri :: URILib_structure) :: Union{String, Nothing}
    uri.query
end

function urilib_query(_ :: Nothing) :: Union{String, Nothing}
    nothing
end

function urilib_fragment(uri :: URILib_structure
                         ) :: Union{String, Nothing}
    uri.fragment
end

function urilib_fragment(_ :: Nothing) :: Union{String, Nothing}
    nothing
end
end

# parser.jl ends here
