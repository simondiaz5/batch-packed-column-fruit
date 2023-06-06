function [out,cons] = fun_sintetica_MO(Fr_input,x0_ini,x_range,x_ss,a,b,graficar,idx)

% Vector param optimo paper
p = [5.99109584947065,0.940875748235140,0.294413959280319,0.499999999999973,0.0497364205218838,2018,0.500000000000306;6.00890281588229,0.940791825164975,0.296176109605957,0.562522196939212,0.0497663855025632,2018.00012499488,0.548289547271803;5.38983788162671,0.580263090372408,0.856119020389810,0.191153343167985,0.0397955538854417,2225.62638937998,2.77197739721344;0.782876827016850,0.694452053945519,0.342412372847857,0.363201162376701,0.0549255848877220,1812.97538237553,0.0690882410890013];
p = p(3,:);

Fc_ini      = 90;  Qb_ini = 600 ;
mu_Tin      = 20 ;   v_Tin      =     8;
mu_Tamb     = 30 ;   v_Tamb     =     8 ;
mu_Eff_area = p(3);  v_Eff_area =  0.002 ;
mu_UA       = 1.5*p(4);  v_UA       =  0.0035*2;
mu_UAc      = 2*p(7);  v_UAc      =   0.6*2;
mu_x1b      = p(5);  v_x1b      =  0.00001*1.5 ;
mu_Mb       = p(6);  v_Mb       =  900*1.5;

