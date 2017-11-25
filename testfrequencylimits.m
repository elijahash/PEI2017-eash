ss = ls2cell('~/seismometer/frequencylimits/acc*HHZ*SAC*');

[fax1,S1] = nlnm();
[fax2,S2] = nhnm();

for i = 1:length(ss)
    load(fullfile('frequencylimits',ss{i}),'fax','S');
    S = 10*log10(1e-18*S);
    
    semilogx(fax,S)
    hold on
    semilogx(fax1,S1)
    semilogx(fax2,S2)
    xlim([5e-2 10])
    
    print(strcat(ss{i},'.png'),'-dpng')
end