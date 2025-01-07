# autority.jl
# Nicolo' Luigi Allegris 909582

function parse_autority(uri :: URILib_structure,
                        s :: String, path_fun :: Function
                        ) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        nothing
    elseif is_char(s[1])
        uri.userinfo = string(s[1])
        read_userinfo(uri, s[2 : end], path_fun)
    end
end

function read_userinfo(uri :: URILib_structure,
                       s :: String, path_fun :: Function
                       ) :: Union{URILib_structure, Nothing}
    if length(s) == 0 || s[1] |> in(['/', ':', '.'])
        s = string(uri.userinfo, s)
        uri.userinfo = nothing
        parse_host(uri, s, path_fun)
    elseif is_char(s[1])
        uri.userinfo = string(uri.userinfo, s[1])
        read_userinfo(uri, s[2 : end], path_fun)
    elseif s[1] == '@'
        parse_host(uri, s[2 : end], path_fun)
    end
end



function parse_ip(uri :: URILib_structure,
                  s :: String, path_fun :: Function
                  ) :: Union{URILib_structure, Nothing}
    uri.host = ""
    ip0(uri, s, 0, path_fun)
end

function ip0(uri :: URILib_structure, s :: String,
             counter :: Int, path_fun :: Function
             ) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        nothing
    elseif s[1] |> in(['0', '1'])
        uri.host = string(uri.host, s[1])
        ip1(uri, s[2 : end], counter, path_fun)
    elseif s[1] == '2'
        uri.host = string(uri.host, s[1])
        ip2(uri, s[2 : end], counter, path_fun)
    elseif s[1] |> in(['3', '4', '5', '6', '7', '8', '9'])
        uri.host = string(uri.host, s[1])
        ip3(uri, s[2 : end], counter, path_fun)
    end
end

function ip1(uri :: URILib_structure, s :: String,
             counter :: Int, path_fun :: Function
             ) :: Union{URILib_structure, Nothing}
    if length(s) == 0 && counter == 3
        uri
    elseif length(s) == 0
        nothing
    elseif is_digit(s[1])
        uri.host = string(uri.host, s[1])
        ip3(uri, s[2 : end], counter, path_fun)
    elseif s[1] == '.' && counter < 3
        uri.host = string(uri.host, s[1])
        ip0(uri, s[2 : end], counter+1, path_fun)
    elseif counter == 3
        ip6(uri, s, path_fun)
    end
end

function ip2(uri :: URILib_structure, s :: String,
             counter :: Int, path_fun :: Function
             ) :: Union{URILib_structure, Nothing}
    if length(s) == 0 && counter == 3
        uri
    elseif length(s) == 0
        nothing
    elseif s[1] |> in(['0', '1', '2', '3', '4'])
        uri.host = string(uri.host, s[1])
        ip3(uri, s[2 : end], counter, path_fun)
    elseif s[1] == '5'
        uri.host = string(uri.host, s[1])
        ip5(uri, s[2 : end], counter, path_fun)
    elseif s[1] |> in(['6', '7', '8', '9'])
        uri.host = string(uri.host, s[1])
        ip4(uri, s[2 : end], counter, path_fun)
    elseif s[1] == '.' && counter < 3
        uri.host = string(uri.host, s[1])
        ip0(uri, s[2 : end], counter+1, path_fun)
    elseif counter == 3
        ip6(uri, s, path_fun)
    end
end

function ip3(uri :: URILib_structure, s :: String,
             counter :: Int, path_fun :: Function
             ) :: Union{URILib_structure, Nothing}
    if length(s) == 0 && counter == 3
        uri
    elseif length(s) == 0
        nothing
    elseif is_digit(s[1])
        uri.host = string(uri.host, s[1])
        ip4(uri, s[2 : end], counter, path_fun)
    elseif s[1] == '.' && counter < 3
        uri.host = string(uri.host, s[1])
        ip0(uri, s[2 : end], counter+1, path_fun)
    elseif counter == 3
        ip6(uri, s, path_fun)
    end
end

function ip4(uri :: URILib_structure, s :: String,
             counter :: Int, path_fun :: Function
             ) :: Union{URILib_structure, Nothing}
    if length(s) == 0 && counter == 3
        uri
    elseif length(s) == 0
        nothing
    elseif s[1] == '.' && counter < 3
        uri.host = string(uri.host, s[1])
        ip0(uri, s[2 : end], counter+1, path_fun)
    elseif counter == 3
        ip6(uri, s, path_fun)
    end
end

function ip5(uri :: URILib_structure, s :: String,
             counter :: Int, path_fun :: Function
             ) :: Union{URILib_structure, Nothing}
    if length(s) == 0 && counter == 3
        uri
    elseif length(s) == 0
        nothing
    elseif s[1] |> in(['0', '1', '2', '3', '4', '5'])
        uri.host = string(uri.host, s[1])
        ip4(uri, s[2 : end], counter, path_fun)
    elseif s[1] == '.' && counter < 3
        uri.host = string(uri.host, s[1])
        ip0(uri, s[2 : end], counter+1, path_fun)
    elseif counter == 3
        ip6(uri, s, path_fun)
    end
end

function ip6(uri :: URILib_structure, s :: String,
             path_fun :: Function
             ) :: Union{URILib_structure, Nothing}
    if s[1] == ':'
        parse_port(uri, s[2 : end], path_fun)
    elseif s[1] == '/'
        choose_next_segment(uri, s[2 : end], path_fun)
    end
end

function parse_host(uri :: URILib_structure,
                    s :: String, path_fun :: Function
                    ) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        nothing
    elseif is_digit(s[1])
        parse_ip(uri, s, path_fun)
    elseif is_letter(s[1])
        uri.host = string(s[1])
        read_host(uri, s[2 : end], path_fun)
    end
end

function read_host(uri :: URILib_structure,
                   s :: String, path_fun :: Function
                   ) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        uri
    elseif s[1] == '.'
        uri.host = string(uri.host, '.')
        dotted(uri, s[2 : end], path_fun)
    elseif is_alphanumeric(s[1])
        uri.host = string(uri.host, s[1])
        read_host(uri, s[2 : end], path_fun)
    elseif s[1] == ':'
        parse_port(uri, s[2 : end], path_fun)
    elseif s[1] == '/'
        choose_next_segment(uri, s[2 : end], path_fun)
    end
end

function dotted(uri :: URILib_structure,
                s :: String, path_fun :: Function
                ) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        nothing
    elseif is_letter(s[1])
        uri.host = string(uri.host, s[1])
        read_host(uri, s[2 : end], path_fun)
    end
end

function choose_next_segment(uri :: URILib_structure,
                             s :: String, path_fun :: Function
                             ) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        uri
    elseif is_char(s[1])
        path_fun(uri, s)
    elseif s[1] == '?'
        parse_query(uri, s[2 : end])
    elseif s[1] == '#'
        parse_fragment(uri, s[2 : end])
    end
end

function parse_port(uri :: URILib_structure,
                    s :: String, path_fun :: Function
                    ) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        nothing
    elseif is_digit(s[1])
        uri.port = string(s[1])
        read_port(uri, s[2 : end], path_fun)
    end
end

function read_port(uri :: URILib_structure,
                   s :: String, path_fun :: Function
                   ) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        uri
    elseif is_digit(s[1])
        uri.port = string(uri.port, s[1])
        read_port(uri, s[2 : end], path_fun)
    elseif s[1] == '/'
        choose_next_segment(uri, s[2 : end], path_fun)
    end
end

# autority.jl ends here
