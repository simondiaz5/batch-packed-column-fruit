clc
clear all
close all

% p=[5.9663    0.5111    0.5231   19.9758 0.039604473495884] % problem 1, corrida 4 daba NaN -> condiciòn inicial loop [0 -1]
% p=[0.5000    0.8166    0.9983   13.3296 0.039604473495884] % problem 2, continua molestando. -> try catch
% p= [5.9997    0.4824    0.9982*1.5   19.9998 0.039604473495884*1.2] % Resultado todas calibrando
% p=[5.9994    0.9991    1.0000   19.9977]



% Resultados 3 duplicados  (ub 30 y 0.055)  / Max eval 50 / ndiverse 10 / 0.
% x0 res 1  [2 3  8 9]  - Pesos 0.9 y 0.1
p_nom=[5.582810105642534,0.853310648588036,0.305660802905230,30,0.043142717739935];
index_140=[2 4];  % 1 y 3 malo
index_200=[5 7];  % 6 malo
index_250=[8 9];  % 10 malo

% Resultados 3 duplicados  (ub 30 y 0.055)  / Max eval 20 / ndiverse 4 / 0.
% x0 res 1  [2 3  8 9]  - Pesos 0.75 y 0.25
% p=[0.986637086072208,0.387382817887436,0.291462567039008,17.464766724876434,0.054746396931041];
% index_140=[2 4];  % 1 y 3 malo
% index_200=[5 7];  % 6 malo
% index_250=[8 9];  % 10 malo

% Resultados 2refinando 1800 (ub 30 y 0.055)  / Max eval 20 / ndiverse 4 /
% x0 res 1  [1 2 3  8 9 10]
% p=[5.870098814691025,0.945974882169374,0.299225083008035,27.136162871996120,0.049183081954976];

% Resultados 1 primera 1575 seg (ub 25 y 0.05)   / Max eval 10 / ndiverse 4 
%   [1 2 3  8 9 10]
% p=[5.99109584947065,0.940876045345408,0.294413959280291,22.2740189203686,0.0497364205218805];
load('destilaciones_qcte')

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

dist_index=[ index_200 ];

opts = simset('SrcWorkspace','current','DstWorkspace','current');


p_bajo=p_nom.*ones(5,5);
p_sobre=p_nom.*ones(5,5);


%Nominal, 2 curvas (para todos el mismo)
%Experimental, 2 curvas (para todos el mismo)

% Bucle por parámetro
for ip=1:5
p_bajo(ip,ip)=p_bajo(ip,ip)*0.9;
p_sobre(ip,ip)=p_sobre(ip,ip)*1.1;
end


% Bucle for para correr las destilaciones nominales
for i=1:length(dist_index)
    [1 i]
    p=p_nom;
    Mcp_c=p(1);Phi_ef=  p(2);Eff_area=p(3);Q_loss=  p(4);x0_ini(2)=p(5);
    dist_exp(i)=destilaciones(dist_index(i)); % aux. matriz de datos exp.
    T_fin=dist_exp{i}(end,2)*60;              % aux. tiempo final destilación exp.
    T_vector=dist_exp{i}(:,2);                % aux. vector tiempo exp.
    Tin=(dist_exp{i}(:,3));               % aux. promedio temp in exp.
    Fc=dist_exp{i}(:,7);
    simout{i}=sim('destilador_14b',[0 T_fin],opts,[]);
    data_n_rs=resample(simout{i}.yout{1}.Values,T_vector*60);
    dist_model{i}=data_n_rs.Data(:,:);
end

