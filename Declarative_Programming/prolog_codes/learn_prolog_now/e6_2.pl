palin(A) :- palin(A,A,[]).

palin(A,[],A).
palin(A,[H|T],B) :- palin(A,T,[H|B]).
