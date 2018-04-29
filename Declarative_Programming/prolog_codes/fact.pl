fact(N,F) :- 
    fact(N,1,F).
fact(N,A,F) :-
    ( N =:= 0 ->
        F = A
    ;   N > 0,
        N1 is N-1,
        A1 is A * N,
        fact(N1,A1,F)
    ).
