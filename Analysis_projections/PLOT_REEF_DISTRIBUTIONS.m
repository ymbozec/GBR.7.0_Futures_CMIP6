%__________________________________________________________________________
%
% REEF DISTRIBUTIONS IN THERMAL COOLSPOTS/HOTSPOTS AND LARVAL BARRENS/HUBS
%
% Yves-Marie Bozec, y.bozec@uq.edu.au, 05/2024
%__________________________________________________________________________
clear

SETTINGS_PLOTS % general settings for plotting

load('GBR_REEF_POLYGONS_2024.mat') % definition of individual reefs
I = find(GBR_REEFS.Shelf_position>1); % Exclude inshore reefs because connectivity patterns are more complex

All_years = [2050 2100]; YearLabRange = {'2050' ; '2100'};

% Metric of recovery potential (larval supply)
RECO(5,length(All_years)).CC_low = [];
RECO(5,length(All_years)).CC_high = [];
RECO(5,length(All_years)).HT_low = [];
RECO(5,length(All_years)).HT_high = [];

% Metric of thermal exposure
EXPO = RECO;

% Select the percentile of choice (top/bottom 10% or 20%)
PCTILE = 10;
% PCTILE = 20;

for ssp = 2:4

    ssp

    if ssp == 1
        gcm_list = [1:5 7 9];
    else
        gcm_list = [1:10];
    end

    for gcm = gcm_list

        load(['sR0_GBR.7.0_herit0.3_SSP' All_SSPs{ssp} '_' All_GCMs{gcm} '.mat'],...
            'coral_cover_per_taxa','coral_HT_mean','coral_larval_supply','nb_coral_offspring','record_applied_DHWs','YEARS');

        % Focus on the heat sensitive species (1:4)
        CC = squeeze(sum(coral_cover_per_taxa(:,I,2:end,1:4),4)); % exclude first step -> 93 years of data
        CC_reshaped = reshape(CC,size(CC,1)*size(CC,2),size(CC,3));

        HT = squeeze(nanmean(coral_HT_mean(:,I,2:end,1:4),4)); % exclude first step -> 93 years of data
        HT_reshaped = reshape(HT,size(HT,1)*size(HT,2),size(HT,3));

        % Calculate external larval supply(EXCLUDING SELF-SUPPLY THROUGH RETENTION)
        LS_EXTERNAL_TMP = extract_external_LS(coral_larval_supply,nb_coral_offspring);
        LS_EXTERNAL = squeeze(sum(LS_EXTERNAL_TMP(:,I,2:end,1:4),4)); % exclude first step -> 93 years of data, 4 species
        LS_EXTERNAL(LS_EXTERNAL<0)=NaN;

        % Determine thermal refugia
        DHW = record_applied_DHWs(:,I,2:end); % exclude first step -> 93 years of data

        for t=1:length(All_years)

            select_year = All_years(t);

            T = find(YEARS == select_year); % capture only the selected year
            T_before = ismember(YEARS, [(YEARS(T)-4):YEARS(T)]);
            T_focus = ismember(YEARS, YEARS(T));

            CC_focus = single(CC_reshaped(:,T_focus==1));
            HT_focus = single(HT_reshaped(:,T_focus==1));

            % Mean external larval supply to date
            LS_EXTERNAL_before = LS_EXTERNAL(:,:,T_before==1);
            LS_EXTERNAL_before_MEAN = exp(nanmean(log(LS_EXTERNAL_before+1),3)); % mean annual

            % Determine bottom and top 10% (or 20%)
            P_low = prctile(log(LS_EXTERNAL_before_MEAN(:)+1),PCTILE);
            I_low = find(log(LS_EXTERNAL_before_MEAN(:)+1)<=P_low);
            P_high = prctile(log(LS_EXTERNAL_before_MEAN(:)+1),100-PCTILE);
            I_high = find(log(LS_EXTERNAL_before_MEAN(:)+1)>=P_high);

            RECO(ssp,t).CC_low = [RECO(ssp,t).CC_low ; CC_focus(I_low)];
            RECO(ssp,t).CC_high = [RECO(ssp,t).CC_high ; CC_focus(I_high)];
            RECO(ssp,t).HT_low = [RECO(ssp,t).HT_low ; HT_focus(I_low)];
            RECO(ssp,t).HT_high = [RECO(ssp,t).HT_high ; HT_focus(I_high)];

            clear I_low I_high

            % Mean DHW to date
            DHW_before = DHW(:,:,T_before==1);
            DHW_before_MEAN = mean(DHW_before,3);

            % Determine bottom and top 10% (or 20%)
            P_low = prctile(DHW_before_MEAN(:),PCTILE);
            I_low = find(DHW_before_MEAN(:)<=P_low);
            P_high = prctile(DHW_before_MEAN(:),100-PCTILE);
            I_high = find(DHW_before_MEAN(:)>=P_high);

            EXPO(ssp,t).CC_low = [EXPO(ssp,t).CC_low ; CC_focus(I_low,:)];
            EXPO(ssp,t).CC_high = [EXPO(ssp,t).CC_high ; CC_focus(I_high,:)];
            EXPO(ssp,t).HT_low = [EXPO(ssp,t).HT_low ; HT_focus(I_low,:)];
            EXPO(ssp,t).HT_high = [EXPO(ssp,t).HT_high ; HT_focus(I_high,:)];

            clear I_low I_high CC_focus HT_focus T

        end
    end
