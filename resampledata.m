ss=ls2cell(fullfile('~/seismometer/smoothpsddata/','*HHZ*001*SAC*'));

for i=1:length(ss)
    
    file = matfile(ss{i});

    x = file.S;
    oldfax = file.fax;
    
    [S,fax] = resample(x,oldfax,100,1,5);
    
    name = strrep(ss{i},'.','-');
    name = strrep(ss{i},'-mat','');
    name = strcat(name,'.mat');
                    
    save(fullfile('~/seismometer/smallpsddata/',name),...
                        'S','fax', '-v7.3');
end