clear all
clc
close all

load sens_01.mat

%% Matriz de residuos
m_s=1;
ResA{1}=dist_exp{1}(m_s:end,6)-dist_model{1}(m_s:end,1);
ResA{2}=dist_exp{2}(m_s:end,6)-dist_model{2}(m_s:end,1);
ResT{1}=dist_exp{1}(m_s:end,4)-dist_model{1}(m_s:end,8);
ResT{2}=dist_exp{2}(m_s:end,4)-dist_model{2}(m_s:end,8);

%% Residual Plot
% close all
figure (2)
lw1=1.25;
lw2=1.25;

%     plot(dist_exp{i}(20:end,2)/60,dist_exp{1,i}(20:end,4),'--','Linewidth',lw1,'Color',[(((1-0.5)/(2-1))*(1-1)+0.5) 0 0]); hold on 
%     plot(dist_exp{i}(20:end,2)/60,dist_model{1,i}(20:end,8),'Linewidth',lw2,'Color',[(((1-0.5)/(2-1))*(2-1)+0.5) 0 0]); hold on
    
%           for i=1:2
            subplot(2,1,1)
            i=1;plot(dist_exp{1}(1:end,2)/60,ResA{1}(1:end,1),'Linewidth',lw1,'Color',[0 (((1-0.5)/(2-1))*(1-1)+0.5) 0 ]); hold on  
            i=2;plot(dist_exp{2}(1:end,2)/60,ResA{2}(1:end,1),'Linewidth',lw2,'Color',[0 (((1-0.5)/(2-1))*(2-1)+0.5) 0 ]); hold on
            i=2;plot(dist_exp{1}(1:end,2)/60,0*ResA{1}(1:end,1),'Linewidth',1.5,'Color',[0 0 0]); hold on
%             title('Ethanol concentration, %v/v')
%     title({'Q_c = 200 W','Validation'})
    ylabel('Residual {\it A_d} (%v/v)')
    xlabel('Time (h)')
            grid on


            subplot(2,1,2)
            
            i=1;plot(dist_exp{1}(1:end,2)/60,ResT{1}(1:end,1),'Linewidth',lw1,'Color',[0 (((1-0.5)/(2-1))*(1-1)+0.5) 0 ]); hold on 
             i=2;plot(dist_exp{2}(1:end,2)/60,ResT{2}(1:end,1),'Linewidth',lw2,'Color',[0 (((1-0.5)/(2-1))*(2-1)+0.5) 0 ]); hold on
              i=2;plot(dist_exp{1}(1:end,2)/60,0*ResT{1}(1:end,1),'Linewidth',1.5,'Color',[0 0 0]); hold on
%              title('Oulet Coolant Temperature, ºC')
        ylabel('Residual {\it T_w_,_o_u_t} (ºC)')
    xlabel('Time (h)')
            grid on
%           end
         legend('Run #3','Run #4')
      legend('Location','best')
%                     end
%                      sgtitle('Residual Plots - Q_c = 200 W (Validation Runs)')
                     grid on
                     set(gcf,'color','white')
                     
%% Test Anderson_Darling

[hA(1),pA(1)]=adtest(ResA{1}(:,1));
display(pA(1),'P-Value {\it A_d} Run #3');
if hA(1) == 0
disp('Residuos normalmente distribuidos')
else
disp('Residuos no están normalmente distribuidos')
end


[hA(2),pA(2)]=adtest(ResA{2}(:,1));
display(pA(2),'P-Value {\it A_d} Run #4');
if hA(2) == 0
disp('Residuos normalmente distribuidos')
else
disp('Residuos no están normalmente distribuidos')
end

[hT(1),pT(1)]=adtest(ResT{1}(:,1));
display(pT(1),'P-Value {\it T_w_,_o_u_t} Run #3');
if hT(1) == 0
disp('Residuos normalmente distribuidos')
else
disp('Residuos no están normalmente distribuidos')
end

[hT(2),pT(2)]=adtest(ResT{2}(:,1));
display(pT(1),'P-Value {\it T_w_,_o_u_t} Run #4');
if hT(2) == 0
disp('Residuos normalmente distribuidos')
else
disp('Residuos no están normalmente distribuidos')
end
%% Gráficos de probabilidad normal

figure(3)

subplot(2,2,1); % Aª1
normplot(ResA{1}(:,1))
xlabel('Residual {\it A_d} Run #3'); ylabel('Probability');
title('')

subplot(2,2,2); % A!ª2
normplot(ResA{2}(:,1))
xlabel('Residual {\it A_d} Run #4'); ylabel('Probability');
title('')

subplot(2,2,3); % T1
normplot(ResT{1}(:,1))
xlabel('Residual {\it T_w_,_o_u_t} Run #3'); ylabel('Probability');
title('')

subplot(2,2,4); % T2
normplot(ResT{2}(:,1))
xlabel('Residual {\it T_w_,_o_u_t} Run #4'); ylabel('Probability');
title('')

set(gcf,'color','white')
%% Test de Durbin-Watson

disp('Para Aº #1')
DW(ResA{1}(:,1));

disp('Para Aº #2')
DW(ResA{2}(:,1));

disp('Para Tout #1')
DW(ResT{1}(:,1));

disp('Para Tout #2')
DW(ResT{2}(:,1));

