function index= index_var(dato, step=0, step2=0, k=0)
  global numJobs;
  global numHoists;
  
  if (strcmp(dato, "period"))
    index=1;
   elseif (strcmp(dato, "entry"))
    index= index_var("period")+1+step;
  elseif (strcmp(dato, "removal"))
    index= index_var("entry", num_steps()+1) + 1+ step;
  elseif (strcmp(dato, "hoist"))
    index= index_var("removal", num_steps()+1) + 1 + step;
  elseif (strcmp(dato, "disj_base_0"))
    index= index_var("hoist", num_steps()+1) + 1;
  elseif (strcmp(dato, "disj_base"))
    index= index_var("disj_base_0") + (1+2*numJobs)*(serialize_order_matrix(step, step2)-1);
  elseif (strcmp(dato, "disj_diffhoist"))
    index= index_var("disj_base", step, step2);
  elseif (strcmp(dato, "disj_order"))
    index= index_var("disj_base", step, step2)+1+2*k;
  elseif (strcmp(dato, "num"))
    index= index_var("disj_base_0")+(1+2*numJobs)*(num_steps()+1)*num_steps()/2 - 1;
  else
    error("dato");
  endif
endfunction