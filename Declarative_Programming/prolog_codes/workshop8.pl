% Q1
sumlist(Ns,Sum) :- sumlist2(Ns,0,Sum).
sumlist2([],Sum,Sum).
sumlist2([X|Xs],Sum0,Sum) :- 
    Sum1 is Sum0 + X,
    sumlist2(Xs,Sum1,Sum).

% Q2
tree(empty).
tree(node(Left,_,Right)) :-
    tree(Left),
    tree(Right).

tree_list(Tree, List) :-
    tree_list(Tree, List, []).

tree_list(empty, List, List).
tree_list(node(L,E,R), List, List0) :-
    tree_list(R,List1,List0),
    tree_list(L,List,[E|List1]).


