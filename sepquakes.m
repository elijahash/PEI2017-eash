files = textread('earthquakeFiles.txt','%s','delimiter','\r');
dirin = '~/seismometer/smallsmoothdata/';
dirout = '~/seismometer/smallsmoothdata/earthquakes';
ss = ls2cell(dirin);

for i=1:length(files)
    files(i) = regexprep(files(i),'~/seismometer/(\w+)/(\w+)/(\w+)/','');
    files(i) = strrep(files(i),'.','-');
    files(i) = strcat(files(i),'.mat');

    for j=1:length(ss)
        if strcmp(files{i},ss{j})
            try
                movefile(fullfile(dirin,ss{j}),dirout);
            catch ME
            end
        end
    end
end