% Bucle for para correr las destilaciones param -10% (BAJO)
for ip=1:5
    for i=1:length(dist_index)
        [2 ip i]
        p=p_bajo(ip,:);
        Mcp_c=p(1);Phi_ef=  p(2);Eff_area=p(3);Q_loss=  p(4);x0_ini(2)=p(5);
        dist_exp(i)=destilaciones(dist_index(i)); % aux. matriz de datos exp.
        T_fin=dist_exp{i}(end,2)*60;              % aux. tiempo final destilación exp.
        T_vector=dist_exp{i}(:,2);                % aux. vector tiempo exp.
        Tin=(dist_exp{i}(:,3));               % aux. promedio temp in exp.
        Fc=dist_exp{i}(:,7);
        simout{i}=sim('destilador_14b',[0 T_fin],opts,[]);
        data_n_rs=resample(simout{i}.yout{1}.Values,T_vector*60);
        dist_model_bajo{i,ip}=data_n_rs.Data(:,:);
    end
end

% Bucle for para correr las destilaciones param +10% (SOBRE)
for ip=1:5
    for i=1:length(dist_index)
        [3 ip i]
        p=p_sobre(ip,:);
        Mcp_c=p(1);Phi_ef=  p(2);Eff_area=p(3);Q_loss=  p(4);x0_ini(2)=p(5);
        dist_exp(i)=destilaciones(dist_index(i)); % aux. matriz de datos exp.
        T_fin=dist_exp{i}(end,2)*60;              % aux. tiempo final destilación exp.
        T_vector=dist_exp{i}(:,2);                % aux. vector tiempo exp.
        Tin=(dist_exp{i}(:,3));               % aux. promedio temp in exp.
        Fc=dist_exp{i}(:,7);
        simout{i}=sim('destilador_14b',[0 T_fin],opts,[]);
        data_n_rs=resample(simout{i}.yout{1}.Values,T_vector*60);
        dist_model_sobre{i,ip}=data_n_rs.Data(:,:);
    end
end

% save sens_01.mat


close all
figure (1)
lw1=0.5;
lw2=1.25;
lw3=0.75;

big_titles={'{\it M^\prime_s_h_e_l_l·Cp_s_h_e_l_l}','\phi_m_a_s_s','\phi_h_e_a_t','{\it Q^\prime_l_o_s_s}','{\it x_1_b_,_i_n_i}'}; %_1_b_,_i_n_

va=[1 2 3 4 5];
vb=[6 7 8 9 10];
figure(1)
for ip=1:5 % graficar los 5 paràmetros
       for i=1:length(dist_index)
            subplot(2,5,va(ip))
%                 plot(dist_exp{i}(20:end,2)/60,dist_exp{1,i}(20:end,6),'--','Linewidth',lw1,'Color','r'); hold on  
                plot(dist_exp{i}(20:end,2)/60,dist_model_sobre{i,ip}(20:end,1),'Linewidth',lw3,'Color','r'); hold on
                plot(dist_exp{i}(20:end,2)/60,dist_model{1,i}(20:end,1),'Linewidth',lw2,'Color','k'); hold on
                plot(dist_exp{i}(20:end,2)/60,dist_model_bajo{i,ip}(20:end,1),'Linewidth',lw3,'Color','b')
            
            ylabel('{\it A_d} (%v/v)')
            xlabel('Time (h)')
            title(big_titles(ip),'fontweight','bold','fontsize',10)
            grid on

            subplot(2,5,vb(ip))
%                 plot(dist_exp{i}(20:end,2)/60,dist_exp{1,i}(20:end,4),'--','Linewidth',lw1,'Color','r'); hold on 
                plot(dist_exp{i}(20:end,2)/60,dist_model_sobre{i,ip}(20:end,8),'Linewidth',lw3,'Color','r'); hold on
                plot(dist_exp{i}(20:end,2)/60,dist_model{1,i}(20:end,8),'Linewidth',lw2,'Color','k'); hold on
                plot(dist_exp{i}(20:end,2)/60,dist_model_bajo{i,ip}(20:end,8),'Linewidth',lw3,'Color','b')

            ylabel('{\it T_w_,_o_u_t}  (ºC)')
            xlabel('Time (h)')
            grid on
    
       end
       
end

% legend('+10%','nominal','-10%')
% legend('Location','best')
% sgtitle('Parameter Sensibility - Validation Distillations Qcte 200W ')
grid on
set(gcf,'color','white')
                set(gcf,'Position',[251,311,1174,449])  

