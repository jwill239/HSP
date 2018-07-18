function x= x_step(s)
  global ricetta;
  
  if (s==0)
    x=0;
  else
    x= ricetta(s, 4);
  endif
endfunction