end

%% EXPORT DISTRIBUTIONS
save(['HISTO_' num2str(PCTILE) '_EXPO_RECO.mat'],'EXPO','RECO','All_years')

%% NOW PLOT THE DIFFERENT DISTRIBUTIONS
load('HISTO_10_EXPO_RECO.mat'); MyPCTILE = 'PCT10_';
% load('HISTO_20_EXPO_RECO.mat'); MyPCTILE = 'PCT20_';

SaveDir = ''
All_Alphas = [1 0.5];

bkg_color1 = [0.8 0.85 0.95];
bkg_color2 = [0.8  0.96 0.96];

Sc(1).VarName='CC' ; Sc(1).DriverName='LSUPPLY';
Sc(2).VarName='CC' ; Sc(2).DriverName='THERMAL';
Sc(3).VarName='HT' ; Sc(3).DriverName='LSUPPLY';
Sc(4).VarName='HT' ; Sc(4).DriverName='THERMAL';

for scenario=1:4

    VarName = Sc(scenario).VarName;
    DriverName = Sc(scenario).DriverName;

    for t=1:length(All_years)
        % for ssp = 2:4

        %% CC and HT distributions for the bottom and top 10% larval supply
        hfig = figure;

        if strcmp(DriverName,'LSUPPLY')==1
            X = RECO;
            MyLegend = ["Larval barrens" ; "Larval hubs"];
        else
            X = EXPO;
            MyLegend = ["Thermal refugia" ; "Hot spots"];
        end

        for ssp = [4 3 2]  % in reverse order to increase visibility

            My_Alpha = All_Alphas(t);

            %% Plot top 10% larval supply
            if strcmp(VarName,'CC')==1
                set(gca,'color',bkg_color2,'Layer', 'top')
                My_X_label = 'Coral cover (%)';
                x=0:0.5:70;
                MyWidth = 4;
                MyRange = [0 62 0 0.102];
                MyYticks = [0.05 0.1];
                MyYticksLabels = {'0.05';'0.10'};
                pd_low = fitdist(X(ssp,t).CC_low,'Kernel','Width',MyWidth);
                y_low = pdf(pd_low,x);
                pd_high = fitdist(X(ssp,t).CC_high,'Kernel','Width',MyWidth);
                y_high = pdf(pd_high,x);

            else
                set(gca,'color',bkg_color1,'Layer', 'top')
                My_X_label = 'Heat tolerance (°C-week)';
                x=-4:0.1:8;
                MyWidth = 0.5;
                MyRange = [- 1.5 8.2 0 0.61];
                MyYticks = [.3 .6];
                MyYticksLabels = {'0.30';'0.60'};
                pd_low = fitdist(X(ssp,t).HT_low,'Kernel','Width',MyWidth);
                y_low = pdf(pd_low,x);
                pd_high = fitdist(X(ssp,t).HT_high,'Kernel','Width',MyWidth);
                y_high = pdf(pd_high,x);
            end

            P(ssp).p_low = plot(x,y_low,':','Color',[rgb(All_SSP_colours(ssp)) My_Alpha],'LineWidth',2);
            hold on
            P(ssp).p_high = plot(x,y_high,'-','Color',[rgb(All_SSP_colours(ssp)) My_Alpha],'LineWidth',2);

            % for the legend
            P(ssp).p_low(2) = plot(nan,nan,':','Color',[0.6 0.6 0.6 My_Alpha],'LineWidth',2);
            P(ssp).p_high(2) = plot(nan,nan,'-','Color',[0.6 0.6 0.6 My_Alpha],'LineWidth',2);

            axis(MyRange)
            yticks(MyYticks)
            yticklabels(MyYticksLabels)

            set(gca, 'color',bkg_color2,'Layer', 'top', 'FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
            ylabel({'Density'},'FontName', 'Arial', 'FontWeight','normal','FontSize',myGraphicParms.FontSizeLabelAxes)
            xlabel(My_X_label,'FontName', 'Arial', 'FontWeight','normal','FontSize',myGraphicParms.FontSizeLabelAxes)

        end

        ll1 = legend([P(2).p_low(2), P(2).p_high(2)], MyLegend, 'Box','off','FontName','Arial');
        ll1.FontSize = myGraphicParms.FontSizeLabelAxes;
        ll1.Position(1) = 0.2;
        savefig(hfig,[SaveDir 'DENSITY_' MyPCTILE VarName '_vs_' DriverName '_' num2str(All_years(t)) '.fig'])
        close all
    end
end
