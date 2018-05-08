% 4.01 Write a predicate istree/1 which succeeds if and only if its argument
%      is a Prolog term representing a binary tree.
%
% istree(T) :- T is a term representing a binary tree (i), (o)

istree(nil).
istree(t(_,L,R)) :-
    istree(L),
    istree(R).


% 4.02 (**) Construct completely balanced binary trees for a given 
% number of nodes.

% cbal_tree(N,T) :- T is a completely balanced binary tree with N nodes.
% (integer, tree)  (+,?)

cbal_tree(0,nil).
cbal_tree(X,t(x,T1,T2)) :- 
    X > 0,
    XX = X-1,
    X1 is XX//2,
    X2 is XX-X1,
    distrib(X1,X2,N1,N2),
    cbal_tree(N1,T1),
    cbal_tree(N2,T2).
% use this function generate all possible solutions.
distrib(N,N,N,N) :- !.
distrib(X1,X2,X2,X1).
distrib(X1,X2,X1,X2).


% 4.04 (**) Binary search trees (dictionaries)

% Use the predicate add/3, developed in chapter 4 of the course,
% to write a predicate to construct a binary search tree 
% from a list of integer numbers. Then use this predicate to test 
% the solution of the problem P56

construct([],nil).
construct([X|Xs],T) :-
    construct(Xs,T1),
    add(X,T1,T).

add(X,nil,t(X,nil,nil)).
add(X,t(Y,L,R),t(Y,L1,R)) :- X @< Y, add(X,L,L1).
add(X,t(Y,L,R),t(Y,L,R1)) :- X @> Y, add(X,R,R1).


% 4.06 (**) Construct height-balanced binary trees
% In a height-balanced binary tree, the following property holds for
% every node: The height of its left subtree and the height of  
% its right subtree are almost equal, which means their
% difference is not greater than one.
% Write a predicate hbal_tree/2 to construct height-balanced
% binary trees for a given height. The predicate should
% generate all solutions via backtracking. Put the letter 'x'
% as information into all nodes of the tree.

% hbal_tree(D,T) :- T is a height-balanced binary tree with depth T

hbal_tree(0,nil).
hbal_tree(N,t(x,T1,T2)) :-
    N > 0,
    N1 is N-1,
    distrib2(N1,N2,N3),
    hbal_tree(N2,T1),
    hbal_tree(N3,T2).
distrib2(N1,N1,N1).
distrib2(N1,N1,N2) :- N2 is N1-1.
distrib2(N1,N2,N1) :- N2 is N1-1.



% 4.13 (**) Layout a binary tree (1)
%
% Given a binary tree as the usual Prolog term t(X,L,R) (or nil).
% As a preparation for drawing the tree, a layout algorithm is
% required to determine the position of each node in a rectangular
% grid. Several layout methods are conceivable, one of them is
% the following:
%
% The position of a node v is obtained by the following two rules:
%   x(v) is equal to the position of the node v in the inorder sequence
%   y(v) is equal to the depth of the node v in the tree
%
% In order to store the position of the nodes, we extend the Prolog 
% term representing a node (and its successors) as follows:
%    nil represents the empty tree (as usual)
%    t(W,X,Y,L,R) represents a (non-empty) binary tree with root
%        W positionned at (X,Y), and subtrees L and R
%
% Write a predicate layout_binary_tree/2:

% layout_binary_tree(T,PT) :- PT is the "positionned" binary
%    tree obtained from the binary tree T. (+,?) or (?,+)

:- ensure_loaded(p4_04). % for test

layout_binary_tree(T,PT) :- layout_binary_tree(T,PT,1,_,1).

% layout_binary_tree(T,PT,In,Out,D) :- T and PT as in layout_binary_tree/2;
%    In is the position in the inorder sequence where the tree T (or PT)
%    begins, Out is the position after the last node of T (or PT) in the 
%    inorder sequence. D is the depth of the root of T (or PT). 
%    (+,?,+,?,+) or (?,+,+,?,+)
 
layout_binary_tree(nil,nil,I,I,_).
layout_binary_tree(t(W,L,R),t(W,X,Y,PL,PR),Iin,Iout,Y) :- 
   Y1 is Y + 1,
   layout_binary_tree(L,PL,Iin,X,Y1), 
   X1 is X + 1,
   layout_binary_tree(R,PR,X1,Iout,Y1).

% Test (see example given in the problem description):
% ?-  construct([n,k,m,c,a,h,g,e,u,p,s,q],T),layout_binary_tree(T,PT).









