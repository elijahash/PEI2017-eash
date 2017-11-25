% let's make a plot for .04s, .4s, and 4s period bands (to within 10%) for
% the 2 weeks around lawnparties, which was 5/7/2017 (day 127)

ss = ls2cell('~/seismometer/resampleby310/*SAC*');
f1 = 10;
f2 = 1;
f3 = .1;
centerdate = 127;

for i = 1:length(ss)
   [hour(i),day(i),month(i),year(i)] = getdates(ss{i},'acc_');     
end

foundit = false;
looking = 0;
while ~foundit
    looking = looking + 1;
    if day(looking) == centerdate & year(looking) == 2017
        foundit = true;
    end
end

load(fullfile('~/seismometer/resampleby310',ss{i}),'fax');

Smed = nan(length((looking-(7*24)):(looking+(7*24))),3);
power = nan(length(fax),length((looking-(7*24)):(looking+(7*24))));

%for each record in this time period, get the median value for each
%frequency band
imed = 1;
ilabel = 1;
for i=(looking-(7*24)):(looking+(7*24))
    load(fullfile('~/seismometer/resampleby310',ss{i}),'S');
    S1 = S(abs(f1 - fax) <= (.1*f1));
    S2 = S(abs(f2 - fax) <= (.1*f2));
    S3 = S(abs(f3 - fax) <= (.1*f3));
    Smed(imed,1) = median(S1);
    Smed(imed,2) = median(S2);
    Smed(imed,3) = median(S3);
    iday(imed) = day(i);
    ihr(imed) = hour(i);
    if hour(i) == 0
        xlabels{ilabel} = num2str(day(i));
        ilabel = ilabel + 1;
    end
    power(:,imed) = S;
    imed = imed + 1;
end

Smed = 10*log10(1e-18*Smed);


%convert hours to account for day and then plot
clf
hold on
ah(1) = gca;
curve1 = plot(Smed(:,1));
curve2 = plot(Smed(:,2));
curve3 = plot(Smed(:,3));
xaxis = 1:length(Smed(:,1));

ah(1).XTick = xaxis(ihr == 0);
%ah(1).XTicksBetween = 1;
%ah(1).XMinorTick = 'on';
ah(1).XTickLabel = xlabels;
ah(1).XGrid = 'on';
ah(1).XMinorGrid = 'on';
longticks(ah(1),2)


label1 = strcat(num2str(f1),' Hz');
label2 = strcat(num2str(f2),' Hz');
label3 = strcat(num2str(f3),' Hz');

legend(label1,label2,label3)
xlabel('date')
ylabel('power [dB]')
xlim([1 length(Smed(:,1))])

weekdays = {'S', 'M', 'T','W','T','F','S','S', 'M', 'T','W','T','F','S','S'}
[ax] = xtraxis(ah(1),xaxis(ihr == 0),weekdays,'day of the week');
longticks(ax,2)

%figure()
%contourf(1:length((looking-(7*24)):(looking+(7*24))),fax,power)