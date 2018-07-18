function init_ricetta()
  global ricetta;

  % 1=tmin 2=tmax 3=tgocc 4=x 5=capacity 6=hoist_r

  ricetta= [
    100  110  0 1000 1 0;
    100  110  0 2000 1 0;
    100  110  0 3000 1 0;
    0    0    0 4000 1 0;
  ];
        
  for step= ricetta'
    if (step(1)>step(2))
      error ("ricetta");
    endif
  endfor
  
  endfunction 