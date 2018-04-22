:- ensure_loaded(borders).
:- ensure_loaded(cities).
:- ensure_loaded(countries).
:- ensure_loaded(rivers).

country(X) :- 
    country(X,_,_,_,_,_,_,_).

larger(X,Y) :-
    country(X,_,_,_,Ax,_,_,_),
    country(Y,_,_,_,Ay,_,_,_),
    Ax > Ay.

river_country(River,Country) :-
    river(River, Countrylist),
    country(Country),
    member(Country, Countrylist).

country_region(Country, Region) :-
    country(Country, Region, _,_,_,_,_,_).