% name   = [ "Tin" , "Tamb", "Eff_area" , "UA" , "UAc" , "x1b0","Mb"];
% names  = [ "T_in coolant ºC" , "T_amb ºC",  "Eff_area " , "UA (colum)" , "UA (condenser)" , "Inital Ethanol frac.","Initial Mole Boiler"];
% mu     = [mu_Tin , mu_Tamb , mu_Eff_area , mu_UA , mu_UAc , mu_x1b , mu_Mb];
% sigma  = [v_Tin  , v_Tamb  ,  v_Eff_area ,  v_UA ,  v_UAc , v_x1b  , v_Mb]*1;
% T      = table( names',mu',sigma','VariableNames',{'Param/Input Disturbed','Average','Standar Deviation'});
% nn     = 35; rng('default') ;
% M      = mvnrnd(mu,sigma,nn);


%% Modelo Modificado
T_fin        = 234*60;              % aux. tiempo final destilación exp.
T_vector     = 0:(1/60):(T_fin/60);                % aux. vector tiempo exp.
Fc_steps     = [Fc_ini,Fr_input];
time_steps   = [0,linspace(60*5,T_fin,length(Fc_steps)-1)];
F_max        = 500;
Fc_steps     = max(min(Fc_steps,F_max),10);
% Tin_v        = M(:,1); Tamb_v       = M(:,2);
% Eff_area_v   = M(:,3); Eff_area_v = max(min(Eff_area_v,1),0.25);
% UA_v         = M(:,4); UAc_v        = M(:,5);
% x0_ini_x1b_v = M(:,6); x0_ini_Mb_v  = M(:,7);

% tic()

%       [mu_Qb , mu_Tin , mu_Tamb , mu_Fc , mu_Eff_area , mu_UA , mu_UAc , mu_x1b , mu_Mb];
%          1        2         3        4         5          6        7       8         9
    Qb   = 1250;
    Tin  = mu_Tin ; %M(ii,1);
    Tamb = mu_Tamb;
 
    
    Eff_area  = mu_Eff_area ;  % Factor eficiencia area transf. calor
    UA        = mu_UA;  % watt
    UAc       = mu_UAc ; 
    x0_ini0(2)= mu_x1b ; % Valor inicial etanol boiler
    x0_ini0(1)= mu_Mb; % Valor inicial moles  boiler
    
    x0_ini0 =x0_ini;
    Mcp_c=   p(1);  % Cp*m metal
    Phi_ef=  p(2);  % Factor eficiencia area transf. masa

          
    % Ejecutar simulación desde simulink
    in = Simulink.SimulationInput('destilador_14d_par_steps');
    in = in.setVariable('x0_ini0',x0_ini0);
    in = in.setVariable('a',a);
    in = in.setVariable('b',b);
    in = in.setVariable('x_ss',x_ss);
    in = in.setVariable('x_range',x_range);
    
    in = in.setVariable('Qb',Qb);
    in = in.setVariable('Qb_ini',Qb_ini);
    in = in.setVariable('Fc_steps',Fc_steps);
    in = in.setVariable('time_steps',time_steps);
    in = in.setVariable('Tin',Tin);
    in = in.setVariable('Tamb',Tamb);
  
    in = in.setVariable('Phi_ef',Phi_ef);
    in = in.setVariable('Mcp_c',Mcp_c);
    in = in.setVariable('Eff_area',Eff_area);
    in = in.setVariable('UA',UA);
    in = in.setVariable('UAc',UAc);
    in = in.setModelParameter('StartTime','0','StopTime',string(T_fin));
    
    try 
        simout=sim(in);
        % Extracción y re-muestreo según tiempo experimental
        data_n_rs              = resample(simout.yout{1}.Values,T_vector*60);
        dist_model.t       = T_vector/60;
        dist_model.GL      = data_n_rs.Data(:,1);
        dist_model.Cmet    = data_n_rs.Data(:,2);
        dist_model.Rec_eth = data_n_rs.Data(:,3);
        dist_model.Rec_met = data_n_rs.Data(:,4);
        dist_model.V       = data_n_rs.Data(:,5);
        dist_model.Dvol    = data_n_rs.Data(:,6);
        dist_model.Fc      = data_n_rs.Data(:,7);
        dist_model.Tout    = data_n_rs.Data(:,8);
        dist_model.Tin     = data_n_rs.Data(:,10);
        dist_model.Qb      = data_n_rs.Data(:,11);
        dist_model.Tamb    = data_n_rs.Data(:,12);
        dist_model.GL_ac   = data_n_rs.Data(:,13);
        dist_model.V       = trapz(T_vector,data_n_rs.Data(:,7))/1000; % V coolant (L)
        
        V_max = F_max*((T_fin-5*60)/60)*(1/1000)+10*(5*60/60)*(1/1000); % Litros a Fmax mL/min maximo flujo
        pWater     = [dist_model.V]*100/V_max;
        R_eth      = [dist_model.Rec_eth(end)];
        R_met      = [dist_model.Rec_met(end)];
        GL         = [dist_model.GL];
        GL_ac      = [dist_model.GL_ac(end)];
        GL_min     = min(GL);
        
%         out = [pWater,GL_ac];

        GL_ac_ideal = 89.0228; % GL acumulado ideal  -> 1
        GL_ac_peor   = 66.7;   % GL acumulado malo  -> 0   
        V_ideal = 2.3879;      % V acumulado ideal -> 1
        V_peor  = 100;         % V acumulado malo  -> 0

        ideal = 1; peor = 0;
        GL_ac_scaled = (GL_ac-GL_ac_peor)*((ideal-peor)/(GL_ac_ideal-GL_ac_peor))-peor;
        V_scaled     = (pWater-V_peor)*((ideal-peor)/(V_ideal-V_peor))-peor;
        
%         out = [V_scaled,GL_ac_scaled]; 
        out = [pWater,-GL_ac]; 
% 
%         J = alpha*(GL_ac_scaled) + (1-alpha)*(V_scaled);
%         vector_values = [pWater;R_eth;R_met;GL_ac;GL_min];

        dist_model.check   = 1;
    catch % end of catch
        dist_model.check=0;

        J = 2;
        out = [100+rand(1),-70-rand(1)]; 
        % out = [999,999];
    end  % end of Try

% toc()  



cons = 0;


 
%% Otra forma de guarda la figura
if graficar ==1
%  close all;
 figure(idx)
 subplot(2,2,1)
         plot(dist_model.t,[dist_model.GL]);hold on;
         xlim([0 4]);
        ylabel('{\it A_d} (%v/v)')
        xlabel('Time (h)')
        grid on
        
 subplot(2,2,3)
         plot(dist_model.t,[dist_model.Fc]);hold on;

         xlim([0 4]);

        ylabel('{\it F_c} (mL/min)')
        xlabel('Time (h)')
        grid on

  set(gcf,'color','white')
  

% Ploteo Figura RP gráfico de barras
subplot(2,2,[2,4])
    categorias = categorical({'% Water','% Eth. Rec.','% Meth. Rec.','Eth. conc. ac.','Eth. conc. min'});
    categorias = reordercats(categorias,{'% Water','% Eth. Rec.','% Meth. Rec.','Eth. conc. ac.','Eth. conc. min'});
    num_cat    = length(categorias);
    bar(categorias,[pWater;R_eth;R_met;GL_ac;GL_min]'); hold on
    ylabel('Percetange')
    
    % Agregar la media
%     plot(1:num_cat,vector_values,'.k','MarkerSize',20)
    % Agregar la media
    xt = 1:num_cat ; yt = vector_values';
    xoffset = [0 0 0 0 0] ; yoffset = [3 3 3 3 3];
    str =   string(num2str(vector_values,3))';
    text(xt+xoffset , yt+yoffset , str ,'FontWeight','bold','Color','k')  % plot text(X,Y,string)
    grid on
  set(gcf,'color','white','position',[540,322,1118,578])
end
