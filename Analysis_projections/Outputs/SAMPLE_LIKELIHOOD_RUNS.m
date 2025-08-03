%__________________________________________________________________________
%
% REEFMOD COUNTERFACTUAL CORAL TRAJECTORIES (MEAN GBR)
%
% Yves-Marie Bozec, y.bozec@uq.edu.au, 12/2023
% Last major update: 13/03/2024
%__________________________________________________________________________
clear

OutputName = 'GBR.7.0_likely_runs';

SETTINGS_PLOTS

% ECS values are 4.7, 4.3, 4.5, 3.1, 5.3, 2.6, 2.7, 3.0, 2.6, 2.6 for the GCMs in that order:
% All_GCMs = ["CNRM-ESM2-1" ; "EC-Earth3-Veg" ; "IPSL-CM6A-LR" ; "MRI-ESM2-0" ; "UKESM1-0-LL" ; ...
%    "GFDL-ESM4" ; "MIROC-ES2L" ; "MPI-ESM1-2-HR" ; "MIROC6" ; "NorESM2-LM" ];

% Using percentile range of the PDF of ECS as shown in Sherwood et al. (2020)
% "The 66% (17–83%) range for ECS, is 2.6–3.9°C with a median of 3.1°C. The 90% (5–95%) range is 2.3–4.7°C"
% So:
% 1-2.3 -> 5%
% 2.3-2.6 -> 17-5=12%
% 2.6-3.1 -> 50-12-5=33%
% 3.1-3.9 -> 83-33-12-5=33%
% 3.9-4.7 -> 95-83=12%
% 4.7-8 -> 5%
% S = [0.12 0.12 0.12 0.33 0.05 0.33 0.33 0.33 0.33 0.33];

% (10/04/24) Now using directly the density of probability of the ECS of each GCM
% after digitalisation of the PDF (Sherwood et al. 2020). Works as weights because give
% the relative likelihood of each ECS value (but not an estimate of the absolute probability of ECS)
S = [0.07 0.14 0.10 0.58 0.03 0.54 0.59 0.61 0.54 0.54]; 


P1 = S; % For all SSPs except SSP1-1.9 (10 GCMs)
P2 = S([1 2 3 4 5 7 9]); % For SSP1-1.9 (7 GCMs only)

N = 1000; % number of bootstrap samples

for ssp = 1:length(All_SSPs)
 
    if ssp == 1
        gcm_list = [1:5 7 9]; P = P2;
    else
        gcm_list = [1:10]; P = P1;
    end
    
    % Generate list of runs for each cyclone scenario
    run_ids = nan(1,length(gcm_list)); % primer
    for r = 1:20
        run_ids = [run_ids ; r:20:20*length(gcm_list)];
    end
    run_ids = run_ids(2:end,:); % remove the primer
    

    % Sample runs for each cyclone scenarios
    select = nan(20,N);
    
    for repeat=1:N
               
        for r = 1:20
            % Sample a GCM for that particular cyclone scneario realisations following associated likelihood
            select(r,repeat) = randsample(run_ids(r,:), 1, true, P);
        end
        
    end
    
    LIKELY_RUNS(ssp).select = select; 
    
end

save(['Extract_coral_trajectories/' OutputName '_NEW2.mat'], 'LIKELY_RUNS')
% Gives the ID of each run selected at random for a realisation of 20 cyclones (rows)
% repeated 100 times (columns)
% Run IDs are numbered 1:20 for gcm 1, then 21:40 for gcm 2 etc.