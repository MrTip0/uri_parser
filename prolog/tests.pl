% -*-Prolog-*-
%Test Cases:
%mailto
:- urilib_parse("mailto:paolo@255.255.255.000",
		uri(mailto, paolo, '255.255.255.000', 25, [], [], [])).
:- urilib_parse("mailto:paolo", uri(mailto, paolo, [], 25, [], [], [])).
:- urilib_parse("mailto:paolo@gmail.com",
		uri(mailto, paolo, 'gmail.com', 25, [], [], [])).
:- not(urilib_parse("mailto:", _)). %fail
:- not(urilib_parse("mailto:paolo.rossi", _)).%fail
:- not(urilib_parse("mailto:paolo@", _)). %fail
:- not(urilib_parse("mailto:paolo@gmail.", _)). %fail
:- not(urilib_parse("mailto:paolo@a255.255", _)). %fail
:- not(urilib_parse("mailto:paolo@256.255.255.000", _)). %fail
:- not(urilib_parse("mailto:paolo@255.255.255", _)). %fail


%news
:- urilib_parse("news:gmail",
		uri(news, [], gmail, 119, [], [], [])).
:- urilib_parse("news:gmail.com", 
		uri(news, [], 'gmail.com', 119, [], [], [])).
:- urilib_parse("news:5.56.0.5",
		uri(news, [], '5.56.0.5', 119, [], [], [])).
:- urilib_parse("news:255.25.5.1", 
		uri(news, [], '255.25.5.1', 119, [], [], [])).
:- urilib_parse("news:185.065.15.255", 
		uri(news, [], '185.065.15.255', 119, [], [], [])).
:- not(urilib_parse("news:", _)). %fail
:- not(urilib_parse("news:a255.255", _)). %fail
:- not(urilib_parse("news:255.255", _)). %fail
:- not(urilib_parse("news:355.255.000.000", _)). %fail
:- not(urilib_parse("news:paolo.polpo..paolo", _)). %fail
:- not(urilib_parse("news:parola_underscore", _)). %fail
:- not(urilib_parse("news:paolo.polpo..paolo", _)). %fail
:- not(urilib_parse("news:paolo+pollo", _)). %fail


%telFax
:- urilib_parse("tel:LoremIpsum", uri(tel, 'LoremIpsum', [], [], [], [], [])).
:- urilib_parse("fax:123456789", uri(fax, '123456789', [], [], [], [], [])).
:- not(urilib_parse("tel:", _)). %fail
:- not(urilib_parse("t.el:123 4568 456", _)). %fail
:- not(urilib_parse("fax:pasd:asd_asd+asd", _)). %fail

%noAuthority
:- urilib_parse("https:path/path2?query#fragment", 
		uri(https, [], [], 443, 'path/path2', query, fragment)).
:- urilib_parse("https:path+now-correct",
		uri(https, [], [], 443, 'path+now-correct', [], [])).
:- urilib_parse("https:path?query",
		uri(https, [], [], 443, path, query, [])).
:- urilib_parse("https:", uri(https, [], [], 443, [], [], [])).
:- urilib_parse("https:?query",
		uri(https, [], [], 443, [], query, [])).
:- urilib_parse("http:",
		uri(http, [], [], 80, [], [], [])).
:- urilib_parse("http:path/to/resource",
		uri(http, [], [], 80, 'path/to/resource', [], [])).
:- urilib_parse("http:/path/to/resource",
		uri(http, [], [], 80, 'path/to/resource', [], [])).
:- urilib_parse("http:?query_con+caratteri=quasi-a-caso", 
		uri(http, [], [], 80, [], 'query_con+caratteri=quasi-a-caso', [])).
:- urilib_parse("ftp:/", uri(ftp, [], [], 21, [], [], [])).
:- urilib_parse("ftp:path_underscore", 
		uri(ftp, [], [], 21, 'path_underscore', [], [])).
:- urilib_parse("ftp:#fragment",
		uri(ftp, [], [], 21, [], [], fragment)).
:- not(urilib_parse("http:path/incorrect/", _)). %fail
:- not(urilib_parse("scheme:path/to/resource", _)). %fail
:- not(urilib_parse("ftp:/path/?query", _)). %fail
:- not(urilib_parse("null:path", _)). %fail
:- not(urilib_parse("ftp:?", _)). %fail
:- not(urilib_parse("ftp:#", _)). %fail
:- not(urilib_parse("https:path#", _)). %fail
:- not(urilib_parse("scheme:", _)). %fail

