# Introduzione alla funzione urilib_parse

La funzione `urilib_parse` è progettata per leggere URI (Uniform Resource
    Identifier) nei seguenti schemi: `http`, `https`, `ftp`, `tel`, `fax`,
    `mailto`, `news`, e `zos`. Questa funzione analizza la URI fornita e
    restituisce un oggetto di tipo `URILib_structure`, che contiene le varie
    componenti della URI.

# Utilizzo
Per utilizzare la funzione `urilib_parse`, è necessario importare il modulo
    `URILib`.
    Di seguito è riportato un esempio di come importare il modulo e utilizzare
    la funzione:

```julia
include("urilib_parse.jl")

using .URILib

uri = urilib_parse("http://ciao.com/pippo?pluto#paperino")
```

a questo punto uri conterra' per esempio ciao.com come host, o pippo come
    path.
