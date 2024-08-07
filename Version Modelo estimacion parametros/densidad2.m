function salida = densidad2(x,T,PM1,PM3)
% Este macro calcula la densidad del etanol y del agua en estado puro a una
% determinada temperatura, as� como el de una mezcla l�quida etanol-agua 
% dada la fracci�n molar del primero [mol/mol] y la temperatura [K].

% En primer orden se calcula la densidad del agua pura:
coef_dens=[-0.0000033 0.001689 0.785085];
rho3 = polyval(coef_dens,T);                         % [g/mL]

% Y posteriormente se calcula la densidad, tanto del etanol puro, como de  
% la mezcla l�quida:

% if T <=  298.15
%     Phi1 = (3/2305843009213690000*(3.94072691458772e225*log((T-273.15)).^5+7.54191037791574e222*log(1).^5-3.03384588584303e226*log((T-273.15)).^4-6.6585949175635e223*log(1).^2-2.83364685934054e227*log((T-273.15)).^2+3.13143308197482e223*log(1).^4+2.44577262363024e223*log(1).^.3-1.72582286594881e227+1.23947996428891e227*log((T-273.15)).^3-1.2299889647338e224*log(1)+3.4363988478601e227*log((T-273.15))+5.46858861992851e221*log(1).^6-2.12239379221164e224*log((T-273.15)).^6)./(9.14983976321219e208*log((T-273.15)).^5+1.26990847104875e205*log(1).^6+1.75461672503655e206*log(1).^5-7.04347901875354e209*log((T-273.15)).^4-1.40741035899216e207*log(1).^2-6.57775293427198e210*log((T-273.15)).^2+7.34647468554983e206*log(1).^4+6.24099966262971e206*log(1).^3-4.92859500495046e207*log((T-273.15)).^6+2.87739058075962e210*log((T-273.15)).^3-4.00580739056943e210-2.91259589571263e207*log(1)+7.97650277942216e210*log((T-273.15))))*1000; % [mL/mol]
%     Phi = (3/2305843009213690000*(3.94072691458772e225*log((T-273.15)).^5+7.54191037791574e222*log(x).^5-3.03384588584303e226*log((T-273.15)).^4-6.6585949175635e223*log(x).^2-2.83364685934054e227*log((T-273.15)).^2+3.13143308197482e223*log(x).^4+2.44577262363024e223*log(x).^.3-1.72582286594881e227+1.23947996428891e227*log((T-273.15)).^3-1.2299889647338e224*log(x)+3.4363988478601e227*log((T-273.15))+5.46858861992851e221*log(x).^6-2.12239379221164e224*log((T-273.15)).^6)./(9.14983976321219e208*log((T-273.15)).^5+1.26990847104875e205*log(x).^6+1.75461672503655e206*log(x).^5-7.04347901875354e209*log((T-273.15)).^4-1.40741035899216e207*log(x).^2-6.57775293427198e210*log((T-273.15)).^2+7.34647468554983e206*log(x).^4+6.24099966262971e206*log(x).^3-4.92859500495046e207*log((T-273.15)).^6+2.87739058075962e210*log((T-273.15)).^3-4.00580739056943e210-2.91259589571263e207*log(x)+7.97650277942216e210*log((T-273.15))))*1000; % [mL/mol]
% else
    Phi1 = (5.1214e-2+6.549e-3+7.406e-5*(T-273.15))*1000;        % [mL/mol]
    Phi = (5.1214e-2+6.549e-3*x+7.406e-5*(T-273.15))*1000;       % [mL/mol]
% end

rho1 = PM1./Phi1;                                                   % [g/mL]
rho13 = (x*PM1+(1-x)*PM3)./(Phi.*x+((1-x)*PM3./rho3));                % [g/mL]

salida = [rho3 ;rho1; rho13];