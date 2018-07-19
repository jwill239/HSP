function o= interval_overlap(T1, T2, log=0)
  d= min(T1(2), T2(2)) - max(T1(1), T2(1));
% ( (T2(2) - T1(1) >=0) && (T1(2) >= T2(1)) )
  if (d>1E-6)
    o=d;
    if (log>=2)
      printf("overlap: %d-%d %d-%d\n", T1(1), T1(2), T2(1), T2(2));
    endif
  else
    o=0;
  endif
endfunction