trans(T,L) :- trans(T,[],L).
trans(empty,L,L).
trans(node(L,N,R),List,X) :-
    trans(R,List,[N|X1]),
    trans(L,X1,X).
