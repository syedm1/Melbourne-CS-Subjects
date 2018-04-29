% QUESTION 1
list_of(_, []).
list_of(Elt, [Elt|Tail]) :-
    list_of(Elt,Tail).

% QUESTION 2
all_same(List) :-
    list_of(_,List).

% QUESTION 3
adjacent(E1,E2,List) :-
    append(_,[E1,E2|_],List).

% QUESTION 4
adjacent2(E1,E2,[E1,E2|_]).
adjacent2(E1,E2,[_|Tail]) :-
    adjacent(E1,E2,Tail).

% QUESTION 5
before(E1,E2,[E1|List]) :-
    member(E2,List).
before(E1,E2,[_|List]) :-
    before(E1,E2,List).

