function [x_dot,y] = fun_f_h(x,u,p,x0)
Fr     = u(1);   % Flow refrigerant 
Tr     = u(2);   % Temperature refrigerant inlet
Qb     = u(3);   % Heating power boiler

x1c=x(end-1);  % implicit variable - liquid molar fraction ethanol condenser
Tout=x(end); % implicit variable - Temperature outlet coil condenser

phi_ef = p(1);
Mcp_c=p(2)*50000;
Eff_area=p(3);
UA=p(4);
UAc=p(5);
Tamb=273.15+20; % Temperatura ambiental

N=7;  % stages
No=6; % Aditional stat for output calculation
Ds = 2.047*2.54/100;                                                      % [m]
S = 0.25*pi*Ds^2;                                                   % [m^2]
ap = phi_ef*771; % Nominal, 0.83                                 % [m^2/m^3]                          
l = 0.25;                                                             % [m]
mr = 1933*5/8;                                                         % [g]                         
mrp = mr/l;                                                         % [g/m]
PM_EtOH = 46.07;                                                  % [g/mol]
PM_MetOH = 32.04;                                                 % [g/mol]
PM_H2O = 18.016;                                                  % [g/mol]
CM = 1.130;                                                           % [-]                                   
g = 9.8;                                                          % [m/s^2]
cpr = 0.474;                                                   % [J/(gr*K)]
Ta = 298.45;                                                          % [K]

z = linspace(0,l,N);
dz = z(2)-z(1);

% Luego se leen los estados con el fin de simplificarlo:
Mb = x(1);
x1b = x(2);
x2b = x(3);

M =x(4+0:4:4*N+0);
x1=x(4+1:4:4*N+1);
x2=x(4+2:4:4*N+2);
T =x(4+3:4:4*N+3);


% A continuación se presentan las ecuaciones algebraicas del modelo:
L= flujo_liquido2(M,x1,T,PM_EtOH,PM_H2O,g,ap,S); %vector flujo liquidoç
h = (55.678*x1+75.425).*T-15208.44*x1-20602.34; %vector de entalpía liquida

% Etapa 5: Presentaci?n de las propiedades del re-hervidor:
coef_num_y_eq=[1220 -735.1 1220 1.498];
coef_den_y_eq=[1 54.93 1538 113];
y1b = polyval(coef_num_y_eq,x1b)/polyval(coef_den_y_eq,x1b);

Tb = (374.1+5855*x1b)/(1+16.65*x1b+0.1086*x1b^2);
y2b = equil2x(x1b,x2b,Tb);
hb = (55.678*x1b+75.425)*Tb-15208.44*x1b-20602.34;
Hb = 36172.03-2919.83*y1b+(31.461-11.976*y1b)*Tb+(4.063e-4+0.0734*y1b)*Tb^2;
dhbdx1b = 55.678*Tb-15208.44;
dhbdTb = 55.678*x1b+75.425;
dTbdx1b = (5855*(1+16.65*x1b+0.1086*x1b^2)-(374.1+5855*x1b)*(16.65+0.2172*x1b))/((1+16.65*x1b+0.1086*x1b)^2);
Qp = -190.45051+0.027736447*Tb^1.5-0.00069779137*Ta^2+(31705.067/Ta); % [W]
Qbe = Qb-Qp;                                                          % [W]
Vb = (L(1)*((h(1)-hb)+(dhbdx1b+dhbdTb*dTbdx1b)*(x1b-x1(1)))+Qbe)/((dhbdx1b+dhbdTb*dTbdx1b)*(x1b-y1b)+(Hb-hb));



y1_1 = -0.00029699079694785408*T.^3+0.31993865536139598*T.^2-114.90802529355385*T+13759.682820348055;
y1_2 = -0.033707692307692737*T+12.59634076923092;
sigma=1./(1+exp(-(T-362.15)/1));
y1=(1-sigma).*y1_1+sigma.*y1_2;


x1i = 1./(400*y1.^4-1299*y1.^3+1586*y1.^2-865*y1+179.6);

param = [N PM_EtOH PM_H2O CM ap S g Qb dz 1 mrp cpr Ta]; % Unidades varias.

% Una vez hecho esto se inicializan las variables de flujo molar de vapor
% que sale de cada etapa, coeficientes de transferencia de masa, presi?n de
% vapor del metanol, coeficiente de actividad de ?ste en fase l?quida, u-
% tilizando el modelo de coeficiente de actividad NRTL. Adem?s se definen
% la fracci?n molar de metanol en el vapor y entalp?a de dicha fase,

