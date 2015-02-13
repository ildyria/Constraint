/**
TP 2 Contraintes logiques

@author Julien BOUVET
@author Benoît VIGUIER
@version Annee scolaire 2014/2015
*/

/*
===============================================================================
	Includes
===============================================================================
*/
:-lib(ic).
:-lib(ic_global).
:-lib(ic_symbolic).
/*
===============================================================================
===============================================================================
	Question 1.1
===============================================================================
*/

:- local domain(color(red,green,blue,white,yellow)).
:- local domain(drink(cafe,tea,milk,juice,water)).
:- local domain(car(ford,bmw,toyota,honda,datsun)).
:- local domain(animal(dog,snake,fox,horse,zebra)).
:- local domain(num(one,two,three,four,five)).
:- local domain(country(england,spain,ukrain,norway,japanese)).


domaines_maison(m(Pays,Couleur,Boisson,Voiture,Animal,Numero)) :- 
	Pays &:: country,
	Couleur &:: color,
	Boisson &:: drink,
	Voiture &:: car,
	Animal &:: animal,
	Numero &:: num.

rue([m(Pays1,Couleur1,Boisson1,Voiture1,Animal1,Num1),
	m(Pays2,Couleur2,Boisson2,Voiture2,Animal2,Num2),
	m(Pays3,Couleur3,Boisson3,Voiture3,Animal3,Num3),
	m(Pays4,Couleur4,Boisson4,Voiture4,Animal4,Num4),
	m(Pays5,Couleur5,Boisson5,Voiture5,Animal5,Num5)
	]) :-
	domaines_maison(m(Pays1,Couleur1,Boisson1,Voiture1,Animal1,Num1)),
	domaines_maison(m(Pays2,Couleur2,Boisson2,Voiture2,Animal2,Num2)),
	domaines_maison(m(Pays3,Couleur3,Boisson3,Voiture3,Animal3,Num3)),
	domaines_maison(m(Pays4,Couleur4,Boisson4,Voiture4,Animal4,Num4)),
	domaines_maison(m(Pays5,Couleur5,Boisson5,Voiture5,Animal5,Num5)),
	ic_symbolic:alldifferent([Num1,Num2,Num3,Num4,Num5]),
	ic_symbolic:alldifferent([Pays1,Pays2,Pays3,Pays4,Pays5]),
	ic_symbolic:alldifferent([Couleur1,Couleur2,Couleur3,Couleur4,Couleur5]),
	ic_symbolic:alldifferent([Boisson1,Boisson2,Boisson3,Boisson4,Boisson5]),
	ic_symbolic:alldifferent([Voiture1,Voiture2,Voiture3,Voiture4,Voiture5]),
	ic_symbolic:alldifferent([Animal1,Animal2,Animal3,Animal4,Animal5]),
	Num1 &= one,
	Num2 &= two,
	Num3 &= three,
	Num4 &= four,
	Num5 &= five.

ecrit_maisons(R) :-
	(foreach(M,R) do
			writeln(M)
	).

getVarList([],[]).
getVarList([m(Pays,Couleur,Boisson,Voiture,Animal,Numero)|T],
	[Pays,Couleur,Boisson,Voiture,Animal,Numero|Result]) :-
	getVarList(T,Result).

labeling_symbolic([]).
labeling_symbolic([H|T]) :-
	ic_symbolic:indomain(H),
	labeling_symbolic(T).

resoudre(Rue) :-
	rue(Rue),
	set_constraint_maison1(Rue),
	set_constraint_maison2(Rue),
	%% set_constraint_maison3(Rue),
	%% set_constraint_maison4(Rue),
	set_constraint_maison5(Rue),
	%% set_constraint_maison6(Rue),
	%% set_constraint_maison7(Rue),
	%% set_constraint_maison8(Rue),
	%% set_constraint_maison9(Rue),
	%% set_constraint_maison10(Rue),
	%% set_constraint_maison11(Rue),
	%% set_constraint_maison12(Rue),
	%% set_constraint_maison13(Rue),
	%% set_constraint_maison14(Rue),
	getVarList(Rue,VarList),
	labeling_symbolic(VarList),
	ecrit_maisons(Rue).

set_constraint_maison1(R) :- 
	member(m(Pays,Couleur,_Boisson,_Voiture,_Animal,_Num),R),
	Pays &= england,
	Couleur &= red.

set_constraint_maison2(R) :- 
	member(m(Pays,_Couleur,_Boisson,_Voiture,Animal,_Num),R),
	Pays &= spain,
	Animal &= dog.

set_constraint_maison3(R) :- 
	member(m(_Pays,Couleur,Boisson,_Voiture,_Animal,_Num),R),
	Couleur &= green,
	Boisson &= cafe.


set_constraint_maison4(R) :- 
	member(m(Pays,_Couleur,Boisson,_Voiture,_Animal,_Num),R),
	Pays &= ukrain,
	Boisson &= tea.

set_constraint_maison5(R) :- 
	member(m(_Pays,CouleurV,_Boisson,_Voiture,_Animal,NumV),R),
	member(m(_Pays,CouleurB,_Boisson,_Voiture,_Animal,NumB),R),
	CouleurB &= white,
	CouleurV &= green,
	((NumV &= five)
	or	(NumV &= four, NumB &= three)
	or	(NumV &= four, NumB &= two)
	or	(NumV &= four, NumB &= one)
	or	(NumV &= three, NumB &= two)
	or	(NumV &= two, NumB &= one)).

set_constraint_maison6(R) :- 
	member(m(_Pays,_Couleur,_Boisson,Voiture,Animal,_Num),R),
	Voiture &= bmw,
	Animal &= snake.

set_constraint_maison7(R) :- 
	member(m(_Pays,Couleur,_Boisson,Voiture,_Animal,_Num),R),
	Couleur &= yellow,
	Voiture &= toyota.

set_constraint_maison8(R) :- 
	member(m(_Pays,_Couleur,Boisson,_Voiture,_Animal,Num),R),
	Boisson &= milk,
	Num &= three.

set_constraint_maison9(R) :- 
	member(m(Pays,_Couleur,_Boisson,_Voiture,_Animal,Num),R),
	Pays &= norway,
	Num &= one.

set_constraint_maison10(R) :- 
	member(m(_Pays,_CouleurV,_Boisson,Voiture,_Animal,NumV),R),
	member(m(_Pays,_CouleurB,_Boisson,_Voiture,Animal,NumA),R),
	Voiture &= ford,
	Animal &= fox,
	(NumV &= NumA + one  or NumA &= NumV + one).

set_constraint_maison11(R) :- 
	member(m(_Pays,_CouleurV,_Boisson,Voiture,_Animal,NumV),R),
	member(m(_Pays,_CouleurB,_Boisson,_Voiture,Animal,NumA),R),
	Voiture &= toyota,
	Animal &= horse,
	(NumV &= NumA + one  or NumA &= NumV + one).

set_constraint_maison12(R) :- 
	member(m(_Pays,_Couleur,Boisson,Voiture,_Animal,_Num),R),
	Voiture &= honda,
	Boisson &= juice.

set_constraint_maison13(R) :- 
	member(m(Pays,_Couleur,_Boisson,Voiture,_Animal,_Num),R),
	Pays &= japanese,
	Voiture &= datsun.

set_constraint_maison14(R) :- 
	member(m(Pays,_CouleurV,_Boisson,_Voiture,_Animal,NumN),R),
	member(m(_Pays,CouleurB,_Boisson,_Voiture,_Animal,NumB),R),
	Pays &= norway,
	CouleurB &= blue,
	(NumN &= NumB + one  or NumB &= NumN + one).

