replace(E1, L1, E2, L2) :-
    append(LL,[E1|LR],L1),
    append(LL,[E2|LR],L2).

zip([],[],[]).
zip([A|As], [B|Bs], [A-B|ABs]) :-
    zip(As,Bs,ABs).

sublist([],_).
sublist([X|Xs], Ys) :-
    append(_,[X|Ysl],Ys),
    sublist(Xs,Ysl).
    
    
