:- lib(listut).
:- lib(between).
:- lib(ic).
:- lib(branch_and_bound).

ricetta([[100,110], [50,110], [100,110], [50,110], [100,110], [50,110], [100,110]]).

steps_no(StepsNo) :- ricetta(R), length(R, StepsNo).

step(S):- steps_no(N), between(1, N, S).
step_ext(S):- S=0; step(S); step_unload(S).
step_succ(S, Succ):-
	step_unload(S), Succ=0,!;
	succ(S, Succ).

step_t(Step, Min, Max) :- ricetta(R), nth1(Step, R, [Min, Max]).

step_unload(S):- steps_no(N), succ(N, S).

hoist_lift_t(5).
hoist_move_t(PosA, PosB, T):- is(T, 10*abs(PosA-PosB)).

event_t(List, Step, T) :-
	nth0(Step, List, T).
	
% Removal: lista formata dai tempi di rimozione della barra dalla vasca
% Entry: lista formata dai tempi di inserimento della barra dalla vasca
% Il formato e': [carico, pos1, pos2, ..., posN, scarico]

lin0(Removal, Entry) :-
	Removal=[R1|_], R1 #= 0,
	Entry=[E1|_], E1 #= 0,
	last(A, Removal), last(B, Entry), A #= B.

% vincolo: tra la estrazione da una posizione e l'inserimento nella successiva posizione deve esserci il tempo di sollevamento, traslazione, abbassamento.
lin1(Removal, Entry) :- findall(S, step(S), StepsList), step_unload(Last), append(StepsList, [Last], StepsListExt), maplist(lin1(Removal, Entry), StepsListExt).

lin1(Removal, Entry,S) :-
	hoist_lift_t(TLift), hoist_lift_t(TLower),
	succ(PredS, S), event_t(Removal, PredS, TA), hoist_move_t(PredS, S, TMove), event_t(Entry, S, TB), TB #= TA+ TLift+ TMove + TLower.
	
% vincolo: tempo di permanenza in una posizione
lin2(Removal, Entry) :- findall(S, step(S), StepsList), maplist(lin2(Removal, Entry), StepsList).

lin2(Removal, Entry, S) :-
	event_t(Entry, S, TIn), event_t(Removal, S, TOut), step_t(S, Tmin, Tmax),
	TIn+Tmin #=< TOut,
	TIn+Tmax #>= TOut.

% vincolo: il tempo di permanenza di una barra nel sistema non puo' superare NumJobs cicli (perche' ad ogni ciclo viene rimossa una barra)
lin3(Removal, NumJobs, Period) :- step_unload(ULStep), event_t(Removal, ULStep, LastT), hoist_move_t(ULStep,0,TRet), LastT+TRet #=< NumJobs * Period.

% il carro deve avere il tempo di andare da una posizione all'altra.
% in questi calcoli il carro e' vuoto (non trasporta barre), quindi ignoriamo i tempi di sollevamento/abbassamento.

% caso 1: la barra viene estratta dallo step2 dopo che e' stata estratta dallo step1
disj1(Removal, Entry, Period, Step1, Step2, K) :- 
	step_succ(Step1, SuccS1),
	event_t(Entry, SuccS1, TEntrySuccS1),
	hoist_move_t(SuccS1, Step2, TMove),
	event_t(Removal, Step2, TRemovalS2),
	TEntrySuccS1 + TMove + K*Period #=< TRemovalS2.
	
% caso 2: la barra viene estratta dallo step1 dopo che e' stata estratta dallo step2
disj1(Removal, Entry, Period, Step1, Step2, K) :-
	step_succ(Step2, SuccS2),
	event_t(Entry, SuccS2, TEntrySuccS2),
	hoist_move_t(SuccS2, Step1, TMove),
	event_t(Removal, Step1, TRemovalS1),
	TEntrySuccS2 + TMove #=< TRemovalS1 + K*Period.

% elenco di tutte le coppie di vasche (step).
list_disj(L) :-
	findall([Step1, Step2], ((step_ext(Step1), step_ext(Step2), Step2>Step1); (step_unload(Step1), Step2=0)), L).

disj(Removal, Entry, NumJobs, Period) :- list_disj(PairList), disj(Removal, Entry, NumJobs, Period, PairList).

disj(_,_,_,_,[]).
disj(Removal, Entry, NumJobs, Period, [[Step1, Step2]| Rem]) :-
	disj(Removal, Entry, NumJobs, Period, Rem),
	(for(K, 0, NumJobs-1), param(Removal, Entry, Period, Step1, Step2) do disj1(Removal, Entry, Period, Step1, Step2, K)).
	
constraint(Removal, Entry, NumJobs, Period) :- lin0(Removal, Entry), lin1(Removal, Entry), lin2(Removal, Entry), lin3(Removal, NumJobs, Period), disj(Removal, Entry, NumJobs, Period).

test1([0, 120, 240, 260], [0, 20, 140, 260]).
test1:- test1(R, E), lin1(R, E), lin2(R, E), lin3(R, 170), disj(R, E, 170).

% Esempio: min_period(Entry, Removal, 2, Period).
min_period(Entry, Removal, NumJobs, Period) :-
	steps_no(StepsNo), ListLen is StepsNo+2,
	length(Removal, ListLen), Removal :: 0..300000,
	length(Entry, ListLen), Entry :: 0..300000,
	Period :: 0..30000000,
	constraint(Removal, Entry, NumJobs, Period),
	append(Removal, Entry, _Problem1), 
	append([Period], _Problem1, Problem),
	minimize(labeling(Problem), Period).

% min_period(Entry, Removal, 4, Period).  Period=530, 6.92s cpu.
