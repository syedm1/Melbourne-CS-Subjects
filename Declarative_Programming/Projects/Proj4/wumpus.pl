:- module(wumpus,[initialState/5, guess/3, updateState/4]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initial state
% State0 [  
%           Map size and Current POS and direction, 
%           Not Visited Pos
%           Empty Pos
%           Pit Pos
%           Wall Pos
%           Wumpus
%        ]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test: initialState(5,6,1,1,State0).
initialState(NR,NC,XS,YS,State0) :-
    all_pos(NR-NC,NC-NR,All_pos),
    N is NR+NC,
    impossible_pos(NR-NC,N,Imposs_pos),
    subtract(All_pos,[XS-YS-north|Imposs_pos],All_pos1),
    State0 = [NR-NC-XS-YS-north,All_pos1,[],[],[],[]],
    write(State0),nl.

% init: generate all positions
% Test: all_pos(5-6,6-5,Pos).
all_pos(R-_,0-R,[]).
all_pos(R-C,X-0,Pos) :-
    X > 0, X1 is X-1,
    all_pos(R-C,X1-R,Pos).
all_pos(R-C,X-Y,[X-Y-north,X-Y-west,X-Y-east,X-Y-south|Pos]) :-
    Y > 0, Y1 is Y-1,
    all_pos(R-C,X-Y1,Pos).

% init: generate all positions
% Test: impossible_pos(5-6,11,Pos).
impossible_pos(_-_,0,[]).
impossible_pos(R-C,N,[C-N-west,1-N-east,N-1-south,N-R-north|Pos]) :-
    N>0, N1 is N-1,
    impossible_pos(R-C,N1,Pos).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find a Route with least distance and the end point
% has not been explored before.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% find the nearest(route) not visited point and generate route
% nearest_point(+,+,+,-,-)
% Test: nearest_point(5-6,1-1-north,[3-4-north],[],End,Route).
nearest_point(R-C,X-Y-D1,Unknown,Empty,U-V-D2,Route) :-
    all_point_dis(R-C,X-Y-D1,Unknown,Empty,Solutions),
    min_member(_-U-V-D2-Route1,Solutions),
    reverse(Route1,Route).

% compute distance and route for all points
% Test: all_point_dis(5-6,1-1-north,[3-4-north,4-4-north,4-5-north,1-2-south],[],Solutions).
all_point_dis(_-_,_-_-_,[],_,[]).
all_point_dis(R-C,X-Y-D1,[U-V-D2|Unknown],Empty,Solution) :-
    nearest_route(R-C,X-Y-D1,U-V-D2,Empty,Dis,Route),
    Solution = [Dis-U-V-D2-Route|Solution1],
    all_point_dis(R-C,X-Y-D1,Unknown,Empty,Solution1).
all_point_dis(R-C,X-Y-D1,[U-V-D2|Unknown],Empty,Solution) :-
    \+ nearest_route(R-C,X-Y-D1,U-V-D2,Empty,_,_),
    all_point_dis(R-C,X-Y-D1,Unknown,Empty,Solution).

% find nearest route of two positions
% Test: nearest_route(5-6,1-1-north,4-5-south,[],Distance,Route).
nearest_route(R-C,X-Y-D1,U-V-D2,Empty,Dis,Route) :-
    route(R-C,1,[X-Y-D1],Empty,Route),
    Route = [U-V-D2|_],
    length(Route,Dis1),
    Dis is Dis1-1.

% all possible end point, all routes. (n steps)
% add pit and wall checking in thie part !!!!
% Test: route(5-6,1,[1-1-north],Route).
route(R-C,Dis,_,_,[]) :-
    Dis =:= R+C.
route(R-C,Dis,Visited,Empty,Route) :-
    Dis =\= R+C,
    dis_route(R-C,Dis,Visited,Empty,Route).
route(R-C,Dis,Visited,Empty,Route) :-
    Dis =\= R+C,
    Dis1 is Dis+1,
    route(R-C,Dis1,Visited,Empty,Route).

% route with one position transient at most once
% Test: dis_route(5-6,14,[1-1-west],[],Route).
dis_route(_,0,Route,_,Route).
dis_route(R-C,1,Visited,Empty,Route) :-
    Visited = [X-Y-D1|_],
    move(R-C,X-Y-D1,U-V-D2),
    \+ memberchk(U-V-D2,Visited),
    \+ memberchk(U-V-D2,Empty),
    dis_route(R-C,0,[U-V-D2|Visited],Empty,Route).
dis_route(R-C,Dis,Visited,Empty,Route) :-
    Dis > 1,
    Visited = [X-Y-D1|_],
    move(R-C,X-Y-D1,U-V-D2),
    \+ memberchk(U-V-D2,Visited),
    memberchk(U-V-D2,Empty),
    Dis1 is Dis-1,
    dis_route(R-C,Dis1,[U-V-D2|Visited],Empty,Route).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% move within the map
move(R-C,X-Y-_,U-V-D) :-
    move_dist(A,B,D),
    U is X+A, U>0, U=<C,
    V is Y+B, V>0, V=<R.

% all directions
move_dist(0,1,south).
move_dist(1,0,east).
move_dist(0,-1,north).
move_dist(-1,0,west).

% transform from positions to directions
route_to_dir([],[]).
route_to_dir([_-_-D|Route],[D|Droute]) :-
    route_to_dir(Route,Droute).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Next guess, get informations from State. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test: guess([5-6-1-1-north,[6-5-east,6-5-south,6-4-north,6-4-east,6-4-south,6-3-north,6-3-east,6-3-south,6-2-north,6-2-east,6-2-south,6-1-north,6-1-east,5-5-west,5-5-east,5-5-south,5-4-north,5-4-west,5-4-east,5-4-south,5-3-north,5-3-west,5-3-east,5-3-south,5-2-north,5-2-west,5-2-east,5-2-south,5-1-north,5-1-west,5-1-east,4-5-west,4-5-east,4-5-south,4-4-north,4-4-west,4-4-east,4-4-south,4-3-north,4-3-west,4-3-east,4-3-south,4-2-north,4-2-west,4-2-east,4-2-south,4-1-north,4-1-west,4-1-east,3-5-west,3-5-east,3-5-south,3-4-north,3-4-west,3-4-east,3-4-south,3-3-north,3-3-west,3-3-east,3-3-south,3-2-north,3-2-west,3-2-east,3-2-south,3-1-north,3-1-west,3-1-east,2-5-west,2-5-east,2-5-south,2-4-north,2-4-west,2-4-east,2-4-south,2-3-north,2-3-west,2-3-east,2-3-south,2-2-north,2-2-west,2-2-east,2-2-south,2-1-north,2-1-west,2-1-east,1-5-west,1-5-south,1-4-north,1-4-west,1-4-south,1-3-north,1-3-west,1-3-south,1-2-north,1-2-west,1-2-south,1-1-west],[],[],[],[]],State,Guess).
guess(State0, State, Guess) :-
    State0 = [R-C-X-Y-_,Unknown,Empty,Pit,Wall,Wumpus],
    State = State0,
    guess_route(State0,100,Route,Wumpus),
    add_shoot(Route,Guess).
    % write(Guess),nl.

% Generate guess route
% terminate while use out energy or konwn all positions
% Test: guess_route([5-6-1-1,[1-2,1-3,1-4,1-5,2-1,2-2,2-3,2-4,5-5,4-5],[],[],[]],30,Guess).
guess_route(_,Energy,_,[]) :- Energy =< 0.
guess_route([_,[],_,_,_,_],_,_,[]).
guess_route([R-C-X-Y-D1,Unknown,Empty,Pit,Wall,Wumpus],Energy,Guess,[]) :-
    Energy > 0,
    nearest_point(R-C,X-Y-D1,Unknown,Empty,U-V-D2,Route),
    subtract(Route,[X-Y-D1],Route1),
    write(Route),nl,
    write(Empty),nl,
    route_to_dir(Route1,Droute),
    length(Droute,Dis),
    Energy1 is Energy - Dis,
    subtract(Unknown,[U-V],Unknown1),
    append(Droute,Guess1,Guess),
    guess_route([R-C-U-V-D2,Unknown1,[U-V-D2|Empty],Pit,Wall,Wumpus],Energy1,Guess1,[]).

add_shoot([],[]).
add_shoot([_],[]).
add_shoot([Dir1,Dir2|Route],[Shoot,Dir1,Dir2|Guess]) :-
    Shoot = shoot,
    add_shoot(Route,Guess).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Test: updateState([],[east,west,shoot],[wall,wall,miss],State).
updateState(State0, Guess, Feedback, State) :-
    write(Feedback),nl,
    State = State0.
% pit
updateState(State0, Guess, [pit], State) :-
    State = State0.
% wall
updateState(State0, Guess, [wall], State) :-
    State = State0.
% wumpus
updateState(State0, Guess, [wumpus], State) :-
    State = State0.
% stench
updateState(State0, Guess, [stench], State) :-
    State = State0.
% smell
updateState(State0, Guess, [smell], State) :-
    State = State0.
% damp
updateState(State0, Guess, [damp], State) :-
    State = State0.
% empty
updateState(State0, Guess, [empty], State) :-
    State = State0.
% hit
updateState(State0, Guess, [hit], State) :-
    State = State0.
% miss
updateState(State0, Guess, [miss], State) :-
    State = State0.
