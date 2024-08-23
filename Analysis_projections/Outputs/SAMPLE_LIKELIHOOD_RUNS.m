%__________________________________________________________________________
%
% REEFMOD COUNTERFACTUAL CORAL TRAJECTORIES (MEAN GBR)
%
% Yves-Marie Bozec, y.bozec@uq.edu.au, 03/2024
%__________________________________________________________________________
clear

SETTINGS_PLOTS % general settings for plotting

% Use the density of probability of the ECS of each GCM derived from (Sherwood et al. 2020). [see Paremeterisation]
% as weights for the relative likelihood of each GCM (NOTan estimate of the absolute probability of ECS)
S = [0.07 0.14 0.10 0.58 0.03 0.54 0.59 0.61 0.54 0.54]; % extracted from the curve of sherwood given the ECS value of each GCM

P1 = S; % For all SSPs except SSP1-1.9 (10 GCMs)
P2 = S([1 2 3 4 5 7 9]); % For SSP1-1.9 (7 GCMs only)

N = 100; % number of bootstrap samples

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
            % Sample a GCM for that particular cyclone realisation following associated likelihood
            select(r,repeat) = randsample(run_ids(r,:), 1, true, P);
        end
        
    end
    
    LIKELY_RUNS(ssp).select = select; 
    
end

save(['GBR.7.0_likely_runs_NEW.mat'], 'LIKELY_RUNS')
% Gives the ID of each run selected at random for a realisation of 20 cyclones (rows)
% repeated 100 times (columns)
% Run IDs are numbered 1:20 for gcm 1, then 21:40 for gcm 2 etc.