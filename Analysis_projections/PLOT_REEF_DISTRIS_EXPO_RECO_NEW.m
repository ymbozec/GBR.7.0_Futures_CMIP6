% April 2025: Same as before, this time excluding inshore reefs (poor water quality) 
% and reefs that were exposed to cyclones during the select time period
clear

InputFolder = 'Raw_outputs/'
SETTINGS_PLOTS

load('/home/ym/Dropbox/REEFMOD/REEFMOD.7.0_GBR/data/GBR_REEF_POLYGONS_2024.mat')% reef definition
I1 = find(GBR_REEFS.Shelf_position>1); % Exclude inshore reefs to exclude effects of WQ

All_years = [2050 2100]; YearLabRange = {'2050' ; '2100'};

% Distribution of coral cover (CC) and heat tolerance (HT) following recovery potential (larval supply)
RECO(5,length(All_years)).CC_low = [];
RECO(5,length(All_years)).CC_high = [];
RECO(5,length(All_years)).HT_low = [];
RECO(5,length(All_years)).HT_high = [];

% Distribution of coral cover (CC) and heat tolerance (HT) following heat exposure (past DHW)
EXPO = RECO;

% Capture all values across all GCMs
ALL(5,length(All_years)).CC = []; % coral cover in year targeted by All_years
ALL(5,length(All_years)).CC_max = []; % max coral cover over the time period prior to targeted year
ALL(5,length(All_years)).HT = []; % mean heat tolerance in year targeted by All_years
ALL(5,length(All_years)).LS = []; % number of larvae supplied externally  external supply averaged over the time period
ALL(5,length(All_years)).DHW = []; % DHW averaged over the time period
ALL(5,length(All_years)).CYC = []; % Number of cyclones of category > 1 during the time period

