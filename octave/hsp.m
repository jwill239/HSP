clear all;
close all;
format short G;

global ricetta;
init_ricetta;
global numJobs;
numJobs=2;
global numHoists;
numHoists=2;

margin=10;

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
% occupazione vasca (capacita' 1)
for s=1:num_steps()
  RC=zeros(1, index_var("num"));
  RC(index_var("period"))= 1;
  RC(index_var("entry", s))= 1;
  RC(index_var("removal", s))= -1;
  vb= margin;
  A= [A; RC];
  b= [b; vb];
  ctype= [ctype "L"];
endfor

% no overlap; disjunctive linearizzato
M= 10000;
for s1=0:num_steps()-1
  for s2=s1+1:num_steps()
    % carri diversi
    RC=zeros(1, index_var("num"));
    RC(index_var("hoist_r", s2))= 1;
    RC(index_var("hoist_r", s1))= -1;
    RC(index_var("disj_diffhoist", s1, s2))= -M;
    vb= 1-M;
    A= [A; RC];
    b= [b; vb];
    ctype= [ctype "L"];

    for k=1:numJobs
      RC=zeros(1, index_var("num"));
      RC(index_var("disj_diffhoist", s1, s2))= 1;
      RC(index_var("disj_order", s1, s2, k-1))= 1;
      RC(index_var("disj_order", s1, s2, k-1)+1)= 1;
      vb= 1;
      A= [A; RC];
      b= [b; vb];
      ctype= [ctype "S"];

      RC=zeros(1, index_var("num"));
      RC(index_var("entry", s1+1))= 1;
      RC(index_var("period"))= k;
      RC(index_var("disj_order", s1, s2, k-1))= M;
      RC(index_var("removal", s2))= -1;
      vb= M-hoist_move_t(s1+1, s2, "empty");
      A= [A; RC];
      b= [b; vb];
      ctype= [ctype "U"];
      
      RC=zeros(1, index_var("num"));
      RC(index_var("entry", s2+1))= 1;
      RC(index_var("period"))= -k;
      RC(index_var("disj_order", s1, s2, k-1)+1)= M;
      RC(index_var("removal", s1))= -1;
      vb= M-hoist_move_t(s2+1, s1, "empty");
      A= [A; RC];
      b= [b; vb];
      ctype= [ctype "U"];
      
    endfor
  endfor
endfor

% compilazione di hoist_e
for s=0:num_steps()
  RC=zeros(1, index_var("num"));
  RC(index_var("hoist_r", s))= 1;
  RC(index_var("hoist_e", s+1))= -1;
  vb= 0;
  A= [A; RC];
  b= [b; vb];
  ctype= [ctype "S"];
endfor

% inizializzazione di hoist_e sul carico e hoist_r sullo scarico (solo per motivi estetici)
RC=zeros(1, index_var("num"));
RC(index_var("hoist_r", s))= 1;
RC(index_var("hoist_e", s))= -1;
vb= 0;
A= [A; RC];
b= [b; vb];
ctype= [ctype "S"];

RC=zeros(1, index_var("num"));
RC(index_var("hoist_r", num_steps()+1))= 1;
RC(index_var("hoist_e", num_steps()+1))= -1;
vb= 0;
A= [A; RC];
b= [b; vb];
ctype= [ctype "S"];


% hoist partition
collision="partition";
if (strcmp(collision, "partition"))
  for s1=0:num_steps()-1
    for s2=s1+1:num_steps()
      RC=zeros(1, index_var("num"));
      RC(index_var("hoist_r", s2))= 1;
      RC(index_var("hoist_r", s1))= -1;
      vb= 0;
      A= [A; RC];
      b= [b; vb];
      ctype= [ctype "L"];
    endfor
  endfor
else
  error("collision");
endif

vartype(1:index_var("num"))= "-";

lb(index_var("period"))=0;
ub(index_var("period"))=Inf;
vartype(index_var("period"))= "C";

for s=0:num_steps()+1
  lb(index_var("entry", s))=0;
  ub(index_var("entry", s))=Inf;
  vartype(index_var("entry", s))= "C";
  lb(index_var("removal", s))=0;
  ub(index_var("removal", s))=Inf;
  vartype(index_var("removal", s))= "C";
  lb(index_var("hoist_r", s))=1;
  ub(index_var("hoist_r", s))=numHoists;
  vartype(index_var("hoist_r", s))= "I";
  lb(index_var("hoist_e", s))=1;
  ub(index_var("hoist_e", s))=numHoists;
  vartype(index_var("hoist_e", s))= "I";
  endfor
lb(index_var("disj_base_0"):index_var("num"))=0;
ub(index_var("disj_base_0"):index_var("num"))=1;
vartype(index_var("disj_base_0"):index_var("num"))="I";

% ricerca
c= zeros(index_var("num"), 1); c(index_var("period"))= 1;
sense=1;
param.msglev = 3;

[x, fmin, errnum, extra] = glpk (c, A, b, lb, ub, ctype, vartype, sense, param);

if (errnum!=0)
  printf("glpk error %d;\n", errnum);
else
  if (overlap(x, numJobs, 2)>eps)
    printf("Error: overlap found!\n");
  endif
  show_sol(x,1);
  timediagram(x, numJobs, 0);
endif