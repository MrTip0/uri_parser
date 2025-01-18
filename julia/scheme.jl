# -*- julia -*-
# scheme.jl
# Nicolo' Luigi Allegris 909582

function read_scheme(uri :: URILib_structure, 
                     s :: String) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        error("Invalid URI")
    elseif is_char(s[1])
        uri.scheme = string(uri.scheme, s[1])
        read_scheme(uri, s[2 : end])
    elseif s[1] == ':'
        select_protocol(uri, s[2 : end])
    else
        error("Invalid URI")
    end
end

function select_protocol(uri :: URILib_structure,
                         s :: String) :: Union{URILib_structure, Nothing}
    if uri.scheme == "ftp"
        uri.port = "21"
        standard_parser(uri, s, parse_path)
    elseif uri.scheme == "https"
        uri.port = "443"
        standard_parser(uri, s, parse_path)
    elseif uri.scheme == "http"
        uri.port = "80"
        standard_parser(uri, s, parse_path)
    elseif uri.scheme == "zos"
        uri.port = "80"
        standard_parser(uri, s, parse_zospath)
    elseif uri.scheme == "mailto"
        uri.port = "25"
        parse_mailto(uri, s)
    elseif uri.scheme == "news"
        uri.port = "119"
        parse_mailtonewshost(uri, s)
    elseif uri.scheme |> in(["tel", "fax"])
        parse_telfaxuserinfo(uri, s)
    else
        error("Invalid URI")
    end
end

# scheme.jl ends here
