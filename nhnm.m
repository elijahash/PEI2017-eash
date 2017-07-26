function [xaxis,power] = nhnm(option)
% generates a Peterson 93 New High-Noise Model (because it is somehow
% not rapidly available online)
%
% INPUT:
% option: 0 (default) creates frequency axis, 1 creates period
%
% OUTPUT:
% xaxis = period or frequency axis
% power = y-axis. units are dB with respect to 1 (m^2/s^4)/Hz.

defval('option',0)

p = [.1 .22 .32 .8 3.8 4.6 6.3 7.9 15.4 20 354.8 100000];

switch (option)
    case 0
        xaxis = 1 ./ p;
    case 1
        xaxis = p;
end

a = -1 .* [108.73 150.34 122.31 116.85 108.48 74.66 -.66 93.37 ...
    -73.54 151.52 206.66 206.66];
b = [-17.23 -80.5 -23.87 32.51 18.08 -32.95 -127.18 -22.42 ...
    -162.98 10.01 31.63 31.63];

power = a + (b.*log10(p));