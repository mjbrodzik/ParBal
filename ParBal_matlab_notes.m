% adding path for project
addpath('/Users/brodzik/ParBal')

% when we run, use fastFlag=True to only solve for melt

% data are in /Volumes/ThunderBay/reconstruction
% matlab indexing is 1-based

% for opening/deleting parpool:
parpool(2)
delete(gcp)

% if you just run something with "parfor" loops in it, it uses your
% parallel pools defaults

% doc FUNCTION_NAME for help
% help FUNCTION_NAME is different, less useful

% Karl will fetch the ldas DEM
% I need to learn how to fetch desired ldas data

% copy GLDAS and DEM files from /work/charis/GLDAS

% run stuff for Naryn and Vakhsh

% Use ~/MATLAB  as top dirdir for my scripts/etc
% prob also one level down for specific projects/
% matlab assumes cwd 