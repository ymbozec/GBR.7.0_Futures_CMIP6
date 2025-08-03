%__________________________________________________________________________
%
% REEFMOD COUNTERFACTUAL RESULTS 2022
%
% Yves-Marie Bozec, y.bozec@uq.edu.au, 12/2023
% Cleaned 07/2025
%__________________________________________________________________________

%% Extract and plot the DHW projections for each SSP
% WARNING: What is recorded in 'applied_DHWs' (extracted from 'record_applied_DHWs'
% and compiled in 'all_DHW_scenarios(ssp,gcm).applied_DHWs' - see EXTRACT_DHW_SCENARIOS.m)
% is the maximum DHW actually applied on a given reef and year, so it takes 0 if there was a cyclone
% predicted during this summer. Need to decide what to represent: the raw DHW projections or the actual
% heat stress applied in relation to coral trajectories?

clear
SaveDir = 'FIGS/Raw_figs/Heat_stress'

SETTINGS_PLOTS

%% SELECT THE SSP TO PLOT
for ssp = 1:5
    
    ssp
    
    %% USING THE APPLIED DHW (mitigated by cyclones)
    % load('/home/ym/Dropbox/REEFMOD/REEFMOD_GBR_OUTPUTS/GBR.6.8_CMIP6_Nov2022/Extract_DHW/DHW_scenarios.mat') % Contains scenarios 20x3806x93 of DHW for each ssp and gcm [all_DHW_scenarios(ssp,gcm)]
    % load('/home/ym/Dropbox/REEFMOD/REEFMOD.6.8_GBR/data/GBR_REEF_POLYGONS_2023.mat')
    % 
    % ALL_DHWs = nan(1,3806,93);
    % 
    % for gcm=1:5
    % 
    %     ALL_DHWs = cat(1, ALL_DHWs, all_DHW_scenarios(ssp,gcm).applied_DHWs);
    % 
    % end
    % 
    % % Delete the starter
    % ALL_DHWs = ALL_DHWs(2:101,:,:);
    % X = reshape(ALL_DHWs, 100*3806,93);

    %% OR USING THE RAW DHW PROJECTIONS
    % Needs to go extract the raw files max_annual_DHW
    DHW = nan(1,93); % starter

    load('/home/ym/Dropbox/REEFMOD/REEFMOD.7.0_GBR/data/Climatology/Past/GBR_past_DHW_CRW_5km_1985_2023.mat')

    if ssp == 1
        gcm_list = [1:5 7 9]; 
    else
        gcm_list = [1:10];
    end

    for gcm = gcm_list

        gcm

        for simul = 1:20

            load(['/home/ym/Dropbox/REEFMOD/REEFMOD.7.0_GBR/data/Climatology/Future/CMIP6/' All_GCMs{gcm} '_' All_SSPs{ssp} '_annual_DHW_max.mat'])

            % Select the specified timeframe in the available forecast (column 29 is 2023)
            % Apr 24: now starting in 2024 (column 30)
            DHW_FORECAST = max_annual_DHW(:,30:end);
            % Let's shuffle available years within each decade
            DHW_FORECAST_shuffled = nan(size(DHW_FORECAST));
            start = 1; % first year of the selected forecast
            remain = size(DHW_FORECAST,2); % number of years still available

            while remain > 10

                sample = randperm(10); % sample at random within the decade
                DHW_FORECAST_shuffled(:,start:(start-1+length(sample)))= DHW_FORECAST(:,start-1+sample); % assign the shuffled years

                start = start + length(sample);
                remain = remain - length(sample);
            end

            % Last years available to be shuffled as well (Less than a decade available)
            sample = randperm(remain);
            DHW_FORECAST_shuffled(:,start:(start-1+length(sample)))= DHW_FORECAST(:,start-1+sample);

            % Finally assign to the DHW matrix
            DHW = [DHW ; [GBR_PAST_DHW(:,24:39) DHW_FORECAST_shuffled]]; %column 24 is 2008, column 39 is 2023

        end
    end

    DHW = DHW(2:end,:); %remove the starter

    X = DHW ; % swap for X
    
    %% Distribution of DHW values across reefs
    DHW_edges = [0 4 8 16 24 100];
    Stress_levels ={'0-4ºC-week','4-8ºC-week','8-16ºC-week','16-24ºC-week','>24ºC-week'};  
    Z = nan(93,length(Stress_levels));
    
    for yr = 1:93
        
        [counts, edges] = histcounts(X(:,yr),DHW_edges);
        Z(yr,:) = counts/sum(counts);
    end

    %% Plot
    YEARS = 2008:2100;
    myfig = figure;
    
    mybar = bar(YEARS,fliplr(Z),1,'stacked','EdgeColor','none');
    hold on

    mybar(5).FaceColor = [240 230 200]/255; % rgb('BlanchedAlmond');
    mybar(4).FaceColor = [240 200 170]/255; % rgb('Rosybrown');
    mybar(3).FaceColor = [240 150 120]/255; % rgb('IndianRed');
    mybar(2).FaceColor = [240 80 50]/255; % rgb('DarkRed');
    mybar(1).FaceColor = rgb('Brown');
    
    set(gca, 'Layer', 'top','FontName', 'Arial' ,'FontSize', myGraphicParms.FontSizeLabelTicks);
    ax = gca; 
    ylabel({'Proportion of reefs';'under heat stress'},'FontName', 'Arial', 'FontWeight','normal','FontSize',myGraphicParms.FontSizeLabelAxes)

    % For past DHW observations (need to comment the block below)
    axis([2007.5 2023.5 0 1]); 
    MyScenario = '/Heat_stress_past_obs';
    xticks([2007:1:2024])   
    ax.YLabel.Position(1)= 2006;
    ll=legend([mybar(5),mybar(4),mybar(3)],Stress_levels,'Box','on');
    ll.ItemTokenSize = [6 6];

    % For the forecast (need to be commented for the hindcast
    axis([2021.5 2100.5 0 1]); 
    MyScenario = ['/Heat_stress_real_SSP' All_SSPs{ssp} '_NEW']; % to align with projected coral
    xticks([2030:20:2100])   
    ax.YLabel.Position(1)= 2000;
    ll=legend([mybar(5),mybar(4),mybar(3),mybar(2),mybar(1)],Stress_levels,'Box','on');
    ll.ItemTokenSize = [6 6];    
    T1 = title(All_SSP_names(ssp),'Units','normalized','FontName', 'Arial','FontWeight','bold','FontSize',14);
    T1.Color = rgb(All_SSP_colours(ssp));
    
    savefig(myfig,[SaveDir  MyScenario])
    
    close all
    
end
