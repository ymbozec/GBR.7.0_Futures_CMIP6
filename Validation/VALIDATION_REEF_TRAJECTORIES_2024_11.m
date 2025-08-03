clear

% Load the new (2024) linear model allowing to convert manta tow into tranect equivalent estimates
load('/home/ym/Dropbox/REEFMOD/REEFMOD.7.0_GBR/data/Corals/LTMP_Transect2Tow_2024.mat')

% Reef definition
load('/home/ym/Dropbox/REEFMOD/REEFMOD.7.0_GBR/data/GBR_REEF_POLYGONS_2024.mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load the hindcast (April 2024, with adaptation)
load('/home/ym/Dropbox/REEFMOD/REEFMOD_GBR_OUTPUTS/GBR.7.0_CMIP6_2024_04/Analysis_hindcast/HINDCAST_METRICS_2008-2023.mat')
load('/home/ym/Dropbox/REEFMOD/REEFMOD_GBR_OUTPUTS/GBR.7.0_CMIP6_2024_04/Raw_outputs/sR0_GBR.7.0_herit0.3_SSP119_CNRM-ESM2-1.mat', 'coral_cover_per_taxa')
Y = sum(coral_cover_per_taxa(:,:,1:17,:),4);

% Initial step is end of 2007 (winter), first step is summer 2008, last step is end of 2017
TIME =  2007.5:0.5:2023.5 ;

%% Load AIMS LTMP observations for the whole GBR
% Load last AIMS observations including manta and fixed transect data (LTMP+MMP)
load('/home/ym/Dropbox/REEFMOD/REEFMOD_DATA/Coral_observations_GBR/2024_from_RIMRep_DMS//GBR_AIMS_OBS_CORAL_COVER_2024.mat')

DATA_TR_LTMP = GBR_AIMS_OBS_CORAL_COVER(strcmp(string(GBR_AIMS_OBS_CORAL_COVER.project_code),'LTMP')==1 & ...
    strcmp(string(GBR_AIMS_OBS_CORAL_COVER.data_type),'photo-transect')==1,:);
DATA_TR_LTMP.CCOVER = 100*DATA_TR_LTMP.mean; % calculate percent coral cover

DATA_TR_MMP = GBR_AIMS_OBS_CORAL_COVER(strcmp(string(GBR_AIMS_OBS_CORAL_COVER.project_code),'MMP')==1 & ...
    strcmp(string(GBR_AIMS_OBS_CORAL_COVER.data_type),'photo-transect')==1 & ...
    GBR_AIMS_OBS_CORAL_COVER.depth>=5,:); % exclude shallow observations (2m depth)
DATA_TR_MMP.CCOVER = 100*DATA_TR_MMP.mean; % calculate percent coral cover

DATA_MT_LTMP = GBR_AIMS_OBS_CORAL_COVER(strcmp(string(GBR_AIMS_OBS_CORAL_COVER.project_code),'LTMP')==1 & ...
    strcmp(string(GBR_AIMS_OBS_CORAL_COVER.data_type),'manta')==1,:);
DATA_MT_LTMP.CCOVER = predict(LTMP_Transect2Tow_Model2, sqrt(100*DATA_MT_LTMP.mean)).^2; % calculate percent coral cover (transect equivalent

% Group all data
DATA_ALL = [DATA_TR_LTMP ; DATA_TR_MMP ; DATA_MT_LTMP];

% Give 1 to each obs for counting nb of surveys
DATA_ALL.OBS = ones(size(DATA_ALL,1),1);

% Only select the monitored reefs that have observations in between 2006-2008 and were used to initialise simulations
select_init = find(DATA_ALL.YearReefMod>=2006 & DATA_ALL.YearReefMod<=2008);

% Build design to count the number of observed years since 2009
DESIGN = varfun(@sum, DATA_ALL(DATA_ALL.YearReefMod>=2009,:),'GroupingVariables',...
    {'Reef_ID','LOC_NAME_S','LABEL_ID','AREA_DESCR','Shelf_position','AIMS_sector'},'InputVariables','OBS');

%% PLOT REEF by REEF
SaveDir = 'VALIDATION_RUNS_2024_NOV';
filename= 'VALID_NEW_REEF' ;
FontSizeLabelTicks = 9; FontSizeLabelAxes = 10; FontSizeLabelTitles = 11;

MIN_OBS = 9;
SELECTION = DESIGN(find(DESIGN.GroupCount>= MIN_OBS),:);
% Further select reefs that had observations in 2006-2008 (for initiatilisation)
SELECTION = SELECTION(ismember(SELECTION.Reef_ID, DATA_ALL.Reef_ID(select_init))==1,:);
% Exclude reefs that were not initialised with the complete LTMP/MMP dataset
my_list = [986,1183,877,938,1758,1854,1425,2175,2765,3130,3294,3095,3062,2650,2881,3622,3518,3691,3647,3760,3672,3702,2375];
SELECTION = SELECTION(ismember(SELECTION.Reef_ID, my_list)==0,:);

% Shorten the name of reefs that have long name
GBR_REEFS.GBR_NAME(1756)='Orpheus Island Reef';
GBR_REEFS.GBR_NAME(1728)='Pelorus Reef';

Ymean = squeeze(mean(Y,1));
ListRegions = unique(GBR_REEFS.AREA_DESCR);

[~,J] = sort(GBR_REEFS.LAT(SELECTION.Reef_ID),'descend'); %sort by latitude
myselect = SELECTION(J,:);
ShelfName = ["I" "M" "O"];

N_tot = size(SELECTION,1);
nrows = [6 6 6];
ncols = 5;
nfigs = 3;
% nfigs = ceil(N_tot/(nrows*ncols));
n=0;

for p=1:nfigs

    hfig = figure;
    width=220*ncols; height=150*nrows(p); set(hfig,'color','w','units','points','position',[0,0,width,height])
    set(hfig, 'Resize', 'off')

    % hh = tight_subplot(nrows(p),ncols,[0.03 0.02],0.05,0.12); %tight_subplot(Nh, Nw, gap, marg_h, marg_w)
    hh = tight_subplot(nrows(p),ncols,[0.05 0.02],0.05,0.12); %tight_subplot(Nh, Nw, gap, marg_h, marg_w)

    count=0;

    for g=1:nrows(p)*ncols

        n = n+1;

        if n<=size(myselect,1)

            count=count+1;
            axes(hh(count));

            traject_all = squeeze(Y(:,myselect.Reef_ID(n),:));
            traject_mean = Ymean(myselect.Reef_ID(n),:);

            OBS_ALL = DATA_ALL(DATA_ALL.Reef_ID==myselect.Reef_ID(n),:);
            OBS_MT = OBS_ALL(ismember(OBS_ALL.data_type,'manta')==1,:);
            OBS_TR_LTMP = OBS_ALL(ismember(OBS_ALL.data_type,'photo-transect')==1 & ismember(OBS_ALL.project_code,'LTMP')==1,:);
            OBS_TR_MMP = OBS_ALL(ismember(OBS_ALL.data_type,'photo-transect')==1 & ismember(OBS_ALL.project_code,'MMP')==1,:);
            OBS_TR_MMP_mean = groupsummary(OBS_TR_MMP,["YearReefMod"],"mean","CCOVER"); % calculate mean across multiple sites each year

            plot(YEARS, traject_all(:,2:end)','Color',rgb('DarkGray')); hold on
            plot(YEARS, traject_mean(2:end), 'Color',rgb('Crimson'),'LineWidth',2)
            line([2008 2008], [0 85],'LineStyle','--', 'LineWidth',1.5)
            plot(OBS_MT.YearReefMod, OBS_MT.CCOVER,'o','MarkerSize',6, 'MarkerEdgeColor',rgb('Black'), 'MarkerFaceColor',rgb('white'),'LineWidth',0.5)
            plot(OBS_TR_LTMP.YearReefMod,OBS_TR_LTMP.CCOVER,'o','MarkerSize',6, 'MarkerEdgeColor',rgb('Black'), 'MarkerFaceColor',rgb('Black'))
            plot(OBS_TR_MMP_mean.YearReefMod, OBS_TR_MMP_mean.mean_CCOVER,'^','MarkerSize',6, 'MarkerEdgeColor',rgb('Black'), 'MarkerFaceColor',rgb('Black'),'LineWidth',0.5)

            set(gca,'Layer', 'top','FontName', 'Arial' ,'FontSize',FontSizeLabelTicks);
            axis([2005.3 2023.8 -2 85])
            yticks([0:20:80])
            xticks([2005:3:2023])

            % text(2010,78.5,char(unique(OBS_ALL.LOC_NAME_S)),'FontName', 'Arial', 'FontWeight','normal','FontSize',9)
            % Use short GBR name instead:
            % text(2009,78,GBR_REEFS.GBR_NAME(myselect.Reef_ID(n)),'FontName', 'Arial', 'FontWeight','normal','FontSize',8)    
            % text(2009,70,['(' char(unique(OBS_ALL.LABEL_ID)) ')'],'FontName', 'Arial', 'FontWeight','normal','FontSize',8)
            % text(2005.75,78.5,ShelfName(unique(OBS_ALL.Shelf_position)),'FontName', 'Arial', 'FontWeight','bold','FontSize',9)

            text(2005.5, 90,['(' char(unique(OBS_ALL.LABEL_ID)) ') ' char(GBR_REEFS.GBR_NAME(myselect.Reef_ID(n)))],'FontName', 'Arial', 'FontWeight','bold','FontSize',9)    
            text(2005.75,78.5,ShelfName(unique(OBS_ALL.Shelf_position)),'FontName', 'Arial', 'FontWeight','bold','FontSize',9)

        else

            plot([],[])
            hh(count+1).XAxis.Parent.XAxis.Visible = 'off';
            hh(count+1).YAxis.Parent.YAxis.Visible = 'off';
        end
    end

    for j=1:nrows(p)
        row_list = [1:ncols:nrows(p)*ncols];
        hh(row_list(j)).YLabel.String={'Coral cover (%)';''};
        hh(row_list(j)).YLabel.FontSize=11;
    end

    IMAGENAME = [SaveDir '/' filename num2str(p)];
    print(hfig, ['-r' num2str(300)], [IMAGENAME '.png' ], ['-d' 'png'] );
    crop([IMAGENAME '.png'],0,20);
    close(hfig);
end
