QUESTION 1
?- borders(X,australia).
X = indian_ocean ;
X = pacific.


QUESTION 2
?- borders(france,Z), borders(spain,Z).
Z = andorra ;
Z = atlantic ;
Z = mediterranean.


QUESTION 3
?- borders(france,X), borders(spain,X),country(X,_,_,_,_,_,_,_).
X = andorra ;
false.


QUESTION 4
country(X) :- 
    country(X,_,_,_,_,_,_,_).

?- borders(france,X), borders(spain,X),country(X).
X = andorra ;
false.


QUESTION 5
larger(X,Y) :-
    country(X,_,_,_,Ax,_,_,_),
    country(Y,_,_,_,Ay,_,_,_),
    Ax > Ay.

?- larger(australia,china).
false.


QUESTION 6
river_country(River,Country) :-
    river(River, Countrylist),
    country(Country),
    member(Country, Countrylist).
country_region(Country, Region) :-
    country(Country, Region, _,_,_,_,_,_).

?- river_country(R,C1),
|    river_country(R,C2),
|    country_region(C1,R1),
|    country_region(C2,R2),
|    R1 \= R2.
