%% Top-level direction, all others relative to this
begin_time = now;
fprintf( 2, "%s: Begin call_reconstruction_for_basins.m\n",...
	 datestr( begin_time ) );

do_energy = true;
do_swe_recon = false;

data_dir = '/Volumes/ThunderBay/reconstruction';

regions = { 'AM', 'SY' };
names = { 'Vakhsh', 'Naryn' };

%% LDAS only (ignore CERES inputs)
ldas_only = true;

%% Year range
start_year = 2001;
stop_year = 2001;

%% Static inputs can be initialized outside the loops
%% LDAS directory should contain data by year sub directories
ldas_basedir = fullfile( data_dir, 'input/GLDAS_NOAH025_3H.2.1' );
ldas_topo_file = fullfile( data_dir, 'input/GLDAS/DEM', 'gldas_topo.mat' );
ceres_dir = fullfile( data_dir, 'input/CERES' );
ceres_topo_file = fullfile( ceres_dir, 'DEM', 'CEREStopo.mat');
fprintf( 2, "LDAS topo : %s\n", ldas_topo_file );
fprintf( 2, "CERES topo: %s\n", ceres_topo_file );

  
%% If outer loops are parpool, it will ignore inner parpool loop
poolsize = 10;
parpool( poolsize );

for r=1:length(regions)
  
  fprintf( 2, "EB for next basin: %s\n", names{r} );
  
  topo_file = fullfile( data_dir, 'input/topography',...
			['CHARIS_' names{r} '_463m_Topography.h5'] );
  landcover_file = fullfile( data_dir, 'input/landcover',...
			     [names{r} '_landcover_463m_sinusoidal.mat'] );

  fprintf( 2, "Topo      : %s\n", topo_file);
  fprintf( 2, "Landcover : %s\n", landcover_file);

  %% fast_flag on means just solves for melt, otherwise solves
  %% for all outputs
  fast_flag=1;
  
  for yr=start_year:stop_year
    fprintf( 2, " Next year=%d\n", yr );

    if eomday( yr, 2 ) == 29; ly=1; else ly = 0; end
    %% doys = 1:1:365+ly;
    %% doys=[ 60 70 91 101 121 131 152 162 182 192 ]; % For testing
    doys=[ 268 269 ];
    
    energy_dir = fullfile( data_dir, 'output/melt',...
			   [ names{r} '_' datestr( now, 'yyyymmdd') ] );
    if ~exist( energy_dir, 'dir')
      mkdir( energy_dir );
    end
    snow_file = fullfile( data_dir, 'input/MODIS', names{r},...
			  [ names{r} '_MODSCAG_463m_sinusoidal_' ...
				 num2str(yr) '.h5' ] );

    if do_energy
      fprintf( 2, "\n Doing Energy: \n" );

      for d=1:length(doys)
	fprintf( 2, " Calling downscale_energy for doy=%d\n", doys(d) );
	fprintf( 2, "   Snow    : %s\n", snow_file );
	downscale_energy(doys(d),snow_file,topo_file,landcover_file,...
			 ldas_basedir,ldas_topo_file,...
			 ceres_dir, ceres_topo_file,...
			 fast_flag, energy_dir, ldas_only);
      end % doy loop

    end % do_energy

    if do_swe_recon
      fprintf( 2, "\n Doing SWE recon: \n" );
      recon_dir = fullfile( data_dir, 'output/reconstruction',...
			    [ names{r} '_' datestr( now, 'yyyymmdd') ] );
      if ~exist( recon_dir, 'dir')
	mkdir( recon_dir );
      end
      reconstruction_file = fullfile( recon_dir,...
				      sprintf('%s_reconstruction_CY%i.h5',...
					       names{r}, yr ) );
      reconstructSWE( poolsize, energy_dir, snow_file, reconstruction_file,...
		      'canopycoverfile', landcover_file,...
		      'watermaskfile', watermask_file );
      
    end % do_swe_recon
    
  end % year loop
  
end % regions loop
  
end_time = now;
fprintf( 2, "%s: End call_reconstruction_for_basins.m\n",...
	 datestr( end_time ) );
fprintf( 2, "Elapsed time=%s\n",...
	 datestr( end_time - begin_time, 'HH:MM:SS.FFF' ) );


