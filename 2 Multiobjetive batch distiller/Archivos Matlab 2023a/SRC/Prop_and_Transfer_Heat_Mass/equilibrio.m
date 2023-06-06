function salida = equilibrio(x,T)
% Comentar si llega a servir.

% Para ello en primer lugar se definen los par�metros requeridos en el mo-
% delo de c�lculo de coeficiente de actividad NRTL, los cuales fueron obte-
% nidos en otros macros MATLAB:

alpha13 = 0.3659;                                                     % [-]
tau13 = -0.0304;                                                      % [-]
tau31 = 1.7292;                                                       % [-]
alpha21 = 13.7309;                                                    % [-]
tau21 = 0.2686;                                                       % [-]
tau12 = -0.0041;                                                      % [-]
alpha23 = 0.1391;                                                     % [-]
tau23 = -0.9384;                                                      % [-]
tau32 = 1.8754;                                                       % [-]

G13 = exp(-alpha13*tau13);                                            % [-]
G31 = exp(-alpha13*tau31);                                            % [-]
G21 = exp(-alpha21*tau21);                                            % [-]
G12 = exp(-alpha21*tau12);                                            % [-]
G23 = exp(-alpha23*tau23);                                            % [-]
G32 = exp(-alpha23*tau32);                                            % [-]

% Una vez hecho esto, se presentan las constantes presentes en la ecuaci�n 
% de Antoine, a partir de la cual se calcula la presi�n de vapor del meta-
% nol a diferentes temperaturas. Estos son obtenidos de Del Valle:

Antoine2 = [16.4948 3593.39 -35.2249];              % [ln kPa,ln kPa * K,K]

% A continuaci�n se desarrolla el c�lculo requerido para obtener el coefi-
% ciente de actividad:

Pvap2 = exp((Antoine2(1)-(Antoine2(2)/(Antoine2(3)+T))));           % [kPa]
lngama21 = (tau12*G12*x+tau32*G32*(1-x))/(G12*x+G32*(1-x));           % [-]
lngama22 = (x*G21/(x+(1-x)*G31))*(tau21-(tau31*G31*(1-x)/(x+(1-x)*G31))); % [-]
lngama23 = ((1-x)*G23/(x*G13+(1-x)))*(tau23-(tau13*G13*x/(x*G13+(1-x)))); % [-]
gama2 = exp(lngama21+lngama22+lngama23);                              % [-]
salida = [Pvap2 gama2];