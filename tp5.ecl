/**
TP 5 Contraintes puis chercher

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
:-lib(branch_and_bound).

/*
===============================================================================
===============================================================================
	Question 2
===============================================================================

voilier1 : 7 places
voilier2 : 6 places
voilier3 : 5 places

equipe1 : 5
equipe2 : 5
equipe3 : 2
equipe4 : 1
*/

solvMaxProfit(Fabriquer,NbTechTotal, Result) :-
	Toto #= -Result,
	minimize(solve(Fabriquer,NbTechTotal, Result),Toto).

reductionPlan(Fabriquer,NbTechTotal, Result) :-
	Result #> 1000,
	minimize(solve(Fabriquer,NbTechTotal, Result),NbTechTotal).


solve(Fabriquer,NbTechTotal, ProfitTotal) :-
	pose_contrainte(Fabriquer, NbTechTotal, ProfitTotal),
	getVarList(Fabriquer, VarList),
	labeling(VarList).


variables(Technicien,QtyPerDay,Benef,Fabriquer) :- 
	Technicien = [](5,7,2,6,9,3,7,5,3),
	QtyPerDay = [](140,130,60,95,70,85,100,30,45),
	Benef = [](4,5,8,5,6,4,7,10,11),
	dim(Benef,[Dim]),
	dim(Fabriquer,[Dim]),
	Fabriquer #:: 0..1
.

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


maxNumWorker(Fabriquer,Worker,Sum) :-
	produit_scalaire(Fabriquer,Worker,Sum).

benefTotalPerTel(QtyPerDay,BenefPerTel,ProfitTotalPerTel) :-
	produit_vecteur(QtyPerDay, BenefPerTel, ProfitTotalPerTel).	

benefTotal(Fabriquer,ProfitTotalPerTel,ProfitTotal) :-
	produit_scalaire(Fabriquer,ProfitTotalPerTel,ProfitTotal).


pose_contrainte(Fabriquer, NbTechTotal, ProfitTotal) :-
	variables(Worker,QtyPerDay,BenefPerTel,Fabriquer),

	
	maxNumWorker(Fabriquer,Worker,NbTechTotal),
	NbTechTotal #=< 22,

	benefTotalPerTel(QtyPerDay,BenefPerTel,ProfitTotalPerTel),
	benefTotal(Fabriquer,ProfitTotalPerTel,ProfitTotal).

%% return the list of variables
getVarList(Fabriquer, Result) :-
	dim(Fabriquer, [Dim]),
	(
     for(I,1,Dim),
        fromto([],List0,List1,Result),
        param(Fabriquer)
        do
        (
        	T is Fabriquer[I],
            List1 = [T|List0]
        )
     ).


/*
solv(F,N,P).
Found a solution with cost 0
Found a solution with cost -560
Found a solution with cost -650
Found a solution with cost -1210
Found a solution with cost -1690
Found a solution with cost -2165
Found a solution with cost -2390
Found a solution with cost -2525
Found a solution with cost -2575
Found a solution with cost -2665
Found no solution with cost -1.0Inf .. -2666

F = [](0, 1, 1, 0, 0, 1, 1, 0, 1)
N = 22
P = 2665
Yes (0.00s cpu)



reductionPlan(F,N,P).
Found a solution with cost 12
Found a solution with cost 7
Found no solution with cost -1.0Inf .. 6

F = [](1, 0, 1, 0, 0, 0, 0, 0, 0)
N = 7
P = 1040
Yes (0.01s cpu)
*/