function init_ricetta()
  global ricetta;

  % 1=tmin 2=tmax 3=tgocc 4=x 5=capacity

  ricetta= [
    100  110  0    0 1;
    1000 1100 0 1000 2;
    100  110  0 2000 1;
    500  550  0 3000 1;
    100  110  0 4000 1;
    100  110  0 5000 1;
    500  550  0 6000 1;
    100  110  0 7000 1;
    0    0    0 8000 1;
  ];
        
    for step= ricetta'
      if (step(1)>step(2))
        error ("ricetta");
      endif
    endfor
  endfunction 