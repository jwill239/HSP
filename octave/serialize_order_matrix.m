function r= serialize_order_matrix(x, y)
  N= num_steps();
  if (x>=y || y>N || x>N)
    error("serialize_order_matrix");
  endif
  if (x==0)
    r= y;
  else
    r= y-x + (N+1)*N/2 - (N-x)*(N-x+1)/2;
  endif
endfunction

% x
% 4 |
% 3 |            10
% 2 |          8  9
% 1 |       5  6  7
% 0 |    1  2  3  4
%    --------------
% y   0  1  2  3  4