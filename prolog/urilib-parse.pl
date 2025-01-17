% urilib.pl
% Nicolo' Luigi Allegris 909582

% digit/1
digit('0').
digit('1').
digit('2').
digit('3').
digit('4').
digit('5').
digit('6').
digit('7').
digit('8').
digit('9').


% letter/1
letter('a').
letter('b').
letter('c').
letter('d').
letter('e').
letter('f').
letter('g').
letter('h').
letter('i').
letter('j').
letter('k').
letter('l').
letter('m').
letter('n').
letter('o').
letter('p').
letter('q').
letter('r').
letter('s').
letter('t').
letter('u').
letter('v').
letter('w').
letter('x').
letter('y').
letter('z').
letter('A').
letter('B').
letter('C').
letter('D').
letter('E').
letter('F').
letter('G').
letter('H').
letter('I').
letter('J').
letter('K').
letter('L').
letter('M').
letter('N').
letter('O').
letter('P').
letter('Q').
letter('R').
letter('S').
letter('T').
letter('U').
letter('V').
letter('W').
letter('X').
letter('Y').
letter('Z').


% alfanum/1
alphanum(X) :- digit(X).
alphanum(X) :- letter(X).


% char/1
char(X) :- alphanum(X).
char('_').
char('-').
char('=').
char('+').


% urilib_parse/2
urilib_parse(String, 
             uri(Scheme0, Userinfo, Host, Port, Path, Query, Fragment)) :-

    string(String),

    % split string in chars
    string_chars(String, Chars),

    % reads scheme
    parse_scheme(Chars, Scheme, Rest),

    % convert list of chars to atoms
    atom_chars(Scheme0, Scheme),

    % choose next automata
    choose_automata(Rest, Scheme0, Userinfo, Host, Port, Path, Query, 
                    Fragment),
                    
    % remove this if the zos path is not necessary
    is_zos_path_ok(Scheme, Path).


% is_zos_path_ok/2
is_zos_path_ok(zos, Path) :- !, Path \= [].
is_zos_path_ok(_, _).


% is_zos_path_ok/2
is_zos_path_ok(zos, Path) :- !, Path \= [].
is_zos_path_ok(_, _).


% urilib_display/2
urilib_display(Stream,
               uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)) :-
    write(Stream, 'scheme:   '), write(Stream, Scheme), nl(Stream),
    write(Stream, 'userinfo: '), write(Stream, Userinfo), nl(Stream),
    write(Stream, 'host:     '), write(Stream, Host), nl(Stream),
    write(Stream, 'port:     '), write(Stream, Port), nl(Stream),
    write(Stream, 'path:     '), write(Stream, Path), nl(Stream),
    write(Stream, 'query:    '), write(Stream, Query), nl(Stream),
    write(Stream, 'fragment: '), write(Stream, Fragment), nl(Stream).


% urilib_display/1
urilib_display(X) :- current_output(Stream), urilib_display(Stream, X).


% parse_scheme/8
parse_scheme([':' | Rest], [], Rest) :- !.
parse_scheme([X | Chars], [X | Scheme], Rest) :-
    char(X), !,
    parse_scheme(Chars, Scheme, Rest).


% choose_automata/7
choose_automata(String, http, Userinfo, Host, Port, Path,
                Query, Fragment) :- !,
    default_parser(String, http, Userinfo, Host, Port, Path, Query, Fragment).

choose_automata(String, https, Userinfo, Host, Port, Path,
                Query, Fragment) :- !,
    default_parser(String, https, Userinfo, Host, Port, Path, Query, Fragment).

choose_automata(String, ftp, Userinfo, Host, Port, Path,
                Query, Fragment) :- !,
    default_parser(String, ftp, Userinfo, Host, Port, Path, Query, Fragment).

choose_automata(String, zos, Userinfo, Host, Port, Path,
                Query, Fragment) :- !,
    default_parser(String, zos, Userinfo, Host, Port, Path, Query, Fragment).

choose_automata(String, mailto, Userinfo0, Host, 25, [], [], []) :- !,
    mailto_parser(String, Userinfo, Host),
    atom_chars(Userinfo0, Userinfo).

choose_automata(String, news, [], Host0, 119, [], [], []) :- !,
    mailto_host_parser(String, Host),
    atom_chars(Host0, Host).

