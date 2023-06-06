function salida = viscosidad(x,T,PM1,PM3,rho3,rho1,rho)
% Este macro calcula la viscosidad del agua y del etanol puros conocida su
% temperatura, así como la de la mezcla líquida dada la fracción molar de
% etanol y su temperatura.

% En primer lugar se calcula la viscosidad tanto del agua como del etanol
% en estado puro:

mu3 = exp(-24.76+(4.21e3/T)+4.53e-2*T-3.38e-5*T^2)*1e-3;       % [kg/(m*s)]
mu1 = exp(-6.21+(1.614e3/T)+6.18e-3*T-1.13e-5*T^2)*1e-3;       % [kg/(m*s)]

% A continuación se procede al cálculo de la viscosidad de la mezcla líqui-
% da etanol-agua:

alpha1 = 102.842;                                                     % [K]
alpha3 = 565.671;                                                     % [K]
x1vol = 1/(1+((1-x)/x)*(rho1*PM3/(rho3*PM1)));                        % [-]
eta = (x1vol*mu1*exp(alpha3*(1-x1vol)/T)/(rho1*1000))+((1-x1vol)*mu3*exp(alpha1*x1vol/T)/(rho3*1000)); % [m^2/s]
mu = eta*rho*1000;                                             % [kg/(m*s)]

salida = [mu3 mu1 mu];