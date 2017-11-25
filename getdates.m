function [ hour,day,month,year ] = getdates( ss,extra,timezone )
% Takes the filename of a seismic record and outputs the integer value for
% its date.
%
% Coming soon: better adaptability for different filenames
%
%   INPUT
% ss: the complete filename. should be a character vector, formatted as
% "extraPP.S0001.00.HHZ.D.year.date(in julian days).hour.SAC
% extra: any modifiers that precede the rest of the filename
% timezone: '0' for EST (default), 1 for UTC. EST conversion currently
% only supports dates from 2016 and 2017.
%
%   OUTPUT
% hour, day, month, year: integer values for each of these attributes.
% Hours are in units of 100 and will be stored in EST.

defval('extra','')
defval('timezone',0)

days = ss;
days = regexprep(days,strcat(extra,'PP-S0001-00-HHZ-D-(\w+)-'),'');
days = strrep(days,'-SAC.mat','');
days = regexprep(days,'-(\w+)','');
day = str2num(char(days));  

yrs = ss;
yrs = strrep(yrs,strcat(extra,'PP-S0001-00-HHZ-D-(\w+)-'),'');
yrs = regexprep(yrs,'-(\w+)-(\w+)-(\w+).mat','');
year = str2num(char(yrs));

if year == 2016
    if day >= 1 && day <= 31
        month = 1;
    elseif day > 31 && day <= 60
        month = 2;
    elseif day > 60 && day <= 91
        month = 3;
    elseif day > 91 && day <= 121
        month = 4;
    elseif day > 121 && day <= 152
        month = 5;
    elseif day > 152 && day <= 182
        month = 6;
    elseif day > 182 && day <= 213
        month = 7;
    elseif day > 213 && day <= 244
        month = 8;
    elseif day > 244 && day <= 274
        month = 9;
    elseif day > 274 && day <= 305
        month = 10;
    elseif day > 305 && day <= 335
        month = 11;
    elseif day > 335 && day <= 366
        month = 12;
    end
elseif year == 2017
    if day >= 1 && day <= 31
        month = 1;
    elseif day > 31 && day <= 59
        month = 2;
    elseif day > 59 && day <= 90
        month = 3;
    elseif day > 90 && day <= 120
        month = 4;
    elseif day > 120 && day <= 151
        month = 5;
    elseif day > 151 && day <= 181
        month = 6;
    elseif day > 181 && day <= 212
        month = 7;
    elseif day > 212 && day <= 243
        month = 8;
    elseif day > 243 && day <= 273
        month = 9;
    elseif day > 273 && day <= 304
        month = 10;
    elseif day > 304 && day <= 334
        month = 11;
    elseif day > 334 && day <= 365
        month = 12;
    end       
end

hr = ss;
hr = regexprep(hr,'acc_PP-S0001-00-HHZ-D-(\w+)-','');
hr = strrep(hr,'-SAC.mat','');
hr = regexprep(hr,'(\w+)-','');
hour = str2num(char(hr));
hour = hour./100;

switch (timezone)
    case 0
        if year == 2016
            if day < 73 || day > 311
                hour = mod((hour - 500),2400)
            elseif day > 73 && day < 311
                hour = mod((hour - 400),2400)
            elseif day == 73 && hour < 200
                hour = mod((hour - 500),2400)
            elseif day == 73 && hour >= 200
                hour = mod((hour - 400),2400)
            elseif day == 311 && hour < 200
                hour = mod((hour - 400),2400)
            elseif day == 311 && hour >= 200
                hour = mod((hour - 500),2400)
            end
        elseif year == 2017 
            if day < 71 || day > 309
                hour = mod((hour - 500),2400)
            elseif day > 71 && day < 309
                hour = mod((hour - 400),2400)
            elseif day == 71 && hour < 200
                hour = mod((hour - 500),2400)
            elseif day == 71 && hour >= 200
                hour = mod((hour - 400),2400)
            elseif day == 309 && hour < 200
                hour = mod((hour - 400),2400)
            elseif day == 309 && hour >= 200
                hour = mod((hour - 500),2400)
            end
        else
            error('Can only convert to EST for years 2016 and 2017. Please switch timezone to UTC.')
        end
    case 1
        % You're done!
        
%alternate method:
%for i = 1:length(ss)
%     % Extract HHMMSS from the filename
%     hour2(i)=str2num(ss{i}(28:33));
% end

end

