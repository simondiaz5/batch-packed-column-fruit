function [h] = fun_f_h_fsolve(x,u,p,x0)


[x_dot,y] = fun_f_h([x0(1:end-2);x],u,p,x0);

h=x_dot(end-1:end);