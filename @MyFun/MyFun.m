classdef MyFun
%% MyFun [Version_16.10.31]
% --------------------------------------------------------------
%  	eedf = Maxwell_EEDF(E_input,E_unit,Te_input,Te_unit)
%	eepf = Maxwell_EEPF(E_input,E_unit,Te_input,Te_unit)
%	n = numDen(p, Tg)       n[cm^-3], p[Pa], Tg[K]
%	ne = e_numDen(eM,n)     eM[J]   n[*/J] the number density per energy
%	E = e_meanE(eM,n)  	eM[J]   n[*/J]
%	k = calKeedf( csM, eedfM )			
%		Calculate the reaction rate constant via eedf and cross section.
% 		csM  	[ e[eV], cs[m^2] ]
%		eedfM	[ e[J], eedf[J^{-1}] ]
%		k		[ m^3/s ]
% ************************History*******************************
% 	16.10.10
% 		The unit issue of EEDF and EEPF have been checked.
% 	16.10.13
% 		Add the numDensity function based on ideal gas law [pV = nRT].
% 	16.10.20
% 		Add the e_meanE and e_numDen function.
%	16.10.31
%		Add the calKeedf function.
% **************************************************************
    properties
    end
    methods(Static)
        %%  EEDF
        %%
        % $${f_e}(E)=2\sqrt{\frac{E}{\pi}}{{\left( \frac{1}{{k_B}{T_e}} \right)}^{3/2}}\exp\left(-\frac{E}{{k_B}{T_e}}\right)\ldots\ldots\left[eV^{-1}\right]$$
        %
        % *input* : $E[eV]$, $Te[eV]$   *output* : $f[eV^{-1}]$
        %
        function f = Maxwell_EEDF(E_input,E_unit,Te_input,Te_unit)
            if strcmp(E_unit,'J')
                E = E_input/Const.e;
            elseif strcmp(E_unit,'eV')
                E = E_input;
            else
                error('Error E_unit');
            end
            if strcmp(Te_unit,'K')
                Te = Te_input/Const.eV2K;
            elseif strcmp(Te_unit,'eV')
                Te = Te_input;
            else
                error('Error Te_unit');
            end
            f = 2*sqrt(E/pi)*(Te)^(-3/2).*exp(-E/Te);
            if strcmp(E_unit,'eV')
                f = f*1;
            elseif strcmp(E_unit,'J')
                f = f/Const.e;
            else
            end
        end
        %%  EEPF
        %%
        %
        % $${f_p}(E)=2\sqrt{\frac{1}{\pi}}{{\left( \frac{1}{{k_B}{T_e}} \right)}^{3/2}}\exp\left(-\frac{E}{{k_B}{T_e}}\right)\ldots\ldots\left[eV^{-3/2}\right]$$
        %
        % *input* : $E[eV]$, $Te[eV]$   *output* : $f[eV^{-3/2}]$
        %
        function f = Maxwell_EEPF(E_input,E_unit,Te_input,Te_unit)
            if strcmp(E_unit,'J')
                E = E_input/Const.e;
            elseif strcmp(E_unit,'eV')
                E = E_input;
            else
                error('Error E_unit');
            end
            if strcmp(Te_unit,'K')
                Te = Te_input/Const.eV2K;
            elseif strcmp(Te_unit,'eV')
                Te = Te_input;
            end
            f = MyFun.Maxwell_EEDF(E,'eV',Te,'eV')./sqrt(E);
            if strcmp(E_unit,'eV')
                f = f*1;
            elseif strcmp(E_unit,'J')
                f = f/Const.e^(3/2);
            else
            end
        end
        %%  Number Density based on ideal gas laws [pV = nRT]
        function n = numDen(p, Tg)
            n = p/Tg/Const.R*Const.NA*1e-6;   % p[Pa] T[K] n[cm-3]
        end
        %%  The total number density of electron
        function ne = e_numDen(eM,n)
            ne = sum(n) * (eM(2)-eM(1));
        end  
        %%  The mean energy of electron based on its eedf.
        %
        function E = e_meanE(eM,n)
            E = sum(eM.*n)*(eM(2)-eM(1))/MyFun.e_numDen(eM,n);
        end
        function k = calKeedf( csM,eedfM )
			ev_cs 	= csM(:,1)*Const.eV2J;
			cs 		= csM(:,2);
			ev_eedf = eedfM(:,1);
			eedf 	= eedfM(:,2);

			accur 	= floor((  min(ev_cs(end), ev_eedf(end)) - max(ev_cs(1), ev_eedf(1))  )/...
							min([diff(ev_cs) ; diff(ev_eedf)])  ) + 1;
			EV 		= linspace(max(ev_cs(1), ev_eedf(1)), min(ev_cs(end), ev_eedf(end)),	accur);

			CS 		= interp1( ev_cs, cs, EV, 'pchip');
			EEDF 	= interp1( ev_eedf, eedf, EV, 'pchip' );

			k = sqrt(2/Const.me) * trapz( EV, sqrt(EV).*CS.*eedf);

		end
    end
    
end

