replace(E1, [E1|L], E2, [E2|L]).
replace(E1, [E|L1], E2, [E|L2]) :-
    replace(E1, L1, E2, L2).

zip([],[],[]).
zip([A|As], [B|Bs], [A-B|ABs]) :-
    zip(As,Bs,ABs).

sublist([],_).
sublist([X|Xs], Ys) :-
    append(_,[X|Ysl],Ys),
    sublist(Xs,Ysl).
