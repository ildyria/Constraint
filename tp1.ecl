/**
TP 1 Decouverte de la biblioteque de contrainte a domaine fini

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

/*
===============================================================================
===============================================================================
	Question 1.1
===============================================================================
*/

couleurs_voiture([rouge,vert(clair),gris,blanc]).
couleurs_bateau([vert,noir,blanc]).

:- mode choixCouleur(?,?).

choixCouleur(CouleurBateau,CouleurVoiture) :-
	CouleurBateau = CouleurVoiture,
	couleurs_voiture(ColorsVoiture),
	member(CouleurVoiture,ColorsVoiture),
	couleurs_bateau(ColorsBateau),
	member(CouleurBateau,ColorsBateau).

/*
choixCouleur(rouge,rouge).
No (0.00s cpu)

choixCouleur(C,C).
C = blanc
Yes (0.00s cpu)

choixCouleur(C,D).
C = blanc
D = blanc
Yes (0.00s cpu)
*/

/*
===============================================================================
===============================================================================
	Question 1.2
===============================================================================

Prolog est un solveur de contrainte de type Generate & Test avec son mécanisme
d'unification.

===============================================================================
===============================================================================
	Question 1.3
===============================================================================
*/
:- mode isBetween(?,+,+).

isBetween(Var,Min,Max) :- 
	=<(Min,Max),
	Var = Min.

isBetween(Var,Min,Max) :-
	=<(Min,Max),
	NextInt is Min + 1,
	isBetween(Var,NextInt,Max).


/*
isBetween(42,1,43).
Yes (0.00s cpu)

isBetween(1337,1,42).
No (0.00s cpu)

isBetween(X,1,3).
X = 1
Yes (0.00s cpu, solution 1, maybe more) ? ;
X = 2
Yes (0.00s cpu, solution 2, maybe more) ? ;
X = 3
Yes (0.00s cpu, solution 3, maybe more) ? ;
No (0.00s cpu)
*/

/*
===============================================================================
===============================================================================
	Question 1.4
===============================================================================
*/

minResistance(5000).
maxResistance(10000).
minCondensateur(9000).
maxCondensateur(20000).

:- mode commande(-,-).
commande(NbResistance,NbCondensateur) :-
	minResistance(MinR),
	maxResistance(MaxR),
	minCondensateur(MinC),
	maxCondensateur(MaxC),
	isBetween(NbResistance,MinR,MaxR),
	isBetween(NbCondensateur,MinC,MaxC),
	>=(NbResistance,NbCondensateur).

/*
commande(R,C).
R = 9000
C = 9000
Yes (2.26s cpu, solution 1, maybe more) ? ;

R = 9001
C = 9000
Yes (2.26s cpu, solution 2, maybe more) ? 
*/

/*
===============================================================================
===============================================================================
	Question 1.5
===============================================================================

cf arbre de recherche sur la version papier.
*/

/*
===============================================================================
===============================================================================
	Question 1.6
===============================================================================

Prolog n'est pas capable de choisir un nombre compris entre deux valeurs,
on est obligé de les générer à l'aide de prédicats. Le predicat =>(,) ne
fonctionne que en mode (+,+).

===============================================================================
===============================================================================
	Question 1.7
===============================================================================
*/

:- mode commandeConstrainted(-,-).
commandeConstrainted(NbResistance,NbCondensateur) :-
	minResistance(MinR),
	maxResistance(MaxR),
	minCondensateur(MinC),
	maxCondensateur(MaxC),
	NbResistance #:: MinR..MaxR,
	NbCondensateur #:: MinC..MaxC,
	#>=(NbResistance,NbCondensateur).
/*
commandeConstrainted(R,C).
R = R{9000 .. 10000}
C = C{9000 .. 10000}
Delayed goals:
	C{9000 .. 10000} - R{9000 .. 10000} #=< 0
Yes (0.00s cpu)

Il a juste posé les contraintes mais n'a pas fait le labeling.

===============================================================================
===============================================================================
	Question 1.8
===============================================================================
*/

:- mode commandeConstraintedV2(-,-).
commandeConstraintedV2(NbResistance,NbCondensateur) :-
	minResistance(MinR),
	maxResistance(MaxR),
	minCondensateur(MinC),
	maxCondensateur(MaxC),
	NbResistance #:: MinR..MaxR,
	NbCondensateur #:: MinC..MaxC,
	#>=(NbResistance,NbCondensateur),
	labeling([NbResistance,NbCondensateur]).

/*
commandeConstraintedV2(R,C).
R = 9000
C = 9000
Yes (0.00s cpu, solution 1, maybe more) ?

cf papier pour l'arbre

===============================================================================
===============================================================================
	Question 1.9
===============================================================================
*/

:- mode chapie(-,-,-,-).
chapie(Chats,Pie,Pattes,Tetes) :-
	#>=(Chats,0),
	#>=(Pie,0),
	#>=(Pattes,0),
	#>=(Tetes,0),
	#=<(Chats,Tetes),
	#=<(Pie,Tetes),
	Pattes #= 4*Chats + 2*Pie,
	Tetes #= Chats + Pie.