%Authority
:- urilib_parse("https://255.255.255.000",
		uri(https, [], '255.255.255.000', 443, [], [], [])).
:- urilib_parse("https://A-user+info@host.caratteri",
		uri(https, 'A-user+info', 'host.caratteri', 443, [], [], [])).
:- urilib_parse("https://pvoa@host.caratteri", 
		uri(https, pvoa, 'host.caratteri', 443, [], [], [])).
:- urilib_parse("https://elearning.unimib.it/course/view?id=57379", 
		uri(https, [], 'elearning.unimib.it', 443, 'course/view', 'id=57379', [])).
:- urilib_parse("http://a@255.255.255.000",
		uri(http, a, '255.255.255.000', 80, [], [], [])).
:- urilib_parse("http://www.google.com",
		uri(http, [], 'www.google.com', 80, [], [], [])).
:- urilib_parse("http://255.255.255.000:72",
		uri(http, [], '255.255.255.000', 72, [], [], [])).
:- urilib_parse("ftp://host.caratteri",
		uri(ftp, [], 'host.caratteri', 21, [], [], [])).
:- urilib_parse("ftp://www.google.com", 
		uri(ftp, [], 'www.google.com', 21, [], [], [])).
:- urilib_parse("ftp://host.caratteri:5464165",
		uri(ftp, [], 'host.caratteri', 5464165, [], [], [])).
:- not(urilib_parse("ftp://", _)). %fail
:- not(urilib_parse("http://255.255.265.000", _)). %fail
:- not(urilib_parse("http://25.256.255.0", _)). %fail
:- not(urilib_parse("fail://255.255.255.000", _)). %fail
:- not(urilib_parse("https://host.caratteri.", _)). %fail
:- not(urilib_parse("http://@255.255.255.000", _)). %fail
:- not(urilib_parse("https://a/@255.255.255.000", _)). %fail
:- not(urilib_parse("https://255.255.255.000:", _)). %fail
:- not(urilib_parse("ftp://host.caratteri:c", _)). %fail

%ZOS
:- urilib_parse("zos:path.to.resource",
		uri(zos, [], [], 80, 'path.to.resource', [], [])).
:- urilib_parse("zos:path.....si",
		uri(zos, [], [], 80, 'path.....si', [], [])).
:- urilib_parse("zos://host.parole/path.pa2t",
		uri(zos, [], 'host.parole', 80, 'path.pa2t', [], [])).
:- urilib_parse("zos:asdaiasd3uibdfssd98dfs", 
		uri(zos, [], [], 80, 'asdaiasd3uibdfssd98dfs', [], [])).
:- urilib_parse("zos:path?query",
		uri(zos, [], [], 80, path, query, [])).
:- urilib_parse("zos:path#fragment",
		uri(zos, [], [], 80, path, [], fragment)).
:- urilib_parse("zos:esattamente44caratteriaaaaaaaaaaaaaaaaaaaaaa",
		uri(zos, [], [], 80, 'esattamente44caratteriaaaaaaaaaaaaaaaaaaaaaa', [], [])).
:- urilib_parse("zos://255.255.255.00/path(id8c)", 
		uri(zos, [], '255.255.255.00', 80, 'path(id8c)', [], [])).
:- urilib_parse("zos:path(precisi8)",
		uri(zos, [], [], 80, 'path(precisi8)', [], [])).
:- not(urilib_parse("zos:path(nprecisi9)", _)). %fail
:- not(urilib_parse("zos:path(8id)", _)). %fail
:- not(urilib_parse("zos:/path/to/resource", _)). %fail
:- not(urilib_parse("zos:", _)). %fail
:- not(urilib_parse("zos:?query", _)). %fail
:- not(urilib_parse("zos://host", _)). %fail
:- not(urilib_parse("zos:path_underscore", _)). %fail
:- not(urilib_parse("zos:path.", _)). %fail
:- not(urilib_parse("zos:.path", _)). %fail
:- not(urilib_parse("zos:path_fail", _)). %fail
:- not(urilib_parse("zos:pat.h(f_ail)", _)). %fail
:- not(urilib_parse("zos:esattamente45caratteriaaaaaaaaaaaaaaaaaaaaaaa", _)). %fail
