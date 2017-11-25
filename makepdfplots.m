function [pdfint] = makepdfplots(fax,bincenters,pdf,Smedian,Stwentyfive,Sseventyfive,Sninetyfive)
% This is a function that takes a 2D-array of linearly-spaced pdf values
% and outputs a new array of logarithmically-spaced values so that they 
% can more conveniently be ploted in the frequency domain. It also makes a
% figure (after McNamara and Buland 2004), plotting the pdf with the
% NLNM, NHNM, and average values from your sample.
%
% INPUT
% fax: frequency axis (spaced linearly)
% bincenters: power axis (should be in decibels)
% pdf: a 2D array of a probability density function for power
% Smedian: a curve of the median power, with respect to frequency axis
%
% OUTPUT
% pdfint: interpolated pdf in logarithmic space

% set the percentages that you want labeled on the colorabar
prc1=10;
prc2=95;

% take pdfs and psds, then put get their values in "log" space
[pdfint,logfax,xlabelslin,xlimlin] = lin2log(fax,pdf,'nearest');
foundit = false;
looking = 1;
while ~foundit
   foundit = ~isnan(pdfint(looking,1));
   looking = looking + 1;
end
pdfint(1:(looking-2),:) = [];
logfax(1:(looking-2))=[];
[hifax,hiS] = nhnm();
[lofax,loS] = nlnm();
[Smedint,newfax] = lin2log(fax,Smedian);

[hiSint,newhifax] = lin2log(hifax,hiS);
[loSint,newlofax] = lin2log(lofax,loS);
[S75int] = lin2log(fax,Sseventyfive);
[S25int] = lin2log(fax,Stwentyfive);
[S95int] = lin2log(fax,Sninetyfive);

% now plot them
pdfint = rot90(rot90(pdfint));
clf
ah(1)=gca;
toplot=pdfint(~~pdfint);
cax=[prctile(toplot,prc1) prctile(toplot,prc2)];
[h,cax]=imagefnan([logfax(end) bincenters(end)],[logfax(1) bincenters(1)],...
    transpose(pdfint),'parula',cax,[],1);
hold on
medh = plot(newfax,(10*log10(1e-18*Smedint)));
medh.Color = 'k';
medh.LineWidth = 2;
%twentyfiveh = plot(newfax,(10*log10(1e-18*S25int)));
%twentyfiveh.Color = 'k';
%twentyfiveh.LineWidth = 1;
%seventyfiveh = plot(newfax,(10*log10(1e-18*S75int)));
%seventyfiveh.Color = 'k';
%seventyfiveh.LineWidth = 1;
%ninetyfiveh = plot(newfax,(10*log10(1e-18*S95int)));
%ninetyfiveh.Color = 'k';
%ninetyfiveh.LineWidth = 1;

%hih = plot(newhifax,hiSint);
%hih.LineWidth = 2;
%hih.LineStyle = '--';
%hih.Color = 'm';
%loh = plot(newlofax,loSint);
%loh.LineWidth = 2;
%loh.LineStyle = '--';
%loh.Color = 'm';

%legend('median','NHNM','NLNM')

% fix the x-axis
xlim(xlimlin)
set(gca,'XTick',xlabelslin)
xlabelstring = {'1e-2','','','','','','',...
    '','','1e-1','','','','','','','','','1','','','','','','','','','10'};
set(gca,'XTickLabel',xlabelstring)
axis normal

% Colorbar
cbtix=unique([cax(1) prctile(toplot,[33 50 67]) cax(2)]);
cbtix=round(cbtix*10000)/10000;
[cb,xcb]=addcb([0.9 0.1095 0.01 0.8155],cax,cax,'parula',cbtix,1);

% Cosmetics
longticks(ah(1),2)
longticks(cb,2)
xlabel(ah,'frequency (Hz)')
ylabel(ah,'power [10log10(m^2/s^4)/Hz][dB]')
ah.Position=[0.1300 0.1100 0.7250 0.8150]
xcb.String='pdf of psd';
cb.YAxisLocation='right';

% add a period axis
axes(ah(1))
oldxlabs=get(gca,'xtick');
xlabs = zeros(1,length(oldxlabs));
xlabs(1) = oldxlabs(end);
deltax = diff(oldxlabs);
for i = 1:(length(oldxlabs)-1)
    xlabs(i+1) = xlabs(i) - deltax(i);
end
xlabels = {'1e-1','','','','','','','','','1','','','','','','','','',...
    '10','','','','','','','','','100'};
[ax]=xtraxis(ah(1),xlabs,xlabels,'period (s)');
longticks(ax,2)

print -dpdf -bestfit try


