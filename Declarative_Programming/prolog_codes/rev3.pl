rev1([], []). 
rev1([A|B], CA) :-
rev1(B, C), append(C, [A], CA).

rev3(ABC,CBA) :-
    samelength(ABC,CBA),
    rev1(ABC,CBA).

samelength([], []).
samelength([_|Xs], [_|Ys]) :-
    samelength(Xs, Ys).
