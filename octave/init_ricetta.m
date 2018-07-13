function init_ricetta()
  global ricetta;

  % 1=tmin 2=tmax 3=tgocc 4=x

  ricetta= [
    100 110 0 0;
    1000 1100 0 1;
    100 110 0 2;
    500 550 0 3;
    100 110 0 4;
    100 110 0 5;
    500 550 0 6;
    100 110 0 7;
    0 0 0 100;
  ];
        
    for step= ricetta'
      if (step(1)>step(2))
        error ("ricetta");
      endif
    endfor
  endfunction 