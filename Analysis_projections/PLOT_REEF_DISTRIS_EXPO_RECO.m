clear

InputFolder = 'Raw_outputs/'

SETTINGS_PLOTS

load('/home/ym/Dropbox/REEFMOD/REEFMOD.7.0_GBR/data/GBR_REEF_POLYGONS_2024.mat')% reef definition
% I = find(GBR_REEFS.Shelf_position>1); % Exclude inshore reefs because connectivity patterns are more complex
I = 1:3806; % now include all reefs

% All_years = [2035 2055 2075 2095]; YearLabRange = {'2030-2040' ; '2050-2060' ; '2070-2080' ; '2090-2100'};
% All_years = [2040 2060 2080]; YearLabRange = {'2040' ; '2060' ; '2080'};
All_years = [2050 2100]; YearLabRange = {'2050' ; '2100'};

% Distribution of coral cover (CC) and heat tolerance (HT) following recovery potential (larval supply)
RECO(5,length(All_years)).CC_low = [];
RECO(5,length(All_years)).CC_high = [];
RECO(5,length(All_years)).HT_low = [];
RECO(5,length(All_years)).HT_high = [];

% Distribution of coral cover (CC) and heat tolerance (HT) following heat exposure (past DHW)
EXPO = RECO;

% Capture all values across all GCMs
ALL(5,length(All_years)).CC = [];
ALL(5,length(All_years)).HT = [];
ALL(5,length(All_years)).LS = [];
ALL(5,length(All_years)).DHW = [];

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

            T = find(YEARS == select_year); % capture CC/HT only in the selected years
            T_before = ismember(YEARS, [(YEARS(T)-4):YEARS(T)]); % capture LS and DHW in the prior 5 years
            % T_before = ismember(YEARS, [(YEARS(T)-9):YEARS(T-5)]); % TEST: capture in the last decade           
            T_focus = ismember(YEARS, YEARS(T));

            CC_focus = single(CC_reshaped(:,T_focus==1));
            HT_focus = single(HT_reshaped(:,T_focus==1));

            % Mean external larval supply to date
            LS_EXTERNAL_before = LS_EXTERNAL(:,:,T_before==1);
            LS_EXTERNAL_before_MEAN = exp(nanmean(log(LS_EXTERNAL_before+1),3)); % mean annual

%           figure; MyPlot = semilogx(LS_EXTERNAL_before_MEAN(:), Y(:),'o'); title([All_SSP_names(ssp) " " num2str(select_year)] )
%           MyPlot.MarkerEdgeColor = rgb(All_SSP_colours(ssp)); axis([0 1e12 0 45])

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

            clear I_low I_high

            % Collect all values
            CCtmp = CC(:,:,T_focus==1);
            HTtmp = HT(:,:,T_focus==1);
            ALL(ssp,t).CC = [ALL(ssp,t).CC ; CCtmp(:)];
            ALL(ssp,t).HT = [ALL(ssp,t).HT ; HTtmp(:)];
            ALL(ssp,t).LS = [ALL(ssp,t).LS ; LS_EXTERNAL_before_MEAN(:)];
            ALL(ssp,t).DHW = [ALL(ssp,t).DHW ; DHW_before_MEAN(:)];

            clear  CC_focus HT_focus T CCtmp HTtmp
        end
    end
end

%% EXPORT DISTRIBUTIONS
save(['HISTO_' num2str(PCTILE) '_EXPO_RECO.mat'],'EXPO','RECO','ALL','All_years')


%% NOW PLOT THE RESULTS
SaveDir = 'Raw_figs/'
SETTINGS_PLOTS
% SELECT WHAT TO PLOT, IE 10/90 or 20/80 percentiles
load('HISTO_10_EXPO_RECO.mat');
% load('HISTO_20_EXPO_RECO.mat');

MyPCTILE = '_PCT10_';

bkg_color1 = [0.8 0.85 0.95];
bkg_color2 = [0.8  0.96 0.96];
% bkg_color3 = rgb(('PaleTurquoise'));


%% 1) DISTRIBUTIONS OF CC AND HT
All_Alphas = [1 0.5];

%% MyWidth = smoothing window -> increase do get more smoothing
Sc(1).VarName='CC' ; Sc(1).DriverName='LSUPPLY';
Sc(2).VarName='CC' ; Sc(2).DriverName='THERMAL';
Sc(3).VarName='HT' ; Sc(3).DriverName='LSUPPLY';
Sc(4).VarName='HT' ; Sc(4).DriverName='THERMAL';

