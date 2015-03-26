/**
TP 4 Les régates

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

solve(Conf) :-
	getData(_TailleEquipes,NbEquipes,_CapaBateaux,NbBateaux,NbConf),
	defineVars(Conf, NbEquipes, NbConf, NbBateaux),
	apply_constraints(Conf),
	getVarsList(Conf,VarList),
	labeling(VarList).

getData(TailleEquipes,NbEquipes,CapaBateaux,NbBateaux,NbConf) :-
	TailleEquipes = [](5,5,2,1),
	CapaBateaux = [](7,6,5),
	dim(TailleEquipes,[NbEquipes]),
	dim(CapaBateaux,[NbBateaux]),
	NbConf #= 3.

defineVars(Conf, NbEquipes, NbConf, NbBateaux) :-
	dim(Conf,[NbEquipes,NbConf]),
	Conf #:: 1..NbBateaux.
/*
getVarsList(Conf,L) :-
	dim(Conf,[NbRow,NbCol]),
	(
	 for(I,1,NbCol),
		param(Conf), param(L), param(NbRow)
		do
		(
		 for(J,1,NbRow),
			param(Conf), param(L), param(NbRow)
			do
			(
				X is Conf[I,J],
				L
			)
		)
	).*/

getVarsList(Conf,VarList) :-
	dim(Conf,[NbRow,NbCol]),
	getVarsList(Conf,[],1,NbRow,1,NbCol,Return1),
	reverse(Return1, VarList).

getVarsList(Conf,L,MaxI,MaxI,MaxJ,MaxJ,Return) :- 
	!,
	X is Conf[MaxI,MaxJ],
	Return = [X|L].
getVarsList(Conf,L,MaxI,MaxI,J,MaxJ,Return) :- 
	!,
	X is Conf[MaxI,J],
	J1 is J + 1,
	L1 = [X|L],
	getVarsList(Conf,L1,1,MaxI,J1,MaxJ,Return).
getVarsList(Conf,L,I,MaxI,J,MaxJ,Return) :- 
	!,
	X is Conf[I,J],
	I1 is I + 1,
	L1 = [X|L],
	getVarsList(Conf,L1,I1,MaxI,J,MaxJ,Return).

/*
testVarsList(In,Out) :-
	In = []([](1,2),[](3,4)),
	getVarsList(In,Out).

[eclipse 10]: testVarsList(I,O).
I = []([](1, 2), [](3, 4))
O = [1, 3, 2, 4]e
Yes (0.00s cpu)

expected :
I : 
1 2
3 4
O : 1 3 2 4
*/

/*
sucre syntaxique :
for (I, 1 , N), from_to([], In, Out, Res) do
X is T[J],
Out = [X|In]
*/

/*
===============================================================================
===============================================================================
	Question 3
===============================================================================
*/


apply_constraints(Conf) :-
	dim(Conf,[NbEquipes,NbConf]),
	pasMemeBateau(Conf,NbEquipes,NbConf),
	pasMemePartenaire(Conf, NbEquipes, NbConf).

pasMemeBateau(Conf,NbEquipes,_NbConf) :-
	(
	 for(I,1,NbEquipes),
		param(Conf)
		do
		(
			TeamRow is Conf[I],
			ic:alldifferent(TeamRow)
		)
	).




countDoublonTeam(Conf, Equipe1, Equipe2, NbConf, NbConf, Prev, Return) :-
	!,
	Case1 is Conf[Equipe1,NbConf],
	Case2 is Conf[Equipe2,NbConf],
	Return #= ((Case2 #= Case1) + Prev).

countDoublonTeam(Conf, Equipe1, Equipe2, I, NbConf, Prev, Return) :-
	Case1 is Conf[Equipe1,I],
	Case2 is Conf[Equipe2,I],
	Prev2 #= ((Case2 #= Case1) + Prev),
	INext is I + 1,
	countDoublonTeam(Conf, Equipe1, Equipe2, INext, NbConf, Prev2, Return).



checkDoublonPerTeam(Conf, Equipe1, NbEquipes, NbEquipes, NbConf) :-
	!,
	countDoublonTeam(Conf, Equipe1, NbEquipes, 1, NbConf, 0, Return),
	Return #< 2.

checkDoublonPerTeam(Conf, Equipe1, Equipe2, NbEquipes, NbConf) :-
	countDoublonTeam(Conf, Equipe1, Equipe2, 1, NbConf, 0, Return),
	Return #< 2,
	EquipeNext is Equipe2 + 1,
	checkDoublonPerTeam(Conf, Equipe1, EquipeNext, NbEquipes, NbConf).



coutDoublon(Conf, NbEquipes, NbEquipes, NbConf) :- 
	!. 

coutDoublon(Conf, Equipe1, NbEquipes, NbConf) :- 
	Equipe2 is Equipe1 + 1,
	checkDoublonPerTeam(Conf, Equipe1, Equipe2, NbEquipes, NbConf),
	EquipeNext is Equipe1 + 1,
	coutDoublon(Conf, EquipeNext, NbEquipes, NbConf).

pasMemePartenaire(Conf, NbEquipes, NbConf) :- 
	coutDoublon(Conf, 1, NbEquipes, NbConf).

capaBateaux(Conf,TailleEquipes,NbEquipes,CapaBateaux,NbBateaux,NbConf) :-
.




sumBoat(Conf,Boat,Result)	