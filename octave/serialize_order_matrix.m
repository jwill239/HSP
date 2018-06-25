function r= serialize_order_matrix(x, y)
  N= num_steps();
  if (x>=y)
    error("serialize_order_matrix");
  endif
  if (x==0)
    r= y;
  else
    r= y-x + (N+1)*N/2 - (N-x)*(N-x+1)/2;
  endif
endfunction