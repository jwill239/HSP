function init_ricetta()
  global ricetta;

  % 1=tmin 2=tmax 3=tgocc 4=x 5=capacity 6=hoist_r

  ricetta= [
    900 945 0 1108 1 0;
    900 945 5 2088 1 0;
    60 70 0 3082 1 0;
    60 70 0 4016 1 0;
    600 630 5 4948 1 0;
    60 70 0 5945 1 0;
    60 70 0 6844 1 0;
    60 70 5 7808 1 0;
    60 70 0 8823 1 0;
    60 70 0 9683 1 0;
    0 0 0 13615 1 0;
  ];
        
  for step= ricetta'
    if (step(1)>step(2))
      error ("ricetta");
    endif
  endfor
  
  endfunction 