/*
chapie(Chats,Pie,Pattes,Tetes)
Chats = Chats{0 .. 1.0Inf}
Pie = Pie{0 .. 1.0Inf}
Pattes = Pattes{0 .. 1.0Inf}
Tetes = Tetes{0 .. 1.0Inf}

Delayed goals:
	-(Tetes{0 .. 1.0Inf}) + Chats{0 .. 1.0Inf} #=< 0
	-(Tetes{0 .. 1.0Inf}) + Pie{0 .. 1.0Inf} #=< 0
	Pattes{0 .. 1.0Inf} - 2 * Pie{0 .. 1.0Inf} - 4 * Chats{0 .. 1.0Inf} #= 0
	Tetes{0 .. 1.0Inf} - Pie{0 .. 1.0Inf} - Chats{0 .. 1.0Inf} #= 0
Yes (0.00s cpu)


chapie(2,Pie,Pattes,5).
Pie = 3
Pattes = 14
Yes (0.00s cpu)

===============================================================================
===============================================================================
	Question 1.10
===============================================================================
*/

question10(Chats,Pie):-
	Pattes #= 3*Tetes,
	chapie(Chats,Pie,Pattes,Tetes),
	labeling([Pattes,Tetes]).

/*
question10(C,P).
lists.eco  loaded in 0.00 seconds
C = 0
P = 0
Yes (0.00s cpu, solution 1, maybe more) ? 
[eclipse 26]: question10(C,P).
C = 0
P = 0
Yes (0.00s cpu, solution 1, maybe more) ? ;
C = 1
P = 1
Yes (0.00s cpu, solution 2, maybe more) ? ;
C = 2
P = 2
Yes (0.00s cpu, solution 3, maybe more) ? 

===============================================================================
===============================================================================
	Question 1.11
===============================================================================
*/

vabsProlog(Toto,Val):-
	Val #>= 0,
	Toto #>= 0,
	Toto #= Val.
vabsProlog(Toto,Val) :-
	Val #>= 0,
	Toto #=< 0,
	Toto #= -Val.

vabsIC(Toto,Val) :- 
	Val #>= 0,
	(Toto #= -Val ; Toto #= Val).

/*
===============================================================================
===============================================================================
	Question 1.12
===============================================================================
X #:: -10..10, vabsProlog(X,Y).
X = X{0 .. 10}
Y = X{0 .. 10}
Yes (0.00s cpu, solution 1, maybe more) ? ;
X = X{-10 .. 0}
Y = Y{0 .. 10}
Delayed goals:
	Y{0 .. 10} + X{-10 .. 0} #= 0
Yes (0.00s cpu, solution 2)

X #:: -10..10, vabsIC(X,Y).
X = X{-10 .. 0}
Y = Y{0 .. 10}
Delayed goals:
	Y{0 .. 10} + X{-10 .. 0} #= 0
Yes (0.00s cpu, solution 1, maybe more) ? ;
X = X{0 .. 10}
Y = X{0 .. 10}
Yes (0.00s cpu, solution 2)

===============================================================================
===============================================================================
	Question 1.13
===============================================================================
*/
:- mode faitList(?,?,+,+).
faitList(ListVars,Taille,Min,Max) :-
	faitListRec([],ListVars,0,Taille,Min,Max).

faitListRec(ListVars,ReturnList,CurrentSize,SizeDesired,Min,Max) :-
	X #:: Min..Max,
	CurrentSizeUpdated #=< SizeDesired,
	CurrentSizeUpdated #= CurrentSize + 1,
	faitListRec([X|ListVars],ReturnList,CurrentSizeUpdated,SizeDesired,Min,Max).

faitListRec(ListVars,ListVars,SizeDesired,SizeDesired,_Min,_Max) :- !.

/*
faitList(ListVars,5,0,5).
ListVars = [_741{0 .. 5}, _608{0 .. 5}, _475{0 .. 5}, _342{0 .. 5}, _209{0 .. 5}]
Yes (0.00s cpu, solution 1, maybe more) ? ;
No (0.00s cpu)

===============================================================================
===============================================================================
	Question 1.14
===============================================================================
*/
suite([A,B,C]) :- 
	A #= vabsProlog(B) - C,
	!.
suite([A,B,C|Q]) :-
	A #= vabsProlog(B) - C,
	suite([B,C|Q]).

/*
===============================================================================
===============================================================================
	Question 1.15
===============================================================================
*/
suite9p([A,B,C,D,E,F,G,H,A]) :-
	!,
	\=(A,B),
	\=(A,C),
	\=(A,D),
	\=(A,E),
	\=(A,F),
	\=(A,G),
	\=(A,H).
suite9p([A,B,C,D,E,F,G,H,A|Q]) :-
	suite9p([B,C,D,E,F,G,H,A|Q]).