choose_automata(String, tel, Userinfo0, [], [], [], [], []) :- !,
    tel_parser(String, Userinfo),
    atom_chars(Userinfo0, Userinfo).

choose_automata(String, fax, Userinfo0, [], [], [], [], []) :- !,
    tel_parser(String, Userinfo),
    atom_chars(Userinfo0, Userinfo).


% default_parser/8
default_parser(['#' | String], ftp, [], [], 21, [], [], Fragment0) :- !,
    fragment_parser(String, Fragment),
    atom_chars(Fragment0, Fragment).

default_parser(['#' | String], https, [], [], 443, [], [], Fragment0) :- !,
    fragment_parser(String, Fragment),
    atom_chars(Fragment0, Fragment).

default_parser(['#' | String], _, [], [], 80, [], [], Fragment0) :- !,
    fragment_parser(String, Fragment),
    atom_chars(Fragment0, Fragment).

default_parser(['?' | String], ftp, [], [], 21, [], Query0, Fragment) :- !,
    query_parser(String, Query, Fragment),
    atom_chars(Query0, Query).

default_parser(['?' | String], https, [], [], 443, [], Query0, Fragment) :- !,
    query_parser(String, Query, Fragment),
    atom_chars(Query0, Query).

default_parser(['?' | String], _, [], [], 80, [], Query0, Fragment) :- !,
    query_parser(String, Query, Fragment),
    atom_chars(Query0, Query).

default_parser(['/' | String], Scheme, Userinfo, Host, Port, Path,
	       Query, Fragment) :- !,
    second_slash_parser(String, Scheme, Userinfo, Host, Port,
                        Path, Query, Fragment).

default_parser([X | String], zos, [], [], 80, Path0, Query, Fragment) :-
    char(X), !,
    zos_path_parser([X | String], Path, Query, Fragment),
    atom_chars(Path0, Path).

default_parser([X | String], ftp, [], [], 21, Path0, Query, Fragment) :-
    char(X), !,
    default_path_parser([X | String], Path, Query, Fragment),
    atom_chars(Path0, Path).

default_parser([X | String], https, [], [], 443, Path0, Query, Fragment) :-
    char(X), !,
    default_path_parser([X | String], Path, Query, Fragment),
    atom_chars(Path0, Path).

default_parser([X | String], http, [], [], 80, Path0, Query, Fragment) :-
    char(X), !,
    default_path_parser([X | String], Path, Query, Fragment),
    atom_chars(Path0, Path).


% fragment_parser/2
fragment_parser([X | String], [X | Fragment]) :-
    char(X), !,
    fragment_reader(String, Fragment).


% fragment_reader/2
fragment_reader([], []) :- !.
fragment_reader([X | String], [X | Fragment]) :-
    char(X), !,
    fragment_reader(String, Fragment).


% query_parser/3
query_parser([X | String], [X | Query], Fragment) :-
    char(X), !,
    query_reader(String, Query, Fragment).


% query_reader/3
query_reader([], [], []) :- !.
query_reader(['#' | String], [], Fragment0) :- !,
    fragment_parser(String, Fragment),
    atom_chars(Fragment0, Fragment).
query_reader([X | String], [X | Query], Fragment) :-
    char(X), !,
    query_reader(String, Query, Fragment).


% default_path_parser/4
default_path_parser([X | String], [X | Path], Query, Fragment) :-
    char(X), !,
    default_path_reader(String, Path, Query, Fragment).


% default_path_reader/4
default_path_reader([], [], [], []) :- !.
default_path_reader(['#' | String], [], [], Fragment0) :- !,
    fragment_parser(String, Fragment),
    atom_chars(Fragment0, Fragment).
default_path_reader(['?' | String], [], Query0, Fragment) :- !,
    query_parser(String, Query, Fragment),
    atom_chars(Query0, Query).
default_path_reader(['/' | String], ['/' | Path], Query, Fragment) :- !,
    default_path_slash(String, Path, Query, Fragment).
default_path_reader([X | String], [X | Path], Query, Fragment) :-
    char(X), !,
    default_path_reader(String, Path, Query, Fragment).


% default_path_dot/4
default_path_slash([X | String], [X | Path], Query, Fragment) :-
    char(X), !,
    default_path_reader(String, Path, Query, Fragment).


