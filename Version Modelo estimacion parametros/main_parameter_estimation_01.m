function main_parameter_estimation_01
clear all
clc
close all
%% Condiciones iniciales
load('X0_ini_ev') %% 6/7/2018 20:06 cond_inicialx0.m % Cmet=1.5; % V=40; % GA=13; % N=21;
load('destilaciones_qcte')



%% Setting initial condition vector
x0_ini2=x0_ini;
N=7;
No=6;  %ecuaciones externas BMyE columna  
x0_ini=zeros(4*N+No,1);
x0_ini(1)=x0_ini2(1);
x0_ini(2)=x0_ini2(2);
x0_ini(3)=x0_ini2(3);
for J=1:N
  x0_ini(4*J+0)=(x0_ini2(4*J+0+8*(J-1))+x0_ini2(4*J+4+8*(J-1))+x0_ini2(4*J+8+8*(J-1)))/3;
  x0_ini(4*J+1)=(x0_ini2(4*J+1+8*(J-1))+x0_ini2(4*J+5+8*(J-1))+x0_ini2(4*J+9+8*(J-1)))/3+0.01;
  x0_ini(4*J+2)=(x0_ini2(4*J+2+8*(J-1))+x0_ini2(4*J+6+8*(J-1))+x0_ini2(4*J+10+8*(J-1)))/3;
  x0_ini(4*J+3)=(x0_ini2(4*J+3+8*(J-1))+x0_ini2(4*J+7+8*(J-1))+x0_ini2(4*J+11+8*(J-1)))/3;
end

b=2;
a=1;
x_min=[1767.71545621850;0.00799041062661984;3.41060000832915e-05;0.740207193810922;0.00799041062661984;3.41060000832915e-05;352.310691243690;0.740207193810922;0.00799041062661984;3.41060000832915e-05;352.310691243690;0.740207193810922;0.00799041062661984;3.41060000832915e-05;352.310691243690;0.740207193810922;0.00799041062661984;3.41060000832915e-05;352.310691243690;0.740207193810922;0.00799041062661984;3.41060000832915e-05;352.310691243690;0.740207193810922;0.00799041062661984;3.41060000832915e-05;352.310691243690;0.740207193810922;0.00799041062661984;3.41060000832915e-05;352.310691243690;0;0;0];
x_max=[2018.07587071285;0.624753322576231;0.000637824871562298;1.30537895369255;0.624753322576231;0.000637824871562298;371.461866693347;1.30537895369255;0.624753322576231;0.000637824871562298;371.461866693347;1.30537895369255;0.624753322576231;0.000637824871562298;371.461866693347;1.30537895369255;0.624753322576231;0.000637824871562298;371.461866693347;1.30537895369255;0.624753322576231;0.000637824871562298;371.461866693347;1.30537895369255;0.624753322576231;0.000637824871562298;371.461866693347;1.30537895369255;0.624753322576231;0.000637824871562298;371.461866693347;65.8799169826809;0.143158013086597;184.381691331991];
x_range=[250.360414494350;0.616762911949612;0.000603718871479006;0.565171759881627;0.616762911949612;0.000603718871479006;19.1511754496572;0.565171759881627;0.616762911949612;0.000603718871479006;19.1511754496572;0.565171759881627;0.616762911949612;0.000603718871479006;19.1511754496572;0.565171759881627;0.616762911949612;0.000603718871479006;19.1511754496572;0.565171759881627;0.616762911949612;0.000603718871479006;19.1511754496572;0.565171759881627;0.616762911949612;0.000603718871479006;19.1511754496572;0.565171759881627;0.616762911949612;0.000603718871479006;19.1511754496572;65.8799169826809;0.143158013086597;184.381691331991];
x_ss=0.5*(x_max+x_min);

%Ajuste de estados auxiliares
x0_ini(4*N+3+1:4*N+No-1)=0;  % estados auxiliares 

ini_ode.x0_ini=x0_ini;
ini_ode.a=a;
ini_ode.b=b;
ini_ode.x_range=x_range;
ini_ode.x_ss=x_ss;

%% Test
% Mcp_c=4;
% Phi_ef=0.70;
% Eff_area=0.355;  %mL volumen
% Q_loss=15; % watt
% p=[Mcp_c Phi_ef Eff_area Q_loss];
% test_parameter_fcost(p)

%% Global Optimization
tic()
rng default % For reproducibility
gs = GlobalSearch('Display','iter');
lb=    [0.5 0.1 0.2    0 0.039604473495884];
ub=    [6    1   1    25 0.05];
x0_opt=[4   0.7 0.355 15 0.039604473495884]; % vector de param opt para exp
A=[];b=[];Aeq=[];beq=[];nonlcon=[];options_opt = optimoptions('fmincon','UseParallel',true,'ConstraintTolerance',1e-12);
problem = createOptimProblem('fmincon','x0',x0_opt,...
    'objective',@(p)fcost(p,destilaciones,ini_ode),'lb',lb,'ub',ub,...
    'options',options_opt);
[x_opt,fval] = run(gs,problem)
toc()
test_parameter_fcost(x_opt)

end

function J=fcost(p,destilaciones,ini_ode)

% Entrada constante
Qb=1000;        % Potencia calefacciòn boiler W
m_s=10; % Primeros puntos descartados
m_f=10; % Ultimos puntos descartados

Qc_v_total=[140 140 140 140 200 200 200 250 250 250];
dist_index=[1 9] ;
Qc_v=Qc_v_total(dist_index);
p
opts = simset('SrcWorkspace','current','DstWorkspace','current');

% Condicion inicial y normalización
x0_ini=ini_ode.x0_ini;
a=ini_ode.a;
b=ini_ode.b;
x_ss=ini_ode.x_ss;
x_range=ini_ode.x_range;

% Parametros
Mcp_c=   p(1);  % Cp*m metal
Phi_ef=  p(2);  % Factor eficiencia area transf. masa
Eff_area=p(3);  % Factor eficiencia area transf. calor
Q_loss=  p(4);  % watt
x0_ini(2)=p(5); % Valor inicial etanol boiler

% Bucle for para correr las destilaciones
for i=1:length(dist_index)
%     i
    Qc=Qc_v(i);
    dist_exp(i)=destilaciones(dist_index(i)); % aux. matriz de datos exp.
    T_fin=dist_exp{i}(end,2)*60;              % aux. tiempo final destilación exp.
    T_vector=dist_exp{i}(:,2);                % aux. vector tiempo exp.
    Tin=mean(dist_exp{i}(:,3));               % aux. promedio temp in exp.
    % Ejecutar simulación desde simulink
    try
        simout{i}=sim('destilador_14',[0 T_fin],opts,[]);
        % Extracción y re-muestreo según tiempo experimental
        data_n_rs=resample(simout{i}.yout{1}.Values,T_vector*60);
        dist_model{i}=data_n_rs.Data(:,:);
        Jy(i)=sum(((dist_exp{i}(m_s:end-m_f,6)-dist_model{i}(m_s:end-m_f,1))./max(dist_exp{i}(m_s:end-m_f,6))).^2);
        Ju(i)=sum(((dist_exp{i}(m_s:end-m_f,7)-dist_model{i}(m_s:end-m_f,7))./max(dist_exp{i}(m_s:end-m_f,7))).^2);
    catch
        Jy(i)=1e3;
        Ju(i)=1e3; 
    end
end

 
J=0.75*sum(Jy)+0.25*sum(Ju)
end
