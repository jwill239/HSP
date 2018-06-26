function init_ricetta()
  global ricetta;
  ricetta= [
    500 550;
    500 550;
    500 550;
    100 110;
    100 110;
    100 110;
    ];
    for step= ricetta'
      if (step(1)>step(2))
        error ("ricetta");
      endif
    endfor
  endfunction 