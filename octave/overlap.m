function o= overlap(vars, numJobs)
  o= 0;
  period= vars(index_var("period"));
  
  for s1= 0:num_steps()-1
    for s2= s1+1:num_steps()
      % disp([s1 s2]);
      EntryS1= vars(index_var("entry", s1));
      EntryS2= vars(index_var("entry", s2));
      i1= [vars(index_var("removal", s1)) vars(index_var("entry", s1+1))+hoist_move_t(s1+1, s2, "empty")];
      i2= [vars(index_var("removal", s2)) vars(index_var("entry", s2+1))+hoist_move_t(s2+1, s1, "empty")];
      for k= 1:numJobs-1
        o= o+ interval_overlap(i1+k*period, i2);
      endfor
    endfor
  endfor
endfunction