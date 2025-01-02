include("urilib.jl")

using .URILib

urilib_display(
    urilib_parse("https:/ciao/mondo_bello_mi0/89?cosadici#staceppa"),
    stdout)

println()
urilib_display(
    urilib_parse("https://192.168.255.061/paperine/paperelle?questaebella#staceppa"),
    stdout)

println()
urilib_display(urilib_parse("http://disco.unimib.it"),
    stdout)
    
println()
urilib_display(urilib_parse("zos://cretino@192.168.054.000:574/staceppa.sonobello(bello)?questaquery#noncestanulla"),
    stdout)