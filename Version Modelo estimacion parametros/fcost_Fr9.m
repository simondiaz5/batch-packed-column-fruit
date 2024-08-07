function J=fcost_Fr9 (p,destilaciones,ini_ode,ww)

% Entrada constante
Qb=1000;        % Potencia calefacciòn boiler W
m_s=10; % Primeros puntos descartados



% p0=[0.986637086072208,0.387382817887436,0.291462567039008,17.464766724876434,0.054746396931041];


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
UA=  p(4);  % watt
x0_ini(2)=p(5); % Valor inicial etanol boiler
x0_ini(1)=p(6); % Valor inicial etanol boiler
UAc=p(7);
% p
% Bucle for para correr las destilaciones
% for w=ww
%     i
w=1;

    dist_exp(w)=destilaciones((ww)); % aux. matriz de datos exp.
    T_fin=dist_exp{w}(end,2)*60;              % aux. tiempo final destilación exp.
    m_f=round(length(dist_exp{1}(:,2))*3/4,0);
    T_vector=dist_exp{w}(1:m_f,2);                % aux. vector tiempo exp.
    Tin=dist_exp{w}(1:m_f,3);               % aux. promedio temp in exp.
    Fc=dist_exp{w}(1:m_f,7);
    vcal 1 mf
%     p
    % Ejecutar simulación desde simulink
     try
        simout{w}=sim('destilador_14c',[0 m_f*10],opts,[]);
        % Extracción y re-muestreo según tiempo experimental
        data_n_rs=resample(simout{w}.yout{1}.Values,T_vector*60);
        dist_model{w}=data_n_rs.Data(:,:);
        Jy(w)=sum(((dist_exp{w}(m_s:m_f,6)-dist_model{w}(m_s:end,1))./max(dist_exp{w}(m_s:m_f,6))).^2);
        Ju(w)=sum(((dist_exp{w}(m_s:m_f,4)-dist_model{w}(m_s:end,8))./max(dist_exp{w}(m_s:m_f,4))).^2);
    catch
        Jy(w)=1e3;
        Ju(w)=1e3; 
    end
% end

 
J=0.95*sum(Jy)+0.05*sum(Ju)
end