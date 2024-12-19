# zos.jl

function parse_zospath(uri :: URILib_structure, 
                         s :: String) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        nothing
    elseif is_letter(s[1])
        uri.path = string(s[1])
        read_id44(uri, s[2 : end], 1)
    end
end

function read_id44(uri :: URILib_structure, 
                        s :: String,
                        counter :: Int) :: Union{URILib_structure, Nothing}
    if counter >= 44 && length(s) > 0 && s[1] != '('
        nothing
    elseif length(s) == 0
        uri
    elseif is_char(s[1])
        uri.path = string(uri.path, s[1])
        read_id44(uri, s[2 : end], counter + 1)
    elseif s[1] == '.'
        uri.path = string(uri.path, s[1])
        read_id44_dot(uri, s[2 : end], counter + 1)
    elseif s[1] == '#'
        parse_fragment(uri, s[2 : end])
    elseif s[1] == '?'
        parse_query(uri, s[2 : end])
    elseif s[1] == '('
        uri.path = string(uri.path, s[1])
        parse_id8(uri, s[2 : end])
    end
end

function read_id44_dot(uri :: URILib_structure, 
                        s :: String,
                        counter :: Int) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        nothing
    elseif is_char(s[1])
        uri.path = string(uri.path, s[1])
        read_id44(uri, s[2 : end], counter + 1)
    elseif s[1] == '.'
        uri.path = string(uri.path, s[1])
        read_id44_dot(uri, s[2 : end], counter + 1)
    end
end

function parse_id8(uri :: URILib_structure, 
                     s :: String) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        nothing
    elseif is_letter(s[1])
        uri.path = string(uri.path, s[1])
        read_id8(uri, s[2 : end], 1)
    end
end

function read_id8(uri :: URILib_structure, 
                    s :: String,
                    counter :: Int) :: Union{URILib_structure, Nothing}
    if length(s) == 0 || (counter >= 8 && s[1] != ')')
        nothing
    elseif is_char(s[1])
        uri.path = string(uri.path, s[1])
        read_id8(uri, s[2 : end], counter + 1)
    elseif s[1] == ')'
        uri.path = string(uri.path, s[1])
        close_id8(uri, s[2 : end])
    end
end

function close_id8(uri :: URILib_structure, 
                    s :: String) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        uri
    elseif s[1] == '#'
        parse_fragment(uri, s[2 : end])
    elseif s[1] == '?'
        parse_query(uri, s[2 : end])
    end
end

# zos.jl ends here