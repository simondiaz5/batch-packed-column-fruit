function salida = destilado(Vn,y1n,y2n,Lc,x1c,x2c,PM_EtOH,PM_H2O)
% Este macro calcula tanto el grado alcohólico como el flujo volumétrico de
% destilado que sale desde el condensador parcial durante la destilación de
% una mezcla ternaria multicomponente, en operación batch, dados los flujos
% y composiciones tanto del vapor que ingresa a él como del relfujo.

% En primer término se calcula el flujo molar de destilado junto con sus 
% composiciones:

D = Vn-Lc ;                                                       % [mol/s] AQUI SE PRODUCE ERROR CON AZEOT.!!!!
y1D = (Vn*y1n-Lc*x1c)/D;                                             % [-]
y2D = (Vn*y2n-Lc*x2c)/D;                                              % [-]
%Borrar IF al ajustar polinomio de equilibrio termodinámico para sacar
%y1(i)
% if D<0
%     if D<-.001
%         a='error en polinomio de Vn'
%         D
%     end
%     y1D=.8947;
%     dens = densidad(y1D,293.15,PM_EtOH,PM_H2O);                        % [g/mL]
%     PM = peso_molecular(y1D,PM_EtOH,PM_H2O);                          % [g/mol]
%     rho_EtOH = dens(1,2);                                              % [g/mL]
%     rho = dens(1,3);                                                   % [g/mL]
%     GL = (y1D*PM_EtOH*rho/(PM*rho_EtOH))*100;                           % [°GL]
%     salida=[GL 0 0 0 0];
% else
% Posteriormente se procede a calcular el flujo volumétrico de destilado 
% (medido a 25 [°C], tal como lo hizo Javier en su trabajo) y la graduación 
% alcohólica propiamente tal (la cual es tomada, por definición, a 20 [°C]):

    dens = densidad(y1D,293.15,PM_EtOH,PM_H2O);                        % [g/mL]
    PM = peso_molecular(y1D,PM_EtOH,PM_H2O);                          % [g/mol]
    rho_EtOH = dens(1,2);                                              % [g/mL]
    rho = dens(1,3);                                                   % [g/mL]
    GL = (y1D*PM_EtOH*rho/(PM*rho_EtOH))*100;                           % [°GL]
    dens1 = densidad(y1D,298.15,PM_EtOH,PM_H2O);                       % [g/mL]
    rho1 = dens1(1,3);                                                 % [g/mL]
    Dvol = D*PM/rho1;                                                  % [mL/s]
   
    
% Finalmente se calcula el porcentaje de recuperación de etanol y metanol 
% que sale del sistema:

    D_EtOH = D*y1D;                                                   % [mol/s]
    D_MEtOH = D*y2D;                                                  % [mol/s]
    D_H2O = D*(1-y1D-y2D);
    
    salida = [GL Dvol D_EtOH D_MEtOH D_H2O];                      % [Unidades varias]
end