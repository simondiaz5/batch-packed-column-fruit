function d = DW(Res);

% Durbin-Watson

sum=0;
sumRes=Res(1)^2;
for i=2:size(Res)
    sum=sum+((Res(i)-Res(i-1))^2);
    sumRes=sumRes+Res(i)^2;
end
d=sum/sumRes;

display(d,'Estadistico Durbin-Watson');

% Determinación parpametros del test estadístico:

% K = 10 --> Número de parámetros
% T = 16 --> Número de experimentos
% n = 64 --> Número de datos experimentales (16x4)

% De la tabla de Durbin (para k = 10, n = 65) se tiene que: 
du = 1.802;
dl  =1.120;
menosdu=4-du;
display([du menosdu],'Rango de independencia de residuos');

end
