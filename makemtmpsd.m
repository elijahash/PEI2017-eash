function [  ] = makemtmpsd( dirin, ss, dirout, nfft )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[x,h]=readsac(fullfile(dirin,ss),0);
x = decimate(x,5);
if length(x) == nfft
    [S]=mtm(x,[],3,4);
    % Make a frequency axis
    % Length in samples
    % Half of it is relevant because signals are real
    selekt=1:floor(nfft/2)+1;
    % Construct a proper frequency axis
    fax=(selekt-1)'/[h.E-h.B]*(length(x)-1)/nfft;
    name = strrep(char(ss),'.','-');
    name = strcat(name,'.mat');
    save(fullfile(dirout,name),...
                        'S','fax', '-v7.3');
end

