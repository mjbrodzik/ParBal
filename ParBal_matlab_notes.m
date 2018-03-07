* TODO:

- copy GLDAS and DEM files from /work/charis/GLDAS to ThunderBay
- get recipe modified and running for a couple days, check output
- run ParBal for Naryn and Vakhsh


* General ParBal notes:

% when we run ParBal, use fastFlag=True to only solve for melt

* General Matlab notes:

% matlab indexing is 1-based

% adding path for project
addpath('/Users/brodzik/ParBal')

% for opening/deleting parpool:
parpool(2)
delete(gcp)

% if you just run something with "parfor" loops in it, it uses your
% parallel pools defaults

% doc FUNCTION_NAME for help
% help FUNCTION_NAME is different, less useful

% Karl will fetch the ldas DEM
% I need to learn how to fetch desired ldas data

% Use ~/MATLAB  as top dirdir for my scripts/etc
% matlab assumes cwd 

* Globus

To add something other than ~/ to Globus defaults,
open Globus Personal Connect App on Mac,
and go to Preferences->Access tab.
