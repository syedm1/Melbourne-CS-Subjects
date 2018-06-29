intset(N,Set0,Set) :-
    ( Set0 = empty -> 
        Set = tree(empty,N,empty)
    ; Set0 = tree(L,V,R),
        ( N > V -> 
            intset(N,R,R1),
            Set = (L,V,R1)
        ; N < V -> 
            intset(N,L,L1),
            Set = (L1,V,R)
        ; Set = Set0
        )
    ).