% second_slash_parser/8
second_slash_parser([X | String], zos, [], [], 80, Path0, Query, Fragment) :-
    char(X), !,
    zos_path_parser([X | String], Path, Query, Fragment),
    atom_chars(Path0, Path).

second_slash_parser([X | String], ftp, [], [], 21, Path0, Query, Fragment) :-
    char(X), !,
    default_path_parser([X | String], Path, Query, Fragment),
    atom_chars(Path0, Path).

second_slash_parser([X | String], https, [], [], 443, Path0, Query, Fragment) :-
    char(X), !,
    default_path_parser([X | String], Path, Query, Fragment),
    atom_chars(Path0, Path).

second_slash_parser([X | String], http, [], [], 80, Path0, Query, Fragment) :-
    char(X), !,
    default_path_parser([X | String], Path, Query, Fragment),
    atom_chars(Path0, Path).

second_slash_parser(['/' | String], Scheme, Userinfo, Host, Port, Path,
		    Query, Fragment) :- !,
    authority_parser(String, Scheme, Userinfo, Host, Port,
                     Path, Query, Fragment).

second_slash_parser(['#' | String], ftp, [], [], 21, [], [], Fragment0) :- !,
    fragment_parser(String, Fragment),
    atom_chars(Fragment0, Fragment).

second_slash_parser(['#' | String], https, [], [], 443, [], [], Fragment0) :- !,
    fragment_parser(String, Fragment),
    atom_chars(Fragment0, Fragment).

second_slash_parser(['#' | String], _, [], [], 80, [], [], Fragment0) :- !,
    fragment_parser(String, Fragment),
    atom_chars(Fragment0, Fragment).

second_slash_parser(['?' | String], ftp, [], [], 21, [], Query0, Fragment) :- !,
    query_parser(String, Query, Fragment),
    atom_chars(Query0, Query).

second_slash_parser(['?' | String], https, [], [], 443, [], Query0,
		    Fragment) :- !,
    query_parser(String, Query, Fragment),
    atom_chars(Query0, Query).

second_slash_parser(['?' | String], _, [], [], 80, [], Query0, Fragment) :- !,
    query_parser(String, Query, Fragment),
    atom_chars(Query0, Query).


% authority_parser/8
authority_parser(String, Scheme, Userinfo0, Host0, Port, Path, Query,
		 Fragment) :-
    userinfo_parser(String, Userinfo, Rest), !,
    atom_chars(Userinfo0, Userinfo),
    default_host_parser(Rest, Scheme, Host, Port, Path, Query, Fragment),
    atom_chars(Host0, Host).
authority_parser(String, Scheme, [], Host0, Port, Path, Query, Fragment) :-
    default_host_parser(String, Scheme, Host, Port, Path, Query, Fragment), !,
    atom_chars(Host0, Host).


% userinfo_parser/3
userinfo_parser([X | String], [X | Userinfo], Rest) :-
    char(X), !,
    userinfo_reader(String, Userinfo, Rest).


% userinfo_reader/3
userinfo_reader([X | String], [X | Userinfo], Rest) :-
    char(X), !,
    userinfo_reader(String, Userinfo, Rest).
userinfo_reader(['@' | Rest], [], Rest) :- !.


% default_host_parser/7
default_host_parser([X | String], Scheme, [X | Host], Port, Path,
		    Query, Fragment) :-
    letter(X), !,
    host_name_reader(String, Scheme, Host, Port, Path, Query, Fragment).
default_host_parser([X | String], Scheme, Host, Port, Path, Query, Fragment) :-
    digit(X), !,
    ip0([X | String], Scheme, Host, Port, Path, Query, Fragment, 0).


% host_name_reader/7
host_name_reader([], ftp, [], 21, [], [], []) :- !.
host_name_reader([], https, [], 443, [], [], []) :- !.
host_name_reader([], _, [], 80, [], [], []) :- !.
host_name_reader([X | String], Scheme, [X | Host], Port, Path,
		 Query, Fragment) :-
    alphanum(X), !,
    host_name_reader(String, Scheme, Host, Port, Path, Query, Fragment).