% Select the percentile of choice (top/bottom 10% or 20%) for distributions
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

        load([InputFolder 'sR0_GBR.7.0_herit0.3_SSP' All_SSPs{ssp} '_' All_GCMs{gcm} '.mat'],...
            'coral_cover_per_taxa','coral_HT_mean','coral_larval_supply','nb_coral_offspring','record_applied_DHWs','record_applied_cyclones','YEARS');

        % Focus on the heat sensitive species (1:4)
        CC = squeeze(sum(coral_cover_per_taxa(:,I1,2:end,1:4),4)); % exclude first step -> 93 years of data
        HT = squeeze(nanmean(coral_HT_mean(:,I1,2:end,1:4),4)); % exclude first step -> 93 years of data

        % Calculate external larval supply(EXCLUDING SELF-SUPPLY THROUGH RETENTION)
        LS_EXTERNAL_TMP = extract_external_LS(coral_larval_supply,nb_coral_offspring);
        LS_EXTERNAL = squeeze(sum(LS_EXTERNAL_TMP(:,I1,2:end,1:4),4)); % exclude first step -> 93 years of data, 4 species
        LS_EXTERNAL(LS_EXTERNAL<0)=0; % few negatives but never large enough to be of concern (eg, -80 larvae)

        % Determine thermal refugia
        DHW = record_applied_DHWs(:,I1,2:end); % exclude first step -> 93 years of data

        % Determine cyclone refugia
        CYC = record_applied_cyclones(:,I1,2:end); % exclude first step -> 93 years of data

        for t=1:length(All_years)

            select_year = All_years(t);

            T = find(YEARS == select_year); % capture CC/HT only in the selected years
            T_before = ismember(YEARS, [(YEARS(T)-4):YEARS(T)]); % capture LS and DHW in the prior 5 years (aligns with the DRIVER ANALYSIS)
            % T_before = ismember(YEARS, [(YEARS(T)-9):YEARS(T)]); % TEST: capture in the last decade    
            T_focus = ismember(YEARS, YEARS(T));

            % Extract coral cover and HT of sensitive groups for this particular year
            CC_focus1 = single(CC(:,:,T_focus==1));
            HT_focus1 = single(HT(:,:,T_focus==1));

            % Number of cyclones to date
            CYC_before = CYC(:,:,T_before==1);
            CYC_before_SUM = sum(CYC_before,3);
            I2 = find(CYC_before_SUM==0); % find reefs exposed to zero cyclone during the period

            % Select coral cover for reefs not exposed to any cyclone during that period
            CC_focus2 = CC_focus1(I2);
            HT_focus2 = HT_focus1(I2);

            % Mean external larval supply to date
            LS_EXTERNAL_before = LS_EXTERNAL(:,:,T_before==1);
            LS_EXTERNAL_before_MEAN = nanmean(LS_EXTERNAL_before,3); % mean annual

            % Determine bottom and top 10% (or 20%)
            P_low = prctile(log(LS_EXTERNAL_before_MEAN(I2)+1),PCTILE);
            I_low = find(log(LS_EXTERNAL_before_MEAN(I2)+1)<=P_low);
            P_high = prctile(log(LS_EXTERNAL_before_MEAN(I2)+1),100-PCTILE);
            I_high = find(log(LS_EXTERNAL_before_MEAN(I2)+1)>=P_high);

            RECO(ssp,t).CC_low = [RECO(ssp,t).CC_low ; CC_focus2(I_low)];
            RECO(ssp,t).CC_high = [RECO(ssp,t).CC_high ; CC_focus2(I_high)];
            RECO(ssp,t).HT_low = [RECO(ssp,t).HT_low ; HT_focus2(I_low)];
            RECO(ssp,t).HT_high = [RECO(ssp,t).HT_high ; HT_focus2(I_high)];

            clear I_low I_high

            % Mean DHW to date
            DHW_before = DHW(:,:,T_before==1);
            DHW_before_MEAN = mean(DHW_before,3);

            % Determine bottom and top 10% (or 20%)
            P_low = prctile(DHW_before_MEAN(I2),PCTILE);
            I_low = find(DHW_before_MEAN(I2)<=P_low);
            P_high = prctile(DHW_before_MEAN(I2),100-PCTILE);
            I_high = find(DHW_before_MEAN(I2)>=P_high);

            EXPO(ssp,t).CC_low = [EXPO(ssp,t).CC_low ; CC_focus2(I_low)];
            EXPO(ssp,t).CC_high = [EXPO(ssp,t).CC_high ; CC_focus2(I_high)];
            EXPO(ssp,t).HT_low = [EXPO(ssp,t).HT_low ; HT_focus2(I_low)];
            EXPO(ssp,t).HT_high = [EXPO(ssp,t).HT_high ; HT_focus2(I_high)];

            clear I_low I_high

            % Collect all values
            CCtmp = CC(:,:,T_focus==1);
            CC_max = max(single(CC(:,:,T_before==1)),[],3);
            HTtmp = HT(:,:,T_focus==1);

            ALL(ssp,t).CC = [ALL(ssp,t).CC ; CCtmp(:)];
            ALL(ssp,t).CC_max = [ALL(ssp,t).CC_max ; CC_max(:)];
            ALL(ssp,t).HT = [ALL(ssp,t).HT ; HTtmp(:)];
            ALL(ssp,t).LS = [ALL(ssp,t).LS ; LS_EXTERNAL_before_MEAN(:)];
            ALL(ssp,t).DHW = [ALL(ssp,t).DHW ; DHW_before_MEAN(:)];
            ALL(ssp,t).CYC = [ALL(ssp,t).CYC ; CYC_before_SUM(:)];

            clear  CC_focus HT_focus T CCtmp HTtmp
        end
    end
end

%% EXPORT DISTRIBUTIONS
% save(['HISTO_' num2str(PCTILE) '_EXPO_RECO_NEW.mat'],'EXPO','RECO','ALL','All_years')


%% NOW PLOT THE RESULTS
SaveDir = 'FIGS/Raw_figs/'
SETTINGS_PLOTS
% SELECT WHAT TO PLOT, IE 10/90 or 20/80 percentiles
% load('HISTO_10_EXPO_RECO.mat'); MyPCTILE = '_PCT10_';
% load('HISTO_20_EXPO_RECO.mat'); MyPCTILE = '_PCT20_';
load('HISTO_10_EXPO_RECO_NEW.mat'); MyPCTILE = '_PCT10_';

bkg_color2 = [0.8  0.96 0.96];
bkg_color1 = [0.85 1 0.85];

