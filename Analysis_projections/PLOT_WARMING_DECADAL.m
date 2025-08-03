%__________________________________________________________________________
%
% REEFMOD COUNTERFACTUAL RESULTS 2022
%
% Yves-Marie Bozec, y.bozec@uq.edu.au, 12/2023
% Updated 04/2024 (DHW future now starts in 2024)
%__________________________________________________________________________

%% Extract and plot the DHW projections for each SSP
% WARNING: What is recorded in 'applied_DHWs' (extracted from 'record_applied_DHWs'
% and compiled in 'all_DHW_scenarios(ssp,gcm).applied_DHWs' - see EXTRACT_DHW_SCENARIOS.m)
% is the maximum DHW actually applied on a given reef and year, so it takes 0 if there was a cyclone
% predicted during this summer. Need to decide what to represent: the raw DHW projections or the actual
% heat stress applied in relation to coral trajectories?

clear
SaveDir = 'FIGS/Raw_figs/Heat_stress'
OutputName = 'sR0_GBR.7.0_';
Stress_levels = {'DHW ≥ 8°C-week';'DHW ≥ 12°C-week';'DHW ≥ 16°C-week';'DHW ≥ 20°C-week'};
SETTINGS_PLOTS
YEARS = 2008:2100;

load('/home/ym/Dropbox/REEFMOD/REEFMOD.6.9_GBR/data/GBR_REEF_POLYGONS_2023.mat')% reef definition
load('/home/ym/Dropbox/REEFMOD/REEFMOD_DATA/Shapefiles/GBR_MAPS.mat') ; % shapefiles, include map of isands and mainland

