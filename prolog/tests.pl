%Test Cases:
%mailto
:- not(urilib_parse("mailto:", _)). %fail
:- urilib_parse("mailto:paolo", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- not(urilib_parse("mailto:paolo.rossi", _)).%fail
:- not(urilib_parse("mailto:paolo@", _)). %fail
:- not(urilib_parse("mailto:paolo@gmail.", _)). %fail
:- urilib_parse("mailto:paolo@gmail.com", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- not(urilib_parse("mailto:paolo@a255.255", _)). %fail
:- urilib_parse("mailto:paolo@255.255.255.000", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- not(urilib_parse("mailto:paolo@256.255.255.000", _)). %fail
:- not(urilib_parse("mailto:paolo@255.255.255", _)). %fail


%news
:- not(urilib_parse("news:", _)). %fail
:- urilib_parse("news:gmail", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- urilib_parse("news:gmail.com", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- urilib_parse("news:5.56.0.5", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- urilib_parse("news:255.25.5.1", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- urilib_parse("news:185.065.15.255", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- not(urilib_parse("news:a255.255", _)). %fail
:- not(urilib_parse("news:255.255", _)). %fail
:- not(urilib_parse("news:355.255.000.000", _)). %fail
:- not(urilib_parse("news:paolo.polpo..paolo", _)). %fail
:- not(urilib_parse("news:parola_underscore", _)). %fail
:- not(urilib_parse("news:paolo.polpo..paolo", _)). %fail
:- not(urilib_parse("news:paolo+pollo", _)). %fail


%telFax
:- not(urilib_parse("tel:", _)). %fail
:- not(urilib_parse("t.el:123 4568 456", _)). %fail
:- urilib_parse("tel:LoremIpsum", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- not(urilib_parse("fax:pasd:asd_asd+asd", _)). %fail
:- urilib_parse("fax:123456789", URI), urilib_parse(String, URI), urilib_parse(String, URI).

%noAuthority
:- not(urilib_parse("scheme:", _)). %fail
:- urilib_parse("http:", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- urilib_parse("https:", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- urilib_parse("ftp:/", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- urilib_parse("http:path/to/resource", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- not(urilib_parse("scheme:path/to/resource", _)). %fail
:- urilib_parse("http:/path/to/resource", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- urilib_parse("ftp:path_underscore", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- urilib_parse("https:path+now-correct", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- not(urilib_parse("http:path/incorrect/", _)). %fail
:- urilib_parse("https:path?query", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- not(urilib_parse("ftp:/path/?query", _)). %fail
:- not(urilib_parse("null:path", _)). %fail
:- not(urilib_parse("ftp:?", _)). %fail
:- urilib_parse("https:?query", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- urilib_parse("http:?query_con+caratteri=quasi-a-caso", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- not(urilib_parse("ftp:#", _)). %fail
:- not(urilib_parse("https:path#", _)). %fail
:- urilib_parse("ftp:#fragment", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- urilib_parse("https:path/path2?query#fragment", URI), urilib_parse(String, URI), urilib_parse(String, URI).

%Authority
:- not(urilib_parse("ftp://", _)). %fail
:- not(urilib_parse("http://255.255.265.000", _)). %fail
:- not(urilib_parse("http://25.256.255.0", _)). %fail
:- urilib_parse("https://255.255.255.000", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- not(urilib_parse("fail://255.255.255.000", _)). %fail
:- urilib_parse("ftp://host.caratteri", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- not(urilib_parse("https://host.caratteri.", _)). %fail
:- urilib_parse("ftp://www.google.com", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- not(urilib_parse("http://@255.255.255.000", _)). %fail
:- urilib_parse("http://a@255.255.255.000", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- urilib_parse("https://A-user+info@host.caratteri", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- urilib_parse("https://pvoa@host.caratteri", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- not(urilib_parse("https://a/@255.255.255.000", _)). %fail
:- not(urilib_parse("https://255.255.255.000:", _)). %fail
:- urilib_parse("http://255.255.255.000:80", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- urilib_parse("ftp://host.caratteri:5464165", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- not(urilib_parse("ftp://host.caratteri:c", _)). %fail
:- urilib_parse("https://elearning.unimib.it/course/view?id=57379", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- urilib_parse("http://www.google.com", URI), urilib_parse(String, URI), urilib_parse(String, URI).

%ZOS
:- urilib_parse("zos:path.to.resource", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- not(urilib_parse("zos:/path/to/resource", _)). %fail
:- not(urilib_parse("zos:", _)). %fail
:- not(urilib_parse("zos:?query", _)). %fail
:- not(urilib_parse("zos://host", _)). %fail
:- not(urilib_parse("zos:path_underscore", _)). %fail
:- urilib_parse("zos://host.parole/path.pa2t", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- not(urilib_parse("zos:path.", _)). %fail
:- not(urilib_parse("zos:.path", _)). %fail
:- urilib_parse("zos:asdaiasd3uibdfssd98dfs", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- urilib_parse("zos:path?query", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- urilib_parse("zos:path#fragment", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- urilib_parse("zos:esattamente44caratteriaaaaaaaaaaaaaaaaaaaaaa", URI),
	urilib_parse(String, URI), urilib_parse(String, URI).
:- not(urilib_parse("zos:path_fail", _)). %fail
:- not(urilib_parse("zos:pat.h(f_ail)", _)). %fail
:- not(urilib_parse("zos:esattamente45caratteriaaaaaaaaaaaaaaaaaaaaaaa", _)). %fail
:- urilib_parse("zos://255.255.255.000/path(id8c)", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- urilib_parse("zos:path(precisi8)", URI), urilib_parse(String, URI), urilib_parse(String, URI).
:- not(urilib_parse("zos:path(nprecisi9)", _)). %fail
:- not(urilib_parse("zos:path(8id)", _)). %fail