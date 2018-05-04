% 1.01 (*) Find the last element of a list.
% Example:
% ?- my_last(X,[a,b,c,d]).
% X = d

my_last(A,[A]).
my_last(A,[_|Tail]) :-
    my_last(A,Tail).


% 1.02 (*) Find the last but one element of a list.

last_but_one(B,[B,_]).
last_but_one(B,[_|Tail]) :-
    last_but_one(B,Tail).


% 1.03 (*): Find the K'th element of a list.
% The first element in the list is number 1.
% Note: nth1(?Index, ?List, ?Elem) is predefined

%%%%%%%%%%%% my answer, K must stantiated 
k_th_elem(1,[E|_],E).
k_th_elem(K,[_|Tail],E) :-
    K > 1,
    K1 is K - 1,
    k_th_elem(K1,Tail,E).

element_at(X,[X|_],1).
element_at(X,[_|L],K) :- 
    K > 1, 
    K1 is K - 1, 
    element_at(X,L,K1).


% 1.04 (*): Find the number of elements of a list.

% my_length(L,N) :- the list L contains N elements
%    (list,integer) (+,?) 

% Note: length(?List, ?Int) is predefined

my_length([],0).
my_length([_|Tail],N) :-
    my_length(Tail, N1),
    N is N1 + 1.


% 1.05 (*): Reverse a list.

% my_reverse(L1,L2) :- L2 is the list obtained from L1 by reversing 
%    the order of the elements.
%    (list,list) (?,?)

% Note: reverse(+List1, -List2) is predefined

my_reverse(AB,BA) :- my_rev(AB,[],BA).
my_rev([],A,A).
my_rev([A|B],C,D) :-
    my_rev(B,[A|C],D).


% 1.06 (*): Find out whether a list is a palindrome
% A palindrome can be read forward or backward; e.g. [x,a,m,a,x]

% is_palindrome(L) :- L is a palindrome list
%    (list) (?)

is_palindrome(L) :-
    reverse(L,L).


% 1.07 (**): Flatten a nested list structure.

% my_flatten(L1,L2) :- the list L2 is obtained from the list L1 by
%    flattening; i.e. if an element of L1 is a list then it is replaced
%    by its elements, recursively. 
%    (list,list) (+,?)

% Note: flatten(+List1, -List2) is a predefined predicate

my_flatten(X,[X]) :-
    \+ is_list(X).
my_flatten([],[]).
my_flatten([X|Xs],Z) :-
    my_flatten(X,Y),
    my_flatten(Xs,Ys),
    append(Y,Ys,Z).


% 1.08 (**): Eliminate consecutive duplicates of list elements.

% compress(L1,L2) :- the list L2 is obtained from the list L1 by
%    compressing repeated occurrences of elements into a single copy
%    of the element.
%    (list,list) (+,?)

compress([],[]).
compress([E],[E]).
compress([E,E|L1],L2) :-
    compress([E|L1],L2).
compress([E1,E2|L1],[E1|L2]) :-
    E1 \= E2,
    compress([E2|L1],L2).


% 1.09 (**):  Pack consecutive duplicates of list elements into sublists.

% pack(L1,L2) :- the list L2 is obtained from the list L1 by packing
%    repeated occurrences of elements into separate sublists.
%    (list,list) (+,?)

pack([],[]).
pack([X|Xs],[Z|Zs]) :- transfer(X,Xs,Ys,Z), pack(Ys,Zs).

transfer(X,[],[],[X]).
transfer(X,[Y|Ys],[Y|Ys],[X]) :- X \= Y.
transfer(X,[X|Xs],Ys,[X|Zs]) :- transfer(X,Xs,Ys,Zs).


% 1.10 (*):  Run-length encoding of a list

% encode(L1,L2) :- the list L2 is obtained from the list L1 by run-length
%    encoding. Consecutive duplicates of elements are encoded as terms [N,E],
%    where N is the number of duplicates of the element E.
%    (list,list) (+,?)

encode(L1,L2) :- pack(L1,L3), transform(L3,L2).

transform([],[]).
transform([[X|Xs]|Ys], [[N,X]|Zs]) :-
    length([X|Xs],N),
    transform(Ys,Zs).


% 1.11 (*):  Modified run-length encoding

% encode_modified(L1,L2) :- the list L2 is obtained from the list L1 by 
%    run-length encoding. Consecutive duplicates of elements are encoded 
%    as terms [N,E], where N is the number of duplicates of the element E.
%    However, if N equals 1 then the element is simply copied into the 
%    output list.
%    (list,list) (+,?)

encode_modified(L1,L2) :- encode(L1,L3), modify(L3,L2).

modify([[1,X]|Xs],[Y|Ys]) :- modify(Xs,Ys).
modify([[N,X]|Xs],[[N,X]|Ys]) :- 
    N > 1,
    modify(Xs,Ys).









