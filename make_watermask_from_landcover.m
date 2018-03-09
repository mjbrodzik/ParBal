%% use a landcover file to make a dummy water mask
data_dir = '/Volumes/ThunderBay/reconstruction';

names = {'Vakhsh', 'Naryn'};

for i=1:length(names)
  
  landcover_file = fullfile( data_dir, 'input/landcover',...
			     [names{i} '_landcover_463m_sinusoidal.mat'] );
  watermask_file = fullfile( data_dir, 'input/landcover',...
			     [names{i} '_watermask_dummy_463m_sinusoidal.mat'] );
  load( landcover_file, 'cc' );
  watermask = false( size(cc) );
  save( watermask_file, 'watermask' );

end

fprintf( 2, "End\n" );  
  


