flatten(L,F) :- flatten(L,[],F).
flatten([],F,F).
flatten(X,L,[X|L]) :-
    X \= [], X \= [_|_].
flatten([H|T],AccL,F) :-
    flatten(T,AccL,L),
    flatten(H,L,F).
