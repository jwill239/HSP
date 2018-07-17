function t= hoist_speed(x_mm)
  hoist_ab_time=2; % acceleration_time e breaking_time
  hoist_inching_time=1;
  hoist_travel_speed= 583.333; % millimetri al secondo
  t= x_mm/hoist_travel_speed;
endfunction