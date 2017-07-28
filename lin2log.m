function [ logy,linlogax,linticks,xlimlin ] = lin2log(linxaxis,yvalues,method,logticks,loglim )
% lin2log takes a function that has an independent variable in linear
% space, then converts it to "logarithmic" space without changing the
% graph in matlab. (That is, it will only appear to be in logarithmic space
% and should be plotted as linear.)
%   
%
%
% INPUT
%
% linxaxis: the independent variable. this should be either strictly
%           increasing or decreasing in linear space.
% yvalues:  the dependent variable. can be 1d or 2d
% method:   'linear' (default) or other interpolation method. This is
%           required because the semilogx version of the dependent variable 
%           must be interpolated to plot in log space.
% logticks: here you may specify the x-axis ticks in logspace.
% loglim:   here you may specify the x-axis limits in logspace.
%
%
% OUTPUT
%
% logy:     the dependent variable, now with respect to a logarithmic
%           x-axis.
% linlogax: the new x-axis, which is logarithmic but should be plotted
%           linearly.
% linticks: will output the proper spacing for where your (logarithmic)
%           axis ticks should be plotted in linear space.
% xlimlin:  similarly, converts logarithmic axis limits to how they should
%           actually be plotted.


defval('logticks',[1e-3 2e-3 3e-3 4e-3 5e-3 6e-3 7e-3 8e-3 9e-3 1e-2 2e-2...
    3e-2 4e-2 5e-2 6e-2 7e-2 8e-2 9e-2 1e-1 2e-1 3e-1 4e-1 5e-1 6e-1 7e-1...
    8e-1 9e-1 1 2 3 4 5 6 7 8 9 10])
defval('loglim',[1e-2 10])
defval('method','linear')

% find the smallest spacing of the x axis in log space
dF = diff(log10(linxaxis));
dFe = min(abs(dF));

% create a new frequency axis that is spaced in units of dFe
if linxaxis(1) == 0
    %check if the axis is increasing or descending and create it
    %accordingly
    if linxaxis(2) < linxaxis(end)
        logF = (log10(linxaxis(end)):-dFe:log10(linxaxis(2)));
    else
        logF = (log10(linxaxis(end)):dFe:log10(linxaxis(2)));
    end
else
    if linxaxis(1) < linxaxis(end)
        logF = (log10(linxaxis(end)):-dFe:log10(linxaxis(1)));
    else
        logF = (log10(linxaxis(end)):dFe:log10(linxaxis(1)));
    end
end

% create a new array in log space by interpolating values to fill in the
% new x-axis
if linxaxis(1) == 0
    logy = interp1(log10(linxaxis(2:end)),yvalues(2:end,:),logF,method);
else
    logy = interp1(log10(linxaxis),yvalues,logF,method);
end

% create an actual log axis and don't let zero mess things up
if linxaxis(1) == 0
    logax = logspace(log10(linxaxis(2)),log10(linxaxis(end)),(length(linxaxis)-1));
    nozerofax = linxaxis(2:end);
else
    logax = logspace(log10(linxaxis(1)),log10(linxaxis(end)),(length(linxaxis)));
    nozerofax = linxaxis(1:end);
end

% do the calculations
m = (logax(end)-logax(1)) / length(nozerofax);
r = (logax(end)/(logax(1)))^(1/length(nozerofax));
a = logax(1);
linticks = (m*(log(logticks/a)/log(r))) + logax(1);
linlogax = (m*(log((10.^logF)/a)/log(r))) + logax(1);
xlimlin = (m*(log(loglim/a)/log(r))) + logax(1);

end

