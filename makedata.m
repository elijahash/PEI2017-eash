% stores psd data to text files

% We want this length
nfft=360000;

bigdir = getfolders('~/seismometer/');

for k = length(bigdir):-1:1
    fname = bigdir(k).name;
    if fname(1) == '2'
    else
        bigdir(k) = [ ];
    end
end

for i=1:length(bigdir)
    months = getfolders(bigdir(i).name);
    for l=1:length(months)
    days = getfolders(fullfile(bigdir(i).name,months(l).name));
        for m=1:length(days)
            diro = fullfile(bigdir(i).name,months(l).name,days(m).name);
            
            % What SAC seismograms are in there?
            ss=ls2cell(fullfile(diro,'*HHZ*SAC'));
            
            for index=1:length(ss)
                [S,fax]=psdest(diro,ss{index},nfft);
                name = strrep(ss{index},'.','-');
                name = strcat(name,'.mat');
                save(fullfile('~/seismometer/smoothpsddata/',name),'S','fax', ...
                    '-v7.3');
            end
        end
    end
end
    
% ------------------------------------------------------------
function [folders] = getfolders(path)

folders = dir(path);

for k = length(folders):-1:1
    % remove non-folders
    if ~folders(k).isdir
        folders(k) = [ ];
        continue
    end

    % remove folders starting with .
    fname = folders(k).name;
    if fname(1) == '.'
        folders(k) = [ ];
    end
end
end
% ------------------------------------------------------------