clear all;
close all;
format short G;

global ricetta;
init_ricetta;
global numJobs;
numJobs=2;

% lin0
% Entry[0]= 0, Removal[0]= 0
RC=zeros(1, index_var("num"));
RC(index_var("entry", 0))=1;
vb=0;
A(1,:)=RC;
b(1)=vb;
ctype="S";

RC=zeros(1, index_var("num"));
RC(index_var("removal", 0))=1;
vb=0;
A= [A; RC];
b= [b; vb];
ctype= [ctype "S"];

% Ultimo Entry== Ultimo Removal
RC=zeros(1, index_var("num"));
RC(index_var("entry", num_steps()+1))= 1;
RC(index_var("removal", num_steps()+1))= -1;
vb=0;
A= [A; RC];
b= [b; vb];
ctype= [ctype "S"];

% lin1
% tra la estrazione da una posizione e l'inserimento nella successiva posizione deve esserci il tempo di sollevamento, traslazione, abbassamento.
for s=1:num_steps()+1
  RC=zeros(1, index_var("num"));
  RC(index_var("entry", s))= 1;
  RC(index_var("removal", s-1))= -1;
  vb= hoist_move_t(s-1, s, "full");
  A= [A; RC];
  b= [b; vb];
  ctype= [ctype "S"];
endfor  

% lin2
% tempo di permanenza
for s=1:num_steps()
  RC=zeros(1, index_var("num"));
  RC(index_var("removal", s))= 1;
  RC(index_var("entry", s))= -1;
  vb= ricetta(s, 1); % min
  A= [A; RC];
  b= [b; vb];
  ctype= [ctype "L"];

  RC=zeros(1, index_var("num"));
  RC(index_var("removal", s))= -1;
  RC(index_var("entry", s))= 1;
  vb= -ricetta(s, 2); % max
  A= [A; RC];
  b= [b; vb];
  ctype= [ctype "L"];
endfor

% lin3
RC=zeros(1, index_var("num"));
RC(index_var("period"))= numJobs;
RC(index_var("entry", num_steps()+1))= -1;
vb= hoist_move_t(num_steps()+1, 0, "empty");
A= [A; RC];
b= [b; vb];
ctype= [ctype "L"];

% lin4
for s=1:num_steps()
  RC=zeros(1, index_var("num"));
  RC(index_var("period"))= 1;
  RC(index_var("entry", s))= 1;
  RC(index_var("removal", s))= -1;
  vb= 0;
  A= [A; RC];
  b= [b; vb];
  ctype= [ctype "L"];
endfor

% no overlap; disjunctive linearizzato
M= 100000;
for s1=0:num_steps()-1
  for s2=s1+1:num_steps()
    for k=1:numJobs
      RC=zeros(1, index_var("num"));
      RC(index_var("bool_order", s1, s2, k-1))= 1;
      RC(index_var("bool_order", s1, s2, k-1)+1)= 1;
      vb= 1;
      A= [A; RC];
      b= [b; vb];
      ctype= [ctype "S"];

      RC=zeros(1, index_var("num"));
      RC(index_var("entry", s1+1))= 1;
      RC(index_var("period"))= k;
      RC(index_var("bool_order", s1, s2, k-1))= M;
      RC(index_var("removal", s2))= -1;
      vb= M-hoist_move_t(s1+1, s2, "empty");
      A= [A; RC];
      b= [b; vb];
      ctype= [ctype "U"];
      
      RC=zeros(1, index_var("num"));
      RC(index_var("entry", s2+1))= 1;
      RC(index_var("period"))= -k;
      RC(index_var("bool_order", s1, s2, k-1)+1)= M;
      RC(index_var("removal", s1))= -1;
      vb= M-hoist_move_t(s2+1, s1, "empty");
      A= [A; RC];
      b= [b; vb];
      ctype= [ctype "U"];
      
    endfor
  endfor
endfor


% ricerca
c= zeros(index_var("num"), 1); c(index_var("period"))= 1;
sense=1;
lb(1:index_var("num"))=0;
ub(1:index_var("num_cont"))=Inf;
vartype(1:index_var("num_cont"))= "C";
ub(index_var("bool_base"):index_var("num"))=1;
vartype(index_var("bool_base"):index_var("num"))="I";
param.msglev = 3;

[x, fmin, errnum, extra] = glpk (c, A, b, lb, ub, ctype, vartype, sense, param);

x(index_var("period"))
overlap(x, numJobs, 2)

timediagram(x, numJobs);