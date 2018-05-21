% Author:   Haonan Li <haonanl5@student.unimelb.edu.au>
% Purpose:  

:- module(wumpus,[initialState/5, guess/3, updateState/4]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initial state
% State0 [  
%           Map size and Current POS and direction, 
%           Unknown Pos
%           Empty Pos
%           Pit Pos
%           Wall Pos
%           Shoot Pos
%           Damp
%           Wumpus
%           Smell
%           Stench
%        ]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial state, save all positions, mark start position empty.
initialState(R,C,X,Y,State0) :-
    all_pos(R-C,C-R,All_pos),
    subtract(All_pos,[X-Y],All_pos1),
    State0 = [R-C-X-Y-north,All_pos1,[X-Y],[],[],[],[],[],[],[]].

% init: generate all positions
all_pos(R-_,0-R,[]).
all_pos(R-C,X-0,Pos) :-
    X > 0, X1 is X-1,
    all_pos(R-C,X1-R,Pos).
all_pos(R-C,X-Y,[X-Y|Pos]) :-
    Y > 0, Y1 is Y-1,
    all_pos(R-C,X-Y1,Pos).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find a Route with least distance and the end point
% has not been explored before.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% find the nearest(route) not visited point and generate route
explore_route(State,State1,Route) :-
    % write('explore_route'),nl,
    State = [R-C-X-Y-D,Unknown,Empty,_,_,_,_,_,_,_],
    reach_able(R-C,Unknown,Empty),
    length(Empty,Dis),
    explore_dis_route(Dis,State,State1,[X-Y-D],Route1),
    reverse(Route1,[_|Route]).

% route with one position transient at most once
explore_dis_route(Dis,State,State1,Visited,Route) :-
    Dis >= 0,
    State = [R-C-_-_-_,Unknown,_,_,_,_,_,_,_,_],
    Visited = [X-Y-D1|_],
    move(R-C,X-Y-D1,U-V-D2),
    memberchk(U-V,Unknown),
    subtract(Unknown,[U-V],Unknown1),
    set_elements(State,State1,[unknown,Unknown1]),
    Route = [U-V-D2|Visited].
 
explore_dis_route(Dis,State,State1,Visited,Route) :-
    Dis > 0,
    Visited = [X-Y-D1|_],
    State = [R-C-_-_-_,_,Empty,_,_,_,_,_,_,_],
    move(R-C,X-Y-D1,U-V-D2),
    \+ memberchk(U-V-D2,Visited),
    memberchk(U-V,Empty),
    Dis1 is Dis-1,
    explore_dis_route(Dis1,State,State1,[U-V-D2|Visited],Route).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the route only contains of empty points
kill_route(State,Route) :-
    % write('kill_route'),nl,
    State = [_-_-X-Y-D1,_,Empty,_,_,Shoot,_,[_],_,_],
    shoot_pos(State,Goal),
    \+ memberchk(Goal,Shoot),
    length(Empty,Dis),
    kill_dis_route(Dis,State,Goal,[X-Y-D1],Route1),
    Route2 = [shoot|Route1],
    reverse(Route2,[_|Route]).

kill_dis_route(Dis,State,Goal,Visited,Route) :-
    Dis > 0,
    State = [R-C-_-_-_,_,Empty,_,_,_,_,_,_,_],
    Visited = [X-Y-D1|_],
    move(R-C,X-Y-D1,S-T-D2),
    (   Goal = S-T-D2 ->
            Route = [Goal|Visited]
    ;   \+ memberchk(S-T-D2,Visited),
        memberchk(S-T,Empty),
        Dis1 is Dis-1,
        kill_dis_route(Dis1,State,Goal,[S-T-D2|Visited],Route)
    ).

% find a known positions that suitable for shoot
shoot_pos(State,Goal) :-
    State = [R-C-_-_-_,Unknown,Empty,_,Wall,_,_,[U-V],_,_],
    shoot_pos(R-C,Empty,Empty,Unknown,Wall,U-V,Goal).
shoot_pos(R-C,Empty,[X-Y|_],Unknown,Wall,U-V,Goal) :-
    move(R-C,X-Y-east,M-N-D),
    check_shoot(M-N-D,U-V,Wall,Unknown),
    memberchk(M-N,Empty),
    Goal = M-N-D.
shoot_pos(R-C,Empty,[_|Candidate],Unknown,Wall,U-V,Goal) :-
    shoot_pos(R-C,Empty,Candidate,Unknown,Wall,U-V,Goal).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% no reachable pos, can't find wumpus
attempt_kill_route(State,State1,Route) :-
    % write('attempt_kill_route'),nl,
    State = [R-C-_-_-_,Unknown,Empty,Pit,_,_,_,[],_,_],
    unknown_shootable_pos(R-C,Pit,Empty,Unknown,Shootable),
    % here only consider one possible pit, not all, for all, kill_route should add update state.
    Shootable = [U-V|_],
    set_elements(State,State1,[wumpus,[U-V]]),
    kill_route(State1,Route).

% find all unknown positions that can be shoot through a pit
unknown_shootable_pos(_,[],_,_,[]).
unknown_shootable_pos(R-C,[X-Y|Pit],Empty,Unknown,Shootable) :-
    move(R-C,X-Y-D,U-V-D),
    (   memberchk(U-V,Unknown) ->
            rev_dir(D,D1),
            (   move(R-C,X-Y-D1,M-N-D1) ->
                memberchk(M-N,Empty),
                Shootable = [U-V|Shootable1],
                unknown_shootable_pos(R-C,Pit,Empty,Unknown,Shootable1)
            ;   unknown_shootable_pos(R-C,Pit,Empty,Unknown,Shootable)
            )
    ;   unknown_shootable_pos(R-C,Pit,Empty,Unknown,Shootable)
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% guess: first find a exact route to kill wumpus, if can't find such route,
%        explore the map, try to arrive unknown positions, add shoot one the 
%        route of explore.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
guess(State0, State, Guess) :-
    write('guess '),nl,
    % write(State0),nl,
    State = State0,
    (   kill_route(State0,Route) -> 
        route_to_dir(Route,Guess)
    ;   guess_route(State0,100,Route),
        (   \+ Route = [] -> 
                add_shoot(Route,Route1,State),
                route_to_dir(Route1,Route2),
                limit_energy(Route2,100,Guess)
        ;   attempt_kill_route(State0,_,Route),
            route_to_dir(Route,Guess)
        )
    ),
    % write(Guess),nl,
    write('done!'),nl.

% shoot 策略，并不是每次shoot都是一行，要考虑石头遮挡
% 已经shoot了的，要记录确定被覆盖的地方, 目前shoot存储X-Y-D格式，要专程X-Y才行
guess_route(_,Energy,[]) :- 
    Energy =< 0.
guess_route(State,_,_) :-
    \+ explore_route(State,_,_),
    \+ kill_route(State,_).
guess_route(State,Energy,Guess) :-
    Energy > 0,
    (   explore_route(State,State1,Route1) ->
            length(Route1,Dis),
            Energy1 is Energy - Dis
    ;   kill_route(State,Route1) ->
        State1 = State,
        Energy1 = 0
    ),
    append(Route1,Guess1,Guess),
    guess_route(State1,Energy1,Guess1).


% add shoot on the route
add_shoot(Route,Route1,State) :-
    (   State = [_,_,_,_,_,_,_,[],_,_] ->
            add_shoot_random(Route,Route1,State)
    ;   add_shoot_wumpus(Route,Route1,State)
    ).

% add shoot if do not find wumpus
add_shoot_random([],[],_).
add_shoot_random([X-Y-D|Route],Droute,State) :-
    State = [R-C-_-_-_,_,_,_,_,Shoot,_,_,_,_],
    way_to_edge(R-C,X-Y-D,Points),
    \+ subtract(Points,Shoot,[]),
    shoot_range(R-C,X-Y-D,Shoot,Shoot1),
    Droute = [X-Y-D,shoot|Droute1],
    set_elements(State,State1,[shoot,Shoot1]),
    add_shoot_random(Route,Droute1,State1).
add_shoot_random([X-Y-D|Route],[X-Y-D|Droute],State) :-
    State = [_,_,_,_,_,Shoot,_,_,_,_],
    memberchk(X-Y,Shoot),
    add_shoot_random(Route,Droute,State).
    
% add shoot if do know where is wumpus
add_shoot_wumpus([],[],_).
add_shoot_wumpus([Rou|Route],Droute,State) :-
    State = [_,_,_,_,Wall,_,_,[U-V],_,_],
    (   Rou = X-Y-D ->
        (   check_shoot(X-Y-D,U-V,Wall,[]) ->
                Droute = [X-Y-D,shoot|Droute1]
        ;   Droute = [X-Y-D|Droute1]
        )
    ;   Droute = Droute1
    ),
    add_shoot_wumpus(Route,Droute1,State).

% add shoot range to the shooted set
% Test: shoot_range(5,6,1-1-south,[],Shoot).
shoot_range(R-C,X-Y-D,Shoot,Shoot1) :-
    way_to_edge(R-C,X-Y-D,Points),
    append(Points,Shoot,Shoot1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Limit the energy to 100.
limit_energy(_,0,[]).
limit_energy([],_,[]).
limit_energy([shoot|_],Energy,[]) :-
    Energy < 5.
limit_energy([X|Route],Energy,[X|Guess]) :-
    X \= shoot,
    Energy > 0,
    Energy1 is Energy-1,
    limit_energy(Route,Energy1,Guess).
limit_energy([shoot|Route],Energy,[shoot|Guess]) :-
    Energy >= 5,
    Energy1 is Energy-5,
    limit_energy(Route,Energy1,Guess).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%updateState: first add all new explored positions to its corresponding sets,
%             then infer the pits and wumpus positions and delete duplicate
%             positions in one set.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
updateState(State0, Guess, Feedback, State) :-
    write('updateState '),nl,
    % write(State0),nl,
    % write(Guess),nl,
    % write(Feedback),nl,
    State0 = [Info,_,_,_,_,_,_,_,_,_],
    update_all(Info,Guess,Feedback,State0,State0,State1),
    delete_dupli(State1,State2),
    infer_pit(State2,State3),
    infer_wumpus(State3,State),
    write('done!'),nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% delete duplicated in each set
delete_dupli(State,State1) :-
    State = [Info,Unknown,Empty,Pit,Wall,Shoot,Damp,Wumpus,Smell,Stench],
    list_to_set(Empty,Empty1),
    list_to_set(Pit,Pit1),
    list_to_set(Wall,Wall1),
    list_to_set(Shoot,Shoot1),
    list_to_set(Damp,Damp1),
    list_to_set(Wumpus,Wumpus1),
    list_to_set(Smell,Smell1),
    list_to_set(Stench,Stench1),
    State1 = [Info,Unknown,Empty1,Pit1,Wall1,Shoot1,Damp1,Wumpus1,Smell1,Stench1].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% infer pit
infer_pit(State,State1) :-
    State = [_,_,_,_,_,_,Damp,_,_,_],
    infer_pit(Damp,State,State1).

infer_pit([],State,State).
infer_pit([X-Y|Remain],State,State1) :-
    State = [_,Unknown,_,Pit,_,_,_,_,_,_],
    stench_around(X-Y,Nearby),
    intersection(Nearby,Pit,[]),
    intersection(Nearby,Unknown,[U-V]),
    subtract(Unknown,[U-V],Unknown1),
    append(Pit,[U-V],Pit1),
    Attrs = [unknown,Unknown1,pit,Pit1],
    set_elements(State,State2,Attrs),
    infer_pit(Remain,State2,State1).

infer_pit([X-Y|Remain],State,State1) :-
    State = [_,Unknown,_,Pit,_,_,_,_,_,_],
    stench_around(X-Y,Nearby),
    (   intersection(Nearby,Pit,[]) ->
            \+ intersection(Nearby,Unknown,[_]),
            infer_pit(Remain,State,State1)
    ;   infer_pit(Remain,State,State1)
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% infer wumpus position
% infer_wumpus([7-8-2-4-north,[8-5,8-4,8-3,8-2,8-1,7-6,7-5,7-4,7-2,7-1,5-6,5-5,4-6,4-5,4-4,4-3,4-2,4-1,3-6,3-3,3-2,3-1,2-2,2-1,1-2,1-1],[2-4,2-5,3-5,2-3,1-3,1-4,1-5,1-6,1-7,2-7,3-7,4-7,2-6,5-7,6-7,7-7,8-7,8-6,6-6,6-5,6-4,6-3,6-2,7-3,5-3,5-2,5-1,6-1],[3-4],[5-4],[2-5-south,3-5-east,2-3-north,1-3-west,1-4-south,1-6-west,2-7-east,2-7-south,3-7-east,3-7-south,5-7-west,4-7-south,5-7-east,8-6-north,6-6-north,6-1-east],[],[],[2-5,3-5,2-3,1-4,4-7,6-5,6-4,6-3,5-3,5-2],[]],S).
infer_wumpus(State,State) :-
    State = [_,_,_,_,_,_,_,[_],_,_].
infer_wumpus(State,State1) :-
    State = [_,Unknown,_,_,_,_,_,[],Smell,Stench],
    smell_infer(Smell,Infer),
    stench_infer(Stench,Infer1),
    merge_infer(Infer,Infer1,Infer2),
    intersection(Infer2,Unknown,Wumpus1),
    (   \+ Wumpus1 = [_-_] ->
            State1 = State
    ;   subtract(Unknown,Wumpus1,Unknown1),
        Attrs = [unknown,Unknown1,wumpus,Wumpus1],
        set_elements(State,State1,Attrs)
    ).

% merge infered wumpus
merge_infer(A,[],A).
merge_infer([],B,B).
merge_infer(A,B,C) :-
    \+ A = [],
    \+ B = [],
    intersection(A,B,C).

% infer wumpus base on stench
stench_infer([],[]).
stench_infer([S],Range) :-
    stench_around(S,Range).
stench_infer([S,S1|Stench],Range) :-
    stench_around(S,Range1),
    stench_infer([S1|Stench],Range2),
    intersection(Range1,Range2,Range).

stench_around(X-Y,Range) :-
    X1 is X-1, X3 is X+1,
    Y1 is Y-1, Y3 is Y+1,
    Range = [X1-Y,X-Y1,X-Y3,X3-Y].
    
% infer wumpus base on smell
smell_infer([],[]).
smell_infer([S],Range) :-
    smell_around(S,Range).
smell_infer([S,S1|Smell],Range) :-
    smell_around(S,Range1),
    smell_infer([S1|Smell],Range2),
    intersection(Range1,Range2,Range).

smell_around(X-Y,Range) :-
    X0 is X-3, X1 is X-2, X2 is X-1, X4 is X+1, X5 is X+2, X6 is X+3,
    Y0 is Y-3, Y1 is Y-2, Y2 is Y-1, Y4 is Y+1, Y5 is Y+2, Y6 is Y+3,
    Range = [X0-Y,X1-Y2,X1-Y,X1-Y4,X2-Y1,X2-Y2,X2-Y,X2-Y4,X2-Y5,X-Y0,X-Y1,X-Y2,
            X-Y4,X-Y5,X-Y6,X4-Y1,X4-Y2,X4-Y,X4-Y4,X4-Y5,X5-Y2,X5-Y,X5-Y4,X6-Y].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Traverse feedback
update_all(_,_,[],_,State,State).
update_all(R-C-X-Y-D1,[Gue|Guess],[Fee|Feedback],State0,State1,State) :-
    update_one(R-C-X-Y-D1,Gue,Fee,U-V-D2,State1,State2),
    update_all(R-C-U-V-D2,Guess,Feedback,State0,State2,State).

% wumpus
update_one(R-C-X-Y-D1,Gue,wumpus,U-V-Gue,State0,State) :-
    move(R-C,X-Y-D1,U-V-Gue),
    State0 = [_,Unknown,_,_,_,_,_,Wumpus,_,_],
    subtract(Unknown,[U-V],Unknown1),
    append(Wumpus,[U-V],Wumpus1),
    Attrs = [unknown,Unknown1,wumpus,Wumpus1],
    set_elements(State0,State,Attrs).
% empty
update_one(R-C-X-Y-D1,Gue,empty,U-V-Gue,State0,State) :-
    move(R-C,X-Y-D1,U-V-Gue),
    State0 = [_,Unknown,Empty,_,_,_,_,_,_,_],
    subtract(Unknown,[U-V],Unknown1),
    append(Empty,[U-V],Empty1),
    Attrs = [unknown,Unknown1,empty,Empty1],
    set_elements(State0,State,Attrs).
% miss
update_one(_-_-X-Y-D1,shoot,miss,X-Y-D1,State0,State) :-
    State0 = [_,_,_,_,_,Shoot,_,_,_,_],
    append(Shoot,[X-Y-D1],Shoot1),
    Attrs = [shoot,Shoot1],
    set_elements(State0,State,Attrs).
% wall
update_one(R-C-X-Y-D1,Gue,wall,X-Y-Gue,State0,State) :-
    move(R-C,X-Y-D1,U-V-Gue),
    State0 = [_,Unknown,_,_,Wall,_,_,_,_,_],
    subtract(Unknown,[U-V],Unknown1),
    append(Wall,[U-V],Wall1),
    Attrs = [unknown,Unknown1,wall,Wall1],
    set_elements(State0,State,Attrs).
% wall, but it is edge, don't change State    
update_one(R-C-X-Y-D1,Gue,wall,X-Y-Gue,State0,State0) :-
    \+ move(R-C,X-Y-D1,_-_-Gue).
% pit
update_one(R-C-X-Y-D1,Gue,pit,U-V-Gue,State0,State) :-
    move(R-C,X-Y-D1,U-V-Gue),
    State0 = [_,Unknown,_,Pit,_,_,_,_,_,_],
    subtract(Unknown,[U-V],Unknown1),
    append(Pit,[U-V],Pit1),
    Attrs = [unknown,Unknown1,pit,Pit1],
    set_elements(State0,State,Attrs).
% stench
update_one(R-C-X-Y-D1,Gue,stench,U-V-Gue,State0,State) :-
    move(R-C,X-Y-D1,U-V-Gue),
    State0 = [_,Unknown,Empty,_,_,_,_,_,_,Stench],
    subtract(Unknown,[U-V],Unknown1),
    append(Empty,[U-V],Empty1),
    append(Stench,[U-V],Stench1),
    Attrs = [unknown,Unknown1,empty,Empty1,stench,Stench1],
    set_elements(State0,State,Attrs).
% smell
update_one(R-C-X-Y-D1,Gue,smell,U-V-Gue,State0,State) :-
    move(R-C,X-Y-D1,U-V-Gue),
    State0 = [_,Unknown,Empty,_,_,_,_,_,Smell,_],
    subtract(Unknown,[U-V],Unknown1),
    append(Empty,[U-V],Empty1),
    append(Smell,[U-V],Smell1),
    Attrs = [unknown,Unknown1,empty,Empty1,smell,Smell1],
    set_elements(State0,State,Attrs).

% damp
update_one(R-C-X-Y-D1,Gue,damp,U-V-Gue,State0,State) :-
    move(R-C,X-Y-D1,U-V-Gue),
    State0 = [_,Unknown,Empty,_,_,_,Damp,_,_,_],
    subtract(Unknown,[U-V],Unknown1),
    append(Empty,[U-V],Empty1),
    append(Damp,[U-V],Damp1),
    Attrs = [unknown,Unknown1,empty,Empty1,damp,Damp1],
    set_elements(State0,State,Attrs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% some basic tools
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reverse direction
rev_dir(east,west).
rev_dir(west,east).
rev_dir(north,south).
rev_dir(south,north).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check if the shoot is aim to wumpus
check_shoot(X-Y-D,U-Y,Wall,Unknown) :-
    nowall(X-Y-D,U-Y,Wall,Unknown).
check_shoot(X-Y-D,X-V,Wall,Unknown) :-
    nowall(X-Y-D,X-V,Wall,Unknown).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make sure no wall on the way 
nowall(U-V-_,U-V,_,_).
nowall(X-Y-west,U-Y,Wall,Unknown) :-
    U < X,
    X1 is X-1,
    \+ memberchk(X1-Y,Wall),
    %\+ memberchk(X1-Y,Unknown),
    nowall(X1-Y-west,U-Y,Wall,Unknown).
nowall(X-Y-east,U-Y,Wall,Unknown) :-
    U > X,
    X1 is X+1,
    \+ memberchk(X1-Y,Wall),
    %\+ memberchk(X1-Y,Unknown),
    nowall(X1-Y-east,U-Y,Wall,Unknown).
nowall(X-Y-north,X-V,Wall,Unknown) :-
    V < Y,
    Y1 is Y-1,
    \+ memberchk(X-Y1,Wall),
    %\+ memberchk(X-Y1,Unknown),
    nowall(X-Y1-north,X-V,Wall,Unknown).
nowall(X-Y-south,X-V,Wall,Unknown) :-
    V > Y,
    Y1 is Y+1,
    \+ memberchk(X-Y1,Wall),
    %\+ memberchk(X-Y1,Unknown),
    nowall(X-Y1-south,X-V,Wall,Unknown).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% move within the map
move(R-C,X-Y-_,U-V-D) :-
    move_dist(A,B,D),
    U is X+A, U>0, U=<C,
    V is Y+B, V>0, V=<R.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% all directions
move_dist(0,1,south).
move_dist(1,0,east).
move_dist(0,-1,north).
move_dist(-1,0,west).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make sure there are reachable unknown point
reach_able(R-C,[X-Y|_],Empty) :-
    one_neighbor(R-C,X-Y,Neighbor),
    \+ intersection(Neighbor,Empty,[]).
reach_able(R-C,[_|Unknown],Empty) :-
    reach_able(R-C,Unknown,Empty).

% one point's neighbor
one_neighbor(R-C,X-Y,Neighbor) :-
    moveable(R-C,X-Y,_-_-west,Rea1),
    moveable(R-C,X-Y,_-_-east,Rea2),
    moveable(R-C,X-Y,_-_-north,Rea3),
    moveable(R-C,X-Y,_-_-south,Rea4),
    append([Rea1,Rea2,Rea3,Rea4],Neighbor).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check one position and move to another in one step
moveable(R-C,X-Y,U-V-D,[]) :-
    \+ move(R-C,X-Y-east,U-V-D).
moveable(R-C,X-Y,U-V-D,[U-V]) :-
    move(R-C,X-Y-east,U-V-D).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% transform from positions to directions
route_to_dir([],[]).
route_to_dir([shoot|Route],[shoot|Droute]) :-
    route_to_dir(Route,Droute).
route_to_dir([_-_-D|Route],[D|Droute]) :-
    route_to_dir(Route,Droute).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set particular elements and return a new state.
set_elements(State,State,[]).
set_elements(State,State1,[Attr,Value|Other]) :-
    index_attr(Attr,Index),
    set_element(State,State2,1,Index,11,Value),
    set_elements(State2,State1,Other).

% set one attribute use its index
set_element([],[],11,_,11,_).
set_element([A|State],[A|State1],Cur,Obj,End,Value) :-
    Cur \= Obj,
    Cur < End,
    Cur1 is Cur+1,
    set_element(State,State1,Cur1,Obj,End,Value).

set_element([_|State],[Value|State1],Cur,Obj,End,Value) :-
    Cur = Obj,
    Cur1 is Cur+1,
    set_element(State,State1,Cur1,Obj,End,Value).

index_attr(info,1).
index_attr(unknown,2).
index_attr(empty,3).
index_attr(pit,4).
index_attr(wall,5).
index_attr(shoot,6).
index_attr(damp,7).
index_attr(wumpus,8).
index_attr(smell,9).
index_attr(stench,10).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% from start pos and go straight to the edge.
way_to_edge(_-_,1-Y-west,[1-Y]).
way_to_edge(R-C,X-Y-west,[X-Y|Points]) :-
    X > 1,
    X1 is X-1,
    way_to_edge(R-C,X1-Y-west,Points).
way_to_edge(_-C,C-Y-east,[C-Y]).
way_to_edge(R-C,X-Y-east,[X-Y|Points]) :-
    X < C,
    X1 is X+1,
    way_to_edge(R-C,X1-Y-east,Points).
way_to_edge(_-_,X-1-north,[X-1]).
way_to_edge(R-C,X-Y-north,[X-Y|Points]) :-
    Y > 1,
    Y1 is Y-1,
    way_to_edge(R-C,X-Y1-north,Points).
way_to_edge(R-_,X-R-south,[X-R]).
way_to_edge(R-C,X-Y-south,[X-Y|Points]) :-
    Y < R,
    Y1 is Y+1,
    way_to_edge(R-C,X-Y1-south,Points).