host_name_reader(['.' | String], Scheme, ['.' | Host], Port, Path,
		 Query, Fragment) :- !,
    host_name_reader_dot(String, Scheme, Host, Port, Path, Query, Fragment).
host_name_reader([':' | String], Scheme, [], Port0, Path, Query, Fragment) :-
    !,
    port_parser(String, Scheme, Port, Path, Query, Fragment),
    atom_chars(Port0, Port).
host_name_reader(['/' | String], ftp, [], 21, Path, Query, Fragment) :- !,
    choose_next_section(String, ftp, Path, Query, Fragment).
host_name_reader(['/' | String], https, [], 443, Path, Query, Fragment) :- !,
    choose_next_section(String, https, Path, Query, Fragment).
host_name_reader(['/' | String], Scheme, [], 80, Path, Query, Fragment) :- !,
    choose_next_section(String, Scheme, Path, Query, Fragment).


% host_name_reader_dot/7
host_name_reader_dot([X | String], Scheme, [X | Host], Port, Path,
		     Query, Fragment) :-
    letter(X), !,
    host_name_reader(String, Scheme, Host, Port, Path, Query, Fragment).


% port_parser/6
port_parser([X | String], Scheme, [X | Port], Path, Query, Fragment) :-
    digit(X), !,
    port_reader(String, Scheme, Port, Path, Query, Fragment).


% port_reader/6
port_reader([], _, [], [], [], []) :- !.
port_reader(['/' | String], Scheme, [], Path, Query, Fragment) :- !,
    choose_next_section(String, Scheme, Path, Query, Fragment).
port_reader([X | String], Scheme, [X | Port], Path, Query, Fragment) :-
    digit(X), !,
    port_reader(String, Scheme, Port, Path, Query, Fragment).


% ip0/8
ip0(['0' | String], Scheme, ['0' | Host], Port, Path, Query, Fragment, Dots) :-
    !,
    ip1(String, Scheme, Host, Port, Path, Query, Fragment, Dots).
ip0(['1' | String], Scheme, ['1' | Host], Port, Path, Query, Fragment, Dots) :-
    !,
    ip1(String, Scheme, Host, Port, Path, Query, Fragment, Dots).
ip0(['2' | String], Scheme, ['2' | Host], Port, Path, Query, Fragment, Dots) :-
    !,
    ip2(String, Scheme, Host, Port, Path, Query, Fragment, Dots).
ip0([X | String], Scheme, [X | Host], Port, Path, Query, Fragment, Dots) :-
    digit(X), !,
    ip3(String, Scheme, Host, Port, Path, Query, Fragment, Dots).


% ip1/8
ip1([], https, [], 443, [], [], [], 3) :- !.
ip1([], ftp, [], 21, [], [], [], 3) :- !.
ip1([], _, [], 80, [], [], [], 3) :- !.
ip1([X | String], Scheme, [X | Host], Port, Path, Query, Fragment, Dots) :-
    digit(X), !,
    ip3(String, Scheme, Host, Port, Path, Query, Fragment, Dots).
ip1(['.' | String], Scheme, ['.' | Host], Port, Path, Query, Fragment, Dots) :-
    !,
    Dots < 3, !,
    Dots1 is Dots + 1,
    ip0(String, Scheme, Host, Port, Path, Query, Fragment, Dots1).
ip1(String, Scheme, [], Port, Path, Query, Fragment, 3) :- !,
    ip6(String, Scheme, Port, Path, Query, Fragment).


% ip2/8
ip2([], https, [], 443, [], [], [], 3) :- !.
ip2([], ftp, [], 21, [], [], [], 3) :- !.
ip2([], _, [], 80, [], [], [], 3) :- !.
ip2(['0' | String], Scheme, ['0' | Host], Port, Path, Query, Fragment, Dots) :-
    !,
    ip3(String, Scheme, Host, Port, Path, Query, Fragment, Dots).
ip2(['1' | String], Scheme, ['1' | Host], Port, Path, Query, Fragment, Dots) :-
    !,
    ip3(String, Scheme, Host, Port, Path, Query, Fragment, Dots).
ip2(['2' | String], Scheme, ['2' | Host], Port, Path, Query, Fragment, Dots) :-
    !,
    ip3(String, Scheme, Host, Port, Path, Query, Fragment, Dots).
