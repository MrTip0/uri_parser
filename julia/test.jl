using Test
include("urilib_parse.jl")
using .URILib

function compare_uris(uri1, uri2)
    return uri1.scheme == uri2.scheme &&
           uri1.userinfo == uri2.userinfo &&
           uri1.host == uri2.host &&
           uri1.port == uri2.port &&
           uri1.path == uri2.path &&
           uri1.query == uri2.query &&
           uri1.fragment == uri2.fragment
end

@testset "URI Parsing Tests" begin
    uri0 = urilib_parse("http://example.com")
    @test uri0.scheme == "http"
    @test uri0.host == "example.com"
    @test uri0.port == "80"
    @test uri0.path == nothing
    uri1 = urilib_parse("https://example.com/path?query=1")
    @test uri1.scheme == "https"
    @test uri1.host == "example.com"
    @test uri1.port == "443"
    @test uri1.path == "path"
    @test uri1.query == "query=1"
    uri2 = urilib_parse("ftp://example.com/resource")
    @test uri2.scheme == "ftp"
    @test uri2.host == "example.com"
    @test uri2.port == "21"
    @test uri2.path == "resource"
    uri3 = urilib_parse("mailto:user@example.com")
    @test uri3.scheme == "mailto"
    @test uri3.userinfo == "user"
    @test uri3.host == "example.com"
    uri4 = urilib_parse("zos://papere@vivalavita.it/sei.bello(si)?siii=ovvio#lalal")
    @test uri4.scheme == "zos"
    @test uri4.userinfo == "papere"
    @test uri4.host == "vivalavita.it"
    @test uri4.port == "80"
    @test uri4.path == "sei.bello(si)"
    @test uri4.query == "siii=ovvio"
    @test uri4.fragment == "lalal"
    uri5 = urilib_parse("https:")
    @test uri5.scheme == "https"
    @test uri5.host == nothing
    @test uri5.port == "443"
    uri5 = urilib_parse("https:ciaomondo#papere")
    @test uri5.scheme == "https"
    @test uri5.host == nothing
    @test uri5.port == "443"
    @test uri5.fragment == "papere"
    @test uri5.path == "ciaomondo"
    

    # mailto
    @test compare_uris(urilib_parse("mailto:paolo@255.255.255.000"), URILib.URILib_structure("mailto", "paolo", "255.255.255.000", "25", nothing, nothing, nothing))
    @test compare_uris(urilib_parse("mailto:paolo"), URILib.URILib_structure("mailto", "paolo", nothing, "25", nothing, nothing, nothing))
    @test compare_uris(urilib_parse("mailto:paolo@gmail.com"), URILib.URILib_structure("mailto", "paolo", "gmail.com", "25", nothing, nothing, nothing))
    @test_throws ErrorException urilib_parse("mailto:")
    @test_throws ErrorException urilib_parse("mailto:paolo.rossi")
    @test_throws ErrorException urilib_parse("mailto:paolo@")
    @test_throws ErrorException urilib_parse("mailto:paolo@gmail.")
    @test_throws ErrorException urilib_parse("mailto:paolo@a255.255")
    @test_throws ErrorException urilib_parse("mailto:paolo@256.255.255.000")
    @test_throws ErrorException urilib_parse("mailto:paolo@255.255.255")

    # news
    @test compare_uris(urilib_parse("news:gmail"), URILib.URILib_structure("news", nothing, "gmail", "119", nothing, nothing, nothing))
    @test compare_uris(urilib_parse("news:gmail.com"), URILib.URILib_structure("news", nothing, "gmail.com", "119", nothing, nothing, nothing))
    @test compare_uris(urilib_parse("news:5.56.0.5"), URILib.URILib_structure("news", nothing, "5.56.0.5", "119", nothing, nothing, nothing))
    @test compare_uris(urilib_parse("news:255.25.5.1"), URILib.URILib_structure("news", nothing, "255.25.5.1", "119", nothing, nothing, nothing))
    @test compare_uris(urilib_parse("news:185.065.15.255"), URILib.URILib_structure("news", nothing, "185.065.15.255", "119", nothing, nothing, nothing))
    @test_throws ErrorException urilib_parse("news:")
    @test_throws ErrorException urilib_parse("news:a255.255")
    @test_throws ErrorException urilib_parse("news:255.255")
    @test_throws ErrorException urilib_parse("news:355.255.000.000")
    @test_throws ErrorException urilib_parse("news:paolo.polpo..paolo")
    @test_throws ErrorException urilib_parse("news:parola_underscore")
    @test_throws ErrorException urilib_parse("news:paolo.polpo..paolo")
    @test_throws ErrorException urilib_parse("news:paolo+pollo")

    # telFax
    @test compare_uris(urilib_parse("tel:LoremIpsum"), URILib.URILib_structure("tel", "LoremIpsum", nothing, nothing, nothing, nothing, nothing))
    @test compare_uris(urilib_parse("fax:123456789"), URILib.URILib_structure("fax", "123456789", nothing, nothing, nothing, nothing, nothing))
    @test_throws ErrorException urilib_parse("tel:")
    @test_throws ErrorException urilib_parse("t.el:123 4568 456")
    @test_throws ErrorException urilib_parse("fax:pasd:asd_asd+asd")

    # noAuthority
    @test compare_uris(urilib_parse("https:path/path2?query#fragment"), URILib.URILib_structure("https", nothing, nothing, "443", "path/path2", "query", "fragment"))
    @test compare_uris(urilib_parse("https:path+now-correct"), URILib.URILib_structure("https", nothing, nothing, "443", "path+now-correct", nothing, nothing))
    @test compare_uris(urilib_parse("https:path?query"), URILib.URILib_structure("https", nothing, nothing, "443", "path", "query", nothing))
    @test compare_uris(urilib_parse("https:"), URILib.URILib_structure("https", nothing, nothing, "443", nothing, nothing, nothing))
    @test compare_uris(urilib_parse("https:?query"), URILib.URILib_structure("https", nothing, nothing, "443", nothing, "query", nothing))
    @test compare_uris(urilib_parse("http:"), URILib.URILib_structure("http", nothing, nothing, "80", nothing, nothing, nothing))
    @test compare_uris(urilib_parse("http:path/to/resource"), URILib.URILib_structure("http", nothing, nothing, "80", "path/to/resource", nothing, nothing))
    @test compare_uris(urilib_parse("http:/path/to/resource"), URILib.URILib_structure("http", nothing, nothing, "80", "path/to/resource", nothing, nothing))
    @test compare_uris(urilib_parse("http:?query_con+caratteri=quasi-a-caso"), URILib.URILib_structure("http", nothing, nothing, "80", nothing, "query_con+caratteri=quasi-a-caso", nothing))
    @test compare_uris(urilib_parse("ftp:/"), URILib.URILib_structure("ftp", nothing, nothing, "21", nothing, nothing, nothing))
    @test compare_uris(urilib_parse("ftp:path_underscore"), URILib.URILib_structure("ftp", nothing, nothing, "21", "path_underscore", nothing, nothing))
    @test compare_uris(urilib_parse("ftp:#fragment"), URILib.URILib_structure("ftp", nothing, nothing, "21", nothing, nothing, "fragment"))
    @test_throws ErrorException urilib_parse("http:path/incorrect/")
    @test_throws ErrorException urilib_parse("scheme:path/to/resource")
    @test_throws ErrorException urilib_parse("ftp:/path/?query")
    @test_throws ErrorException urilib_parse("null:path")
    @test_throws ErrorException urilib_parse("ftp:?")
    @test_throws ErrorException urilib_parse("ftp:#")
    @test_throws ErrorException urilib_parse("https:path#")
    @test_throws ErrorException urilib_parse("scheme:")

    # Authority
    @test compare_uris(urilib_parse("https://255.255.255.000"), URILib.URILib_structure("https", nothing, "255.255.255.000", "443", nothing, nothing, nothing))
    @test compare_uris(urilib_parse("https://A-user+info@host.caratteri"), URILib.URILib_structure("https", "A-user+info", "host.caratteri", "443", nothing, nothing, nothing))
    @test compare_uris(urilib_parse("https://pvoa@host.caratteri"), URILib.URILib_structure("https", "pvoa", "host.caratteri", "443", nothing, nothing, nothing))
    @test compare_uris(urilib_parse("https://elearning.unimib.it/course/view?id=57379"), URILib.URILib_structure("https", nothing, "elearning.unimib.it", "443", "course/view", "id=57379", nothing))
    @test compare_uris(urilib_parse("http://a@255.255.255.000"), URILib.URILib_structure("http", "a", "255.255.255.000", "80", nothing, nothing, nothing))
    @test compare_uris(urilib_parse("http://www.google.com"), URILib.URILib_structure("http", nothing, "www.google.com", "80", nothing, nothing, nothing))
    @test compare_uris(urilib_parse("http://255.255.255.000:72"), URILib.URILib_structure("http", nothing, "255.255.255.000", "72", nothing, nothing, nothing))
    @test compare_uris(urilib_parse("ftp://host.caratteri"), URILib.URILib_structure("ftp", nothing, "host.caratteri", "21", nothing, nothing, nothing))
    @test compare_uris(urilib_parse("ftp://www.google.com"), URILib.URILib_structure("ftp", nothing, "www.google.com", "21", nothing, nothing, nothing))
    @test compare_uris(urilib_parse("ftp://host.caratteri:5464165"), URILib.URILib_structure("ftp", nothing, "host.caratteri", "5464165", nothing, nothing, nothing))
    @test_throws ErrorException urilib_parse("ftp://")
    @test_throws ErrorException urilib_parse("http://255.255.265.000")
    @test_throws ErrorException urilib_parse("http://25.256.255.0")
    @test_throws ErrorException urilib_parse("fail://255.255.255.000")
    @test_throws ErrorException urilib_parse("https://host.caratteri.")
    @test_throws ErrorException urilib_parse("http://@255.255.255.000")
    @test_throws ErrorException urilib_parse("https://a/@255.255.255.000")
    @test_throws ErrorException urilib_parse("https://255.255.255.000:")
    @test_throws ErrorException urilib_parse("ftp://host.caratteri:c")

    # ZOS
    @test compare_uris(urilib_parse("zos:path.to.resource"), URILib.URILib_structure("zos", nothing, nothing, "80", "path.to.resource", nothing, nothing))
    @test compare_uris(urilib_parse("zos:path.........a"), URILib.URILib_structure("zos", nothing, nothing, "80", "path.........a", nothing, nothing))
    @test compare_uris(urilib_parse("zos://host.parole/path.pa2t"), URILib.URILib_structure("zos", nothing, "host.parole", "80", "path.pa2t", nothing, nothing))
    @test compare_uris(urilib_parse("zos:asdaiasd3uibdfssd98dfs"), URILib.URILib_structure("zos", nothing, nothing, "80", "asdaiasd3uibdfssd98dfs", nothing, nothing))
    @test compare_uris(urilib_parse("zos:path?query"), URILib.URILib_structure("zos", nothing, nothing, "80", "path", "query", nothing))
    @test compare_uris(urilib_parse("zos:path#fragment"), URILib.URILib_structure("zos", nothing, nothing, "80", "path", nothing, "fragment"))
    @test compare_uris(urilib_parse("zos:esattamente44caratteriaaaaaaaaaaaaaaaaaaaaaa"), URILib.URILib_structure("zos", nothing, nothing, "80", "esattamente44caratteriaaaaaaaaaaaaaaaaaaaaaa", nothing, nothing))
    @test compare_uris(urilib_parse("zos://255.255.255.00/path(id8c)"), URILib.URILib_structure("zos", nothing, "255.255.255.00", "80", "path(id8c)", nothing, nothing))
    @test compare_uris(urilib_parse("zos:path(precisi8)"), URILib.URILib_structure("zos", nothing, nothing, "80", "path(precisi8)", nothing, nothing))
    @test_throws ErrorException urilib_parse("zos:path(nprecisi9)")
    @test_throws ErrorException urilib_parse("zos:path(8id)")
    @test_throws ErrorException urilib_parse("zos:/path/to/resource")
    @test_throws ErrorException urilib_parse("zos:")
    @test_throws ErrorException urilib_parse("zos:?query")
    @test_throws ErrorException urilib_parse("zos://host")
    @test_throws ErrorException urilib_parse("zos:path_underscore")
    @test_throws ErrorException urilib_parse("zos:path.")
    @test_throws ErrorException urilib_parse("zos:.path")
    @test_throws ErrorException urilib_parse("zos:path_fail")
    @test_throws ErrorException urilib_parse("zos:pat.h(f_ail)")
    @test_throws ErrorException urilib_parse("zos:esattamente45caratteriaaaaaaaaaaaaaaaaaaaaaaa")
end