%% 1) DISTRIBUTIONS OF CC AND HT
% All_Alphas = [1 0.5];
All_Alphas = [1 1]; % no transparency between years

%% MyWidth = smoothing window -> increase do get more smoothing
Sc(1).VarName='CC' ; Sc(1).DriverName='LSUPPLY';
Sc(2).VarName='CC' ; Sc(2).DriverName='THERMAL';
Sc(3).VarName='HT' ; Sc(3).DriverName='LSUPPLY';
Sc(4).VarName='HT' ; Sc(4).DriverName='THERMAL';
Sc(1).Nb_reefs_low = nan(5,length(All_years)); % record number of reefs for the 10th percentile (for each ssp and selected time)
Sc(1).Nb_reefs_high = nan(5,length(All_years)); % record number of reefs for the 90th percentile (for each ssp and selected time)

for scenario=1:4

    VarName = Sc(scenario).VarName;
    DriverName = Sc(scenario).DriverName;

    for t=1:length(All_years)

        %% CC and HT distributions for the bottom and top 10% larval supply
        hfig = figure;

        if strcmp(DriverName,'LSUPPLY')==1
            X = RECO;
            MyLegend = ["Larval barrens" ; "Larval hubs"];
        else
            X = EXPO;
            MyLegend = ["Thermal refugia" ; "Warm spots"];
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
                Sc(scenario).Nb_reefs_low(ssp,t) = length(X(ssp,t).CC_low);
                Sc(scenario).Nb_reefs_high(ssp,t) = length(X(ssp,t).CC_high);
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
                Sc(scenario).Nb_reefs_low(ssp,t) = length(X(ssp,t).CC_low);
                Sc(scenario).Nb_reefs_high(ssp,t) = length(X(ssp,t).CC_high);
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

        % savefig(hfig,[SaveDir 'DENSITY_NEW' MyPCTILE VarName '_vs_' DriverName '_' num2str(All_years(t)) '.fig'])
        close all
    end
end

% compile the desing of observations
MyYears = [2050 2050 2050 2100 2100 2100];
MySSPs = [2 3 4 2 3 4];
Larval_low = nan(6,1);
Larval_high = nan(6,1);
Thermal_low = nan(6,1);
Thermal_high = nan(6,1);
DESIGN_CC = table(MyYears',MySSPs',Larval_low,Larval_high,Thermal_low,Thermal_high);
DESIGN_HT = DESIGN_CC;

% Remember the scenarios:
% Sc(1).VarName='CC' ; Sc(1).DriverName='LSUPPLY';
% Sc(2).VarName='CC' ; Sc(2).DriverName='THERMAL';
% Sc(3).VarName='HT' ; Sc(3).DriverName='LSUPPLY';
% Sc(4).VarName='HT' ; Sc(4).DriverName='THERMAL';
Nb_reefs_low = nan(1,2); % first column 2050, second 2100
Nb_reefs_high = nan(1,2);

for scenario = 1:4
    Nb_reefs_low = [Nb_reefs_low ; Sc(scenario).Nb_reefs_low(2:4,:) ];
    Nb_reefs_high = [Nb_reefs_high ; Sc(scenario).Nb_reefs_high(2:4,:) ];
end
Nb_reefs_low(1,:)=[];
Nb_reefs_high(1,:)=[];

DESIGN_CC.Larval_low = [Nb_reefs_low(1:3,1) ; Nb_reefs_low(1:3,2)];
DESIGN_CC.Thermal_low = [Nb_reefs_low((1:3)+3,1) ; Nb_reefs_low((1:3)+3,2)];

DESIGN_HT.Larval_low = [Nb_reefs_low((1:3)+6,1) ; Nb_reefs_low((1:3)+6,2)];
DESIGN_HT.Thermal_low = [Nb_reefs_low((1:3)+9,1) ; Nb_reefs_low((1:3)+9,2)];

DESIGN_CC.Larval_high = [Nb_reefs_high(1:3,1) ; Nb_reefs_high(1:3,2)];
DESIGN_CC.Thermal_high = [Nb_reefs_high((1:3)+3,1) ; Nb_reefs_high((1:3)+3,2)];

