function t= hoist_move_t(PA, PB, opt="empty")
  hoist_speed= 10;
  hoist_lift_t= 5;

  if (strcmp(opt, "empty"))
    t= 10*abs(PA-PB);
  elseif (strcmp(opt, "full"))
    t= hoist_lift_t + 10*abs(PA-PB) + hoist_lift_t;
  else
    error("opt");
  endif
endfunction