for scenario=1:4

    VarName = Sc(scenario).VarName;
    DriverName = Sc(scenario).DriverName;

    for t=1:length(All_years)

        %% CC and HT distributions for the bottom and top 10% larval supply
        hfig = figure;

        if strcmp(DriverName,'LSUPPLY')==1
            X = RECO;
            % MyLegend = {'2050 low larval supply';'2050 high larval supply';
            %     '2100 low larval supply';'2100 high larval supply'};
            MyLegend = ["Larval barrens" ; "Larval hubs"];
        else
            X = EXPO;
            % MyLegend = {'2050 low heat stress';'2050 high heat stress';
            %     '2100 low heat stress';'2100 high heat stress'};
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

        % ll = legend([P(1).p10, P(1).p90, P(2).p10, P(2).p90], MyLegend, 'Box','off','FontName','Arial');
        % ll.FontSize = myGraphicParms.FontSizeLabelAxes-1;

        % ll = legend([P(2).p10, P(2).p90, P(2).p90, P(3).p90, P(4).p90], [MyLegend ;All_SSP_names(2:4)], 'Box','off','FontName','Arial');
        ll1 = legend([P(2).p_low(2), P(2).p_high(2)], MyLegend, 'Box','off','FontName','Arial');
        ll1.FontSize = myGraphicParms.FontSizeLabelAxes;
        ll1.Position(1) = 0.2;
        savefig(hfig,[SaveDir 'DENSITY' MyPCTILE VarName '_vs_' DriverName '_' num2str(All_years(t)) '.fig'])

        close all
    end
end

%% 2) RELATIONSHIP BETWEEN EXTERNAL LARVAL SUPPLY AND CC

