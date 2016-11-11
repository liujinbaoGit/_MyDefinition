classdef Reactions < handle
%% Reactions [Version_16.11.01]
% ----------------------------------------------------------------------------------
%   Properties[DEPENDENT]
%   nSpcs           Species numbers.
%   nRctns          Reaction numbers.
%   rcntsij         The reactant info-matrix.   [ i X j ]   species[i] reactions[j]
%   prdtsij         The product info-matrix.
%   sij             The reactions info-matrix.  [ - rcntsij + prdtsij ]
%   Properties[INPUT]
%   type            'EEDF-reactions' or 'COEK-reactions'
%   spcs            Species     [ cell(n x 1) ] e.g. { 'CO'; 'CO2'; 'O2' }
%   rcnt            Reactant    [ cell(m x n) ]
%   prdt            Product     [ cell(m x n) ]
%                               e.g. For CO + O = CO2
%                                         O + O = O2
%                                       rcnt = { 'CO', 'O'; 'O', 'O'}
%                                       prdt = { 'CO2'    ; 'O2'    }
%   dEe             electron energy loss    [J]
%   dEg             neutron energy loss     [J]
%   CS              Cross section packages  [ cell(n x 1) ]
%   k               Reaction rate constant
%   rate            Reaction rate
% ----------------------------------------------------------------------------------
%   1. Construction:    Reactions( spcs, rcnt, prdt )
%       [3 types]       Reactions( spcs, rcnt, prdt, dEg )
%                       Reactions( spcs, rcnt, prdt, dEg, dEe )
%   2.                  Auto calculate the nSpcs, nRctns, rcntsij, prdtsij and sij
%                           from the input.
%   3. Calculate        k       [m^3/s]     setK(obj, eedfM, Te, Tg)
%                           (1) if the reaction is relative to the eedf
%                               setKeedf(obj, eedfM)
%                           (2) otherwise.
%                               setKcoek(obj, Te, Tg)
%                       rate    [m^{-3}/s]  setRate( obj, n )
%   4. Calculate        dn      [m^{-3}/s]  dn  = getdn(obj)
%                       dQe     [J/m^3/s]   dQe = getdQe(obj)
%                       dQg     [J/m^3/s]   dQg = getdQg(obj)
% ----------------------------------------------------------------------------------
%   plotCS(obj)         plot obj's cross section.
%   info(obj)           disp the reactionlist.
% ----------------------------------------------------------------------------------
%%  Properties
% ----------------------------------------------------------------------------------
    properties (Dependent)
        nSpcs
        nRctns
        rcntsij
        prdtsij
        sij
    end
    properties
        type = '';
        spcs
        rcnt
        prdt
        dEe
        dEg
    end
    properties
        CS
        coek
    end
    properties
        k
        rate
    end
% --------------------------------------------------------------
%%  Methods
% --------------------------------------------------------------
    methods
% --------------------------------------------------------------
%%      Construction
% --------------------------------------------------------------
        function obj = Reactions( spcs, rcnt, prdt, dEg, dEe )
            if nargin == 0
            elseif nargin == 3
                obj.spcs = spcs;
                obj.rcnt = rcnt;
                obj.prdt = prdt;
                obj.dEg  = zeros(size(rcnt,1),1);
                obj.dEe  = zeros(size(rcnt,1),1);
            elseif nargin == 4
                obj.spcs = spcs;
                obj.rcnt = rcnt;
                obj.prdt = prdt;
                obj.dEg  = dEg;
                obj.dEe  = zeros(size(rcnt,1),1);
            elseif nargin == 5
                obj.spcs = spcs;
                obj.rcnt = rcnt;
                obj.prdt = prdt;
                obj.dEg  = dEg;
                obj.dEe  = dEe;
            end

        end
% --------------------------------------------------
%%      Get.value       [ nSpcs, nSpcs, rcntsij, prdtsij, sij ]
% --------------------------------------------------
        function val = get.nSpcs(obj)
            val = size(obj.spcs,1);
        end
        function val = get.nRctns(obj)
            val = size(obj.sij,2);
        end
        function val = get.rcntsij(obj)
            val = cell2mat(cellfun(@(x)(sum(strcmp(x, obj.rcnt),2))',...
                obj.spcs,'UniformOutput', false));
            val = sparse(val);
        end
        function val = get.prdtsij(obj)
            val = cell2mat(cellfun(@(x)(sum(strcmp(x, obj.prdt),2))',...
                obj.spcs,'UniformOutput', false));
            val = sparse(val);
        end
        function val = get.sij(obj)
            val = -obj.rcntsij + obj.prdtsij;
            val = sparse(val);
        end
