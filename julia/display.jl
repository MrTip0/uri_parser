# display.jl

function urilib_display(_ :: Nothing, stream :: IO) :: Bool
    urilib_display(URILib_structure(), stream)
end

function urilib_display(uri :: URILib_structure, stream :: IO) :: Bool
    write(stream,
          string(
              "Scheme:\t\t", urilib_display_scheme(uri),
              "\nUserinfo:\t", urilib_display_userinfo(uri),
              "\nHost:\t\t", urilib_display_host(uri),
              "\nPort:\t\t", uri.port,
              "\nPath:\t\t", urilib_display_path(uri),
              "\nQuery:\t\t", urilib_display_query(uri),
              "\nFragment:\t", urilib_display_fragment(uri), "\n"
          )
          )
    true
end

function urilib_display_scheme(uri :: URILib_structure) :: String
    if uri.scheme === nothing
        "nothing"
    else
        string('"', uri.scheme, '"')
    end
end

function urilib_display_userinfo(uri :: URILib_structure) :: String
    if uri.userinfo === nothing
        "nothing"
    else
        string('"', uri.userinfo, '"')
    end
end

function urilib_display_host(uri :: URILib_structure) :: String
    if uri.host === nothing
        "nothing"
    else
        string('"', uri.host, '"')
    end
end

function urilib_display_path(uri :: URILib_structure) :: String
    if uri.path === nothing
        "nothing"
    else
        string('"', uri.path, '"')
    end
end

function urilib_display_query(uri :: URILib_structure) :: String
    if uri.query === nothing
        "nothing"
    else
        string('"', uri.query, '"')
    end
end

function urilib_display_fragment(uri :: URILib_structure) :: String
    if uri.fragment === nothing
        "nothing"
    else
        string('"', uri.fragment, '"')
    end
end

# display.jl ends here
