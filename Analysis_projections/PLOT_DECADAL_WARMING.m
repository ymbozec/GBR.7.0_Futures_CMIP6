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

Stress_levels = {'DHW ≥ 8°C-week';'DHW ≥ 12°C-week';'DHW ≥ 16°C-week';'DHW ≥ 20°C-week'};
YEARS = 2008:2100;

%% SELECT THE SSP TO PLOT
for ssp = 1:5

    ssp

    % starters
    F_8DHW = nan(1,72);
    F_12DHW = nan(1,72);
    F_16DHW = nan(1,72);
    F_20DHW = nan(1,72);

    % Pre-allocate matrices of probability of a given heat stress (one column for each gcm)
    P_tot_8DHW = nan(3806,10);
    P_tot_12DHW = nan(3806,10);
    P_tot_16DHW = nan(3806,10);
    P_tot_20DHW = nan(3806,10);
    THERMAL_SCORE = nan(3806,10);

    if ssp == 1
        gcm_list = [1:5 7 9];
    else
        gcm_list = [1:10];
    end

    for gcm = gcm_list

        gcm

        % Load the heat stress scenarios iteratively
        % (available from REEFMOD.7.0_GBR/data/Climatology/Future/CMIP6 in GitHub)
        % https://github.com/ymbozec/REEFMOD.7.0_GBR/tree/fd0b8e3195c9eac77430eef08257c39403ace06d/data/Climatology/Future/CMIP6
        MyPath = '/home/ym/Dropbox/REEFMOD/REEFMOD.7.0_GBR/data/Climatology/Future/CMIP6/';
        load([MyPath All_GCMs{gcm} '_' All_SSPs{ssp} '_annual_DHW_max.mat'])        
        
        for yr = 1:size(F_8DHW,2) % (year 30 is 2024)
            % Select the specified timeframe in the available forecast
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

    % Plot median, 10th and 90th percentiles
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
    ax = gca; ax.YLabel.Position(1)= 2020;
    T1 = text(0.1, 0.9, All_SSP_names(ssp),'Units','normalized','FontName', 'Arial','FontWeight','bold','FontSize', ...
        myGraphicParms.FontSizeLabelAxes-1, 'HorizontalAlignment','left');
    T1.Color = rgb(All_SSP_colours(ssp));

    savefig(myfig,['Heat_stress_8DHW_DISTRI_DECADAL_FREQ_real_SSP' All_SSPs{ssp}])

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
    ax = gca; ax.YLabel.Position(1)= 2020;
    T1 = text(0.1, 0.9, All_SSP_names(ssp),'Units','normalized','FontName', 'Arial','FontWeight','bold','FontSize', ...
        myGraphicParms.FontSizeLabelAxes-1, 'HorizontalAlignment','left');
    T1.Color = rgb(All_SSP_colours(ssp));

    savefig(myfig,['Heat_stress_16DHW_DISTRI_DECADAL_FREQ_real_SSP' All_SSPs{ssp}])

    close all
end
