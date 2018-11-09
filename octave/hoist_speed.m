function t= hoist_speed(x_mm)
  
  superfast= false;
  
  if (superfast)
    hoist_ab_time=2; % acceleration_time e breaking_time
    hoist_inching_time=1; % es. 1
    hoist_travel_speed= 1.5; % metri al secondo
  else
    hoist_ab_time=2; % acceleration_time e breaking_time
    hoist_inching_time=1; % es. 1
    hoist_travel_speed= 583.333/1000; % metri al secondo
  endif

  x= abs(x_mm)/1000;
  if (x<eps)
    t=0;
    return;
  endif
  s_2ta= hoist_travel_speed^2/hoist_ab_time;
  if (x < s_2ta)
    t_mov= sqrt(x/hoist_travel_speed);
  else
    t_mov= 2*hoist_travel_speed/hoist_ab_time + (x - s_2ta)/hoist_travel_speed;
  endif
  t= t_mov + hoist_inching_time;
endfunction