ip2(['3' | String], Scheme, ['3' | Host], Port, Path, Query, Fragment, Dots) :-
    !,
    ip3(String, Scheme, Host, Port, Path, Query, Fragment, Dots).
ip2(['4' | String], Scheme, ['3' | Host], Port, Path, Query, Fragment, Dots) :-
    !,
    ip3(String, Scheme, Host, Port, Path, Query, Fragment, Dots).
ip2(['5' | String], Scheme, ['5' | Host], Port, Path, Query, Fragment, Dots) :-
    !,
    ip5(String, Scheme, Host, Port, Path, Query, Fragment, Dots).
ip2([X | String], Scheme, [X | Host], Port, Path, Query, Fragment, Dots) :-
    digit(X), !,
    ip4(String, Scheme, Host, Port, Path, Query, Fragment, Dots).
ip2(['.' | String], Scheme, ['.' | Host], Port, Path, Query, Fragment, Dots) :-
    !,
    Dots < 3, !,
    Dots1 is Dots + 1,
    ip0(String, Scheme, Host, Port, Path, Query, Fragment, Dots1).
ip2(String, Scheme, [], Port, Path, Query, Fragment, 3) :- !,
    ip6(String, Scheme, Port, Path, Query, Fragment).


% ip3/8
ip3([], https, [], 443, [], [], [], 3) :- !.
ip3([], ftp, [], 21, [], [], [], 3) :- !.
ip3([], _, [], 80, [], [], [], 3) :- !.
ip3([X | String], Scheme, [X | Host], Port, Path, Query, Fragment, Dots) :-
    digit(X), !,
    ip5(String, Scheme, Host, Port, Path, Query, Fragment, Dots).
ip3(['.' | String], Scheme, ['.' | Host], Port, Path, Query, Fragment, Dots) :-
    !,
    Dots < 3, !,
    Dots1 is Dots + 1,
    ip0(String, Scheme, Host, Port, Path, Query, Fragment, Dots1).
ip3(String, Scheme, [], Port, Path, Query, Fragment, 3) :- !,
    ip6(String, Scheme, Port, Path, Query, Fragment).


% ip4/8
ip4([], https, [], 443, [], [], [], 3) :- !.
ip4([], ftp, [], 21, [], [], [], 3) :- !.
ip4([], _, [], 80, [], [], [], 3) :- !.
ip4(['.' | String], Scheme, ['.' | Host], Port, Path, Query, Fragment, Dots) :-
    Dots < 3, !,
    Dots1 is Dots + 1,
    ip0(String, Scheme, Host, Port, Path, Query, Fragment, Dots1).
ip4(String, Scheme, [], Port, Path, Query, Fragment, 3) :- !,
    ip6(String, Scheme, Port, Path, Query, Fragment).


% ip5/8
ip5([], https, [], 443, [], [], [], 3) :- !.
ip5([], ftp, [], 21, [], [], [], 3) :- !.
ip5([], _, [], 80, [], [], [], 3) :- !.
ip5(['0' | String], Scheme, ['0' | Host], Port, Path, Query, Fragment, Dots) :-
    !,
    ip4(String, Scheme, Host, Port, Path, Query, Fragment, Dots).
ip5(['1' | String], Scheme, ['1' | Host], Port, Path, Query, Fragment, Dots) :-
    !,
    ip4(String, Scheme, Host, Port, Path, Query, Fragment, Dots).
ip5(['2' | String], Scheme, ['2' | Host], Port, Path, Query, Fragment, Dots) :-
    !,
    ip4(String, Scheme, Host, Port, Path, Query, Fragment, Dots).
ip5(['3' | String], Scheme, ['3' | Host], Port, Path, Query, Fragment, Dots) :-
    !,
    ip4(String, Scheme, Host, Port, Path, Query, Fragment, Dots).
ip5(['4' | String], Scheme, ['4' | Host], Port, Path, Query, Fragment, Dots) :-
    !,
    ip4(String, Scheme, Host, Port, Path, Query, Fragment, Dots).
ip5(['5' | String], Scheme, ['5' | Host], Port, Path, Query, Fragment, Dots) :-
    !,
    ip4(String, Scheme, Host, Port, Path, Query, Fragment, Dots).
