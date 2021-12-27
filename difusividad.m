function salida = difusividad(x,T,mu3,mu1,sigma2,sigma3)
% Este macro calcula la difusividad de cada uno de los pares binarios pre-
% sentes en el sistema multicomponente etanol-metanol-agua. Se desarrolla
% en primer orden los pares etanol-metanol y metanol-agua, considerándose
% una dilución infinita, mientras que mediante ajuste de curvas se obtiene
% la disfusividad del par etanol-agua:

% En primer lugar se definen los volúmenes molares de cada compuesto:

Vb1 = 60.9;                                                    % [cm^3/mol]
Vb2 = 42.5;                                                    % [cm^3/mol]
Vb3 = 18.7;                                                    % [cm^3/mol]

% Y luego se calculan las difusividades a dilución infinita de los pares
% binarios etanol-metanol y metanol-agua:

D21 = (8.93e-8*(Vb1^0.267/(Vb2^0.433))*T/(mu1*1000))/10000;       % [m^2/s]
D23 = (8.93e-8*(Vb3^0.267/(Vb2^0.433))*(T/(mu3*1000))*(sigma3/sigma2)^0.15)/10000; % [m^2/s]

% Para posteriormente calcular la difusividad del par binario etanol-agua
% por medio de ajustes de curvas:
x=0.2
if x< 0.4
    A = 0.004745235+3.958654915*x^2-13.37189422*x^2.5+12.11394577*x^3;
    B = (0.000568651-0.001808107*x+0.006240566*x^2-0.007762593*x^3)^(-1);
    D13 = A*exp((-B/T))/10000;                                    % [m^2/s]
else if x >= 0.4 && x < 0.7
        A = sqrt((-0.09525306+0.534784927*x-0.922772004*x^2+0.509481294*x^3));
        B = 6076.684116-3506.527734*x-(717.9913854/x);
        D13 = A*exp((-B/T))/10000;                                % [m^2/s]            
    else
        A = (0.012535922-0.01846448*x)/(1-1.442042142*x);
        B = (1993.82159-3106.302058*x)/(1-1.527718036*x);
        D13 = A*exp((-B/T))/10000;                                % [m^2/s]         
    end
end

salida = [D21 D23 D13];