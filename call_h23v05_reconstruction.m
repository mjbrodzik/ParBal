addpath('C:\Users\nbair\Dropbox\reconstruction_working\code');

topofile='C:\raid\data\nbair\datasets\Topography_h23v05\GDEM_MODIS_h23v05_500m_Topography.h5';
landcoverfile='C:\raid\data\nbair\datasets\Landcover_h23v05\h23v05LandCover.mat';
watermaskfile='C:\raid\data\nbair\datasets\masks\h23v05_water_mask.mat';
ldas_dir='C:\raid\scratch\reconstruction\GLDAS2\data\GLDAS\GLDAS_NOAH025_3H.2.1';
ceres_dir='C:\raid\scratch\reconstruction\CERES';
ceres_topofile='C:\raid\scratch\reconstruction\CERES\DEM\CEREStopo.mat';
ldas_topofile='C:\raid\scratch\reconstruction\GLDAS\DEM\gldas_topo.mat';
basedir='C:\raid\data\nbair\datasets\reconstructions\h23v05';                
melt_outdir=fullfile(basedir,'melt');
sdir='C:\raid\data\nbair\datasets\modscag_h23v05\h23v05_karl';
watermask='C:\raid\data\nbair\datasets\masks\h23v05_water_mask.mat';
poolsize=20;
%just compute M
fast_flag=true;
parpool_check(poolsize);

ys=2017;
for i=1:length(ys)
    y=ys(i);
    d=dir(fullfile(sdir,sprintf('*%i.h5',y)));
    sFile=fullfile(d.folder,d.name);
    rFile=fullfile(basedir,sprintf('reconstruction_h23v05_CY%i.h5',y));
%     parfor j=1:304
%     parfor j=1:273
% %     parfor j=1:yeardays(y)
%         outfile=fullfile(melt_outdir,[datestr(datenum([y 1 1])+j-1,'yyyymmdd'),'.mat']);
%         if 0==exist(outfile,'file')
%         downscale_energy(j,sFile,topofile,landcoverfile,...
%             ldas_dir,ldas_topofile,ceres_dir,ceres_topofile,fast_flag,...
%             melt_outdir,true)
%         end
%     end
    reconstructSWE(poolsize,melt_outdir,sFile,rFile,'canopycoverfile',landcoverfile,...
        'watermaskfile',watermask);
end