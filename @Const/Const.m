classdef Const < handle
%% Const [Version 16.10.24]
% ----------------------------------------------------------------------------------
%	Received from "CODATA Recommended Values of the Fundamental Physical Constants: 2014."
%   Const.e, Const.eV2J
%   Const.specie.value
% ***********************************History****************************************
%	__16.10.24__
%	Add some molecular constants.
%	e.g. Const.H2O.formula, Const.CO.u
%	u           relative molecular mass             []
%	u0          absolute molecular mass             [kg]
%	r0          hard sphere diameter                [A]
%	we          vibrational constant: first term    [cm-1]
%	wexe        vibrational constant: second term   [cm-1]
%	xe                                              []
%	dissEnergy  dissociation energy                 [eV]
% **********************************************************************************
    properties (Constant)
        c0   = 299792458;           % [m/s]
        h    = 6.626070040E-34; 	% [J*s]
        e    = 1.6021766208E-19;	% [C]
        R    = 8.3144598;           % [J/(mol*K)]
        kB   = 1.38064852E-23;   	% [J/K]
        me   = 9.10938356E-31;      % [kg]
        NA   = 6.022140857E23;      % [mol-1]
        e0   = 8.854187817e-12      % [F*m-1]
        u0   = 1.66053904020e-27;   % [kg]      atomic mass unit 1/12(_12C)
        Td   = 1e-21;               % [V*m^2]   Townsend (unit)
        m2eV = 1.2398419739E-6;     % [m-1]  => [eV]
        cm2eV = 1.2398419739E-4;    % [cm-1] => [eV]

        eV2J = Const.e;             % [eV]   => [J]
        J2eV = 1/Const.e;           % [J]    => [eV]

        eV2K = Const.e/Const.kB;    % [eV]   => [K]
        K2eV = 1/Const.eV2K;        % [K]    => [eV]

        J2K  = 1/Const.kB;          % [J]    => [K]
        K2J  = Const.kB;            % [K]    => [J]

        cm2K = Const.cm2eV*Const.eV2K;
        pAtm = 101.325e3;           % Pa
    end
    properties (Constant)
        N2 = []
        O2 = []
        CO = []
        H2 = []
        CO2 = []
        H2O = []
    end
    methods
        %%  N2
        function Species = get.N2()
            Species.formula = 'N2';
            Species.type = 'diatomic';
            Species.u  = 28.0134;
            Species.u0 = Species.u*Const.u0;
            Species.r0 = 3.70;
            Species.we = 2358.57;          % cm-1
            Species.wexe = 14.324;         % cm-1
            Species.xe = Species.wexe/Species.we;
            Species.dissEnergy = 9.76;     % eV
        end
        %%  O2
        function Species = get.O2()
            Species.formula = 'O2';
            Species.type = 'diatomic';
            Species.u  = 31.9988;
            Species.u0 = Species.u*Const.u0;
            Species.r0 = 3.46;
            Species.we = 1580.19;
            Species.wexe = 11.98;
            Species.xe = Species.wexe/Species.we;
            Species.dissEnergy = 5.12;
        end
        %%  CO
        function Species = get.CO()
            Species.formula    = 'CO';
            Species.type       = 'diatomic';
            Species.u          = 28.0101;
            Species.u0         = Species.u*Const.u0;
            Species.r0         = 3.76;
            Species.we         = 2169.81358;
            Species.wexe       = 13.28831;
            Species.xe         = Species.wexe/Species.we;
            Species.dissEnergy = 11.09;
        end
        %%  H2
        function Species = get.H2()
            Species.formula    = 'H2';
            Species.type       = 'diatomic';
            Species.u          = 2.01588;
            Species.u0         = Species.u*Const.u0;
            Species.r0         = 2.87;
            Species.we         = 4401.21;
            Species.wexe       = 121.33;
            Species.xe         = Species.wexe/Species.we;
            Species.dissEnergy = 4.48;
        end
        %%  CO2
        function Species = get.CO2()
            Species.formula    = 'CO2';
            Species.type       = 'triatomic';
            Species.u          = 44.0095;
            Species.u0         = Species.u*Const.u0;
            Species.r0         = 3.94;
            Species.w          = [1351.2; 672.2; 2396.4];
            Species.X          = [...
                -0.3,   5.7,    -21.9;
                0,      -1.3,   -11.0;
                0,      0,      -12.5];
            Species.dissEnergy = 5.451;
        end
        %%  H2O
        function Species = get.H2O()
            Species.formula    = 'H2O';
            Species.type       = 'triatomic';
            Species.u          = 18.0153;
            Species.u0         = Species.u*Const.u0;
            %             Species.r0         =
            Species.w          = [3825.32;1653.91;3935.59];
            Species.X          = [...
                -43.89, -20.02, -155.06;
                0,      -19.50, -19.81;
                0,      0,      -46.37];
            Species.dissEnergy = 5.0992;
        end
    end
end

