% Top-level direction, all others relative to this
fprintf(2, "Begin call_reconstruction_for_basins.m\n")

dataDir='/Volumes/ThunderBay';
regions={'AM','SD'};
names={'Vakhsh','Naryn'};

% Static inputs
ldasDemFile=fullfile(dataDir,'reconstruction/input_static/GLDAS/DEM',...
		     'gldas_topo.mat');
fprintf(2, "LDAS DEM: %s\n", ldasDemFile);

% cpu=2; % 12
% parpool(cpu)

for r=1:length(regions)
  fprintf(2, "Next basin: %s\n", names{r});
  
  topofile=fullfile(dataDir,'reconstruction/input_static',...
		    ['CHARIS_' names{r} '_463m_Topography.h5']);
  landcoverfile=fullfile(dataDir,'reconstruction/input_static',...
			 [names{r} '_landcover_463m_sinusoidal.mat']);

  fprintf(2, "Topo      : %s\n", topofile);
  fprintf(2, "Landcover : %s\n", landcoverfile);

  % sFileDay=1:1:366;
  sFileDay=[60 91 121 152]; % For testing

  fastFlag=1;
  for yr=2001:2001
%    if eomday(yr,2)==29;ly=1;else ly=0;end
%    sFileDay=1+ly:1:365+ly;  % FIXME: why does leap year start
%    on day 2?
    energyDir=fullfile(dataDir,'reconstruction/output',...
		       [regions{r} '_' num2str(yr)]);
    if ~exist(energyDir, 'dir')
      mkdir(energyDir);
    end
    sFile=fullfile(dataDir,'reconstruction/input_dynamic/modis',...
		   [names{r} '_MODSCAG_463m_sinusoidal_' num2str(yr) '.h5']);
    fprintf(2, "Snow      : %s\n", sFile);
    for d=1:length(sFileDay)
      fprintf(2, " Calling downscale_energy_azure\n");
      fprintf(2, "   sFileDay: %d\n", sFileDay(d));
      fprintf(2, "   sFile   : %s\n", sFile);
      fprintf(2, "   ...etc...\n");
      %{
      downscale_energy(sFileDay(d),sFile,cpu,topofile,...
		       landcoverfile,ldasDir,ldasDemFile,...
		       ceres_dir, ceres_topofile,...
		       fastFlag,energDir)
		       %}
    end % day loop
  end % year loop
end % regions loop

%%
%{
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
%}
fprintf(2,"End call_reconstruction_for_basins.m\n")

