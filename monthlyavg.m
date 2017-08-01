function [ fax,Saverage,Stwentyfive,Sseventyfive,Sninetyfive,pdf, ...
    mth,count,bincenters ] = monthlyavg( dirin,type,extra )
%Returns average and 25th, 75th, and 95th percentiles by month in 2D
%arrays. gives probability density function in 1-dB power bins from in a
%3d array.
%   type = 0 gives median; 1 gives mean

defval('dirin','/home/eash/seismometer/smallsmoothdata/')
defval('type',0)

% create array of seismogram filenames
ss=ls2cell(fullfile(dirin,'*HHZ*SAC*'));

% store the frequency axis
psddata = matfile(char(fullfile(dirin,ss(1))));
fax = psddata.fax;

% create array of months
mth = [1 2 3 4 5 6 7 8 9 10 11 12];
month = nan(length(ss),1);
year = nan(length(ss),1);
day = nan(length(ss),1);

% categorize the records by month
for i = 1:length(ss)
    [~,day(i),month(i),year(i)] = getdates(ss{i},extra);
end

% initialize stuff
binedges = -200:1:-50;
bincenters = nan(length(binedges)-1,1);
for ibin = 1:length(binedges)-1
    bincenters(ibin) = (binedges(ibin+1) + binedges(ibin)) / 2;
end
nbins = length(binedges) - 1;
Saverage = nan(length(fax),length(mth));
Stwentyfive = nan(length(fax),length(mth));
Sseventyfive = nan(length(fax),length(mth));
Sninetyfive = nan(length(fax),length(mth));
count = zeros(length(mth),1);
pdf = nan(length(fax),length(mth),nbins);


% The number of frequencies quoted
nfft=36001;

% Loop block
nfreq=3600;

monthlysort = nan(nfreq, 5+ceil(length(ss)/length(mth)));

array = nan(nfreq,ceil(nfft/nfreq));
column = 1;
index = 1;

for i = 1:nfft
    if index <= nfreq
        array(index,column) = i;
    else
        column = column + 1;
        index = 1;
        array(index,column) = i;
    end
    index = index + 1;
end
% remove the last column
arraysize = size(array);
extra = nan(arraysize(1),1);
extra = array(:,arraysize(2));
array(:,arraysize(2)) = [];
extra(isnan(extra)) = [];

% for each month at each frequency, find the mean value of power
for ifreq = array%1:10000:nfft  
    for imth = 1:length(mth)
        monthlysortindex = 1;
        monthlysort = nan(nfreq, 5+ceil(length(ss)/length(mth)));
        for iseis = 1:length(ss)
            if month(iseis) == mth(imth)
                % Loads a precalculated power-spectral density estimate
                % psddata = matfile(char(fullfile(dirin,ss(iseis))));
                % Just load 'S'
                load(char(fullfile(dirin,ss(iseis))),'S');
                % if ~isnan(psddata.S(1))   
                if sum(isnan(S))==0 
                    %monthlysort(iseis) = psddata.S(ifreq);
                    count(imth) = count(imth) + 1;
                    monthlysort(:,monthlysortindex) = S(ifreq);
                    monthlysortindex = monthlysortindex + 1;
                end
            end
        end
        
        % Calculate the average over all available records at that frequency
        % and at that month
        switch (type)
            case 0
                Saverage(ifreq,imth) = nanmedian(monthlysort,2);
                Stwentyfive(ifreq,imth) = prctile(monthlysort,25,2);
                Sseventyfive(ifreq,imth) = prctile(monthlysort,75,2);
                Sninetyfive(ifreq,imth) = prctile(monthlysort,95,2);
                monthlysortindex = 1;
                for littleifreq = ifreq(1):ifreq(end)
                    pdf(littleifreq,imth,:) =  histcounts((10 * ...
                        log10(1e-18*monthlysort(monthlysortindex,:))),binedges) / count(imth);
                    monthlysortindex = monthlysortindex + 1;
                end
            case 1
                Saverage(ifreq,imth) = nanmean(monthlysort,2);
        end
    end
end
%do the rest of the frequencies

monthlysort = nan(length(extra), 5+ceil(length(ss)/length(mth)));

for ifreq = extra%1:10000:nfft
    for imth = 1:length(mth)
        monthlysortindex = 1;
        for iseis = 1:length(ss)
            if month(iseis) == mth(imth)
                % Loads a precalculated power-spectral density estimate
                % psddata = matfile(char(fullfile(dirin,ss(iseis))));
                % Just load 'S'
                load(char(fullfile(dirin,ss(iseis))),'S');
                % if ~isnan(psddata.S(1))   
                if sum(isnan(S))==0 
                    %monthlysort(iseis) = psddata.S(ifreq);
                    count(imth) = count(imth) + 1;
                    monthlysort(:,monthlysortindex) = S(ifreq);
                    monthlysortindex = monthlysortindex + 1;
                end
            end
        end
        % Calculate the average over all available records at that frequency
        % and at that month
        switch (type)
            case 0
                Saverage(ifreq,imth) = nanmedian(monthlysort,2);
                Stwentyfive(ifreq,imth) = prctile(monthlysort,25,2);
                Sseventyfive(ifreq,imth) = prctile(monthlysort,75,2);
                Sninetyfive(ifreq,imth) = prctile(monthlysort,95,2);
                monthlysortindex = 1;
                for littleifreq = ifreq(1):ifreq(end)
                    pdf(littleifreq,imth,:) =  histcounts((10 * ...
                        log10(1e-18*monthlysort(monthlysortindex,:))),binedges) / count(imth);
                    monthlysortindex = monthlysortindex + 1;
                end
                
            case 1
                Saverage(ifreq,imth) = nanmean(monthlysort,2);
        end
    end
end