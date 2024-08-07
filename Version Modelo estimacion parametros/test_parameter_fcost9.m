function test_parameter_fcost9(p)
% p=[5.9663    0.5111    0.5231   19.9758 0.039604473495884] % problem 1, corrida 4 daba NaN -> condiciòn inicial loop [0 -1]
% p=[0.5000    0.8166    0.9983   13.3296 0.039604473495884] % problem 2, continua molestando. -> try catch
% p= [5.9997    0.4824    0.9982*1.5   19.9998 0.039604473495884*1.2] % Resultado todas calibrando
% p=[5.9994    0.9991    1.0000   19.9977]


p=[5.99109584947065,0.940875748235140,0.294413959280319,0.499999999999973,0.0497364205218838,2018,0.500000000000306;6.00890281588229,0.940791825164975,0.296176109605957,0.562522196939212,0.0497663855025632,2018.00012499488,0.548289547271803;5.38983788162671,0.580263090372408,0.856119020389810,0.191153343167985,0.0397955538854417,2225.62638937998,2.77197739721344;0.782876827016850,0.694452053945519,0.342412372847857,0.363201162376701,0.0549255848877220,1812.97538237553,0.0690882410890013];
% p=[5.99109584947065,0.940876045345408,0.294413959280291,22.2740189203686,0.0497364205218805 2018]; % x0 para 3

%Resultados 4 0,9
% p=[5.582810105642534,0.853310648588036,0.305660802905230,30,0.043142717739935];
% Resultados 3 duplicados  (ub 30 y 0.055)  / Max eval 20 / ndiverse 4 /
% x0 res 1  [2 3  8 9]

% Resultados 2refinando 1800 (ub 30 y 0.055)  / Max eval 20 / ndiverse 4 /
% x0 res 1  [1 2 3  8 9 10]
% p=[5.870098814691025,0.945974882169374,0.299225083008035,27.136162871996120,0.049183081954976];

% Resultados 1 primera 1575 seg (ub 25 y 0.05)   / Max eval 10 / ndiverse 4 
%   [1 2 3  8 9 10]
% p=[5.99109584947065,0.940876045345408,0.294413959280291,22.2740189203686,0.0497364205218805];
load('destilaciones_fr_step2')

%% Setting initial condition vector - Simulink integrator
load('X0_ini_ev') %% 6/7/2018 20:06 cond_inicialx0.m % Cmet=1.5; % V=40; % GA=13; % N=21;
x0_ini2=x0_ini;N=7;No=6;  x0_ini=zeros(4*N+No,1);
x0_ini(1)=x0_ini2(1);x0_ini(2)=x0_ini2(2);x0_ini(3)=x0_ini2(3);
for J=1:N
  x0_ini(4*J+0)=(x0_ini2(4*J+0+8*(J-1))+x0_ini2(4*J+4+8*(J-1))+x0_ini2(4*J+8+8*(J-1)))/3;
  x0_ini(4*J+1)=(x0_ini2(4*J+1+8*(J-1))+x0_ini2(4*J+5+8*(J-1))+x0_ini2(4*J+9+8*(J-1)))/3+0.01;
  x0_ini(4*J+2)=(x0_ini2(4*J+2+8*(J-1))+x0_ini2(4*J+6+8*(J-1))+x0_ini2(4*J+10+8*(J-1)))/3;
  x0_ini(4*J+3)=(x0_ini2(4*J+3+8*(J-1))+x0_ini2(4*J+7+8*(J-1))+x0_ini2(4*J+11+8*(J-1)))/3;
end
b=2;a=1;
x_min=[1767.71545621850;0.00799041062661984;3.41060000832915e-05;0.740207193810922;0.00799041062661984;3.41060000832915e-05;352.310691243690;0.740207193810922;0.00799041062661984;3.41060000832915e-05;352.310691243690;0.740207193810922;0.00799041062661984;3.41060000832915e-05;352.310691243690;0.740207193810922;0.00799041062661984;3.41060000832915e-05;352.310691243690;0.740207193810922;0.00799041062661984;3.41060000832915e-05;352.310691243690;0.740207193810922;0.00799041062661984;3.41060000832915e-05;352.310691243690;0.740207193810922;0.00799041062661984;3.41060000832915e-05;352.310691243690;0;0;0];
x_max=[2018.07587071285;0.624753322576231;0.000637824871562298;1.30537895369255;0.624753322576231;0.000637824871562298;371.461866693347;1.30537895369255;0.624753322576231;0.000637824871562298;371.461866693347;1.30537895369255;0.624753322576231;0.000637824871562298;371.461866693347;1.30537895369255;0.624753322576231;0.000637824871562298;371.461866693347;1.30537895369255;0.624753322576231;0.000637824871562298;371.461866693347;1.30537895369255;0.624753322576231;0.000637824871562298;371.461866693347;1.30537895369255;0.624753322576231;0.000637824871562298;371.461866693347;65.8799169826809;0.143158013086597;184.381691331991];
x_range=[250.360414494350;0.616762911949612;0.000603718871479006;0.565171759881627;0.616762911949612;0.000603718871479006;19.1511754496572;0.565171759881627;0.616762911949612;0.000603718871479006;19.1511754496572;0.565171759881627;0.616762911949612;0.000603718871479006;19.1511754496572;0.565171759881627;0.616762911949612;0.000603718871479006;19.1511754496572;0.565171759881627;0.616762911949612;0.000603718871479006;19.1511754496572;0.565171759881627;0.616762911949612;0.000603718871479006;19.1511754496572;0.565171759881627;0.616762911949612;0.000603718871479006;19.1511754496572;65.8799169826809;0.143158013086597;184.381691331991];
x_ss=0.5*(x_max+x_min);
x0_ini(4*N+3+1:4*N+No-1)=0;  % estados auxiliares 

