% we want to make a histogram for each frequency of a psd

dirin = '/home/eash/seismometer/smallsmoothdata/';

% create array of seismogram filenames
ss=ls2cell(fullfile(dirin,'*HHZ*SAC*'));

% store the frequency axis
psddata = matfile(char(fullfile(dirin,ss(1))));
fax = psddata.fax;

composite = nan(1,length(ss));

for ifreq = 100%array
    for iseis = 1:length(ss)
        load(char(fullfile(dirin,ss(iseis))),'S');
        if sum(isnan(S))==0 
            composite(1,iseis) = S(ifreq);
        end
    end
end

fixed = log(composite);

maxs = 20;

fixed = fixed(fixed < maxs);

histogram(fixed)