/**
TP 6 Sur une balançoire

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
%% :-lib(ic_symbolic).
:-lib(branch_and_bound).

/*
===============================================================================
	Includes
===============================================================================
*/


solve(Position) :-
	variables(Noms,Poids,Position),
	getVarList(Position,VarList),
	set_contraint(Noms,Poids,Position,VarList),
	labeling(VarList).

variables(Noms,Poids,Position) :- 
	Poids = [](24,39,85,60,165,6,32,123,7,14),
	Noms = [](ron,zoe,jim,lou,luc,dan,ted,tom,max,kim),
	dim(Position,[10]),
	Position #:: -8..8.


set_contraint(Noms,Poids,Position,VarList) :- 
	set_contraint_assis(_Noms,_Poids,Position),
	set_contraint_sum(Noms,Poids,Position),
	set_contraint_number(Noms,Poids,Position),
	set_contraint_parent(Noms,Poids,Position,VarList),
	set_contraint_dan_max(Position)
	.

set_contraint_sum(_Noms,Poids,Position) :-
	produit_scalaire(Poids,Position,0).


set_contraint_number(_Noms,_Poids,Position) :-
	dim(Position, [Dim]),
	(
     for(I,1,Dim),
     	fromto(0,Sum0,Sum1,Result),
        param(Position)
        do
        (
        	Pos is Position[I],
        	Sum1 #= Sum0 + (Pos #> 0) - (Pos #< 0)
        )
    ),
	Result #= 0
    .


set_contraint_assis(_Noms,_Poids,Position) :-
	dim(Position, [Dim]),
	(
     for(I,1,Dim),
     	fromto([],List1,List2,Result),
     	param(Position)
        do
        (
        	Toto is Position[I],
        	Toto #\= 0,
        	List2 = [Toto|List1]
        )
    ),
    ic:alldifferent(Result)
.

get_position(0,_Position,0) :-
	!.
get_position(I,Position,Result) :-
	Result is Position[I].



%% return the list of variables
getVarList(Position, Result) :-
	dim(Position, [Dim]),
	(
     for(I,1,Dim),
        fromto([],List0,List1,Result),
        param(Position)
        do
        (
        	T is Position[I],
            List1 = [T|List0]
        )
     ).

set_contraint_parent(_Noms,_Poids,Position,VarList) :-
	Maman is Position[4],
	Papa is Position[8],
	ic:min(VarList,Maman),
	ic:max(VarList,Papa).

set_contraint_dan_max(Position) :-
	Dan is Position[6],
	Max is Position[9],
	Maman is Position[4],
	Papa is Position[8],
	((Dan #= Papa - 1) or (Dan #= Maman + 1)),
	((Max #= Papa - 1) or (Max #= Maman + 1))
	.


/*
===============================================================================
	Tools box (thx tp5)
===============================================================================
*/

produit_vecteur(Vect1, Vect2, Result) :-
	dim(Vect1,[Dim]),
	dim(Result,[Dim]),
	(
	 for(I, 1, Dim),
		param(Result), param(Vect1), param(Vect2)
	 do
	 (
		Xi is Vect1[I],
		Yi is Vect2[I],
		Result[I] #= Xi * Yi
	 )
	).

produit_scalaire(Vect1,Vect2,Result) :-
	produit_vecteur(Vect1, Vect2, ResultInter),
	dim(Vect1,[Dim]),
	(
	 for(I,1,Dim),
		fromto(0,Sum0,Sum1,Result),
		param(ResultInter)
		do
		(
			Sum1 #= Sum0 + ResultInter[I]
		)
	 ).