function init_ricetta()
  global ricetta;

  % 1=tmin 2=tmax 3=tgocc 4=x 5=capacity 6=hoist_r

  ricetta= [
    300 360 10 1077 1 1; %2 sgrassatura
    300 360 10 2057 1 1;
    60 80 10 3076 1 1;
    60 80 5 3937 1 1;
    60 80 10 4809 1 1;
    300 360 10 5843 1 1;
    300 360 10 6823 1 1;
    60 80 5 7856 1 1;
    60 80 5 8740 1 1;
    60 80 10 9648 1 1; % 11
    1 360 0 10500, 1, 2; % buffer
    
    1800 2500 15 19606 6 2; % 19-24 stagno
    1 360 0 10500, 1, 1; % buffer
    0 0 0 0 1 0;
  ];

  ricetta_old2= [
    300 360 10 1077 1 1; %2 sgrassatura
    300 360 10 2057 1 1;
    60 80 10 3076 1 1;
    60 80 5 3937 1 1;
    60 80 10 4809 1 1;
    300 360 10 5843 1 1;
    300 360 10 6823 1 1;
    60 80 5 7856 1 1;
    60 80 5 8740 1 1;
    60 80 10 9648 1 1; % 11
    1 360 0 10500, 1, 0; % buffer
    
    1800 2500 15 19606 6 2; % 19-24 stagno
    60 80 10 16173 1 2; % 18 recupero
    60 80 5 15231 1 2;
    60 80 5 14358 1 2;
    60 80 10 13497 1 2;
    60 70 10 12499 1 2;
    60 80 5 11485 1 2;
    60 80 10 10648 1 2; % 12 lavaggio
    1 360 0 10500, 1, 0; % buffer
    0 0 0 0 1 0;
  ];

  
  ricetta_1L_old= [
    300 360 10 1077 1 1;
    300 360 10 2057 1 1;
    60 80 10 3076 1 1;
    60 80 5 3937 1 1;
    60 80 10 4809 1 1;
    300 360 10 5843 1 1;
    300 360 10 6823 1 1;
    60 80 5 7856 1 1;
    60 80 5 8740 1 1;
    60 80 10 9648 1 1; % 11
    1 360 0 17000 1 2; % buffer
    1800 2500 15 29168 6 2;
    60 80 10 24810 1 2;
    60 80 5 23868 1 2;
    60 80 5 22995 1 2;
    60 80 10 22134 1 2;
    60 70 10 21136 1 2;
    60 80 5 20122 1 2;
    60 80 10 19284 1 2; % 21
    1 360 0 17000 1 1; % buffer
    0 0 0 0 1 0;
  ];

  ricetta_A2L_1= [
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
        
  ricetta_A2L_2= [
    2400 2520 10 3499 6 0;
    60 70 0 6964 1 0;
    60 70 0 7864 1 0;
    60 70 0 8753 1 0;
    60 70 0 9638 1 0;
    60 70 5 10645 1 0;
    60 70 0 11617 1 0;
    60 70 0 12475 1 0;
    0 0 0 13615 1 0;
  ];

  for step= ricetta'
    if (step(1)>step(2))
      error ("ricetta");
    endif
  endfor
  
  endfunction 