function t= hoist_move_t(PA, PB, opt="empty")
  
  global ricetta;
  
  hoist_speed_r= 10; % reciproco della velocita', secondi per una posizione
  hoist_lift_t= 5;

  if (PA==0)
    xa=0;
  else
    xa= ricetta(PA, 4);
  endif
  if (PB==0)
    xb=0;
  else
    xb= ricetta(PB, 4);
  endif
  dist= abs(xb-xa);
  
  if (strcmp(opt, "empty"))
    t= hoist_speed_r*dist;
  elseif (strcmp(opt, "full"))
    if (PA==0)
      t_gocc= 0;
    else
      t_gocc= ricetta(PA, 3);
    endif
    t= hoist_lift_t + t_gocc + hoist_speed_r*dist + hoist_lift_t;
  else
    error("opt");
  endif
endfunction