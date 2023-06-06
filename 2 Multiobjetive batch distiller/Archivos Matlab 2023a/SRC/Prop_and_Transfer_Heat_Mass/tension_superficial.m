function salida = tension_superficial(x,T)
% Este macro calcula la tensión superficial de todos los compuestos presen-
% tes en el sistema (etanol-metanol-agua) en estado puro, dada una cierta
% temperatura, así como la tensión superficial de la mezcla líquida etanol-
% agua. 

% En primer lugar calculamos la tensión superficial de cada compuesto puro:

sigma1 = (-0.0733*T+43.566)/1000;                                   % [N/m] 
sigma2 = (-0.0921*T+49.961)/1000;                                   % [N/m]
sigma3 = (-0.1681*T+122.05)/1000;                                   % [N/m]

% A continuación se procede a calcular la tensión superficial de la mezcla
% líquida:

sigma = (x*sigma1^(-3.9544)+(1-x)*sigma3^(-3.9544))^(-1/3.9544);    % [N/m]

salida = [sigma1 sigma2 sigma3 sigma];