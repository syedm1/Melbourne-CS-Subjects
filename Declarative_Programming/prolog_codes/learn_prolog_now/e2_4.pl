%% Exercise 2.4
%% Here are six English words:
%% abalone, abandon, anagram, connect, elegant, enhance.
%% They are to be arranged in a crossword puzzle like fashion in the grid given
%% below.
%%     V1V2V3
%%     _ _ _
%% H1 _______
%%     _ _ _
%% H2 _______
%%     _ _ _
%% H3 _______
%%     _ _ _

word(astante,  a,s,t,a,n,t,e). 
word(astoria,  a,s,t,o,r,i,a). 
word(baratto,  b,a,r,a,t,t,o). 
word(cobalto,  c,o,b,a,l,t,o). 
word(pistola,  p,i,s,t,o,l,a). 
word(statale,  s,t,a,t,a,l,e).

grid(A,B,C,D,E,F) :-
    word(A,_,A2,_,A4,_,A6,_),
    word(B,_,B2,_,B4,_,B6,_),
    word(C,_,C2,_,C4,_,C6,_),
    word(D,_,A2,_,B2,_,C2,_),
    word(E,_,A4,_,B4,_,C4,_),
    word(F,_,A6,_,B6,_,C6,_).
    
