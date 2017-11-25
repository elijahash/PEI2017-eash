ss = ls2cell('accelerationredo/acc*HHZ*SAC');

for i = 1:length(ss)
    makemtmpsd( '~/seismometer/accelerationredo/', ss{i}, '~/seismometer/accelerationpsd/', 72000 )
end