function show_sol(x, detail=0)
  global numJobs;
  
  printf("numero di cicli: %u;\n", numJobs);
  printf("Ciclo= %f secondi;\n", x(index_var("period")));
  poslist=(0:num_steps()+1)';
  disp([poslist x(index_var("hoist", poslist)) x(index_var("entry", poslist)) x(index_var("removal", poslist)) (x(index_var("removal", poslist)) - x(index_var("entry", poslist)))]);

  if (detail>=1)
    printf("disjunction\n");
    for s1=0:num_steps()-1
      for s2=s1+1:num_steps()
        printf( "%u-%u %u ", s1, s2, x(index_var("disj_diffhoist", s1, s2)));
        for k=0:numJobs-1
          printf("%u-%u ", x(index_var("disj_order", s1, s2, k)), x(index_var("disj_order", s1, s2, k)+1));
        endfor
        printf("\n");
      endfor
    endfor
  endif
  
  endfunction