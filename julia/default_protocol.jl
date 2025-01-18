# default_protocol.jl
# Nicolo' Luigi Allegris 909582

include("autority.jl")

function standard_parser(uri :: URILib_structure,
                         s :: String, path_fun :: Function
                         ) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        uri
    elseif s[1] == '/'
        second_slash(uri, s[2 : end], path_fun)
    elseif is_char(s[1])
        path_fun(uri, s)
    elseif s[1] == '#'
        parse_fragment(uri, s[2 : end])
    elseif s[1] == '?'
        parse_query(uri, s[2 : end])
    else
        error("Invalid URI")
    end
end

function parse_path(uri :: URILib_structure,
                    s :: String) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        error("Invalid URI")
    elseif is_char(s[1])
        uri.path = string(s[1])
        read_path(uri, s[2 : end])
    else
        error("Invalid URI")
    end
end

function read_path(uri :: URILib_structure,
                   s :: String) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        uri
    elseif s[1] == '/'
        uri.path = string(uri.path, '/')
        read_path_divisor(uri, s[2 : end])
    elseif is_char(s[1])
        uri.path = string(uri.path, s[1])
        read_path(uri, s[2 : end])
    elseif s[1] == '#'
        parse_fragment(uri, s[2 : end])
    elseif s[1] == '?'
        parse_query(uri, s[2 : end])
    else
        error("Invalid URI")
    end
end

function read_path_divisor(uri :: URILib_structure,
                           s :: String) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        error("Invalid URI")
    elseif is_char(s[1])
        read_path(uri, s)
    else
        error("Invalid URI")
    end
end

function second_slash(uri :: URILib_structure,
                      s :: String, path_fun :: Function
                      ) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        uri
    elseif is_char(s[1])
        path_fun(uri, s)
    elseif s[1] == '/'
        parse_autority(uri, s[2 : end], path_fun)
    elseif s[1] == '#'
        parse_fragment(uri, s[2 : end])
    elseif s[1] == '?'
        parse_query(uri, s[2 : end])
    else
        error("Invalid URI")
    end
end

function parse_query(uri :: URILib_structure,
                     s :: String) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        error("Invalid URI")
    elseif is_char(s[1])
        uri.query = string(s[1])
        read_query(uri, s[2 : end])
    else
        error("Invalid URI")
    end
end

function read_query(uri :: URILib_structure,
                    s :: String) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        uri
    elseif is_char(s[1])
        uri.query = string(uri.query, s[1])
        read_query(uri, s[2 : end])
    elseif s[1] == '#'
        parse_fragment(uri, s[2 : end])
    else
        error("Invalid URI")
    end
end

function parse_fragment(uri :: URILib_structure,
                        s :: String) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        error("Invalid URI")
    elseif is_char(s[1])
        uri.fragment = string(s[1])
        read_fragment(uri, s[2 : end])
    else
        error("Invalid URI")
    end
end

function read_fragment(uri :: URILib_structure,
                       s :: String) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        uri
    elseif is_char(s[1])
        uri.fragment = string(uri.fragment, s[1])
        read_fragment(uri, s[2 : end])
    else
        error("Invalid URI")
    end
end

# default_protocol.jl ends here