ini_ode.x0_ini=x0_ini;
ini_ode.a=a;
ini_ode.b=b;
ini_ode.x_range=x_range;
ini_ode.x_ss=x_ss;

%% Desde Aquì copiar o hacer funciòn para test

% Parameters
% Mcp_c=4;
% Phi_ef=0.70;
% Eff_area=0.2;  %mL volumen
% Q_loss=15; % watt

% Entrada constante
Qb=1000;        % Potencia calefacciòn boiler W
m_s=10; % Primeros puntos descartados
m_f=10; % Ultimos puntos descartados

dist_index=[1 2 3 4];

% Parametros

opts = simset('SrcWorkspace','current','DstWorkspace','current');


% Bucle for para correr las destilaciones
for i=1:length(dist_index)
    Mcp_c=   p(i,1);  % Cp*m metal
    Phi_ef=  p(i,2);  % Factor eficiencia area transf. masa
    Eff_area=p(i,3);  % Factor eficiencia area transf. calor
    UA=  p(i,4);  % watt
    x0_ini(2)=p(i,5); % Valor inicial etanol boiler
    x0_ini(1)=p(i,6); % Valor inicial etanol boiler
    UAc=p(i,7);
    dist_exp(i)=destilaciones3(dist_index(i)); % aux. matriz de datos exp.
    T_fin=dist_exp{i}(end,2)*60;              % aux. tiempo final destilación exp.
    T_vector=dist_exp{i}(:,2);                % aux. vector tiempo exp.
    Tin=(dist_exp{i}(:,3));               % aux. promedio temp in exp.
    Fc=dist_exp{i}(:,7);
    % Ejecutar simulación desde simulink
    simout{i}=sim('destilador_14c',[0 T_fin],opts,[]);
    % Extracción y re-muestreo según tiempo experimental
    data_n_rs=resample(simout{i}.yout{1}.Values,T_vector*60);
    dist_model{i}=data_n_rs.Data(:,:);

    Jy(i)=sum(((dist_exp{i}(m_s:end-m_f,6)-dist_model{i}(m_s:end-m_f,1))./max(dist_exp{i}(m_s:end-m_f,6))).^2)
    Ju(i)=sum(((dist_exp{i}(m_s:end-m_f,4)-dist_model{i}(m_s:end-m_f,8))./max(dist_exp{i}(m_s:end-m_f,4))).^2)
end

close all
figure (1)
% titles={{'Distillation #1','Validation'},{'Distillation #2','Validation'},{'Distillation #3','Validation'},{'Distillation #4','Validation'}};
% titles={{'Distillation #1','Calibration'},{'Distillation #2','Calibration'},{'Distillation #3','Calibration'},{'Distillation #4','Calibration'}};
titles={{'Distillation #1'},{'Distillation #2'},{'Distillation #3'},{'Distillation #4'}};
lw1=0.5;
lw2=1;
 v_a=[1 2 3 4];
 v_f=[5 6 7 8];
 v_t=[9 10 11 12];
 figure(1)
 for i=1:4
    m_f=round(length(dist_exp{i}(:,2))*3/4,0);
    
    subplot(3,4,v_a(i))  % 1 2 3 4
    plot(destilaciones3{i}(1:end,2)/60,destilaciones3{1,i}(1:end,6),'--','Linewidth',lw1); hold on
    plot(dist_exp{i}(1:m_f,2)/60,dist_model{1,i}(1:m_f,1),'Linewidth',lw2)
    plot(dist_exp{i}(m_f:end,2)/60,dist_model{1,i}(m_f:end,1),'Linewidth',lw2)
    title(titles{i})
    legend('exp','calibration','validation')
    ylabel('Aº_d (%v/v)')
    xlabel('Time (h)')
    grid on
    
    subplot(3,4,v_f(i)) % 5 6 7 8
    plot(destilaciones3{i}(1:end,2)/60,destilaciones3{1,i}(1:end,7),'--','Linewidth',lw1); hold on 
    plot(dist_exp{i}(1:end,2)/60,dist_model{1,i}(1:end,7),'Linewidth',lw2)
    legend('exp','model')
    ylabel('F_c (mL/min)')
    xlabel('Time, h')
    
    subplot(3,4,v_t(i)) % 5 9 10 11 12
    plot(destilaciones3{i}(1:end,2)/60,destilaciones3{1,i}(1:end,4),'--','Linewidth',lw1) ; hold on
    plot(dist_exp{i}(1:m_f,2)/60,dist_model{1,i}(1:m_f,8),'Linewidth',lw2)
    plot(dist_exp{i}(m_f:end,2)/60,dist_model{1,i}(m_f:end,8),'Linewidth',lw2)
    legend('exp','calibration','validation')
    ylabel('T_o_u_t (ºC)')
    xlabel('Time, h')
    grid on
    
    grid on
 end
 sgtitle('Destilaciones experimentales 1000W - Escalones Q removido')
 set(gcf,'color','white')
                     
J=sum(Jy)*0.95+sum(Ju)*0.05