%% SELECT THE SSP TO PLOT
for ssp = 1:5

    ssp

    %% OR USING THE RAW DHW PROJECTIONS
    % Needs to go extract the raw files max_annual_DHW
    % starters
    % F_8DHW = nan(1,77);
    % F_12DHW = nan(1,77);
    % F_16DHW = nan(1,77);
    % F_20DHW = nan(1,77);
    F_8DHW = nan(1,72);
    F_12DHW = nan(1,72);
    F_16DHW = nan(1,72);
    F_20DHW = nan(1,72);

    load('/home/ym/Dropbox/REEFMOD/REEFMOD.7.0_GBR/data/Climatology/Past/GBR_past_DHW_CRW_5km_1985_2023.mat') % updated NOAA-CRW with 2021 (no bleaching) and 2022 (bleaching)

    if ssp == 1
        gcm_list = [1:5 7 9];
    else
        gcm_list = [1:10];
    end

    % Pre-allocate matrices of probability of a given heat stress (one column for each gcm)
    P_tot_8DHW = nan(3806,10);
    P_tot_12DHW = nan(3806,10);
    P_tot_16DHW = nan(3806,10);
    P_tot_20DHW = nan(3806,10);
    THERMAL_SCORE = nan(3806,10);

    for gcm = gcm_list

        gcm

        load(['/home/ym/Dropbox/REEFMOD/REEFMOD.7.0_GBR/data/Climatology/Future/CMIP6/' All_GCMs{gcm} '_' All_SSPs{ssp} '_annual_DHW_max.mat'])
        DECADAL_FREQ_8DHW = zeros(3806, size(F_8DHW,2));

        for yr = 1:size(F_8DHW,2) % (year 30 is 2024)
            % Select the specified timeframe in the available forecast
            % DHW_FORECAST = max_annual_DHW(:,30+yr-10:30+yr-1);
            DHW_FORECAST = max_annual_DHW(:,30+yr-5:30+yr-1+5);

            DECADE_EVENT_8DHW = zeros(3806,10);
            DECADE_EVENT_8DHW(DHW_FORECAST>=8)=1;
            DECADAL_FREQ_8DHW(:,yr) = sum(DECADE_EVENT_8DHW,2);

            DECADE_EVENT_12DHW = zeros(3806,10);
            DECADE_EVENT_12DHW(DHW_FORECAST>=12)=1;
            DECADAL_FREQ_12DHW(:,yr) = sum(DECADE_EVENT_12DHW,2);

            DECADE_EVENT_16DHW = zeros(3806,10);
            DECADE_EVENT_16DHW(DHW_FORECAST>=16)=1;
            DECADAL_FREQ_16DHW(:,yr) = sum(DECADE_EVENT_16DHW,2);

            DECADE_EVENT_20DHW = zeros(3806,10);
            DECADE_EVENT_20DHW(DHW_FORECAST>=20)=1;
            DECADAL_FREQ_20DHW(:,yr) = sum(DECADE_EVENT_20DHW,2);
        end

        F_8DHW = [F_8DHW ; DECADAL_FREQ_8DHW];
        F_12DHW = [F_12DHW ; DECADAL_FREQ_12DHW];
        F_16DHW = [F_16DHW ; DECADAL_FREQ_16DHW];
        F_20DHW = [F_20DHW ; DECADAL_FREQ_20DHW];

        % Calculate the probability of a given intensity  yeary (for mapping)
        year_max = 66; % capture from 2024 t 2060
        F_tot_8DHW = zeros(3806, size(max_annual_DHW(:,30:year_max),2));
        F_tot_8DHW(max_annual_DHW(:,30:year_max)>=8)=1;
        P_tot_8DHW(:,gcm) = sum(F_tot_8DHW,2)/size(max_annual_DHW(:,30:year_max),2);

        F_tot_12DHW = zeros(3806, size(max_annual_DHW(:,30:year_max),2));
        F_tot_12DHW(max_annual_DHW(:,30:year_max)>=12)=1;
        P_tot_12DHW(:,gcm) = sum(F_tot_12DHW,2)/size(max_annual_DHW(:,30:year_max),2);

        F_tot_16DHW = zeros(3806, size(max_annual_DHW(:,30:year_max),2));
        F_tot_16DHW(max_annual_DHW(:,30:year_max)>=16)=1;
        P_tot_16DHW(:,gcm) = sum(F_tot_16DHW,2)/size(max_annual_DHW(:,30:year_max),2);

        F_tot_20DHW = zeros(3806, size(max_annual_DHW(:,30:year_max),2));
        F_tot_20DHW(max_annual_DHW(:,30:year_max)>=20)=1;
        P_tot_20DHW(:,gcm) = sum(F_tot_20DHW,2)/size(max_annual_DHW(:,30:year_max),2);

        MEAN_DHW = mean(max_annual_DHW(:,30:year_max),2);
        THERMAL_SCORE(:,gcm) = (MEAN_DHW - min(MEAN_DHW))/(max(MEAN_DHW) - min(MEAN_DHW)); % rescale between 0 and 1 for each gcm
    end

    F_8DHW = F_8DHW(2:end,:); %remove the starter
    F_12DHW = F_12DHW(2:end,:); %remove the starter
    F_16DHW = F_16DHW(2:end,:); %remove the starter
    F_20DHW = F_20DHW(2:end,:); %remove the starter

    SUMMARY_8DHW = array2table(transpose([YEARS(17:end-5) ; mean(F_8DHW,1) ; prctile(F_8DHW,10,1) ;  median(F_8DHW,1) ; prctile(F_8DHW,90,1)]));
    SUMMARY_8DHW.Properties.VariableNames = {'Year';'Mean';'10PCTILE';'Median';'90PCTILE'};

    SUMMARY_12DHW = array2table(transpose([YEARS(17:end-5) ; mean(F_12DHW,1) ; prctile(F_12DHW,10,1) ;  median(F_12DHW,1) ; prctile(F_12DHW,90,1)]));
    SUMMARY_12DHW.Properties.VariableNames = {'Year';'Mean';'10PCTILE';'Median';'90PCTILE'};

    SUMMARY_16DHW = array2table(transpose([YEARS(17:end-5) ; mean(F_16DHW,1) ; prctile(F_16DHW,10,1) ;  median(F_16DHW,1) ; prctile(F_16DHW,90,1)]));
    SUMMARY_16DHW.Properties.VariableNames = {'Year';'Mean';'10PCTILE';'Median';'90PCTILE'};

    SUMMARY_20DHW = array2table(transpose([YEARS(17:end-5) ; mean(F_20DHW,1) ; prctile(F_20DHW,10,1) ;  median(F_20DHW,1) ; prctile(F_20DHW,90,1)]));
    SUMMARY_20DHW.Properties.VariableNames = {'Year';'Mean';'10PCTILE';'Median';'90PCTILE'};

    % NEW (Aug 24): plot median, 10th and 90th percentiles
    % 8 DHW
    myfig = figure;
    xconf = [SUMMARY_8DHW.Year ; flip(SUMMARY_8DHW.Year)];
    yconf = [SUMMARY_8DHW.("10PCTILE") ; flip(SUMMARY_8DHW.("90PCTILE"))];
    p = fill(xconf,yconf,rgb('Rosybrown'),'FaceAlpha',0.3);
    hold on
    plot(SUMMARY_8DHW.Year,SUMMARY_8DHW.Median,'Color',rgb('Rosybrown'),'LineWidth',2)
    axis([2024 2094 0 10.5])
    set(gca, 'Layer', 'top','FontName', 'Arial' ,'FontSize', myGraphicParms.FontSizeLabelTicks);
    xticks([2030:20:2100])
    ylabel({'Number of heatwaves per decade'},'FontName', 'Arial', 'FontWeight','normal','FontSize',myGraphicParms.FontSizeLabelAxes)
    ax = gca; ax.YLabel.Position(1)= 2025;
    T1 = text(0.1, 0.9, All_SSP_names(ssp),'Units','normalized','FontName', 'Arial','FontWeight','bold','FontSize', ...
        myGraphicParms.FontSizeLabelAxes-1, 'HorizontalAlignment','left');
    T1.Color = rgb(All_SSP_colours(ssp));
    
    savefig(myfig,[SaveDir '/Heat_stress_8DHW_DISTRI_DECADAL_FREQ_real_SSP' All_SSPs{ssp}])

    % 16 DHW
    myfig = figure;
    xconf = [SUMMARY_16DHW.Year ; flip(SUMMARY_16DHW.Year)];
    yconf = [SUMMARY_16DHW.("10PCTILE") ; flip(SUMMARY_16DHW.("90PCTILE"))];
    p = fill(xconf,yconf,rgb('Indigo'),'FaceAlpha',0.3);
    hold on
    plot(SUMMARY_16DHW.Year,SUMMARY_16DHW.Median,'Color',rgb('Indigo'),'LineWidth',2)
    axis([2024 2094 0 10.5])
    set(gca, 'Layer', 'top','FontName', 'Arial' ,'FontSize', myGraphicParms.FontSizeLabelTicks);
    xticks([2030:20:2100])
    ylabel({'Number of heatwaves per decade'},'FontName', 'Arial', 'FontWeight','normal','FontSize',myGraphicParms.FontSizeLabelAxes)
    ax = gca; ax.YLabel.Position(1)= 2025;
    T1 = text(0.1, 0.9, All_SSP_names(ssp),'Units','normalized','FontName', 'Arial','FontWeight','bold','FontSize', ...
        myGraphicParms.FontSizeLabelAxes-1, 'HorizontalAlignment','left');
    T1.Color = rgb(All_SSP_colours(ssp));

    savefig(myfig,[SaveDir '/Heat_stress_16DHW_DISTRI_DECADAL_FREQ_real_SSP' All_SSPs{ssp}])

    %% Plot
    % myfig = figure;
    %
    % p1=plot(YEARS(17:end-5), mean(F_8DHW,1),'-','Color',rgb('Rosybrown'),'LineWidth',2);
    % hold on
    % p2=plot(YEARS(17:end-5), mean(F_12DHW,1),'-','Color',rgb('IndianRed'),'LineWidth',2);
    % p3=plot(YEARS(17:end-5), mean(F_16DHW,1),'-','Color',rgb('Indigo'),'LineWidth',2);
    % p4=plot(YEARS(17:end-5), mean(F_20DHW,1),'-','Color',rgb('Black'),'LineWidth',2);
    % % axis([2024 2099 0 10.5])
    % axis([2024 2094 0 10.5])
    % 
    % set(gca, 'Layer', 'top','FontName', 'Arial' ,'FontSize', myGraphicParms.FontSizeLabelTicks);
    % xticks([2030:20:2100])
    % 
    % ylabel({'Mean number of heatwaves per decade'},'FontName', 'Arial', 'FontWeight','normal','FontSize',myGraphicParms.FontSizeLabelAxes)
    % ax = gca; ax.YLabel.Position(1)= 2025;
    % 
    % T1 = text(0.1, 0.9, All_SSP_names(ssp),'Units','normalized','FontName', 'Arial','FontWeight','bold','FontSize', ...
    %     myGraphicParms.FontSizeLabelAxes-1, 'HorizontalAlignment','left');
    % T1.Color = rgb(All_SSP_colours(ssp));
    % 
    % ll=legend([p1,p2,p3,p4],Stress_levels,'Box','on');
    % ll.ItemTokenSize = [6 6];
    % ll.Position(2)=0.72;
    % ll.Position(1)=0.62;
    % 
    % savefig(myfig,[SaveDir '/Heat_stress_MEAN_DECADAL_FREQ_real_SSP' All_SSPs{ssp}])

    close all

    %% Map the probability of sveere heat stress yearly
    %     FontSizeTowns = 11 ;
    %     FontSizeCoord = 14 ;
    %     FontSizeTitleCC = 12 ; % for some reason needs to be downsized when printed
    %     cctitle = {'Pr(DHW>16)';''};
    % %     MyPalette = makeColorMap([1 0 0] , [1 1 0] , [0 0.5 0.1]);
    % %     MyPalette = flipud(colormap(plasma()));
    % MyPalette = makeColorMap([0 0 1] , [1 1 1] , [1 0 0]);
    %
    %     RANGE = 0:0.05:0.5 ;
    %     RANGE_lab = {' 0';'0.5'} ;
    %
    % %     Z = nanmean(P_tot_8DHW,2);
    %     Z0 = nanmean(THERMAL_SCORE,2);
    %     Z = (Z0 - min(Z0))/(max(Z0) - min(Z0));
    %     hfig = figure('visible','on');
    %     width=400; height=600; set(hfig,'color','w','units','points','position',[0,0,width,height])
    %     set(hfig, 'Resize', 'off')
    %     [hm1,cc1] = f_map(map_MAINLAND, map_ISLANDS, RANGE, RANGE_lab, GBR_REEFS.LON, GBR_REEFS.LAT, Z, cctitle, '', '',MyPalette);
    %
    %     savefig(hfig,[SaveDir '/MAP_Heat_stress_proba_' All_SSPs{ssp}])
    %     close all

end
