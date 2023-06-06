function L = flujo_liquido2(M,x,T,PM1,PM3,g,a,S)
%%Funcion vectorizada

% Este macro calcula el flujo de l�quido existente en cada etapa discreti-
% zada, a partir de la cantidad de l�quido retenido en ella. Para ello en
% primer lugar se calcula la densidad de la fase l�quida, utilizando la ex-
% presi�n presentada en Osorio et al. (1) y contenida en el macro
% densidad.m:

density = densidad2(x,T,PM1,PM3);                                   % [g/mL]
rho = density(3,:);                                                % [g/mL]

% A continuaci�n se procede a relacionar los moles de l�quido retenido por 
% metro de relleno con el flujo de �ste. Para ello se emplear�n las corre-
% laciones expresadas por Mackowiak (10). En primer lugar se calcular� la
% relaci�n entre los moles retenidos por metro de relleno y el hold-up de
% l�quido, obtenido en Peng et al (11).

PMprom = peso_molecular(x,PM1,PM3);                               % [g/mol]
hL = (M.*PMprom./(S*rho))*1e-6;                   % [m^3 l�quido/m^3 relleno]

% A continuaci�n se calcula la carga de l�quido y el flujo de l�quido por
% medio de las ecuaciones presentadas por Mackowiak (10):

rho1 = density(2,:);                                               % [g/mL]
rho3 = density(1,:);                                               % [g/mL]
viscosity = viscosidad2(x,T,PM1,PM3,rho3,rho1,rho);             % [kg/(m*s)]
mu = viscosity(3,:);                                           % [kg/(m*s)]
epsilon = 0.7; % Fracci�n vac�a del empaque [-]. Es un valor estimado a 
% partir de datos de anillos raschig de vidrio de 5 [mm] y de anillos ras-
% chig de metal de 6 [mm] (no se encontraron datos para 5 [mm]), conside-
% rando que el empaque utilizado es una mezcla entre anillos raschig de vi-
% % drio de 5 [mm] y resortes de cobre de 5 [mm] de largo.
% for i=1:length(hL)
%     if hL(i)<0
%     hL(i)=0.0001;
%     end
% end

uL = ((hL.^3*g^1.2.*(rho*1000).^0.7)./(12*1.094^2*a^1.9*mu.^0.7)).^(1/1.7);  % [m/s] 
L = (uL.*rho*S./PMprom)*1e6;                                        % [mol/s]