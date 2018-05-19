test_clp_1:- E=[E1 , E2], fd_domain(E, 1, 6), fd_labeling(E), 10 =:= E1+E2.

test_clp_2 :- fd_domain(A, 0, 100), fd_domain(B, 0, 100), fd_domain(C, 0, 100), C #=# 2*A, A + 1 #=# B, A+B+C #<# 100, fd_labeling([A, B, C]).

test_clp_3 :- fd_domain(A, 0, 100), fd_domain(B, 0, 100), fd_domain(C, 0, 100), C #=# 2*A, A + 1 #=# B, A+B+C #<# 100, fd_maximize(fd_labeling([A, B, C]), A).
