function [xaxis,power] = nlnm(option)
% generates a Peterson 93 New Low-Noise Model (because it is somehow
% not rapidly available online)
%
% INPUT:
% option: 0 (default) creates frequency axis, 1 creates period
%
% OUTPUT:
% xaxis = period or frequency axis
% power = y-axis. units are dB with respect to 1 (m^2/s^4)/Hz.

defval('option',0)

p = [.1 .17 .4 .8 1.24 2.4 4.3 5 6 10 12 15.6 21.9 31.6 45 70 101 ...
    154 328 600 10000 100000];

switch (option)
    case 0
        xaxis = 1 ./ p;
    case 1
        xaxis = p;
end

a = -1 .* [162.36 166.7 170 166.4 168.6 159.98 141.1 71.36 97.26 ...
    132.18 205.27 37.65 114.37 160.58 187.5 216.47 185 168.34 ...
    217.43 258.28 346.88 346.88];
b = [5.64 0 -8.3 28.9 52.48 29.81 0 -99.77 -66.49 -31.57 36.16 ...
    -104.33 -47.1 -16.28 0 15.7 0 -7.61 11.9 26.6 48.75 48.75];

power = a + (b.*log10(p));
