% 7.01 (**) Eight queens problem

% This is a classical problem in computer science. The objective is to
% place eight queens on a chessboard so that no two queens are attacking 
% each other; i.e., no two queens are in the same row, the same column, 
% or on the same diagonal. We generalize this original problem by 
% allowing for an arbitrary dimension N of the chessboard. 

queens(List) :-
    premu([1,2,3,4,5,6,7,8],List),
    zip(List,[1,2,3,4,5,6,7,8],X),
    queens1(X).

zip([],[],[]).
zip([A|Ax],[B|Bx],[A-B|Xs]) :-
    zip(Ax,Bx,Xs).

queens1([]).
queens1([X|Xs]) :- 
    queens2(X,Xs),
    queens1(Xs).

queens2(_,[]).
queens2(X,[Y|Ys]) :-
    queens3(X,Y),
    queens2(X,Ys).

queens3(X-XX,Y-YY) :-
    X + XX =\= Y + YY,
    X - XX =\= Y - YY.

premu([],[]).
premu(Xs,[Y|Ys]) :- 
    del(Y,Xs,Rs),
    premu(Rs,Ys).

del(X,[X|Xs],Xs).
del(X,[Y|Ys],[Y|Rs]) :- 
    del(X,Ys,Rs).


% 7.02 (**) Knight's tour
% Another famous problem is this one: How can a knight jump on an
% NxN chessboard in such a way that it visits every square exactly once?

knight(N,Knights) :- 
    M is N*N,
    knightt(N,M,[1/1],Knights).

knightt(N,M,K,Knights) :-
    knight(N,M,K,Knights).
knightt(N,M,K,Knights) :-
    M > 0,
    M1 is M-1,
    knightt(N,M1,K,Knights).

knight(_,0,Knights,Knights).
knight(N,M,Visited,Knights) :-
    Visited = [X/Y|_],
    jump(N,X/Y,U/V),
    \+ memberchk(U/V,Visited),
    M1 is M-1,
    knight(N,M1,[U/V|Visited],Knights).

jump(N,X/Y,U/V) :-
    jump_dist(A,B),
    U is X+A, U>0, U=<N,
    V is Y+B, V>0, V=<N.

jump_dist(1,2).
jump_dist(1,-2).
jump_dist(-1,2).
jump_dist(-1,-2).
jump_dist(2,1).
jump_dist(2,-1).
jump_dist(-2,1).
jump_dist(-2,-1).

show([]).
show([X/Y|Knights]) :-
    show(Knights),
    write(X/Y),nl.

