ip5(['.' | String], Scheme, ['.' | Host], Port, Path, Query, Fragment, Dots) :-
    Dots < 3, !,
    Dots1 is Dots + 1,
    ip0(String, Scheme, Host, Port, Path, Query, Fragment, Dots1).
ip5(String, Scheme, [], Port, Path, Query, Fragment, 3) :- !,
    ip6(String, Scheme, Port, Path, Query, Fragment).


% ip6/8
ip6([':' | String], Scheme, Port0, Path, Query, Fragment) :- !,
    port_parser(String, Scheme, Port, Path, Query, Fragment),
    atom_chars(Port0, Port).
ip6(['/' | String], ftp, 21, Path, Query, Fragment) :- !,
    choose_next_section(String, ftp, Path, Query, Fragment).
ip6(['/' | String], https, 443, Path, Query, Fragment) :- !,
    choose_next_section(String, https, Path, Query, Fragment).
ip6(['/' | String], Scheme, 80, Path, Query, Fragment) :- !,
    choose_next_section(String, Scheme, Path, Query, Fragment).


% choose_next_section/5
choose_next_section([], _, [], [], []) :- !.
choose_next_section(['#' | String], _, [], [], Fragment0) :- !,
    fragment_parser(String, Fragment),
    atom_chars(Fragment0, Fragment).
choose_next_section(['?' | String], _, [], Query0, Fragment) :- !,
    query_parser(String, Query, Fragment),
    atom_chars(Query0, Query).
choose_next_section([X | String], zos, Path0, Query, Fragment) :-
    char(X), !,
    zos_path_parser([X | String], Path, Query, Fragment),
    atom_chars(Path0, Path).
choose_next_section([X | String], _, Path0, Query, Fragment) :-
    char(X), !,
    default_path_parser([X | String], Path, Query, Fragment),
    atom_chars(Path0, Path).


% zos_path_parser/4
zos_path_parser([X | String], [X | Path], Query, Fragment) :- !,
    letter(X), !,
    zos_path_id44(String, Path, Query, Fragment, 1).


% zos_path_id44/5
zos_path_id44([], [], [], [], _) :- !.
zos_path_id44(['#' | String], [], [], Fragment0, _) :- !,
    fragment_parser(String, Fragment),
    atom_chars(Fragment0, Fragment).
zos_path_id44(['?' | String], [], Query0, Fragment, _) :- !,
    query_parser(String, Query, Fragment),
    atom_chars(Query0, Query).
zos_path_id44([X | String], [X | Path], Query, Fragment, Counter) :-
    char(X), !, 
    Counter < 44,
    Counter1 is Counter + 1,
    zos_path_id44(String, Path, Query, Fragment, Counter1).
zos_path_id44(['.' | String], ['.' | Path], Query, Fragment, Counter) :- !,
    Counter < 44,
    Counter1 is Counter + 1,
    zos_path_id44_dot(String, Path, Query, Fragment, Counter1).
zos_path_id44(['(' | String], ['(' | Path], Query, Fragment, _) :- !,
    zos_path_id8(String, Path, Query, Fragment).


% zos_path_id44_dot/5
zos_path_id44_dot([X | String], [X | Path], Query, Fragment, Counter) :-
    char(X), !,
    Counter < 44,
    Counter1 is Counter + 1,
    zos_path_id44(String, Path, Query, Fragment, Counter1).


% zos_path_id8/5
zos_path_id8([X | String], [X | Path], Query, Fragment) :- !,
    letter(X),
    zos_path_id8_reader(String, Path, Query, Fragment, 1).


% zos_path_id8_reader/5
zos_path_id8_reader([')' | String], [')'], Query, Fragment, _) :- !,
    zos_path_closer(String, Query, Fragment).
zos_path_id8_reader([X | String], [X | Path], Query, Fragment, Counter) :-
    char(X), !,
    Counter < 8,
    Counter1 is Counter + 1,
    zos_path_id8_reader(String, Path, Query, Fragment, Counter1).


% zos_path_closer/3
zos_path_closer([], [], []) :- !.
zos_path_closer(['#' | String], [], Fragment0) :- !,
    fragment_parser(String, Fragment),
    atom_chars(Fragment0, Fragment).
zos_path_closer(['?' | String], Query0, Fragment) :- !,
    query_parser(String, Query, Fragment),
    atom_chars(Query0, Query).