k13aef = zeros(1,N);
V = zeros(1,N);
k21aef = zeros(1,N);
k23aef = zeros(1,N);
keqaef = zeros(1,N);
P2vap = zeros(1,N);
gama2 = zeros(1,N);
y2 = zeros(1,N);
H = zeros(1,N);

% (FIN DEL PARENTESIS)

Kaef = transf_masa2(x1(1),L(1),T(1),param);
k13aef(1) = Kaef(1,1);
V(1) = ((y1(1)*Vb/dz)+param(10)*S*k13aef(1)*(x1(1)-x1i(1)))/((2*y1(1)-y1b)/dz);
k21aef(1) = Kaef(1,2);
k23aef(1) = Kaef(1,3);
keqaef(1) = (k23aef(1)*k21aef(1)/(x1(1)*k23aef(1)+(1-x1(1))*k21aef(1)));
equil = equilibrio(x1i(1),T(1));
P2vap(1) = equil(1,1);
gama2(1) = equil(1,2);
y2(1) = ((V(1)*y2b/dz)+param(10)*S*keqaef(1)*x2(1))/(((2*V(1)-Vb)/dz)+(param(10)*S*keqaef(1)*101.325/(P2vap(1)*gama2(1))));
H(1) = 36172.03-2919.83*y1(1)+(31.461-11.976*y1(1))*T(1)+(4.063e-4+0.0734*y1(1))*T(1)^2;


for i = 2:N
    Kaef = transf_masa2(x1(i),L(i),T(i),param);
    k13aef(i) = Kaef(1,1);
    V(i) = ((y1(i)*V(i-1)/dz)+param(10)*S*k13aef(i)*(x1(i)-x1i(i)))/((2*y1(i)-y1(i-1))/dz);
    k21aef(i) = Kaef(1,2);
    k23aef(i) = Kaef(1,3);
    keqaef(i) = (k23aef(i)*k21aef(i)/(x1(i)*k23aef(i)+(1-x1(i))*k21aef(i)));
    equil = equilibrio(x1i(i),T(i));
    P2vap(i) = equil(1,1);
    gama2(i) = equil(1,2);
    y2(i) = ((V(i)*y2(i-1)/dz)+param(10)*S*keqaef(i)*x2(i))/(((2*V(i)-V(i-1))/dz)+(param(10)*S*keqaef(i)*101.325/(P2vap(i)*gama2(i))));
    H(i) = 36172.03-2919.83*y1(i)+(31.461-11.976*y1(i))*T(i)+(4.063e-4+0.0734*y1(i))*T(i)^2;
end

    Hn = 36172.03-2919.83*y1(N)+(31.461-11.976*y1(N))*T(N)+(4.063e-4+0.0734*y1(N))*T(N)^2; % [J/mol]
    yD = polyval(coef_num_y_eq,x1c)/polyval(coef_den_y_eq,x1c);
    R = (yD-y1(N))/(y1(N)-x1c);                                              % [-]
    Lc = V(N)/(1+(1/R));                                             % [mol/s]
    Tc = (374.1+5855*x1c)/(1+16.65*x1c+0.1086*x1c^2);                    % [K]
    equil = equilibrio(x1c,Tc);                          % [Unidades varias]                               
    P2vap = equil(1,1);                                             % [kPa]                                                
    gama2 = equil(1,2);                                               % [-]
    x2c = V(N)*y2(N)/(Lc*(1+(P2vap*gama2/(101.325*R))));                    % [-]
    hc = (55.678*x1c+75.425)*Tc-15208.44*x1c-20602.34;              % [J/mol]
    HD = 36172.03-2919.83*yD+(31.461-11.976*yD)*Tc+(4.063e-4+0.0734*yD)*Tc^2; % [J/mol]
% Finalmente se presentan las ecuaciones diferenciales del modelo:
x_dot=zeros(4*N+No,1);

