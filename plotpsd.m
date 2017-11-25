for ihr = 1:length(hrs)
loglog(fax,Smedian(:,ihr),'r')
xlim([1e-2 10])
ylim([1 1e12])
label = annotation('doublearrow',[.72 .89], [.8 .8]);
label.Color = 'g';
label.LineWidth = 1.5;
labelname = annotation('textbox',[.72 .48 .8 .4],'String','cultural noise');
labelname.FitBoxToText = 'on';
labelname.EdgeColor = 'none';

label2 = annotation('doublearrow',[.5 .65], [.8 .8]);
label2.Color = 'b';
label2.LineWidth = 1.5;
labelname2 = annotation('textbox',[.5 .48 .8 .4],'String','microseism');
labelname2.FitBoxToText = 'on';
labelname2.EdgeColor = 'none';

xlabel('frequency (Hz)')
ylabel('median power spectral density (V^2*s)')
intname = mod((hrs(ihr)/100 -4),24);
name = num2str(intname);
if (intname / 10) < 1
    name = strcat('0',name);
end
name = strcat(name,'00 EST');
title(name)

print(fullfile('~/seismometer/noquakehourlypsd',strrep(name,' ','')),'-dpng');
end