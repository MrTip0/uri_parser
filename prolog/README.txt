# Introduzione al predicato urilib_parse/2

Il predicato `urilib_parse` accetta come primo parametro una URI che può
    appartenere ai seguenti schemi: http, https, ftp, tel, fax, mailto, news,
    e zos. Come secondo parametro, il predicato restituisce un funtore del tipo
    `uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)`, dove:

- `Scheme` rappresenta lo schema della URI (ad esempio, http, https, ecc.).
- `Userinfo` contiene le informazioni dell'utente (se presenti).
- `Host` rappresenta l'host della URI.
- `Port` è il numero di porta (se specificato).
- `Path` è il percorso della risorsa.
- `Query` contiene la stringa di query (se presente).
- `Fragment` rappresenta il frammento della URI (se presente).

# Esempio di utilizzo del predicato urilib_parse/2

```prolog
% Chiamare il predicato urilib_parse/2
urilib_parse('http://papere.com:42/pluto', uri(Scheme, _, _, _, _, _, _)).
```

in questo caso la variabile Scheme unificherà con l'atomo http.