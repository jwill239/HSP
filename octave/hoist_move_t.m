function t= hoist_move_t(PA, PB, opt="empty")
  hoist_speed_r= 10; % reciproco della velocita', secondi per una posizione
  hoist_lift_t= 5;

  if (strcmp(opt, "empty"))
    t= hoist_speed_r*abs(PA-PB);
  elseif (strcmp(opt, "full"))
    t= hoist_lift_t + hoist_speed_r*abs(PA-PB) + hoist_lift_t;
  else
    error("opt");
  endif
endfunction