function o= interval_overlap(T1, T2)
  d= min(T1(2), T2(2)) - max(T1(1), T2(1));
% ( (T2(2) - T1(1) >=0) && (T1(2) >= T2(1)) )
  if (d>0)
    o=d;
  else
    o=0;
  endif
endfunction