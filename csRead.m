function cs = csRead( filename,strInput )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if strcmp(strInput,'all')
    fileID = fopen(filename,'r');
    text = textscan(fileID,'%s','delimiter', '\n');
    text = text{1};
    cs = text(startsWith(text,'PROCESS'));
    disp(cs);
    fclose(fileID);
else
    fileID = fopen(filename,'r');
    text = textscan(fileID,'%s','delimiter', '\n');
    text = text{1};
    reacIndex = find(startsWith(text,['PROCESS: ',strInput]));
    if size(reacIndex,1)>1
        error('More than one cross section block are found!')
    elseif size(reacIndex,1) == 1
        lineIndex = find(startsWith(text,'----'));
        lineIndex = lineIndex(lineIndex>reacIndex);
        a = text((lineIndex(1)+1):(lineIndex(2)-1));
        cs = zeros(size(a,1),2);
        for i = 1:size(a,1)
            cs(i,:) = str2num(a{i});
        end
        if cs(1,1) >0 
            cs = [[0,0];cs];
        end
    else
        error('Process not found')
    end
    
    fclose(fileID);
end

end

