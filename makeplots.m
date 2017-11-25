% makes psd plots for all of the seismograms

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
            sac2psd(fullfile(bigdir(i).name,months(l).name,days(m).name),'~/seismometer/PDF/');
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