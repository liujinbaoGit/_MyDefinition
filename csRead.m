function csM = csRead( fileName,strInput )
%% csRead [Version 16.11.11]
% ----------------------------------------------------------------------------------
%   csM = csRead( fileName, strInput )
%   The *.txt file is downloaded from http://fr.lxcat.net/home/
%   strInput is the reaction char.
%   csM     [ e[eV], cs[m^2] ]
%       the first e must be 0. (If not, this function add [0,0] in the first line.)
% ----------------------------------------------------------------------------------
if ischar(fileName)
    fileID = fopen(fileName,'r');
    text = textscan(fileID,'%s','delimiter', '\n');
    text = text{1};
    fclose(fileID);
elseif iscell(fileName)
    text = {''};
    for i = 1:size(fileName,1)
        fileID = fopen(fileName{i},'r');
        temp = textscan(fileID,'%s','delimiter', '\n');
        fclose(fileID);
        text = [text;temp{1}];
    end
else
    error('fileName''s type is wrong.');
end

if strcmp(strInput,'all')
    csM = text(startsWith(text,'PROCESS'));
    disp(csM);
else
    reacIndex = find(startsWith(text,['PROCESS: ',strInput, ',']));
    if size(reacIndex,1)>1
        error('More than one cross section block are found!')
    elseif size(reacIndex,1) == 1
        lineIndex = find(startsWith(text,'----'));
        lineIndex = lineIndex(lineIndex>reacIndex);
        a = text((lineIndex(1)+1):(lineIndex(2)-1));
        csM = zeros(size(a,1),2);
        for i = 1:size(a,1)
            csM(i,:) = str2num(a{i});
        end
        if csM(1,1) >0
            csM = [[0,0];csM];
        end
    else
        error('Process not found')
    end

end

end

