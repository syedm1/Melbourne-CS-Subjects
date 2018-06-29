nnodes(t(_,[]),1).
nnodes(t(X,[Y|Ys]),N) :-
    nnodes(Y,N1),
    nnodes(t(X,Ys),N2),
    N is N1+N2.
