function salida = transf_masa2(xTM,L,T,p)
% Este macro calcula coeficientes de transferencia de masa siguiendo corre-
% lación de Billet y Schultes:
                                          
dens = densidad(xTM,T,p(2),p(3));                  
rho3TM = dens(1,1);                                             
rho1TM = dens(1,2);                                            
rho13TM = dens(1,3);                                           
visc = viscosidad(xTM,T,p(2),p(3),rho3TM,rho1TM,rho13TM);   
mu3TM = visc(1,1);                                          
mu1TM = visc(1,2);                                         
mu13TM = visc(1,3);                                        
tens_sup = tension_superficial(xTM,T);                       
sigma1TM = tens_sup(1,1);                                       
sigma2TM = tens_sup(1,2);                                        
sigma3TM = tens_sup(1,3);                                       
sigma13TM = tens_sup(1,4);                                      
difus = difusividad(xTM,T,mu3TM,mu1TM,sigma2TM,sigma3TM); 
D13TM = difus(1,3);                                            
D21TM = difus(1,1);                                            
D23TM = difus(1,2);                                            
PM13TM = peso_molecular(xTM,p(2),p(3));           

% Una vez calculadas todas las propiedades físicas, se procede a calcular
% la razón entre el área efectiva y la razón entre área específica y volu-
% men específico de relleno:

epsilon = 0.7;                       % Explicación en macro flujo_liquido.m
leq = 4*epsilon/p(5);                   % Largo hidráulico del relleno, [m]
ae13 = p(5)*1.5*(p(5)*leq)^(-0.5)*(L*PM13TM*leq*0.001/(p(6)*mu13TM))^(-0.2)*(L^2*PM13TM^2*1e-12/(rho13TM^2*p(6)^2*p(7)*leq))^(-0.45)*(L^2*PM13TM^2*leq*1e-9/(rho13TM*p(6)^2*sigma13TM))^(0.75); % [m^2/m^3]
ae21 = p(5)*1.5*(p(5)*leq)^(-0.5)*(L*p(2)*leq*0.001/(p(6)*mu1TM))^(-0.2)*(L^2*p(2)^2*1e-12/(rho1TM^2*p(6)^2*p(7)*leq))^(-0.45)*(L^2*p(2)^2*leq*1e-9/(rho1TM*p(6)^2*sigma1TM))^(0.75); % [m^2/m^3]
ae23 = p(5)*1.5*(p(5)*leq)^(-0.5)*(L*p(3)*leq*0.001/(p(6)*mu3TM))^(-0.2)*(L^2*p(2)^2*1e-12/(rho3TM^2*p(6)^2*p(7)*leq))^(-0.45)*(L^2*p(3)^2*leq*1e-9/(rho3TM*p(6)^2*sigma3TM))^(0.75); % [m^2/m^3]

% A continuación se obtiene el coeficiente de transferencia de masa por me-
% dio de dicha correlación:

kl13 = p(4)*(rho13TM*1000*p(7)/mu13TM)^(1/6)*(D13TM/leq)^(0.5)*(L*PM13TM*1e-6/(rho13TM*p(6)*p(5)))^(1/3); % [m/s]
kl21 = p(4)*(rho1TM*1000*p(7)/mu1TM)^(1/6)*(D21TM/leq)^(0.5)*(L*p(2)*1e-6/(rho1TM*p(6)*p(5)))^(1/3); % [m/s]
kl23 = p(4)*(rho3TM*1000*p(7)/mu3TM)^(1/6)*(D23TM/leq)^(0.5)*(L*p(3)*1e-6/(rho3TM*p(6)*p(5)))^(1/3); % [m/s]

% Finalmente se calcula el coeficiente de transferencia de masa volumétrico
% de acuerdo a esta correlación:

k13aef = kl13*ae13*rho13TM*1e6/PM13TM;                      % [mol/(m^3*s)]
k21aef = kl21*ae21*rho13TM*1e6/PM13TM;                      % [mol/(m^3*s)]
k23aef = kl23*ae23*rho13TM*1e6/PM13TM;                      % [mol/(m^3*s)]
salida = [k13aef k21aef k23aef];