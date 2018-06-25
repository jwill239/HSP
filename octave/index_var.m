function index= index_var(dato, step=0, step2=0, k=0)
  global numJobs;
  
  if (strcmp(dato, "period"))
    index=1;
   elseif (strcmp(dato, "entry"))
    index= 1+1+step;
  elseif (strcmp(dato, "removal"))
    index= 2+ num_steps()+2 + step;
  elseif (strcmp(dato, "num_cont"))
    index= 1+ 2*(num_steps()+2);
  elseif (strcmp(dato, "bool_base"))
    index= 1+ 2*(num_steps()+2)+1;
  elseif (strcmp(dato, "num"))
    index= index_var("num_cont") + 2*numJobs*(num_steps()+1)*num_steps()/2;
  elseif (strcmp(dato, "bool_order"))
    if (step2<=step)
      error("bool_order");
    endif
    index= index_var("num_cont") +1 + 2*(numJobs*(serialize_order_matrix(step, step2)-1)+ k);
  else
    error("dato");
  endif
endfunction