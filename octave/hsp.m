clear all;
close all;
format short G;

global ricetta;
init_ricetta;
numJobs=5;

% lin0
% Entry[0]= 0, Removal[0]= 0
RC=zeros(1, index_var("num"));
RC(index_var("entry", 0))=1;
vb=0;
CE(1,:)=RC;
be(1)=vb;

RC=zeros(1, index_var("num"));
RC(index_var("removal", 0))=1;
vb=0;
CE= [CE; RC];
be= [be; vb];

% Ultimo Entry== Ultimo Removal
RC=zeros(1, index_var("num"));
RC(index_var("entry", num_steps()+1))= 1;
RC(index_var("removal", num_steps()+1))= -1;
vb=0;
CE= [CE; RC];
be= [be; vb];

% lin1
% tra la estrazione da una posizione e l'inserimento nella successiva posizione deve esserci il tempo di sollevamento, traslazione, abbassamento.
for s=1:num_steps()+1
  RC=zeros(1, index_var("num"));
  RC(index_var("entry", s))= 1;
  RC(index_var("removal", s-1))= -1;
  vb= hoist_move_t(s-1, s, "full");
  CE= [CE; RC];
  be= [be; vb];
endfor  

% lin2
% tempo di permanenza
% Periodo>0 e' superflua ma la metto per inizializzare la matrice
RC=zeros(1, index_var("num"));
RC(index_var("period"))=1;
vb=0;
CD(1,:)=RC;
bd(1)=vb;

for s=1:num_steps()
  RC=zeros(1, index_var("num"));
  RC(index_var("removal", s))= 1;
  RC(index_var("entry", s))= -1;
  vb= ricetta(s, 1); % min
  CD= [CD; RC];
  bd= [bd; vb];
  
  RC=zeros(1, index_var("num"));
  RC(index_var("removal", s))= -1;
  RC(index_var("entry", s))= 1;
  vb= -ricetta(s, 2); % max
  CD= [CD; RC];
  bd= [bd; vb];
endfor

% lin3
RC=zeros(1, index_var("num"));
RC(index_var("period"))= numJobs;
RC(index_var("entry", num_steps()+1))= -1;
vb= hoist_move_t(num_steps()+1, 0, "empty");
CD= [CD; RC];
bd= [bd; vb];

% lin4
for s=1:num_steps()
  RC=zeros(1, index_var("num"));
  RC(index_var("period"))= 1;
  RC(index_var("entry", s))= 1;
  RC(index_var("removal", s))= -1;
  vb= 0;
  CD= [CD; RC];
  bd= [bd; vb];
endfor

% ricerca
cost= @(vars) vars(index_var("period"))+1000*overlap(vars, numJobs);
g= @(vars) CE*vars-be;
h= @(vars) CD*vars-bd;
x0= zeros(index_var("num"),1); x0(index_var("period"))=110;

[x, obj, info, iter, nf, lambda]= sqp(x0, cost, g, h);

x(index_var("period"))
overlap(x, numJobs, 2)

timediagram(x, numJobs);