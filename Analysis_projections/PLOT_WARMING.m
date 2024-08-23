%__________________________________________________________________________
%
% REEFMOD COUNTERFACTUAL RESULTS 2024
%
% Yves-Marie Bozec, y.bozec@uq.edu.au, 12/2023
%__________________________________________________________________________

clear
SaveDir = '';

SETTINGS_PLOTS % general settings for plotting
load('GBR_past_DHW_CRW_5km_1985_2023.mat') % Historical DHW per reef

DHW_edges = [0 4 8 16 24 100];
Stress_levels ={'0-4ºC-week','4-8ºC-week','8-16ºC-week','16-24ºC-week','>24ºC-week'};

%% SELECT THE SSP TO PLOT
for ssp = 1:5

    ssp
    DHW = nan(1,93); % starter

    if ssp == 1
        gcm_list = [1:5 7 9];
    else
        gcm_list = [1:10];
    end

    for gcm = gcm_list

        gcm

        for simul = 1:20

            % Load the heat stress scenarios iteratively
            % (available from REEFMOD.7.0_GBR/data/Climatology/Future/CMIP6 in GitHub)
            % https://github.com/ymbozec/REEFMOD.7.0_GBR/tree/fd0b8e3195c9eac77430eef08257c39403ace06d/data/Climatology/Future/CMIP6
            MyPath = '/home/ym/Dropbox/REEFMOD/REEFMOD.7.0_GBR/data/Climatology/Future/CMIP6/';
            load([MyPath All_GCMs{gcm} '_' All_SSPs{ssp} '_annual_DHW_max.mat'])

            % Select the specified timeframe in the available forecast (column 30 is 2024)
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

            % Last years available need to be shuffled as well (but less than a decade is available)
            sample = randperm(remain);
            DHW_FORECAST_shuffled(:,start:(start-1+length(sample)))= DHW_FORECAST(:,start-1+sample);

            % Finally assign to the DHW matrix and collate with historical DHW
            DHW = [DHW ; [GBR_PAST_DHW(:,24:39) DHW_FORECAST_shuffled]]; % In the historical DHW, column 24 is 2008, column 39 is 2023

        end
    end

    DHW = DHW(2:end,:); %remove the starter

    %% Distribution of DHW values across reefs
    Z = nan(93,length(Stress_levels));

    for yr = 1:93

        [counts, edges] = histcounts(DHW(:,yr),DHW_edges);
        Z(yr,:) = counts/sum(counts);
    end

    %% Plot the percentage of reefs (n=3,806) under different categories of heat stress
    %% across all climate projections (n=140 projections for SSP1-1.9, n=200 for all other SSPs)
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

    % For the forecast (need to be commented for the hindcast
    axis([2021.5 2100.5 0 1]);
    MyScenario = ['Heat_stress_real_SSP' All_SSPs{ssp}]; % to align with projected coral
    xticks([2030:20:2100])
    ax.YLabel.Position(1)= 2000;
    ll=legend([mybar(5),mybar(4),mybar(3),mybar(2),mybar(1)],Stress_levels,'Box','on');
    ll.ItemTokenSize = [6 6];
    T1 = title(All_SSP_names(ssp),'Units','normalized','FontName', 'Arial','FontWeight','bold','FontSize',14);
    T1.Color = rgb(All_SSP_colours(ssp));

    savefig(myfig,[SaveDir  MyScenario])

end

%% Plot the proportion of reefs under different categories of heat stress between 2008 and 2023
% (just take the last iteration of DHW as they are all the same for the hindcast)
axis([2007.5 2023.5 0 1]);
MyScenario = 'Heat_stress_Hindcast';
xticks([2007:1:2024])
ax.YLabel.Position(1)= 2006;
ll=legend([mybar(5),mybar(4),mybar(3)],Stress_levels,'Box','on');
ll.ItemTokenSize = [6 6];
delete(T1)
savefig(myfig,[SaveDir  MyScenario])
