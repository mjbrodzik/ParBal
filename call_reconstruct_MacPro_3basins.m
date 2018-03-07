inDir='/Volumes/LaCie';
regions={'IN','GA_BR','SD_AM'};
names={'Indus','Ganges_Brama','SyrDarya_AmuDarya'};
cpu=12;
parpool(cpu)
for r=1:length(regions)
    topofile=fullfile(inDir,'reconstruction_inputs',...
        ['CHARIS_' regions{r} '_463m_Topography.h5']);
    landcoverfile=fullfile(inDir,'reconstruction_inputs',...
        ['CHARIS_' regions{r} '_landcover_463m_sinusoidal.mat']);
    ldas_dir='/Volumes/scratch/GLDAS';
    ldas_dem_file=fullfile(ldas_dir,'DEM/gldas_topo.mat');
    %sFileDay=1:1:366;    %sFileDay=[60 91 121 152];%For testing

    for yr=2001:2014
        if eomday(yr,2)==29;ly=1;else ly=0;end
        sFileDay=1+ly:1:365+ly;
        energy_dir=fullfile('/Volumes/LaCie/energy/',...
            [regions{r} '_' num2str(yr)]);
        mkdir(energy_dir)
        sFile=fullfile(inDir,'reconstruction_inputs',...
        [names{r} '_MODSCAG_463m_sinusoidal_' num2str(yr) '.h5']);
        for d=1:length(sFileDay)%171:269
            downscale_energy_azure(sFileDay(d),sFile,topofile,landcoverfile,...
                ldas_dir,ldas_dem_file,energy_dir,cpu,1)
        end
    end
end
%%
inDir='/Volumes/LaCie';
names={'Indus','Ganges_Brama','SyrDarya_AmuDarya'};
regions={'IN','GA_BR','SD_AM'};
for r=3:3%length(regions)
    for yr=2001:2005
        sFile=fullfile(inDir,'reconstruction_inputs',...
            [names{r} '_MODSCAG_463m_sinusoidal_' num2str(yr) '.h5']);
        rFile=fullfile(inDir,'reconstruction_outputs',...
            ['reconstruction_' regions{r} '_463m_WY' num2str(yr) '.mat']);
        energy_dir=fullfile(inDir,['energy_' regions{r}]);
        reconstructSWE_azure(energy_dir,sFile,rFile);
    end
end