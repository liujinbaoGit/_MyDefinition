function list = reactionsList( spcs, rcntsij0, prdtsij0, xj0 )
%% reactionsList [Version_16.11.01]
% --------------------------------------------------------------
%	disprReaction [spcs, rcntsij, prdtsij] ¡ª¡ª> j*['aA+bB => cC+dD']
% 	If one reaction is null, do not export it.
% 	If the all reactions are null, export 'NULL'.
% 	xj is the number of reaction.

% **************************************************************
rcntsij = rcntsij0(:,xj0~=0);
prdtsij = prdtsij0(:,xj0~=0);
xj = xj0(xj0~=0);

%%
if all(all([rcntsij;prdtsij] == 0) == 1)||(size(xj,1) == 0)
    list = {'NULL'};      %%% if the all reactions are null, export 'NULL'.
else
    ia = find(~and(all(rcntsij == 0), all(prdtsij == 0)));
    rcntsij = rcntsij(:,ia);
    prdtsij = prdtsij(:,ia);      %%% if a reaction is null, do not export it.
    xj = xj(ia);

    list = repmat({''},size(xj,1),1);

    for j = 1:size(xj,1)
        rcntsi = rcntsij(:,j);
        prdtsi = prdtsij(:,j);
        rcntStrM = '';
        prdtStrM = '';
        for i = 1:size(spcs,1)
            if rcntsi(i) == 0
                rcntspc = '';
            elseif rcntsi(i) == 1
                rcntspc = spcs{i};
            elseif rcntsi(i) > 1
                rcntspc = [num2str(abs(rcntsi(i))), spcs{i}];
            else
                disp(['error in rcntsij[',num2str(i),',',num2str(j), '] in function dispReaction'])
            end
            if prdtsi(i) == 0
                prdtspc = '';
            elseif prdtsi(i) == 1
                prdtspc = spcs{i};
            elseif prdtsi(i) > 1
                prdtspc = [num2str(abs(prdtsi(i))), spcs{i}];
            else
                disp(['error in prdtsij[',num2str(i),',',num2str(j), '] in function dispReaction'])
            end

            if ~strcmp(rcntStrM,'')&&~strcmp(rcntspc,'')
                rcntStrM = [rcntStrM,'+',rcntspc];
            else
                rcntStrM = [rcntStrM,rcntspc];
            end
            if ~strcmp(prdtStrM,'')&&~strcmp(prdtspc,'')
                prdtStrM = [prdtStrM,'+',prdtspc];
            else
                prdtStrM = [prdtStrM,prdtspc];
            end
        end
        if xj(j) ~= 1
            reactions = ['(',rcntStrM,' => ',prdtStrM,')x',num2str(xj(j))];
        else
            reactions = [rcntStrM,' => ',prdtStrM];
        end

        list(j,1) = {reactions};
    end
end

end
