clear
SaveDir = ''

load('/home/ym/Dropbox/REEFMOD/REEFMOD.7.0_GBR/data/GBR_REEF_POLYGONS_2024.mat')
load('/home/ym/Dropbox/REEFMOD/REEFMOD_GBR_OUTPUTS/GBR.7.0_CMIP6_2024_02/Analysis_hindcast/HINDCAST_METRICS_2008-2023.mat')

%% Graphic parameters
myGraphicParms.FontSizeLabelTicks = 8;
myGraphicParms.FontSizeLabelAxes = 10;
myGraphicParms.FontSizeLabelTitles = 13;
myGraphicParms.DotSize = 2;
myGraphicParms.res = 400 ; %resolution
myGraphicParms.margins = 10 ;

%% LOAD MONITORING DATA
% [MT , AIMS_TR] = f_display_monitoring(GBR_REEFS);
% ALL_OBS = [MT ; AIMS_TR];

%% Jan 2025: Use only LTMP + MMP datadownloaded from RimREP
% Load the new (2024) linear model allowing to convert manta tow into tranect equivalent estimates
load('/home/ym/Dropbox/REEFMOD/REEFMOD.7.0_GBR/data/Corals/LTMP_Transect2Tow_2024.mat')

% Load last AIMS observations including manta and fixed transect data (LTMP+MMP)
load('/home/ym/Dropbox/REEFMOD/REEFMOD_DATA/Coral_observations_GBR/2024_from_RIMRep_DMS//GBR_AIMS_OBS_CORAL_COVER_2024.mat')
all_project_codes = [1:3];

DATA_TR_LTMP = GBR_AIMS_OBS_CORAL_COVER(strcmp(string(GBR_AIMS_OBS_CORAL_COVER.project_code),'LTMP')==1 & ...
    strcmp(string(GBR_AIMS_OBS_CORAL_COVER.data_type),'photo-transect')==1,:);
DATA_TR_LTMP.CCOVER = 100*DATA_TR_LTMP.mean; % calculate percent coral cover

DATA_TR_MMP = GBR_AIMS_OBS_CORAL_COVER(strcmp(string(GBR_AIMS_OBS_CORAL_COVER.project_code),'MMP')==1 & ...
    strcmp(string(GBR_AIMS_OBS_CORAL_COVER.data_type),'photo-transect')==1 & ...
    GBR_AIMS_OBS_CORAL_COVER.depth>=5,:); % exclude shallow observations (2m depth)
DATA_TR_MMP.CCOVER = 100*DATA_TR_MMP.mean; % calculate percent coral cover

DATA_MT_LTMP = GBR_AIMS_OBS_CORAL_COVER(strcmp(string(GBR_AIMS_OBS_CORAL_COVER.project_code),'LTMP')==1 & ...
    strcmp(string(GBR_AIMS_OBS_CORAL_COVER.data_type),'manta')==1,:);
DATA_MT_LTMP.CCOVER = predict(LTMP_Transect2Tow_Model2, 100*DATA_MT_LTMP.mean); % calculate percent coral cover (transect equivalent

% Group all data
ALL_OBS = [DATA_TR_LTMP ; DATA_TR_MMP ; DATA_MT_LTMP];
ALL_OBS.YEAR = ALL_OBS.YearReefMod; % to plot every season of observation
ALL_OBS.YEAR2 = floor(ALL_OBS.YEAR); % to average observations yearly

omean = @(x) mean(x,'omitnan');

pos_anchor = 0.14 ;
pos_switch = 0.174 ;
MarkerSize = 4;
% MarkerColor = rgb('Crimson');
MarkerColor = 0.15*[1 1 1];
MinSampleSize = 5 ;
myGraphicParms.FontSizeLabelAxes = 11;
myGraphicParms.FontSizeLabelTitles = 12;
myGraphicParms.res = 800;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1) Plot mean trajectoires for each region (Northern, Central, Southern)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename= 'GBR.7.0.HINDCAST_PER_REGION_NEW' ;

hfig = figure;
width=1000; height=200; set(hfig,'color','w','units','points','position',[0,0,width,height])
set(hfig, 'Resize', 'off')

