files = ls2cell('~/seismometer/psddata/*2016*001*');
x=zeros(1,24);
z=zeros(180001,24);

for i=1:length(files)
    name = strrep(files{i},'PP-S0001-00-HHZ-D-2016-001-','');
    name = strrep(name,'-SAC.mat','');
    x(1,i) = str2num(name);
    
    file = matfile(files{i});
    z(:,i) = file.S;
end

file = matfile('~/seismometer/psddata/PP-S0001-00-HHZ-D-2016-001-000000-SAC.mat');
y = file.fax;

y = log(y);
z = log(z);

y(1) = -8.5;

contourf(x,y,z)