% Select year of interest
for t=1:2

    hfig = figure;
    set(gca,'color',bkg_color2,'Layer', 'top')

    for ssp=2:4

        P_low = prctile(ALL(ssp,t).DHW, 10);
        P_high = prctile(ALL(ssp,t).DHW, 90);
        K = find(ALL(ssp,t).DHW <= P_low); % for plotting relationship in coolspots
        J = find(ALL(ssp,t).DHW >= P_high);  % for plotting relationship in warmspots

        % X = ALL(ssp,t).LS(K)/400; % divide by grid area to get density of larvae per m2
        % Y = ALL(ssp,t).CC(K);
        X = ALL(ssp,t).LS(J)/400; % divide by grid area to get density of larvae per m2
        Y = ALL(ssp,t).CC(J);

        subplot(1,3,ssp-1)
        MyPlot = semilogx(X, Y,'o');
        title(All_SSP_names(ssp))
        % t1 = text(1e1,30,num2str(All_years(t)))
        axis([0 0.5e11 0 34])
        MyPlot.MarkerEdgeColor = rgb(All_SSP_colours(ssp));
        MyPlot.MarkerSize = 1;

        lm = fitlm(log(1+X),Y);

        if ssp==4 & t==2
            hold on; % just skip the plotting of the linear model
        else
            hold on; line(0.01+[0 1e12]',predict(lm,log(0.01+[0 1e12])'),'Color','k','LineStyle','--','LineWidth',1)
        end

        set(gca, 'color',bkg_color2,'Layer', 'top', 'FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
        ylabel({'Coral cover (%)'},'FontName', 'Arial', 'FontWeight','normal','FontSize',myGraphicParms.FontSizeLabelAxes)
        xlabel('Recent larval supply (larva.m^{-2})','FontName', 'Arial', 'FontWeight','normal','FontSize',myGraphicParms.FontSizeLabelAxes)

        savefig(hfig,[SaveDir 'CC_vs_LSUPPLY_IN' MyPCTILE 'HOTSPOTS_' num2str(All_years(t)) '.fig'])
    end
end



%% OLD WAY OF PLOTTING THE DIFFERENT DISTRIBUTIONS
% SaveDir = ''
%
% bkg_color1 = [0.8 0.85 0.95];
% bkg_color2 = [0.8  0.96 0.96];
%
% % VarName = 'CC' ; MyBins = [0:2:60]; % if coral cover
% VarName = 'HT' ; MyBins = [-1:0.5:8]; % if HT
%
% for ssp = 2:4
%
%     %% CC and HT distributions for the bottom and top 10% larval supply
%     hfig = figure;
%     width=1200; height=400;
%     set(hfig,'color','w','units','points','position',[0,0,width,height])
%     set(hfig, 'Resize', 'off')
%     set(gca,'color',rgb('PaleTurquoise'),'Layer', 'top')
%
%     for t=1:length(All_years)
%
%         %% Plot top 10% larval supply
%         if strcmp(VarName,'CC')==1
%             subplot(2,length(All_years),t); h = histogram(RECO(ssp,t).CC90(:),MyBins); xlim([min(MyBins)-2 max(MyBins)+2])
%         else
%             subplot(2,length(All_years),t); h = histogram(RECO(ssp,t).HT90(:),MyBins); xlim([min(MyBins)-2 max(MyBins)+2])
%             hold on; plot(nanmedian(RECO(ssp,t).HT90(:))*[1 1], max(h.Values)*[0 1],'LineWidth', 2, 'LineStyle','--','Color','k')
%         end
%
%         set(gca, 'color',bkg_color2,'Layer', 'top', 'FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks+1);
%         FormatHisto(h, All_SSP_names, All_SSP_colours, ssp, VarName, 'HIGH LS')
%         T1 = title(YearLabRange{t},'FontName', 'Arial','FontWeight','bold','FontSize', 14, 'HorizontalAlignment','center');
%
%         %% Plot bottom 10% larval supply
%         if strcmp(VarName,'CC')==1
%             subplot(2,length(All_years),t+length(All_years)); h = histogram(RECO(ssp,t).CC10(:),MyBins); xlim([min(MyBins)-2 max(MyBins)+2])
%         else
%             subplot(2,length(All_years),t+length(All_years)); h = histogram(RECO(ssp,t).HT10(:),MyBins); xlim([min(MyBins)-2 max(MyBins)+2])
%             hold on; plot(nanmedian(RECO(ssp,t).HT10(:))*[1 1], max(h.Values)*[0 1],'LineWidth', 2, 'LineStyle','--','Color','k')
%         end
%
%         set(gca, 'color',bkg_color1,'Layer', 'top', 'FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks+1);
%         FormatHisto(h, All_SSP_names, All_SSP_colours, ssp, VarName, 'LOW LS')
%
%     end
%
%     %-- EXPORT --------------------
%     set(gcf, 'InvertHardCopy', 'off');
%     IMAGENAME = [SaveDir 'FIG_HISTO_RECO_vs_' VarName '_SSP' All_SSPs{ssp}];
%     print(hfig, ['-r' num2str(myGraphicParms.res)], [IMAGENAME '.png' ], ['-d' 'png'] );
%     crop([IMAGENAME '.png'],0,myGraphicParms.margins);
%     close all
%
%
%     %% CC and HT distributions for the bottom and top 10% thermal refugia
%     hfig = figure;
%     width=1200; height=400;
%     set(hfig,'color','w','units','points','position',[0,0,width,height])
%     set(hfig, 'Resize', 'off')
%     set(gca,'color',rgb('PaleTurquoise'),'Layer', 'top')
%
%     bkg_color1 = [0.8 0.85 0.95];
%     bkg_color2 = [0.8  0.96 0.96];
%
%     for t=1:length(All_years)
%
%         %% Plot top 10% thermal refugia
%         if strcmp(VarName,'CC')==1
%             subplot(2,length(All_years),t); h = histogram(EXPO(ssp,t).CC90(:),MyBins); xlim([min(MyBins)-2 max(MyBins)+2])
%         else
%             subplot(2,length(All_years),t); h = histogram(EXPO(ssp,t).HT90(:),MyBins); xlim([min(MyBins)-2 max(MyBins)+2])
%             hold on; plot(nanmedian(EXPO(ssp,t).HT90(:))*[1 1], max(h.Values)*[0 1],'LineWidth', 2, 'LineStyle','--','Color','k')
%         end
%
%         set(gca, 'color',bkg_color2,'Layer', 'top', 'FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks+1);
%         FormatHisto(h, All_SSP_names, All_SSP_colours, ssp, VarName, 'HOT')
%         T1 = title(YearLabRange{t},'FontName', 'Arial','FontWeight','bold','FontSize', 14, 'HorizontalAlignment','center');
%
%         %% Plot bottom 10% thermal refugia
%         if strcmp(VarName,'CC')==1
%             subplot(2,length(All_years),t+length(All_years)); h = histogram(EXPO(ssp,t).CC10(:),MyBins); xlim([min(MyBins)-2 max(MyBins)+2])
%         else
%             subplot(2,length(All_years),t+length(All_years)); h = histogram(EXPO(ssp,t).HT10(:),MyBins); xlim([min(MyBins)-2 max(MyBins)+2])
%             hold on; plot(nanmedian(EXPO(ssp,t).HT10(:))*[1 1], max(h.Values)*[0 1],'LineWidth', 2, 'LineStyle','--','Color','k')
%         end
%
%         set(gca, 'color',bkg_color1,'Layer', 'top', 'FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks+1);
%         FormatHisto(h, All_SSP_names, All_SSP_colours, ssp, VarName, 'COLD')
%
%     end
%
%     %-- EXPORT --------------------
%     set(gcf, 'InvertHardCopy', 'off');
%     IMAGENAME = [SaveDir 'FIG_HISTO_EXPO_vs_' VarName '_SSP' All_SSPs{ssp}];
%     print(hfig, ['-r' num2str(myGraphicParms.res)], [IMAGENAME '.png' ], ['-d' 'png'] );
%     crop([IMAGENAME '.png'],0,myGraphicParms.margins);
%     close all
%
% end
