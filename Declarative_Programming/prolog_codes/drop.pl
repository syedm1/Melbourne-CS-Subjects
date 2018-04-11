drop(N,List,Back) :-
    length(Front,N),
    append(Front, Back, List).
