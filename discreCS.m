function cs = discreCS( eM, csM )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if (csM(1,1) <= eM(1)) && (csM(end,1) >= eM(end))
    cs = interp1(csM(:,1),csM(:,2),eM);
else
    error('The range of the input cross section is not wide enough.')
end

