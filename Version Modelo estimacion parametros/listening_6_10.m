% First specify continuous system S, Eqn. 6.10.
Kp = 1; % System gain Kp
ntau = [-45 -45 4 2]; % numerator time constants
tau = [20,20,20,18,18,18,5,5,5,10,10,16,14,12]; % 14 time constants !

z = -1./ntau; p = -1./tau; % poles & zeros
S = zpk(z,p,Kp*prod(ntau)/prod(tau)); % System S in zpk form
N = 200; Ts = 5; t = Ts*[0:N-1]'; % Sample time Ts = 5
u = randn(N,1); y = lsim(S,u,t); % Generate 200 i/o pairs

plot(t,y)
hold on
plot(t,u)
legend('y','u')



%% Try-Square wave

n=5000;

t = linspace(0,20000,n)';
Fd = Amplitude*square((2*pi/Period)*t_sim);
plot(t,Fd)