x_dot(1) = L(1)-Vb;
x_dot(2) = (1/Mb)*(L(1)*(x1(1)-x1b)-Vb*(y1b-x1b));
x_dot(3) = (1/Mb)*(L(1)*(x2(1)-x2b)-Vb*(y2b-x2b));
x_dot(4) = ((L(2)-L(1))/dz)+((Vb-V(1))/dz);
x_dot(5) = (1/M(1))*(L(1)*((x1(2)-x1(1))/dz)+V(1)*((y1b-y1(1))/dz)+(x1(1)-y1(1))*((V(1)-Vb)/dz));
x_dot(6) = (1/M(1))*(L(1)*((x2(2)-x2(1))/dz)+V(1)*((y2b-y2(1))/dz)+(x2(1)-y2(1))*((V(1)-Vb)/dz));
x_dot(7) = ((Mcp_c+mrp*cpr+M(1)*(55.678*x1(1)+75.425))^-1)*(-(UA*(T(1)-Tamb))/dz+L(1)*((h(2)-h(1))/dz)+V(1)*((Hb-H(1))/dz)+(h(1)-H(1))*((V(1)-Vb)/dz)-(55.678*T(1)-15208.44)*(L(1)*((x1(2)-x1(1))/dz)+V(1)*((y1b-y1(1))/dz)+(x1(1)-y1(1))*((V(1)-Vb)/dz)));
for i = 2:(N-1)
    x_dot(4*i) = ((L(i+1)-L(i))/dz)+((V(i-1)-V(i))/dz);
    x_dot(4*i+1) = (1/M(i))*(L(i)*((x1(i+1)-x1(i))/dz)+V(i)*((y1(i-1)-y1(i))/dz)+(x1(i)-y1(i))*((V(i)-V(i-1))/dz));
    x_dot(4*i+2) = (1/M(i))*(L(i)*((x2(i+1)-x2(i))/dz)+V(i)*((y2(i-1)-y2(i))/dz)+(x2(i)-y2(i))*((V(i)-V(i-1))/dz));
    x_dot(4*i+3) = ((Mcp_c+mrp*cpr+M(i)*(55.678*x1(i)+75.425))^-1)*(-(UA*(T(i)-Tamb))/dz+L(i)*((h(i+1)-h(i))/dz)+V(i)*((H(i-1)-H(i))/dz)+(h(i)-H(i))*((V(i)-V(i-1))/dz)-(55.678*T(i)-15208.44)*(L(i)*((x1(i+1)-x1(i))/dz)+V(i)*((y1(i-1)-y1(i))/dz)+(x1(i)-y1(i))*((V(i)-V(i-1))/dz)));
end
x_dot(4*N) = ((Lc-L(N))/dz)+((V(N-1)-V(N))/dz);
x_dot(4*N+1) = (1/M(N))*(L(N)*((x1c-x1(N))/dz)+V(N)*((y1(N-1)-y1(N))/dz)+(x1(N)-y1(N))*((V(N)-V(N-1))/dz));
x_dot(4*N+2) = (1/M(N))*(L(N)*((x2c-x2(N))/dz)+V(N)*((y2(N-1)-y2(N))/dz)+(x2(N)-y2(N))*((V(N)-V(N-1))/dz));
x_dot(4*N+3) = ((Mcp_c+mrp*cpr+M(N)*(55.678*x1(N)+75.425))^-1)*(-(UA*(T(N)-Tamb))/dz+L(N)*((hc-h(N))/dz)+V(N)*((H(N-1)-H(N))/dz)+(h(N)-H(N))*((V(N)-V(N-1))/dz)-(55.678*T(N)-15208.44)*(L(N)*((x1c-x1(N))/dz)+V(N)*((y1(N-1)-y1(N))/dz)+(x1(N)-y1(N))*((V(N)-V(N-1))/dz)));

% Se procede a calcular el volumen de destilado que es retirado del siste-
% ma:
destil = destilado(V(N),y1(N),y2(N),Lc,x1c,x2c,PM_EtOH,PM_H2O);
GL=destil(1,1);
Dvol=destil(1,2);
%     salida = [GL Dvol D_EtOH D_MEtOH D_H2O];  

x_dot(4*N+4) = destil(1,3);  %33  D_EtOH
x_dot(4*N+5) = destil(1,4);  %34  D_MEtOH
x_dot(4*N+6) = destil(1,5);  %34  D_H2O
% x_dot(4*N+7)= (GL-GL_m)/(7.35/Dvol);    %40 Eq. dif sensor, cte tiempo: V/Dvol (seg)

N_et=x(4*N+4);
N_met=x(4*N+5);
N_w=x(4*N+6);

%% Output variables calculation
x1_ac=N_et/(N_et+N_met+N_w) ; % Ethanol mole fraction destilate drum
x2_ac=N_met/(N_et+N_met+N_w); % Methanol mole fraction distilate drum
dens_ac = densidad(x1_ac,293.15,PM_EtOH,PM_H2O); 
rho_1ac=dens_ac(1,2); % pure alcohol density in destialte drum
rho_13ac=dens_ac(1,3); % solution density in destialte drum
Mt=N_et*PM_EtOH+N_met*PM_MetOH+N_w*PM_H2O;
% rho_methanol=0.789; % Density of pure methanol 20°C
Cmet=x2_ac*PM_MetOH*1000/(x1_ac*(1/rho_1ac)*PM_EtOH);
GL_ac=x1_ac*(PM_EtOH/(PM_EtOH*x1_ac+PM_MetOH*x2_ac+PM_H2O*(1-x1_ac-x2_ac)))*(1/rho_1ac)*100/(1/rho_13ac);
Rec_eth=N_et*100/(x0(1)*x0(2));
Rec_met=N_met*100/(x0(1)*x0(3));