%-- GBR
subplot(1,4,1) ; TitleReefSelection = {'';'GBR'}; display_OBS = 1;
pos = get(gca, 'Position'); pos(1) = pos_anchor; %[x y width height]
set(gca, 'Position', pos,'Layer', 'top','FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
select_OBS = 1:size(ALL_OBS,1);
[~,p_mean]=f_plot_reef_trajectory(select.GBR, YEARS, Coral_tot.M(:,2:end), area_w, display_OBS, ALL_OBS, TitleReefSelection,'',myGraphicParms);

ALL_OBS_MEANS = groupsummary(ALL_OBS(select_OBS,:),"YEAR2","mean","CCOVER");
select_yr = find(ALL_OBS_MEANS.GroupCount >= MinSampleSize & ismember(ALL_OBS_MEANS.YEAR2, YEARS)==1);
plot(ALL_OBS_MEANS.YEAR2(select_yr), ALL_OBS_MEANS.mean_CCOVER(select_yr),'Color','k')
plot(ALL_OBS_MEANS.YEAR2(select_yr), ALL_OBS_MEANS.mean_CCOVER(select_yr),'o','MarkerSize',MarkerSize,'MarkerFaceColor',MarkerColor,'MarkerEdgeColor','k')
uistack(p_mean,'top')

MyYLabel = ylabel({'Coral cover (%)'},'FontName', 'Arial', 'FontWeight','normal','FontSize',myGraphicParms.FontSizeLabelAxes);
MyYLabel.Units='centimeters';
MyYLabel.Position(1) = -0.6;

% Calculate model error
PRED_MEAN = area_w'*Coral_tot.M(:,2:end)/sum(area_w);
OBS_MEAN = ALL_OBS_MEANS.mean_CCOVER(ismember(ALL_OBS_MEANS.YEAR2, YEARS)==1);
E =  PRED_MEAN(2:end)' - OBS_MEAN(2:end); % exclude 2008 because initialisation uses observations
TitleReefSelection
round(mean(E),1)
round(std(E),1)

%-- NORTHERN
subplot(1,4,2) ; TitleReefSelection = {'Northern region'}; display_OBS = 1;
pos = get(gca, 'Position'); pos(1) = pos_anchor+pos_switch; %[x y width height]
set(gca, 'Position', pos,'Layer', 'top','FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
select_OBS = find(ALL_OBS.AIMS_sector>=1 & ALL_OBS.AIMS_sector<4);
[~,p_mean]=f_plot_reef_trajectory(select.North, YEARS, Coral_tot.M(:,2:end), area_w, display_OBS,  ALL_OBS(select_OBS,:), TitleReefSelection,'',myGraphicParms);

ALL_OBS_MEANS = groupsummary(ALL_OBS(select_OBS,:),"YEAR2","mean","CCOVER");
select_yr = find(ALL_OBS_MEANS.GroupCount >= MinSampleSize & ismember(ALL_OBS_MEANS.YEAR2, YEARS)==1);
plot(ALL_OBS_MEANS.YEAR2(select_yr), ALL_OBS_MEANS.mean_CCOVER(select_yr),'Color','k')
plot(ALL_OBS_MEANS.YEAR2(select_yr), ALL_OBS_MEANS.mean_CCOVER(select_yr),'o','MarkerSize',MarkerSize,'MarkerFaceColor',MarkerColor,'MarkerEdgeColor','k')
uistack(p_mean,'top')

% Calculate model error
PRED_MEAN = area_w'*Coral_tot.M(:,2:end)/sum(area_w);
OBS_MEAN = ALL_OBS_MEANS.mean_CCOVER(ismember(ALL_OBS_MEANS.YEAR2, YEARS)==1);
E =  PRED_MEAN(2:end)' - OBS_MEAN(2:end); % exclude 2008 because initialisation uses observations
TitleReefSelection
round(mean(E),1)
round(std(E),1)

%-- CENTRAL
subplot(1,4,3) ; TitleReefSelection = {'Central region'}; display_OBS = 1;
pos = get(gca, 'Position'); pos(1) = pos_anchor+2*pos_switch; %[x y width height]
set(gca, 'Position', pos,'Layer', 'top','FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
select_OBS = find(ALL_OBS.AIMS_sector>=4 & ALL_OBS.AIMS_sector<9);
[~,p_mean]=f_plot_reef_trajectory(select.Centre, YEARS, Coral_tot.M(:,2:end), area_w, display_OBS,  ALL_OBS(select_OBS,:), TitleReefSelection,'',myGraphicParms);

ALL_OBS_MEANS = groupsummary(ALL_OBS(select_OBS,:),"YEAR2","mean","CCOVER");
select_yr = find(ALL_OBS_MEANS.GroupCount >= MinSampleSize & ismember(ALL_OBS_MEANS.YEAR2, YEARS)==1);
plot(ALL_OBS_MEANS.YEAR2(select_yr), ALL_OBS_MEANS.mean_CCOVER(select_yr),'Color','k')
plot(ALL_OBS_MEANS.YEAR2(select_yr), ALL_OBS_MEANS.mean_CCOVER(select_yr),'o','MarkerSize',MarkerSize,'MarkerFaceColor',MarkerColor,'MarkerEdgeColor','k')
uistack(p_mean,'top')

% Calculate model error
PRED_MEAN = area_w'*Coral_tot.M(:,2:end)/sum(area_w);
OBS_MEAN = ALL_OBS_MEANS.mean_CCOVER(ismember(ALL_OBS_MEANS.YEAR2, YEARS)==1);
E =  PRED_MEAN(2:end)' - OBS_MEAN(2:end); % exclude 2008 because initialisation uses observations
TitleReefSelection
round(mean(E),1)
round(std(E),1)

%-- SOUTHERN
subplot(1,4,4) ; TitleReefSelection = {'Southern region'}; display_OBS = 1;
pos = get(gca, 'Position'); pos(1) = pos_anchor+3*pos_switch; %[x y width height]
set(gca, 'Position', pos,'Layer', 'top','FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
select_OBS = find(ALL_OBS.AIMS_sector>=9);
[~,p_mean]=f_plot_reef_trajectory(select.South, YEARS, Coral_tot.M(:,2:end), area_w, display_OBS,  ALL_OBS(select_OBS,:), TitleReefSelection,'',myGraphicParms);

ALL_OBS_MEANS = groupsummary(ALL_OBS(select_OBS,:),"YEAR2","mean","CCOVER");
select_yr = find(ALL_OBS_MEANS.GroupCount >= MinSampleSize & ismember(ALL_OBS_MEANS.YEAR2, YEARS)==1);
plot(ALL_OBS_MEANS.YEAR2(select_yr), ALL_OBS_MEANS.mean_CCOVER(select_yr),'Color','k')
plot(ALL_OBS_MEANS.YEAR2(select_yr), ALL_OBS_MEANS.mean_CCOVER(select_yr),'o','MarkerSize',MarkerSize,'MarkerFaceColor',MarkerColor,'MarkerEdgeColor','k')
uistack(p_mean,'top')

% Calculate model error
PRED_MEAN = area_w'*Coral_tot.M(:,2:end)/sum(area_w);
OBS_MEAN = ALL_OBS_MEANS.mean_CCOVER(ismember(ALL_OBS_MEANS.YEAR2, YEARS)==1);
E =  PRED_MEAN(2:end)' - OBS_MEAN(2:end); % exclude 2008 because initialisation uses observations
TitleReefSelection
round(mean(E),1)
round(std(E),1)

%-- EXPORT --------------------
IMAGENAME = [SaveDir filename];
print(hfig, ['-r' num2str(myGraphicParms.res )], [IMAGENAME '.png' ], ['-d' 'png'] );
crop([IMAGENAME '.png'],0,20); close(hfig);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot trajectories of HT in each region (Northern, Central, Southern)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename= 'REEFMOD-GBR.7.0.HINDCAST_HEAT_TOLERANCE' ;
% 
% hfig = figure;
% width=1000; height=200; set(hfig,'color','w','units','points','position',[0,0,width,height])
% set(hfig, 'Resize', 'off')
% 
% %-- GBR
% subplot(1,4,1) ; TitleReefSelection = {'';'GBR'};
% p1=plot(YEARS, Coral_tot.M_HT(:,2:end),'-','Color',rgb('LightBlue')); hold on
% p2=plot(YEARS, nanmean(Coral_tot.M_HT(:,2:end),1),'-','Color',rgb('Crimson'),'LineWidth',1.5);
% MyYLabel = ylabel({'Mean heat tolerance (degC-week)'},'FontName', 'Arial', 'FontWeight','normal','FontSize',myGraphicParms.FontSizeLabelAxes);
% MyYLabel.Units='centimeters';
% MyYLabel.Position(1) = -0.8;
% pos = get(gca, 'Position'); pos(1) = pos_anchor; %[x y width height]
% 
% set(gca, 'Position', pos,'Layer', 'top','FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
% 
% %-- NORTHERN
% subplot(1,4,2) ; TitleReefSelection = {'North'}; display_OBS = 1;
% p1=plot(YEARS, Coral_tot.M_HT(select.North,2:end),'-','Color',rgb('LightBlue')); hold on
% p2=plot(YEARS, nanmean(Coral_tot.M_HT(select.North,2:end),1),'-','Color',rgb('Crimson'),'LineWidth',1.5);
% pos = get(gca, 'Position'); pos(1) = pos_anchor+pos_switch; %[x y width height]
% set(gca, 'Position', pos,'Layer', 'top','FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
% 
% %-- CENTRAL
% subplot(1,4,3) ; TitleReefSelection = {'Center'}; display_OBS = 1;
% p1=plot(YEARS, Coral_tot.M_HT(select.Centre,2:end),'-','Color',rgb('LightBlue')); hold on
% p2=plot(YEARS, nanmean(Coral_tot.M_HT(select.Centre,2:end),1),'-','Color',rgb('Crimson'),'LineWidth',1.5);
% pos = get(gca, 'Position'); pos(1) = pos_anchor+2*pos_switch; %[x y width height]
% set(gca, 'Position', pos,'Layer', 'top','FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
% 
% %-- SOUTHERN
% subplot(1,4,4) ; TitleReefSelection = {'South'}; display_OBS = 1;
% p1=plot(YEARS, Coral_tot.M_HT(select.South,2:end),'-','Color',rgb('LightBlue')); hold on
% p2=plot(YEARS, nanmean(Coral_tot.M_HT(select.South,2:end),1),'-','Color',rgb('Crimson'),'LineWidth',1.5);
% pos = get(gca, 'Position'); pos(1) = pos_anchor+3*pos_switch; %[x y width height]
% set(gca, 'Position', pos,'Layer', 'top','FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
% 
% %-- EXPORT --------------------
% IMAGENAME = [SaveDir filename];
% print(hfig, ['-r' num2str(myGraphicParms.res )], [IMAGENAME '.png' ], ['-d' 'png'] );
% crop([IMAGENAME '.png'],0,20); close(hfig);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot mean trajectoires for shelf position in each region (Northern, Central, Southern)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename= 'REEFMOD-GBR.7.0.HINDCAST_PER_SHELF-REGION' ;
% 
% hfig = figure;
% width=1000; height=800; set(hfig,'color','w','units','points','position',[0,0,width,height])
% set(hfig, 'Resize', 'off')
% 
% display_OBS = 1;
% x_N = 2010;
% 
% %-- NORTHERN
% subplot(3,3,1) ; TitleReefSelection = {'North inshore'}; 
% select_reefs = find((GBR_REEFS.AIMS_sector==1|GBR_REEFS.AIMS_sector==2|GBR_REEFS.AIMS_sector==3) & GBR_REEFS.Shelf_position==1 & GBR_REEFS.LAT<lat_cutoff);
% select_OBS = find(ALL_OBS.AIMS_sector>=1 & ALL_OBS.AIMS_sector<4 & ALL_OBS.Shelf_position==1);
% f_plot_reef_trajectory(select_reefs, YEARS, Coral_tot.M(:,2:end), area_w, display_OBS, ALL_OBS(select_OBS,:), TitleReefSelection, '',myGraphicParms);
% ylabel({'Coral cover (%)';''},'FontName', 'Arial', 'FontWeight','normal','FontSize',myGraphicParms.FontSizeLabelAxes)
% pos = get(gca, 'Position'); pos(1) = 0.13; pos(2) = 0.75;  %[x y width height]
% set(gca, 'Position', pos,'Layer', 'top','FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
% N = ['(n = ' num2str(length(select_reefs)) ')'];
% text(x_N,75,N,'FontName', 'Arial', 'FontSize',myGraphicParms.FontSizeLabelTicks,'HorizontalAlignment','center')
% 
% subplot(3,3,2) ; TitleReefSelection = {'North mid-shelf'};
% select_reefs = find((GBR_REEFS.AIMS_sector==1|GBR_REEFS.AIMS_sector==2|GBR_REEFS.AIMS_sector==3) & GBR_REEFS.Shelf_position==2 & GBR_REEFS.LAT<lat_cutoff);
% select_OBS = find(ALL_OBS.AIMS_sector>=1 & ALL_OBS.AIMS_sector<4 & ALL_OBS.Shelf_position==2);
% f_plot_reef_trajectory(select_reefs, YEARS, Coral_tot.M(:,2:end), area_w, display_OBS, ALL_OBS(select_OBS,:), TitleReefSelection, '',myGraphicParms);
% pos = get(gca, 'Position'); pos(1) = 0.37; pos(2) = 0.75;  %[x y width height]
% set(gca, 'Position', pos,'Layer', 'top','FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
% N = ['(n = ' num2str(length(select_reefs)) ')'];
% text(x_N,75,N,'FontName', 'Arial', 'FontSize',myGraphicParms.FontSizeLabelTicks,'HorizontalAlignment','center')
% 
% subplot(3,3,3) ; TitleReefSelection = {'North outer shelf'};
% select_reefs = find((GBR_REEFS.AIMS_sector==1|GBR_REEFS.AIMS_sector==2|GBR_REEFS.AIMS_sector==3) & GBR_REEFS.Shelf_position==3 & GBR_REEFS.LAT<lat_cutoff);
% select_OBS = find(ALL_OBS.AIMS_sector>=1 & ALL_OBS.AIMS_sector<4 & ALL_OBS.Shelf_position==3);
% f_plot_reef_trajectory(select_reefs, YEARS, Coral_tot.M(:,2:end), area_w, display_OBS, ALL_OBS(select_OBS,:), TitleReefSelection, '',myGraphicParms);
% pos = get(gca, 'Position'); pos(1) = 0.61; pos(2) = 0.75;  %[x y width height]
% set(gca, 'Position', pos,'Layer', 'top','FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
% N = ['(n = ' num2str(length(select_reefs)) ')'];
% text(x_N,75,N,'FontName', 'Arial', 'FontSize',myGraphicParms.FontSizeLabelTicks,'HorizontalAlignment','center')
% 
% %-- CENTRAL
% subplot(3,3,4) ; TitleReefSelection = {'Center inshore'};
% select_reefs = find(GBR_REEFS.Shelf_position==1&(GBR_REEFS.AIMS_sector==4|GBR_REEFS.AIMS_sector==5|GBR_REEFS.AIMS_sector==6|GBR_REEFS.AIMS_sector==7|GBR_REEFS.AIMS_sector==8));
% select_OBS = find(ALL_OBS.AIMS_sector>=4 & ALL_OBS.AIMS_sector<9 & ALL_OBS.Shelf_position==1);
% f_plot_reef_trajectory(select_reefs, YEARS, Coral_tot.M(:,2:end), area_w, display_OBS, ALL_OBS(select_OBS,:), TitleReefSelection, '',myGraphicParms);
% ylabel({'Coral cover (%)';''},'FontName', 'Arial', 'FontWeight','normal','FontSize',myGraphicParms.FontSizeLabelAxes)
% pos = get(gca, 'Position'); pos(1) = 0.13; pos(2) = 0.49;  %[x y width height]
% set(gca, 'Position', pos,'Layer', 'top','FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
% N = ['(n = ' num2str(length(select_reefs)) ')'];
% text(x_N,75,N,'FontName', 'Arial', 'FontSize',myGraphicParms.FontSizeLabelTicks,'HorizontalAlignment','center')
% 
% subplot(3,3,5) ; TitleReefSelection = {'Center mid-shelf'};
% select_reefs = find(GBR_REEFS.Shelf_position==2&(GBR_REEFS.AIMS_sector==4|GBR_REEFS.AIMS_sector==5|GBR_REEFS.AIMS_sector==6|GBR_REEFS.AIMS_sector==7|GBR_REEFS.AIMS_sector==8));
% select_OBS = find(ALL_OBS.AIMS_sector>=4 & ALL_OBS.AIMS_sector<9 & ALL_OBS.Shelf_position==2);
% f_plot_reef_trajectory(select_reefs, YEARS, Coral_tot.M(:,2:end), area_w, display_OBS, ALL_OBS(select_OBS,:), TitleReefSelection, '',myGraphicParms);
% pos = get(gca, 'Position'); pos(1) = 0.37; pos(2) = 0.49;  %[x y width height]
% set(gca, 'Position', pos,'Layer', 'top','FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
% N = ['(n = ' num2str(length(select_reefs)) ')'];
% text(x_N,75,N,'FontName', 'Arial', 'FontSize',myGraphicParms.FontSizeLabelTicks,'HorizontalAlignment','center')
% 
% subplot(3,3,6) ; TitleReefSelection = {'Center outer shelf'};
% select_reefs = find(GBR_REEFS.Shelf_position==3&(GBR_REEFS.AIMS_sector==4|GBR_REEFS.AIMS_sector==5|GBR_REEFS.AIMS_sector==6|GBR_REEFS.AIMS_sector==7|GBR_REEFS.AIMS_sector==8));
% select_OBS = find(ALL_OBS.AIMS_sector>=4 & ALL_OBS.AIMS_sector<9 & ALL_OBS.Shelf_position==3);
% f_plot_reef_trajectory(select_reefs, YEARS, Coral_tot.M(:,2:end), area_w, display_OBS, ALL_OBS(select_OBS,:), TitleReefSelection, '',myGraphicParms);
% pos = get(gca, 'Position'); pos(1) = 0.61; pos(2) = 0.49;  %[x y width height]
% set(gca, 'Position', pos,'Layer', 'top','FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
% N = ['(n = ' num2str(length(select_reefs)) ')'];
% text(x_N,75,N,'FontName', 'Arial', 'FontSize',myGraphicParms.FontSizeLabelTicks,'HorizontalAlignment','center')
% 
% %-- SOUTHERN
% subplot(3,3,7) ; TitleReefSelection = {'South inshore'};
% select_reefs = find(GBR_REEFS.Shelf_position==1&(GBR_REEFS.AIMS_sector==9|GBR_REEFS.AIMS_sector==10|GBR_REEFS.AIMS_sector==11));
% select_OBS = find(ALL_OBS.AIMS_sector>=9 & ALL_OBS.Shelf_position==1);
% f_plot_reef_trajectory(select_reefs, YEARS, Coral_tot.M(:,2:end), area_w, display_OBS, ALL_OBS(select_OBS,:), TitleReefSelection, '',myGraphicParms);
% ylabel({'Coral cover (%)';''},'FontName', 'Arial', 'FontWeight','normal','FontSize',myGraphicParms.FontSizeLabelAxes)
% pos = get(gca, 'Position'); pos(1) = 0.13; pos(2) = 0.23;  %[x y width height]
% set(gca, 'Position', pos,'Layer', 'top','FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
% N = ['(n = ' num2str(length(select_reefs)) ')'];
% text(x_N,75,N,'FontName', 'Arial', 'FontSize',myGraphicParms.FontSizeLabelTicks,'HorizontalAlignment','center')
% 
% subplot(3,3,8) ; TitleReefSelection = {'South mid-shelf'};
% select_reefs = find(GBR_REEFS.Shelf_position==2&(GBR_REEFS.AIMS_sector==9|GBR_REEFS.AIMS_sector==10|GBR_REEFS.AIMS_sector==11));
% select_OBS = find(ALL_OBS.AIMS_sector>=9 & ALL_OBS.Shelf_position==2);
% f_plot_reef_trajectory(select_reefs, YEARS, Coral_tot.M(:,2:end), area_w, display_OBS, ALL_OBS(select_OBS,:), TitleReefSelection, '',myGraphicParms);
% pos = get(gca, 'Position'); pos(1) = 0.37; pos(2) = 0.23;  %[x y width height]
% set(gca, 'Position', pos,'Layer', 'top','FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
% N = ['(n = ' num2str(length(select_reefs)) ')'];
% text(x_N,75,N,'FontName', 'Arial', 'FontSize',myGraphicParms.FontSizeLabelTicks,'HorizontalAlignment','center')
% 
% subplot(3,3,9) ; TitleReefSelection = {'South outer shelf'};
% select_reefs = find(GBR_REEFS.Shelf_position==3&(GBR_REEFS.AIMS_sector==9|GBR_REEFS.AIMS_sector==10|GBR_REEFS.AIMS_sector==11));
% select_OBS = find(ALL_OBS.AIMS_sector>=9 & ALL_OBS.Shelf_position==3);
% f_plot_reef_trajectory(select_reefs, YEARS, Coral_tot.M(:,2:end), area_w, display_OBS, ALL_OBS(select_OBS,:), TitleReefSelection, '',myGraphicParms);
% pos = get(gca, 'Position'); pos(1) = 0.61; pos(2) = 0.23;  %[x y width height]
% set(gca, 'Position', pos,'Layer', 'top','FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
% N = ['(n = ' num2str(length(select_reefs)) ')'];
% text(x_N,75,N,'FontName', 'Arial', 'FontSize',myGraphicParms.FontSizeLabelTicks,'HorizontalAlignment','center')
% 
% 
% %-- EXPORT --------------------
% IMAGENAME = [SaveDir filename];
% print(hfig, ['-r' num2str(myGraphicParms.res )], [IMAGENAME '.png' ], ['-d' 'png'] );
% crop([IMAGENAME '.png'],0,20); close(hfig);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot mean trajectoires per species
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure;
% subplot(2,3,1); plot(YEARS,Coral_sp(1).M(:,2:end),'k-','LineWidth',1, 'Color', rgb('OrangeRed')); axis([2007 2020 0 60]);
% subplot(2,3,2); plot(YEARS,Coral_sp(2).M(:,2:end),'k-','LineWidth',1, 'Color', rgb('DarkOrange'));axis([2007 2020 0 60]);
% subplot(2,3,3); plot(YEARS,Coral_sp(3).M(:,2:end),'k-','LineWidth',1, 'Color', rgb('Gold'));axis([2007 2020 0 60]);
% subplot(2,3,4); plot(YEARS,Coral_sp(4).M(:,2:end),'k-','LineWidth',1, 'Color', rgb('ForestGreen'));axis([2007 2020 0 60]);
% subplot(2,3,5); plot(YEARS,Coral_sp(5).M(:,2:end),'k-','LineWidth',1, 'Color', rgb('Magenta'));axis([2007 2020 0 60]);
% subplot(2,3,6); plot(YEARS,Coral_sp(6).M(:,2:end),'k-','LineWidth',1, 'Color', rgb('DodgerBlue'));axis([2007 2020 0 60]);
% 
% select_steps = 3:2:27;
% list_reefs = GBR_REEFS.Reef_ID;
% list_shelf = GBR_REEFS.Shelf_position;
% list_region = nan(length(list_reefs),1);
% list_region(select.North)=1;
% list_region(select.Centre)=2;
% list_region(select.South)=3;

% list_YEARS = YEARS(select_steps)-0.5;
% X0 = repmat(list_reefs, length(list_YEARS),1);
% X = X0(:);
% Y0 = repmat(list_YEARS, length(list_reefs),1);
% Y = Y0(:);
% S0 = repmat(list_shelf, length(list_YEARS),1);
% S = S0(:);
% R0 = repmat(list_region, length(list_YEARS),1);
% R = R0(:);
% 
% Z1 = Coral_sp(1).M(:,select_steps);
% Z2 = Coral_sp(2).M(:,select_steps);
% Z3 = Coral_sp(3).M(:,select_steps);
% Z4 = Coral_sp(4).M(:,select_steps);
% Z5 = Coral_sp(5).M(:,select_steps);
% Z6 = Coral_sp(6).M(:,select_steps);
% 
% plot(list_YEARS, mean(Z1,1)); hold on
% plot(list_YEARS, mean(Z2,1));
% plot(list_YEARS, mean(Z3,1));
% plot(list_YEARS, mean(Z4,1));
% plot(list_YEARS, mean(Z5,1));
% plot(list_YEARS, mean(Z6,1));
% 
% COVER_SP = [ Z1(:) Z2(:) Z3(:) Z4(:) Z5(:) Z6(:) ];
% 
% COVER_TOT = sum(COVER_SP,2);
% COMM_COMPO = COVER_SP./COVER_TOT(:,ones(1,6));
% COMM_COMPO(isnan(COMM_COMPO)==1)=0;
% 
% EXPORT = array2table([ X Y S R COMM_COMPO ],'VariableNames',{'ReefID','Year','Shelf', 'Region','SP1','SP2','SP3','SP4','SP5','SP6'});
% writetable(EXPORT,'DATA_COMPO_ANALYSIS.csv')
% 
% EXPORT = array2table([ X Y S R COVER_SP ],'VariableNames',{'ReefID','Year','Shelf', 'Region','SP1','SP2','SP3','SP4','SP5','SP6'});
% writetable(EXPORT,'DATA_COVER_ANALYSIS.csv')