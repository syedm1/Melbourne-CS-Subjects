proper_list([]).
proper_list([_Head|Tail]) :-
    proper_list(Tail).

append([], C, C).
append([A|B], C, [A|BC]) :-
    append(B, C, BC).

take(N, List, Front) :-
    length(Front, N),
    append(Front, _, List).

member(Elt, List) :-
    append(_, [Elt|_], List).

member2(Elt, [Elt|_]).
member2(Elt, [_|Rest]) :-
    member2(Elt, Rest).

rev1([], []).
rev1([A|BC], CBA) :-
    rev1(BC, CB),
    append(CB, [A], CBA).
    
rev3(ABC, CBA) :-
    samelength(ABC, CBA),
    rev1(ABC, CBA).

same([], []).
samelength([_|Xs], [_|Ys]) :-
    samelength(Xs, Ys).

fact(0, 1).
fact(N, Fact) :-
    N > 0,
    N1 is N-1,
    fact(N1, F1),
    Fact is N * F1.

hello(haonan).
hello(niu).
nihao(X) :- hello(X).

all_same([]).
all_same([_]).
all_same([E,E|T]) :- all_same([E|T]).

before(E1, E2, [E1|List]) :-
    member(E2, List).
before(E1, E2, [_|List]) :-
    before(E1, E2, List).

hello(X,Y) :-
    ( X>0,Y>0 ->
        write("hello")
    ; write("hi")
    ).

q2([H | T], H, T).
q2([H | T], E, [H | NT]) :-
    q2(T, E, NT).

