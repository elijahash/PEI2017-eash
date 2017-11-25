function [ fax,Saverage,Stwentyfive,Sseventyfive,Sninetyfive,...
    pdf,hrs,count,bincenters ] = hrlyavg( dirin, type, extra )
%Returns average and 25th, 75th, and 95th percentiles by hour in 2D
%arrays. gives probability density function in 1-dB power bins from in a
%3d array.
%   type = 0 takes median, type = 1 takes mean

defval('dirin','/home/eash/seismometer/smallsmoothdata/')
defval('type',0)

nm2tom2 = 1e-18;

% create array of seismogram filenames
ss=ls2cell(fullfile(dirin,'*HHZ*SAC*'));

% store the frequency axis
psddata = matfile(char(fullfile(dirin,ss(1))));
fax = psddata.fax;

% create array of utc hours
hrs = [00:100:2300];

hour = nan(length(ss),1);

% categorize the records by hour
% spring forward at 0200 on 73 in 2016, fall back at 0200 311 in 2016, 
% spring forward again 0200 on 71 in 2017, fall back at 0200 309
% 4 hours behind utc on daylight savings, 5 when not
for i = 1:length(ss)
   [hour(i)] = getdates(ss{i},extra);     
end


% Inspect 
% plot(mod(diff(hour),2400)/100,'o')

% initialize stuff
binedges = -200:1:-50;
bincenters = nan(length(binedges)-1,1);
for ibin = 1:length(binedges)-1
    bincenters(ibin) = (binedges(ibin+1) + binedges(ibin)) / 2;
end
nbins = length(binedges) - 1;
Saverage = nan(length(fax),length(hrs));
Stwentyfive = nan(length(fax),length(hrs));
Sseventyfive = nan(length(fax),length(hrs));
Sninetyfive = nan(length(fax),length(hrs));
count = zeros(length(hrs),1);
pdf = nan(length(fax),length(hrs),nbins);

% The number of frequencies quoted
nfft=36001;

% Loop block
nfreq=3600;

hourlysort = nan(nfreq, 5+ceil(length(ss)/length(hrs)));

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

% for each hour at each frequency, find the mean value of power
for ifreq = array%1:10000:nfft
    
    for ihr = 1:length(hrs)
        hourlysortindex = 1;
        hourlysort = nan(nfreq, 5+ceil(length(ss)/length(hrs)));
        for iseis = 1:length(ss)
            if hour(iseis) == hrs(ihr)
                % Loads a precalculated power-spectral density estimate
                % psddata = matfile(char(fullfile(dirin,ss(iseis))));
                % Just load 'S'
                load(char(fullfile(dirin,ss(iseis))),'S');
                % if ~isnan(psddata.S(1))   
                if sum(isnan(S))==0 
                    %hourlysort(iseis) = psddata.S(ifreq);
                    count(ihr) = count(ihr) + 1;
                    hourlysort(:,hourlysortindex) = S(ifreq);
                    hourlysortindex = hourlysortindex + 1;
                end
            end
        end
        
        % Calculate the average over all available records at that frequency
        % and at that hour
        switch (type)
            case 0
                Saverage(ifreq,ihr) = nanmedian(hourlysort,2);
                Stwentyfive(ifreq,ihr) = prctile(hourlysort,25,2);
                Sseventyfive(ifreq,ihr) = prctile(hourlysort,75,2);
                Sninetyfive(ifreq,ihr) = prctile(hourlysort,95,2);
                hourlysortindex = 1;
                for littleifreq = ifreq(1):ifreq(end)
                    pdf(littleifreq,ihr,:) =  histcounts((10 * ...
                        log10(nm2tom2*hourlysort(hourlysortindex,:))),binedges) / count(ihr);
                    hourlysortindex = hourlysortindex + 1;
                end                
            case 1
                Saverage(ifreq,ihr) = nanmean(hourlysort,2);
        end
    end
end
%do the rest of the frequencies

hourlysort = nan(length(extra), 5+ceil(length(ss)/length(hrs)));

for ifreq = extra%1:10000:nfft
    for ihr = 1:length(hrs)
        hourlysortindex = 1;
        for iseis = 1:length(ss)
            if hour(iseis) == hrs(ihr)
                % Loads a precalculated power-spectral density estimate
                % psddata = matfile(char(fullfile(dirin,ss(iseis))));
                % Just load 'S'
                load(char(fullfile(dirin,ss(iseis))),'S');
                % if ~isnan(psddata.S(1))   
                if sum(isnan(S))==0 
                    %hourlysort(iseis) = psddata.S(ifreq);
                    count(ihr) = count(ihr) + 1;
                    hourlysort(:,hourlysortindex) = S(ifreq);
                    hourlysortindex = hourlysortindex + 1;
                end
            end
        end
        % Calculate the average over all available records at that frequency
        % and at that hour
        switch (type)
            case 0
                Saverage(ifreq,ihr) = nanmedian(hourlysort,2);
                Stwentyfive(ifreq,ihr) = prctile(hourlysort,25,2);
                Sseventyfive(ifreq,ihr) = prctile(hourlysort,75,2);
                Sninetyfive(ifreq,ihr) = prctile(hourlysort,95,2);
                hourlysortindex = 1;
                for littleifreq = ifreq(1):ifreq(end)
                    pdf(littleifreq,ihr,:) =  histcounts((10 * ...
                        log10(1e-18*hourlysort(hourlysortindex,:))),binedges) / count(ihr);
                    hourlysortindex = hourlysortindex + 1;
                end                   
            case 1
                Saverage(ifreq,ihr) = nanmean(hourlysort,2);
        end
    end
end