using Test
include("urilib_parse.jl")
using .URILib


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
end