% tel_parser/2
tel_parser([X | String], [X | Userinfo]) :-
    char(X), !,
    tel_reader(String, Userinfo).


% tel_reader/2
tel_reader([], []) :- !.
tel_reader([X | String], [X | Userinfo]) :-
    char(X), !,
    tel_reader(String, Userinfo).


% mailto_parser/3
mailto_parser([X | String], [X | Userinfo], Host) :-
    char(X), !,
    mailto_reader(String, Userinfo, Host).


% mailto_reader/3
mailto_reader([], [], []) :- !.
mailto_reader(['@' | String], [], Host0) :- !,
    mailto_host_parser(String, Host),
    atom_chars(Host0, Host).
mailto_reader([X | String], [X | Userinfo], Host) :-
    char(X), !,
    mailto_reader(String, Userinfo, Host).


% mailto_host_parser/2
mailto_host_parser([X | String], [X | Host]) :-
    letter(X), !,
    mailto_host_name_reader(String, Host).
mailto_host_parser([X | String], Host) :-
    digit(X), !,
    mailto_ip0([X | String], Host, 0).


% mailto_host_name_reader/2
mailto_host_name_reader([], []) :- !.
mailto_host_name_reader([X | String], [X | Host]) :-
    alphanum(X), !,
    mailto_host_name_reader(String, Host).
mailto_host_name_reader(['.' | String], ['.' | Host]) :- !,
    mailto_host_name_reader_dot(String, Host).


% mailto_host_name_reader_dot/2
mailto_host_name_reader_dot([X | String], [X | Host]) :-
    letter(X), !,
    mailto_host_name_reader(String, Host).


% mailto_ip0/3
mailto_ip0(['0' | String], ['0' | Host], Dots) :- !,
    mailto_ip1(String, Host, Dots).
mailto_ip0(['1' | String], ['1' | Host], Dots) :- !,
    mailto_ip1(String, Host, Dots).
mailto_ip0(['2' | String], ['2' | Host], Dots) :- !,
    mailto_ip2(String, Host, Dots).


% mailto_ip1/3
mailto_ip1([X | String], [X | Host], Dots) :-
    digit(X), !,
    mailto_ip3(String, Host, Dots).


% mailto_ip2/3
mailto_ip2(['0' | String], ['0' | Host], Dots) :- !,
    mailto_ip3(String, Host, Dots).
mailto_ip2(['1' | String], ['1' | Host], Dots) :- !,
    mailto_ip3(String, Host, Dots).
mailto_ip2(['2' | String], ['2' | Host], Dots) :- !,
    mailto_ip3(String, Host, Dots).
mailto_ip2(['3' | String], ['3' | Host], Dots) :- !,
    mailto_ip3(String, Host, Dots).
mailto_ip2(['4' | String], ['3' | Host], Dots) :- !,
    mailto_ip3(String, Host, Dots).
mailto_ip2(['5' | String], ['5' | Host], Dots) :- !,
    mailto_ip4(String, Host, Dots).


% mailto_ip3/3
mailto_ip3([X | String], [X | Host], Dots) :-
    digit(X), !,
    mailto_ip5(String, Host, Dots).


% mailto_ip4/3
mailto_ip4(['0' | String], ['0' | Host], Dots) :- !,
    mailto_ip5(String, Host, Dots).
mailto_ip4(['1' | String], ['1' | Host], Dots) :- !,
    mailto_ip5(String, Host, Dots).
mailto_ip4(['2' | String], ['2' | Host], Dots) :- !,
    mailto_ip5(String, Host, Dots).
mailto_ip4(['3' | String], ['3' | Host], Dots) :- !,
    mailto_ip5(String, Host, Dots).
mailto_ip4(['4' | String], ['4' | Host], Dots) :- !,
    mailto_ip5(String, Host, Dots).
mailto_ip4(['5' | String], ['5' | Host], Dots) :- !,
    mailto_ip5(String, Host, Dots).


% mailto_ip5/3
mailto_ip5([], [], 3) :- !.
mailto_ip5(['.' | String], ['.' | Host], Dots) :-
    Dots < 3, !,
    Dots1 is Dots + 1,
    mailto_ip0(String, Host, Dots1).

% urilib.pl ends here
