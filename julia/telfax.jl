# telfax.jl

function parse_telfaxuserinfo(uri :: URILib_structure, 
                              s :: String) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        nothing
    elseif is_char(s[1])
        uri.userinfo = string(s[1])
        read_telfaxuserinfo(uri, s[2 : end])
    end
end

function read_telfaxuserinfo(uri :: URILib_structure, 
                             s :: String) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        uri
    elseif is_char(s[1])
        uri.userinfo = string(uri.userinfo, s[1])
        read_telfaxuserinfo(uri, s[2 : end])
    end
end

# telfax.jl ends here
