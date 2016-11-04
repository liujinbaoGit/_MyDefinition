function E = e_meanE(eM,n)
% The mean energy of electron based on its eedf.
% 3/2*Te = meanE
% Version 16.10.22
% E  = e_meanE(eM,n)  	eM[J]   n[*/J]
E = sum(eM.*n)*(eM(2)-eM(1))/MyFun.e_numDen(eM,n);

end
