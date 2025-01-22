%__________________________________________________________________________
%
% COMPARISON OF OBSERVED vs HINDCAST DHW PREDICTED BY THE GCMs
% WITH MEAN FREQUENCY OF ALL DHW VALUES WEIGHTED BY ECS
%
% Yves-Marie Bozec, y.bozec@uq.edu.au, 11/2024
%__________________________________________________________________________

clear
SaveDir = 'FIGS/Raw_figs/Heat_stress'

SETTINGS_PLOTS

%% Distribution of DHW values across reefs
% DHW_edges = [0:1:40] ;
DHW_edges = [0.5:1:40.5] ;
% DHW_edges = [0.5:1:80.5] ;
DHW_counts = nan(5,10,length(DHW_edges)-1);
DHW_counts_lat = nan(5,10,5,length(DHW_edges)-1); % same but by latitude (5 latitude slices, ie every 3°)

load('/home/ym/Dropbox/REEFMOD/REEFMOD.7.0_GBR/data/GBR_REEF_POLYGONS_2024.mat')% reef definition
lat_edges = [-10:-3:-25];

% DHW_10pct = nan(5,10,24); % capture the 10th percentiles of DHW between 2000 and 2023

%% Load the past observed DHW
load('/home/ym/Dropbox/REEFMOD/REEFMOD.7.0_GBR/data/Climatology/Past/GBR_past_DHW_CRW_5km_1985_2023.mat') % updated NOAA-CRW with 2021 (no bleaching) and 2022 (bleaching)
% DHW_OBS = GBR_PAST_DHW(:,24:39); %column 24 is 2008, column 39 is 2023
DHW_OBS = GBR_PAST_DHW(:,30:39); %column 30 is 2014, column 39 is 2023
[DHW_OBS_counts, ~]= histcounts(DHW_OBS,DHW_edges);

%% Start by compiling the proportion of reefs under each DHW category for each ssp/gcm
for ssp = 1:5

    ssp
    if ssp == 1
        gcm_list = [1:5 7 9];
    else
        gcm_list = [1:10];
    end

    for gcm = gcm_list

        gcm
        load(['/home/ym/Dropbox/REEFMOD/REEFMOD.7.0_GBR/data/Climatology/Future/CMIP6/' All_GCMs{gcm} '_' All_SSPs{ssp} '_annual_DHW_max.mat'])
        % DHW_10pct(ssp,gcm,:) = prctile(max_annual_DHW(:,6:29),95,1);

        % Select the specified timeframe in the available hindcast (column 6 is 2000, col 14 is 2008, col 29 is 2023)
        % DHW_HINDCAST = max_annual_DHW(:,14:29); %2008-2023
        DHW_HINDCAST = max_annual_DHW(:,20:29); %2014-2023
        % DHW_HINDCAST = max_annual_DHW(:,30:39); %2024-2033
        % DHW_HINDCAST = max_annual_DHW(:,40:49); %2034-2043

        [DHW_counts(ssp,gcm,:), ~]= histcounts(DHW_HINDCAST,DHW_edges);

        for lat=1:5
            I = find(GBR_REEFS.LAT < lat_edges(lat) & GBR_REEFS.LAT > lat_edges(lat+1));
            [DHW_counts_lat(ssp,gcm,lat,:), ~]= histcounts(DHW_HINDCAST(I,:),DHW_edges);
        end
    end
end

%% PLOT THE OBSERVED VS PREDICTED DISTRI OF PAST DHW PER SSP
MyColour1 = 'Wheat';

MYFIG = figure;

width=15; height=7*5;
set(MYFIG,'color','w','units','centimeters','position',[0,0,width,height])
set(MYFIG, 'Resize', 'off')

for ssp = 1:5

    ssp
    if ssp == 1
        gcm_list = [1:5 7 9];
    else
        gcm_list = [1:10];
    end

    % Define the sampling weight associated to each gcm using the density of probability of its ECS based on
    % the digitalisation of the PDF (Sherwood et al. 2020). Works as weights because give
    % the relative likelihood of each ECS value (but not an estimate of the absolute probability of ECS)
    S = [0.07 0.14 0.10 0.58 0.03 0.54 0.59 0.61 0.54 0.54];
    P = S(gcm_list);
    X = squeeze(DHW_counts(ssp,gcm_list,:));
    Y = P*X/sum(P);

    subplot(5,1,ssp)
    hold on
    b1=bar(Y(1:end),'FaceColor',rgb(All_SSP_colours(ssp)));
    b1.BarWidth = 0.4;
    b2=bar(DHW_OBS_counts(1:end),'FaceColor',rgb(MyColour1),'FaceAlpha', 0.5);

    set(gca, 'Layer', 'top','FontName', 'Arial' ,'FontSize', myGraphicParms.FontSizeLabelTicks);
    xlim([0 31])
    ylabel('Frequence (reef/year)','FontSize', myGraphicParms.FontSizeLabelAxes)

    if ssp==5
        xlabel('Heat stress (°C-week)','FontSize', myGraphicParms.FontSizeLabelAxes)
    end

    T1 = title([char(All_SSP_names(ssp)) ' hindcast'],'Units','normalized','FontName', 'Arial','FontWeight','bold','FontSize',13);
    T1.Color = rgb(All_SSP_colours(ssp));

