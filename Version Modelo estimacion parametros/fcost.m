function J=fcost(p,destilaciones,ini_ode)

% Entrada constante
Qb=1000;        % Potencia calefacciòn boiler W
m_s=10;         % Primeros puntos descartados
m_f=10;         % Ultimos puntos descartados


% dist_index=[2 4 8 9] ;
dist_index=[8 9] ;

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

    dist_exp(i)=destilaciones(dist_index(i)); % aux. matriz de datos exp.
    T_fin=dist_exp{i}(end,2)*60;              % aux. tiempo final destilación exp.
    T_vector=dist_exp{i}(:,2);                % aux. vector tiempo exp.
    Tin=dist_exp{i}(:,3);               % aux. promedio temp in exp.
    Fc=dist_exp{i}(:,7);
    % Ejecutar simulación desde simulink
    try
        simout{i}=sim('destilador_14b',[0 T_fin],opts,[]);
        % Extracción y re-muestreo según tiempo experimental
        data_n_rs=resample(simout{i}.yout{1}.Values,T_vector*60);
        dist_model{i}=data_n_rs.Data(:,:);
        Jy(i)=sum(((dist_exp{i}(m_s:end-m_f,6)-dist_model{i}(m_s:end-m_f,1))./max(dist_exp{i}(m_s:end-m_f,6))).^2);
        Ju(i)=sum(((dist_exp{i}(m_s:end-m_f,4)-dist_model{i}(m_s:end-m_f,8))./max(dist_exp{i}(m_s:end-m_f,4))).^2);
    catch
        Jy(i)=1e3;
        Ju(i)=1e3; 
    end
end

 
J=0.9*sum(Jy)+0.1*sum(Ju)
end