% --------------------------------------------------------------
%%      Set     [ k, rate ]
% --------------------------------------------------------------
        function setKeedf(obj, eedfM)
        % eedfM [ e[J], eedf[J^{-1}] ]
            for i = 1:obj.nRctns
                obj.k(i,1) = MyFun.calKeedf( obj.CS{i}, eedfM );
            end
        end
        function setK(obj, eedfM, Te, Tg)
            if strcmp(obj.type ,'EEDF-reactions')
                obj.setKeedf( eedfM );
            elseif strcmp(obj.type ,'COEK-reactions')
                obj.setKcoek(Te, Tg);
            elseif strcmp(obj.type, '')
                obj.setKcoek(Te, Tg);
            else
                error('Reactions.type is wrong.');
            end
        end
        function setRate(obj,n)
            obj.rate = obj.k.*prod((repmat(n',obj.nRctns,1)).^(obj.rcntsij'),2);
        end
% --------------------------------------------------------------
%%      Getvalue        [ dn, dQe, dQg ]
% --------------------------------------------------------------
        function val = getdn(obj)
            val = obj.sij*obj.rate;
        end
        function val = getdQe(obj)
            val = obj.dEe'*obj.rate;
        end
        function val = getdQg(obj)
            val = obj.dEg'*obj.rate;
        end
% --------------------------------------------------------------
%%      Plus(obj0, obj1)
% --------------------------------------------------------------
        function obj2 = plus(obj0, obj1)
            obj2 = ReactionSets.Reactions();
            %%  obj0.spcs + obj1.spcs
            obj2.spcs = unique([obj0.spcs;obj1.spcs],'stable');
            %%  obj0.rcnt + obj1.rcnt
            if size(obj0.rcnt,2) == size(obj1.rcnt,2)
                obj2.rcnt = [obj0.rcnt;obj1.rcnt];
            elseif size(obj0.rcnt,2) > size(obj1.rcnt,2)
                rcnt1 = [obj1.rcnt, repmat({''},size(obj1.rcnt,1),size(obj0.rcnt,2)-size(obj1.rcnt,2))];
                obj2.rcnt = [obj0.rcnt;rcnt1];
            elseif size(obj0.rcnt,2) < size(obj1.rcnt,2)
                rcnt0 = [obj0.rcnt, repmat({''},size(obj0.rcnt,1),size(obj1.rcnt,2)-size(obj0.rcnt,2))];
                obj2.rcnt = [rcnt0;obj1.rcnt];
            else
                error('Error in plus(obj0, obj1)')
            end
            %%  obj0.prdt + obj1.prdt
            if size(obj0.prdt,2) == size(obj1.prdt,2)
                obj2.prdt = [obj0.prdt;obj1.prdt];
            elseif size(obj0.prdt,2) > size(obj1.prdt,2)
                prdt1 = [obj1.prdt, repmat({''},size(obj1.prdt,1),size(obj0.prdt,2)-size(obj1.prdt,2))];
                obj2.prdt = [obj0.prdt;prdt1];
            elseif size(obj0.prdt,2) < size(obj1.prdt,2)
                prdt0 = [obj0.prdt, repmat({''},size(obj0.prdt,1),size(obj1.prdt,2)-size(obj0.prdt,2))];
                obj2.prdt = [prdt0;obj1.prdt];
            else
                error('Error in plus(obj0, obj1)')
            end
            %%  obj0.dEe + obj1.dEe
            obj2.dEe  = [obj0.dEe; obj1.dEe];
            %%  obj0.dEg + obj1.dEg
            obj2.dEg  = [obj0.dEg; obj1.dEg];
        end
% --------------------------------------------------------------
%%      plotCS and disp(obj)
% --------------------------------------------------------------
        function plotCS(obj)
            figure;
            for i = 1:obj.nRctns
                cs = obj.CS{i,1};
                semilogx(cs(:,1),cs(:,2),'marker','.');
                hold on;
            end
            xlabel('energy [eV]');
            ylabel('cross section [m^2]')
            hold off;
        end
% --------------------------------------------------------------
%%      info(obj)
% --------------------------------------------------------------
        function info(obj)
            disp('SPECIES:');
            disp(obj.spcs);
            fprintf('REACTIONS__dEg__dEe\n');
            reactionsList = obj.reactionsList(...
                obj.spcs, obj.rcntsij,obj.prdtsij,ones(obj.nRctns,1));
            disp([reactionsList,num2cell(obj.dEg),num2cell(obj.dEe)]);
        end

    end
% ----------------------------------------------------------------------------------
%%  reactionsList
% ----------------------------------------------------------------------------------
    methods(Static)
        list    = reactionsList( spcs, rcntsij, prdtsij, xj);
    end
% **********************************************************************************
end