end

savefig(MYFIG,[SaveDir  '/HINDCAST_Heat_stress_per_SSP'])


%% SAME BUT WITH PREDICTED DISTRI OF PAST DHW AVERAGED OVER ALL SSPs
MyColour2 = 'DarkSlateBlue';
% MyColour2 = 'DarkSlateGray';
% MyColour2 = 'SteelBlue';

MYFIG = figure;

width=13; height=7;  % Make sure this matches the dimensions of 'FIG_PAST_DHW_OBS'
set(MYFIG,'color','w','units','centimeters','position',[0,0,width,height])
set(MYFIG, 'Resize', 'off')

Y = nan(5,size(DHW_counts,3));

for ssp = 1:5

    ssp
    if ssp == 1
        gcm_list = [1:5 7 9];
    else
        gcm_list = [1:10];
    end

    % Define the sampling weight associated to each gcm using the density of probability of its ECS based on
    % the digitalisation of the PDF (Sherwood et al. 2020). Works as weights because give
    % the relative likelihood of each ECS value (but not an estimate of the absolute probability of ECS)
    S = [0.07 0.14 0.10 0.58 0.03 0.54 0.59 0.61 0.54 0.54];
    P = S(gcm_list);
    X = squeeze(DHW_counts(ssp,gcm_list,:));
    Y(ssp,:) = P*X/sum(P);

end

hold on
b1=bar(mean(Y,1),'FaceColor',rgb(MyColour2));
b1.BarWidth = 0.4;
b2=bar(DHW_OBS_counts(1:end),'FaceColor',rgb(MyColour1),'FaceAlpha', 0.5);

set(gca, 'Layer', 'top','FontName', 'Arial' ,'FontSize', myGraphicParms.FontSizeLabelTicks);
xlim([0 40.5])
ylabel('Frequency (reef/year)','FontSize', myGraphicParms.FontSizeLabelAxes,'Units','normalized','Position',[-0.1 0.5 0])
xlabel('Heat stress (°C-week)','FontSize', myGraphicParms.FontSizeLabelAxes)

lg = legend({' 2014-23 predictions'; ' 2014-23 observations'});
lg.ItemTokenSize = [4 18];

savefig(MYFIG,[SaveDir  '/HINDCAST_Heat_stress_all_SSP'])

%% NOW breakdown DHW distributions per latidude slice
MYFIG = figure;

width=40; height=25;
set(MYFIG,'color','w','units','centimeters','position',[0,0,width,height])
% set(MYFIG, 'Resize', 'off')

for ssp = 1:5

    ssp
    if ssp == 1
        gcm_list = [1:5 7 9];
    else
        gcm_list = [1:10];
    end

    % Define the sampling weight associated to each gcm using the density of probability of its ECS based on
    % the digitalisation of the PDF (Sherwood et al. 2020). Works as weights because give
    % the relative likelihood of each ECS value (but not an estimate of the absolute probability of ECS)
    S = [0.07 0.14 0.10 0.58 0.03 0.54 0.59 0.61 0.54 0.54];
    P = S(gcm_list);
    pos_panel = [0:5:20] + ssp;

    for lat=1:5
        X = squeeze(DHW_counts_lat(ssp,gcm_list,lat,:));
        Y = P*X/sum(P);

        subplot(5,5,pos_panel(lat))
        hold on
        b1=bar(Y(1:end),'FaceColor',rgb(All_SSP_colours(ssp)));
        b1.BarWidth = 0.4;
        % b2=bar(DHW_OBS_counts(1:end),'FaceColor',rgb(MyColour),'FaceAlpha', 0.5);

        set(gca, 'Layer', 'top','FontName', 'Arial' ,'FontSize', myGraphicParms.FontSizeLabelTicks);
        xlim([0 31])

        if ssp==1
            MyText = [num2str(-lat_edges(lat)) '-' num2str(-lat_edges(lat+1)) '°S'];
            text(-0.7,0.5, MyText, 'Units','normalized', 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize',13);
            if lat==3
                ylabel('Frequence (reef/year)','FontSize', myGraphicParms.FontSizeLabelAxes)
            end
        end

        if lat==5
            xlabel('Heat stress (°C-week)','FontSize', myGraphicParms.FontSizeLabelAxes)
        end

        T1 = title([char(All_SSP_names(ssp)) ' hindcast'],'Units','normalized','FontName', 'Arial','FontWeight','bold','FontSize',11);
        T1.Color = rgb(All_SSP_colours(ssp));
    end
end

savefig(MYFIG,[SaveDir  '/HINDCAST_Heat_stress_per_SSP_per_latitude'])

close all
