for imth = 1:length(mth)
loglog(fax,Smedian(:,imth),'r')
xlim([1e-2 10])
ylim([1 1e12])
xlabel('frequency (Hz)')
ylabel('median power spectral density (V^2*s)')
name = num2str(mth(imth));
if (mth(imth) / 10) < 1
    name = strcat('0',name);
end
title(name)

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

set(gca,'TickDir','out')

print(fullfile('~/seismometer/noquakemonthlypsd',strrep(name,' ','')),'-dpng');
end