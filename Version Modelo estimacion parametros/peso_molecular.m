function salida = peso_molecular(x,PM1,PM3)
% Este macro calcula el peso molecular promedio de una mezcla binaria, a
% partir de la fracción molar de uno de los compuestos y sus pesos molecu-
% lares individuales:

salida = x*PM1+(1-x)*PM3;                                         % [g/mol]