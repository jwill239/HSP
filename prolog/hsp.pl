ricetta(R) :- g_read(ricetta_global, R).

steps_no(StepsNo) :- ricetta(R), length(R, StepsNo).

step(S):- steps_no(N), between(1, N, S).

step_t(Step, Min, Max) :- ricetta(R), nth(Step, R, [Min, Max]).

step_unload(S):- steps_no(N), succ(N, S).

hoist_lift_t(5).
hoist_move_t(PosA, PosB, T):- is(T, 10*abs(PosA-PosB)).

numJobs(2).

event_t(List, Step, T) :-
	succ(Step, Idx), nth(Idx, List, T).
	
% Removal: lista formata dai tempi di rimozione della barra dalla vasca
% Entry: lista formata dai tempi di inserimento della barra dalla vasca
% Il formato e': [carico, pos1, pos2, ..., posN, scarico]

lin0(Removal, Entry) :-
	Removal=[R1|_], R1 #=# 0,
	Entry=[E1|_], E1 #=# 0,
	last(Removal, A), last(Entry, B), A #=# B.

% vincolo: tra la estrazione da una posizione e l'inserimento nella successiva posizione deve esserci il tempo di sollevamento, traslazione, abbassamento.
lin1(Removal, Entry) :- findall(S, step(S), StepsList), step_unload(Last), append(StepsList, [Last], StepsListExt), maplist(lin1(Removal, Entry), StepsListExt).

lin1(Removal, Entry,S) :-
	hoist_lift_t(TLift), hoist_lift_t(TLower),
	succ(PredS, S), event_t(Removal, PredS, TA), hoist_move_t(PredS, S, TMove), event_t(Entry, S, TB), TB #=# TA+ TLift+ TMove + TLower.
	
% vincolo: tempo di permanenza in una posizione
lin2(Removal, Entry) :- findall(S, step(S), StepsList), maplist(lin2(Removal, Entry), StepsList).

lin2(Removal, Entry, S) :-
	event_t(Entry, S, TIn), event_t(Removal, S, TOut), step_t(S, Tmin, Tmax),
	TIn+Tmin #=<# TOut,
	TIn+Tmax #>=# TOut.

% vincolo: il tempo di permanenza di una barra nel sistema non puo' superare NumJobs cicli (perche' ad ogni ciclo viene rimossa una barra)
lin3(Removal, Period) :- step_unload(ULStep), numJobs(NumJobs), event_t(Removal, ULStep, LastT), LastT #=<# NumJobs * Period.

% il carro deve avere il tempo di andare da una posizione all'altra.
% in questi calcoli il carro e' vuoto (non trasporta barre), quindi ignoriamo i tempi di sollevamento/abbassamento.

disj1(Removal, Entry, Period, Step1, Step2, K) :- 
	succ(Step1, SuccS1),
	event_t(Entry, SuccS1, TEntrySuccS1),
	hoist_move_t(SuccS1, Step2, TMove),
	event_t(Removal, Step2, TRemovalS2),
	TEntrySuccS1 + TMove + K*Period #=<# TRemovalS2.
	
disj1(Removal, Entry, Period, Step1, Step2, K) :-
	succ(Step2, SuccS2),
	event_t(Entry, SuccS2, TEntrySuccS2),
	hoist_move_t(SuccS2, Step1, TMove),
	event_t(Removal, Step1, TRemovalS1),
	TEntrySuccS2 + TMove #=<# TRemovalS1 + K*Period.

list_disj(L) :-
	steps_no(StepsNo),
	succ(StepsNoPrec, StepsNo),
	findall([Step1, Step2], (between(1, StepsNoPrec, Step1), succ(Step1, Step1Succ), between(Step1Succ, StepsNo, Step2)), L).

disj(Removal, Entry, Period) :- list_disj(PairList), disj(Removal, Entry, Period, PairList).

disj(_,_,_,[]).
disj(Removal, Entry, Period, [[Step1, Step2]| Rem]) :-
	disj(Removal, Entry, Period, Rem),
	numJobs(NumJobs), succ(NumJobsPrec, NumJobs),
	findall(K, between(1, NumJobsPrec, K), KList),
	maplist(disj1(Removal, Entry, Period, Step1, Step2), KList).
	
constraint(Removal, Entry, Period) :- lin0(Removal, Entry), lin1(Removal, Entry), lin2(Removal, Entry), lin3(Removal, Period), disj(Removal, Entry, Period).

test1([0, 120, 240, 260], [0, 20, 140, 260]).
test1:- test1(R, E), lin1(R, E), lin2(R, E), lin3(R, 170), disj(R, E, 170).

% Esempio: min_period([[100,110], [100,110]], Period).
min_period(Ricetta, Period) :-
	g_assign(ricetta_global, Ricetta),
	fd_set_vector_max(1000),
	steps_no(StepsNo), ListLen is StepsNo+2,
	length(Removal, ListLen), fd_domain(Removal, 0, 300),
	length(Entry, ListLen), fd_domain(Entry, 0, 300),
	fd_domain(Period, 0, 300),
	constraint(Removal, Entry, Period),
	append(Removal, Entry, _Problem1), Problem = [Period|_Problem1],
	fd_minimize(fd_labeling(Problem), Period).
	
	
% E=[E1 , E2], fd_domain(E, 1, 6), fd_labeling(E), 10 =:= E1+E2.
