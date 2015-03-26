/**
TP 3 Ordonnancement de tâches sur deux machines

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

/*
===============================================================================
===============================================================================
	Question 1.1
===============================================================================
*/

taches(T) :- 
T = [](	tache(3, [], 	m1, _),
		tache(8, [], 	m1, _),
		tache(8, [4,5], m1, _),
		tache(6, [], 	m2, _),
		tache(3, [1], 	m2, _),
		tache(4, [1,7], m1, _),
		tache(8, [3,5], m1, _),
		tache(6, [4], 	m2, _),
		tache(6, [6,7], m2, _),
		tache(6, [9,12], m2, _),
		tache(3, [1], 	m2, _),
		tache(6, [7,8], m2, _)).

% solve the problem but not necessarly the best solution.
solve(Taches,Fin) :-
	taches(Taches),
	domaines(Taches, Fin),
	apply_constraints(Taches),
	getVarList(Taches, VarList),
	labeling(VarList),
	display_taches(Taches).


% solve the problem and look for the best solution
solvMinTime(Taches,Final) :-
	solvMinTime(Taches,Final, _Fin),
	display_taches(Taches).

solvMinTime(Taches2,Final, Fin) :-
	taches(Taches),
	domaines(Taches, Fin),
	apply_constraints(Taches),
	getVarList(Taches, VarList),
	labeling(VarList),
	!,
	NextFin is Fin - 1,
	solvMinTime(Taches2, Final, NextFin).
	% if succed decrease Fin by 1
	% if doesn't succed, check the other branch => therefore the provious solution was the right one.
	% i love cuts =D

solvMinTime(Taches,Final, NextFin) :- 
	Final is NextFin + 1,
	taches(Taches),
	domaines(Taches, Final),
	apply_constraints(Taches),
	getVarList(Taches, VarList),
	labeling(VarList),
	!.
	% cut because i like to have only ONE solution =D


%% diplay the tasks
display_taches(Taches) :-
	dim(Taches, [Dim]),
	(
	 for(I, 1, Dim),
		param(Taches)
	 do
	 (
	 	Xi is Taches[I],
	 	writeln(Xi)
	 )
	).

%% apply the domain to the start
domaines(Taches, Fin) :- 
	sum_times(Taches, Fin),
	!,
	apply_Fin(Taches,Fin).

domaines(Taches, Fin) :-
	apply_Fin(Taches,Fin).

apply_Fin(Taches,Fin) :-
	dim(Taches, [Dim]),
	(
	 for(I, 1, Dim),
		param(Taches), param(Fin)
	 do
	 (
	 	tache(Duree, _ListPrevious, _Machine, Debut) is Taches[I],
	 	FinTache is Fin - Duree,
	 	Debut #:: 0..FinTache
	 )
	).

%% look for a possible maximum value of Fin in the event it wouldn't be provided
sum_item(Taches,Sum,Return,Max,Max) :-
	!,
	tache(Duree, _ListPrevious, _Machine, _Debut) is Taches[Max],
	Return is Sum + Duree.
sum_item(Taches,Sum,Return,Index,Max) :-
	tache(Duree, _ListPrevious, _Machine, _Debut) is Taches[Index],
	Sum2 is Sum + Duree,
	Index2 is Index + 1,
	sum_item(Taches,Sum2,Return,Index2,Max).

sum_times(Taches, Return) :-
	dim(Taches, [Dim]),
	sum_item(Taches,0,Return,1,Dim).

%% Apply constraints
apply_constraints(Taches):-
	precedences(Taches),
	conflicts(Taches).

%% Define precedence contraints
precedences(Taches) :-
	dim(Taches, [Dim]),
	(
	 for(I, 1, Dim),
		param(Taches)
	 do
	 (
	 	tache(_Duree, ListPrevious, _Machine, Debut) is Taches[I],
	 	apply_precedence(Debut,Taches, ListPrevious)
	 )
	).

apply_precedence(_DebutTask,_Taches, []).
apply_precedence(DebutTask,Taches, [H|T]) :-
	tache(Duree, _ListPrevious, _Machine, Debut) is Taches[H],
	DebutTask #>= Debut + Duree,
	apply_precedence(DebutTask,Taches, T).

%% Define conflicts contraints

conflicts(Taches) :-
	dim(Taches, [Dim]),
	(
	 for(I, 1, Dim),
		param(Taches), param(Dim)
	 do
	 (
	 	tache(Duree, _ListPrevious, Machine, Debut) is Taches[I],
	 	Max is Dim + 1,
	 	Start is I + 1,
	 	apply_conflicts(Debut, Duree, Machine, Taches, Start, Max)
	 )
	).

apply_conflicts(_DebutTask, _Duree, _Machine, _Taches, Max, Max) :-
	!.
apply_conflicts(Debut1, Duree1, Machine1, Taches, Index, Max) :-
	tache(Duree2, _ListPrevious, Machine2, Debut2) is Taches[Index],
	apply_single_conflic(Debut1,Duree1,Machine1,Debut2,Duree2,Machine2),
	Index2 is Index + 1,
	apply_conflicts(Debut1, Duree1, Machine1, Taches, Index2, Max).	
	
apply_single_conflic(Debut1,Duree1,Machine,Debut2,Duree2,Machine) :-
	!,
	(Debut1 + Duree1 #=< Debut2 or Debut2 + Duree2 #=< Debut1).
apply_single_conflic(_Debut1,_Duree1,_Machine1,_Debut2,_Duree2,_Machine2).


%% return the list of variables
getVarList(Taches, Return) :-
	dim(Taches, [Dim]),
	var_item(Taches,[],Return,1,Dim).

var_item(Taches,PreviousList,Return,Max,Max) :-
	!,
	tache(_Duree, _ListPrevious, _Machine, Debut) is Taches[Max],
	Return = [Debut|PreviousList].
var_item(Taches,PreviousList,ReturnList,Index,Max) :-
	tache(_Duree, _ListPrevious, _Machine, Debut) is Taches[Index],
	List = [Debut|PreviousList],
	Index2 is Index + 1,
	var_item(Taches,List,ReturnList,Index2,Max).