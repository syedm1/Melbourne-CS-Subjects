
same_elements(L1,L2) :-
    sort(L1,L11),
    sort(L2,L22),
    same(L11,L22).
same([],[]).
same([L|L1],[L|L2]) :-
    same(L1,L2).


containers(Steps) :-
    containers(3,5,0,0,_,4,[0-0],Steps).

containers(_,_,V1,V2,V1,V2,_,[]).
containers(C1,C2,V1,V2,T1,T2,His,[Move|Steps]):-
    move(C1,C2,V1,V2,M1,M2,Move),
    State = M1-M2,
    \+ memberchk(State,His),
    containers(C1,C2,M1,M2,T1,T2,[State|His],Steps).

move(C1,_,_,T2,C1,T2,fill(C1)).
move(_,C2,T1,_,T1,C2,fill(C2)).
move(C1,_,_,T2,0,T2,empty(C1)).
move(_,C2,T1,_,T1,0,empty(C2)).

move(C1, C2, V1, V2, N1, N2, pour(C1,C2)) :-
    pour(C2, V1, V2, N1, N2).
move(C1, C2, V1, V2, N1, N2, pour(C2,C1)) :-
    pour(C1, V2, V1, N2, N1).

pour(C2, V1, V2, N1, N2) :-
    (   V1 + V2 > C2 ->
            N1 is V1 - (C2 - V2),
            N2 is C2
    ;   N1 = 0,
        N2 is V1 + V2
    ). 
