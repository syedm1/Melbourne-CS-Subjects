:- module(wumpus,[initialState/5, guess/3, updateState/4]).

initialState(+NR, +NC, +XS, +YS, -State0) :-
    a is 1.

guess(+State0, -State, -Guess) :-
    Guess = "shoot".

updateState(+State0, +Guess, +Feedback, -State) :-
    a is 2.
