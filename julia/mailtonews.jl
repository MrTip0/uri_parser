# mailtonews.jl
# Nicolo' Luigi Allegris 909582

function parse_mailto(uri :: URILib_structure,
                      s :: String) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        error("Invalid URI")
    elseif is_char(s[1])
        uri.userinfo = string(s[1])
        read_mailtouserinfo(uri, s[2 : end])
    else
        error("Invalid URI")
    end
end

function read_mailtouserinfo(uri :: URILib_structure,
                             s :: String) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        uri
    elseif is_char(s[1])
        uri.userinfo = string(uri.userinfo, s[1])
        read_mailtouserinfo(uri, s[2 : end])
    elseif s[1] == '@'
        parse_mailtonewshost(uri, s[2 : end])
    else
        error("Invalid URI")
    end
end


function parse_mailtonewshost(uri :: URILib_structure,
                              s :: String) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        error("Invalid URI")
    elseif is_digit(s[1])
        parse_mailtonewsip(uri, s)
    elseif is_letter(s[1])
        uri.host = string(s[1])
        read_mailtonewshost(uri, s[2 : end])
    else
        error("Invalid URI")
    end
end

function read_mailtonewshost(uri :: URILib_structure,
                             s :: String) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        uri
    elseif s[1] == '.'
        uri.host = string(uri.host, '.')
        mailtonewsdotted(uri, s[2 : end])
    elseif is_alphanumeric(s[1])
        uri.host = string(uri.host, s[1])
        read_mailtonewshost(uri, s[2 : end])
    else
        error("Invalid URI")
    end
end

function mailtonewsdotted(uri :: URILib_structure,
                          s :: String) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        error("Invalid URI")
    elseif is_letter(s[1])
        uri.host = string(uri.host, s[1])
        read_mailtonewshost(uri, s[2 : end])
    else
        error("Invalid URI")
    end
end

function parse_mailtonewsip(uri :: URILib_structure,
                            s :: String) :: Union{URILib_structure, Nothing}
    uri.host = ""
    mailtonewsip0(uri, s, 0)
end

function mailtonewsip0(uri :: URILib_structure, s :: String,
                       counter :: Int) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        error("Invalid URI")
    elseif s[1] |> in(['0', '1'])
        uri.host = string(uri.host, s[1])
        mailtonewsip1(uri, s[2 : end], counter)
    elseif s[1] == '2'
        uri.host = string(uri.host, s[1])
        mailtonewsip2(uri, s[2 : end], counter)
    else
        error("Invalid URI")
    end
end

function mailtonewsip1(uri :: URILib_structure, s :: String,
                       counter :: Int) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        error("Invalid URI")
    elseif is_digit(s[1])
        uri.host = string(uri.host, s[1])
        mailtonewsip3(uri, s[2 : end], counter)
    else
        error("Invalid URI")
    end
end

function mailtonewsip2(uri :: URILib_structure, s :: String,
                       counter :: Int) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        error("Invalid URI")
    elseif s[1] |> in(['0', '1', '2', '3', '4'])
        uri.host = string(uri.host, s[1])
        mailtonewsip3(uri, s[2 : end], counter)
    elseif s[1] == '5'
        uri.host = string(uri.host, s[1])
        mailtonewsip4(uri, s[2 : end], counter)
    else
        error("Invalid URI")
    end
end

function mailtonewsip3(uri :: URILib_structure, s :: String,
                       counter :: Int) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        error("Invalid URI")
    elseif is_digit(s[1])
        uri.host = string(uri.host, s[1])
        mailtonewsip5(uri, s[2 : end], counter)
    else
        error("Invalid URI")
    end
end

function mailtonewsip4(uri :: URILib_structure, s :: String,
                       counter :: Int) :: Union{URILib_structure, Nothing}
    if length(s) == 0
        error("Invalid URI")
    elseif s[1] |> in(['0', '1', '2', '3', '4', '5'])
        uri.host = string(uri.host, s[1])
        mailtonewsip5(uri, s[2 : end], counter)
    else
        error("Invalid URI")
    end
end

function mailtonewsip5(uri :: URILib_structure, s :: String,
                       counter :: Int) :: Union{URILib_structure, Nothing}
    if length(s) == 0 && counter == 3
        uri
    elseif length(s) == 0
        error("Invalid URI")
    elseif s[1] == '.' && counter < 3
        uri.host = string(uri.host, s[1])
        mailtonewsip0(uri, s[2 : end], counter+1)
    else
        error("Invalid URI")
    end
end


# mailtonews.jl ends here
