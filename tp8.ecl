/**
TP 8 Histoire de menteurs

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

:- local domain(mw(man,woman)).


solve :-
	variables(Parent1,Parent2,Enfant,AffEselonP1,AffP1,Aff1P2,Aff2P2, AffE),
	constraint(Parent1,Parent2,Enfant,AffEselonP1,AffP1,Aff1P2,Aff2P2, AffE),
	affirme_content(Parent1,Parent2,Enfant,AffEselonP1,AffP1,Aff1P2,Aff2P2, AffE),
	get_variables_symbolic(Parent1,Parent2,Enfant, VarList),
	labeling_symbolic(VarList),
	print_result(Parent1,Parent2,Enfant).

/*
[eclipse 23]: solve.
Parent 1 is a man
Parent 2 is a woman
Child is a man

Yes (0.00s cpu, solution 1, maybe more) ? ;
No (0.00s cpu)
*/

variables(Parent1,Parent2,Enfant,AffEselonP1,AffP1,Aff1P2,Aff2P2, AffE) :- 
	Parent1 &:: mw,
	Parent2 &:: mw,
	Enfant &:: mw,
	AffE #:: 0..1,
	AffEselonP1 #:: 0..1,
	AffP1 #:: 0..1,
	Aff1P2 #:: 0..1,
	Aff2P2 #:: 0..1.

affirme(Personne, Affirmation) :-
	(Personne &= woman, Affirmation #= 1) or Personne &= man.

affirme(Personne, Affirmation1, Affirmation2) :-
	(Personne &= man, Affirmation1 #= 1, Affirmation2 #= 0) or
	(Personne &= man, Affirmation1 #= 0, Affirmation2 #= 1) or
	Personne &= woman.

constraint(Parent1,Parent2,_Enfant,_AffEselonP1,AffP1,Aff1P2,Aff2P2, _AffE) :-
	couple(Parent1,Parent2),
	affirme(Parent1, AffP1),
	affirme(Parent1, AffP1, _Affirmation),

	affirme(Parent2, Aff1P2),
	affirme(Parent2, Aff2P2),
	affirme(Parent2, Aff1P2, Aff2P2).

affirme_content(_Parent1,_Parent2,Enfant,AffEselonP1,AffP1,Aff1P2,Aff2P2, AffE) :-
	AffEselonP1 #= (Enfant &= woman),
	AffP1 #= (AffEselonP1 #= AffE),
	Aff1P2 #= (Enfant &= man),
	Aff2P2 #= (AffE #= 0).

couple(Parent1,Parent2) :-
	(Parent1 &= man and Parent2 &= woman) or (Parent1 &= woman and Parent2 &= man).



get_variables_symbolic(Parent1,Parent2,Enfant, [Parent1,Parent2,Enfant]).

labeling_symbolic([]).
labeling_symbolic([H|T]) :-
	ic_symbolic:indomain(H),
	labeling_symbolic(T).


print_result(Parent1,Parent2,Enfant) :-
	write('Parent 1 is a '),
	writeln(Parent1),
	write('Parent 2 is a '),
	writeln(Parent2),
	write('Child is a '),
	writeln(Enfant).
	