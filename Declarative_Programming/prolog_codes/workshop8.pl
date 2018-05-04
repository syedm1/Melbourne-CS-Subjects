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

tree_list(empty,[]).
tree_list(node(L,Elt,R),List) :-
    tree_list(L,List1),
    tree_list(R,List2).
    append(List1,[Elt|List2],List)
    