y=zeros(1,12);
y(1) = 0;   %35  GL
y(2)=GL;
y(3)=GL_ac;  %mL/s  Volumetric flow
y(4) =Tc;    %36  Tc
y(5) =Tb;    %37  
y(6) =x1c;   %38
y(7) =x2c;    %39
y(8)=Cmet;   %g/L a.a.
y(9)=Rec_eth;   %Ethanol molar flow mol/s
y(10)=Rec_met;   %Methanol molar flow mol/s
y(11)=Mt*rho_13ac/1000 ; % Destilate volumen  L
y(12)=Dvol; %mL/min Flow distillate

  
%% Partial Condenser Tube-side
% Tout  Implicit variable
    Qc_ef = V(N)*Hn-Lc*(hc+(HD/R));     % [W]
 

T_film = 0.5*(Tr+Tout)     ;                                         % [K]
% cp = 0.000008935*T_film^2-0.0054919213*T_film+5.0225997509;   % [kJ/(kg*K)]
mu = exp((-9.108111-(753.33377/T_film)+(410019.22/(T_film^2))));   % [Pa*s]
k = -0.000008072*T_film^2+0.006348737*T_film-0.5649534949;      % [W/(m*K)]
Pr = exp((-8.9216883+0.00000062007495*T_film^2.5+(2915.8766/T_film))); % [-]

% ... y de la temperatura de la pared.

mu_s = exp((-9.108111-(753.33377/Tc)+(410019.22/(Tc^2))));         % [Pa*s]

% Ahora se procede a calcular las condiciones para el número de Nusselt, 
% antes se presentan los parámetros geométricos del serpentín:

As = Eff_area*157.4776*(0.01^2);                                                  % [m^2]
do = 0.008;                                                           % [m]
di=0.007;
Long = As/(pi*do);                                                       % [m]

rho_def = -0.00295*(Tr)^2+1.45738*(Tr)+824.9622;

m = Fr*rho_def*(1/(60*1000*1000) );                                     % [kg/s]

Re = (4*m)/(pi*di*mu);                                                % [-]
Gz_mod = ((Re*Pr/(Long/do)))^(1/3)*((mu/mu_s))^(0.14);                   % [-]                                           
if (Re < 10000) && (Gz_mod < 2)
    Nu = 3.66;                                                        % [-]
elseif (Re < 10000) && (Gz_mod >= 2)
    Nu = 1.86*Gz_mod;                                              % [-]
else
    Nu = 0.027*Re^(4/5)*Pr^(1/3)*(mu/mu_s)^(0.14);                % [-]

end

% Tras esto se calcula el coeficiente de transferencia de calor para el
% flujo refrigerante:

h_conv = k*Nu/do;                                                  % [W/(m^2*K)]
                                              % [W]

 
cp_def = 0.000008935*(0.5*(Tr+Tout))^2-0.0054919213*(0.5*(Tr+Tout))+5.0225997509; % [kJ/(kg*K)]


% Qc= Fr*(1/(60*1000)) *rho_def* cp_def * (Tout-Tr) ;
%     
% 
% h=zeros(2,1);
% h(1)= ((Qc-Qc_ef)/Qc)^2;  % Implicit equation 1
% h(2)= ((Tout-(Tc-(Tc-Tr)*exp((- h_conv*As)/(Fr*(1/(60*1000)) *rho_def* cp_def))))/Tout)^2 ; % Implicit equation 2  


Qc= Fr*(1/(60*1000)) *rho_def* cp_def * (Tout-Tr)+UAc*(Tc-Tamb) ;
    
h=zeros(2,1);
h(1)= ((Qc-Qc_ef)/Qc)^1;  % Implicit equation 1
h(2)= ((Tout-(Tc-(Tc-Tr)*exp((- h_conv*As*(Tout-Tr))/(Fr*(1/(60*1000)) *rho_def* cp_def*(Tout-Tr)+UAc*(Tc-Tamb)))))/Tout)^1 ; % Implicit equation 2 

x_dot=[x_dot;h];
