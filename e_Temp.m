function Te = e_Temp( eM,n )
% The temperature of electron based on its eedf.
% 3/2*Te = meanE
% Version 16.10.22
% Te = e_meanE(eM,n)  	eM[J]   n[*/J]
Te = 2/3*e_meanE(eM,n);
end

