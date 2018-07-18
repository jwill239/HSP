function h= hoist_r_step(s)
  
  global numHoists;
  global ricetta;
  
  if (s==0)
    h=1;
  else
    h= ricetta(s, 6);
  endif
  if (h>numHoists)
    error("numHoists too small");
  endif
endfunction
  