DESIGN_HT.Larval_high = [Nb_reefs_high((1:3)+6,1) ; Nb_reefs_high((1:3)+6,2)];
DESIGN_HT.Thermal_high = [Nb_reefs_high((1:3)+9,1) ; Nb_reefs_high((1:3)+9,2)];

% Number of reefs per decile should be the exact same for CC and HT
% Should be around 20,000 reefs (2658 offshore reefs * 20 * 10 GCM) - reefs impacted by cyclones
% Can be much higher for larval deciles if highly skewed distributions, eg 1st decile = 2st decile if they are all 0
% larvae

%% 2) Distribution of CC for each percentile of external larval supply

for scenario= [1 3] % 1 to plot coral cvoer, 3 to plot heat tolerance

    VarName = Sc(scenario).VarName;

    if strcmp(VarName,'CC')==1
        bkg_color = bkg_color2;
        MyRange = [0.5 10.5 0 10.5];
        MyYlabel = 'Coral cover (%)';
    else
        bkg_color = bkg_color1;
        MyRange = [0.5 10.5 -1 8.2];
        MyYlabel = 'Mean heat tolerance (°C-week)';
    end

    for t=1:2 % Select year of interest

        hfig = figure;
        set(gca,'color',bkg_color2,'Layer', 'top')

        for ssp=2:4

            % first select reefs that have escaped cyclones
            I3 = find(ALL(ssp,t).CYC==0);

            % Focus on warmspots
            P_high_DHW = prctile(ALL(ssp,t).DHW(I3), 90);
            J = find(ALL(ssp,t).DHW(I3)>P_high_DHW);

            % Or coolpsots
            % P_low_DHW = prctile(ALL(ssp,t).DHW(I3), 10);
            % J = find(ALL(ssp,t).DHW(I3)<P_low_DHW);

            X0 = ALL(ssp,t).LS(I3); % External larval supply for all reefs (with selected cyclone history)

            if strcmp(VarName,'CC')==1
                Y0 = ALL(ssp,t).CC(I3); % Total cover of coral groups 1 to 4 for all reefs (with selected cyclone history)
            else
                Y0 = ALL(ssp,t).HT(I3); % Total cover of coral groups 1 to 4 for all reefs (with selected cyclone history)
            end

            X1 = X0(J); % External supply in warmspots only (with selected cyclone history)
            Y1 = Y0(J); % Total cover of coral groups 1 to 4 in warmspots only (with selected cyclone history)

            All_deciles = prctile(X1, [0:10:100]); % Deciles of external larval supply in warmspots only

            % Re-arrange data for plotting distributionNow collate the column of percentile indicator with corresponding coral cvoer values
            Z = nan(1, 2); % primer -> column 1 gives decile number, column 2 gives coral cover

            for k = 1:length(All_deciles)-1
                K = find(X1 >= All_deciles(k) & X1 < All_deciles(k+1));
                Z = [Z ; [ k*ones(length(K),1) Y1(K)] ];
            end
            Z(1,:)=[]; % remove the primer

            % Now we plot
            subplot(1,3,ssp-1)

            hb = boxplot(Z(:,2),Z(:,1),'Plotstyle','compact','Color',rgb(All_SSP_colours(ssp)),'symbol','');
            % hb = boxplot(Z(:,2),Z(:,1),'Plotstyle','compact','Color',rgb(All_SSP_colours(ssp)),'symbol','.'); % with outliers
            set(gca, 'color',bkg_color,'Layer', 'top', 'FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
            ylabel(MyYlabel,'FontName', 'Arial', 'FontWeight','normal','FontSize',myGraphicParms.FontSizeLabelAxes)
            xlabel({'Deciles of external larval supply';''},'FontName', 'Arial', 'FontWeight','normal','FontSize',myGraphicParms.FontSizeLabelAxes)
            axis(MyRange)
            set(gca,'XTickLabel',{' '})
            xticks([1:1:10])
            xticklabels({'1','2','3','4','5','6','7','8','9','10'})

        end
        savefig(hfig,[SaveDir VarName '_vs_LSUPPLY_IN' MyPCTILE 'HOTSPOTS_' num2str(All_years(t)) 'NEW.fig'])
        close all
    end
end
