:- module(wumpus,[initialState/5, guess/3, updateState/4]).

initialState(_,_,_,_,_).

guess(State, State, Guess) :-
	generate(16,Guess1),
	shoot(Guess1,Guess).

generate(0,[]).
generate(N,[X|G]) :-
	N > 0,
	random_select(X,[east,west,north,south],_),
	N1 is N-1,
	generate(N1,G).

shoot([],[]).
shoot([A|G],[A,shoot|G1]):-
    shoot(G,G1).

updateState(State,_,_,State).
