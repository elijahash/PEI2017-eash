% rearrange the windspeed matrix
load('weatherdata.mat');
load('newsamplinghourlymedian.mat');
load('lawnpartiespower.mat');

longwindspd = [];
for i = 1:size(windspd,2)
    longwindspd = vertcat(longwindspd,windspd(:,i));
end

% take the median at each hour of each day, store these in a new matrix
hourlysort = nan(60,1);

% while there is sill more matrix
%   while we haven't bumped over to the next hour
%       store all of the windspeed values
%   take the median
%   then start looking in the next section

i = 1;
isort = 1;
inew = 1;
while i <= length(longwindspd)
    while dates((i+1),5) ~= 0
        hourlysort(isort) = longwindspd(i);
        i = i + 1;
        isort = isort + 1;
        if i == length(longwindspd)
            dates((i+1),5) = 0;
        end
    end
    hourlysort(isort) = longwindspd(i);
    i = i + 1;
    newwindspd(inew) = nanmedian(hourlysort);
    newdates(inew,1:4) = dates(i,1:4);
    inew = inew + 1;
    hourlysort = nan(60,1);
    isort = 1;
end

% take the power records and plot them by wind
centerdate = [2017 5 7 0];
looking = 0;
foundit = false;
while ~foundit
    looking = looking + 1;
    
    if newdates(looking,1) == centerdate(1) && newdates(looking,2)...
            == centerdate(2) && newdates(looking,3) == centerdate(3)
        foundit = true;
    end
end

relevantwind = newwindspd((looking-(7*24)):(looking+(7*24)));
[relevantwind,newindeces] = sort(relevantwind);
newpower = nan(size(power));
for i = 1:length(newindeces)
    newpower(:,i) = power(:,newindeces(i));
end

% deal with the repeated values

% for as long as the next index is the same value, group them and take
% their median, and do the same for their power spectra

igroup = 1;
inew = 1;
grouping = [];
powergrouping = [];
i = 1;
oops = true;
while i <= length(relevantwind)
    if i ~= length(relevantwind)
        while relevantwind(i) == relevantwind(i+1)
            grouping(igroup) = relevantwind(i);
            powergrouping(:,igroup) = newpower(:,i);
            i = i + 1;
            igroup = igroup + 1;
            if i == length(relevantwind)
                relevantwind(i+1) = 123123123;
                oops = false;
            end
        end
    end
    if i <= (length(relevantwind) - 1) || oops
    grouping = [grouping, relevantwind(i)];
    powergrouping = [powergrouping, newpower(:,i)];
    newrelevantwind(inew) = nanmedian(grouping);
    newnewpower(:,inew) = nanmedian(powergrouping,2);
    inew = inew + 1;
    i = i + 1;
    igroup  = 1;
    grouping = [];
    powergrouping = [];
    end
end

newnewpower = 10*log10(1e-18*newnewpower);

[~,h] = contourf(newrelevantwind,fax,newnewpower);
h.LineColor = 'none';
c = colorbar;
set(gca,'YScale','log')
ylim([1e-2 10])
xlabel('Windspeed (m/s)')
ylabel('Frequency (Hz)')
c.Label.String = 'Power (dB)';

% do pressure too
% change the range of the colorbar
% use max instead of median