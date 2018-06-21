function index= index_var(dato, step=0)
  if (strcmp(dato, "period"))
    index=1;
   elseif (strcmp(dato, "entry"))
    index= 1+1+step;
  elseif (strcmp(dato, "removal"))
    index= 2+ num_steps()+2 + step;
  elseif (strcmp(dato, "num"))
    index= 1+ 2*(num_steps()+2);
  else
    error("dato");
  endif
endfunction