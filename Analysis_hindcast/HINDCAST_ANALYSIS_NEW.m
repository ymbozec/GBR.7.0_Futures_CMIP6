clear

outfilename ='HINDCAST_METRICS_2008-2023.mat';

MyDir = '/home/ym/Dropbox/REEFMOD/REEFMOD_GBR_OUTPUTS/GBR.7.0_CMIP6_2024_04/Raw_outputs/';

% any of the GCM/SSP scenarios would show same hindcast
load([MyDir 'sR0_GBR.7.0_herit0.3_SSP119_CNRM-ESM2-1.mat'], 'META', 'coral_cover_per_taxa',...
    'nb_coral_recruit','nb_coral_juv','nb_coral_adol','nb_coral_adult','nb_coral_offspring','coral_larval_supply', 'coral_HT_mean')

load('/home/ym/Dropbox/REEFMOD/REEFMOD.7.0_GBR/data/GBR_REEF_POLYGONS_2024.mat')

% Initial step is end of 2007 (winter), first step is summer 2008, last step is end of 2017
start_year = 2007.5 ;
TIME =  start_year + (0:META.nb_time_steps)/2 ;
YEARS = TIME(2:2:end) ;
YEARS = YEARS(1:16); % excludes initial step (2007.5)

coral_cover_tot = sum(coral_cover_per_taxa(:,:,1:length(YEARS)+1,:),4);
Coral_tot.M = squeeze(mean(coral_cover_tot, 1)) ;
Coral_tot.SD = squeeze(std(coral_cover_tot, 0, 1)) ;
Coral_tot.M_nb_coral_recruit = squeeze(mean(sum(nb_coral_recruit(:,:,1:length(YEARS)+1,:),4), 1));
Coral_tot.M_nb_coral_juv = squeeze(mean(sum(nb_coral_juv(:,:,1:length(YEARS)+1,:),4), 1));
Coral_tot.M_nb_coral_adol = squeeze(mean(sum(nb_coral_adol(:,:,1:length(YEARS)+1,:),4), 1));
Coral_tot.M_nb_coral_adult = squeeze(mean(sum(nb_coral_adult(:,:,1:length(YEARS)+1,:),4), 1));
Coral_tot.M_nb_coral_offspring = squeeze(mean(sum(nb_coral_offspring(:,:,1:length(YEARS)+1,:),4), 1));
Coral_tot.M_coral_larval_supply = squeeze(mean(sum(coral_larval_supply(:,:,1:length(YEARS)+1,:),4), 1));
Coral_tot.M_HT = squeeze(nanmean(nanmean(coral_HT_mean(:,:,1:length(YEARS)+1,:),4), 1));

% Mean per species
for s=1:META.nb_coral_types
    
    Coral_sp(s).M = squeeze(mean(coral_cover_per_taxa(:,:,1:length(YEARS)+1,s), 1)) ;
    Coral_sp(s).SD = squeeze(std(coral_cover_per_taxa(:,:,1:length(YEARS)+1,s), 0, 1));
    Coral_sp(s).M_nb_coral_recruit = squeeze(mean(nb_coral_recruit(:,:,1:length(YEARS)+1,s), 1));
    Coral_sp(s).M_nb_coral_juv = squeeze(mean(nb_coral_juv(:,:,1:length(YEARS)+1,s), 1));
    Coral_sp(s).M_nb_coral_adol = squeeze(mean(nb_coral_adol(:,:,1:length(YEARS)+1,s), 1));
    Coral_sp(s).M_nb_coral_adult = squeeze(mean(nb_coral_adult(:,:,1:length(YEARS)+1,s), 1));
    Coral_sp(s).M_nb_coral_offspring = squeeze(mean(nb_coral_offspring(:,:,1:length(YEARS)+1,s), 1));
    Coral_sp(s).M_coral_larval_supply = squeeze(mean(coral_larval_supply(:,:,1:length(YEARS)+1,s), 1)); 
    Coral_sp(s).M_HT = squeeze(nanmean(coral_HT_mean(:,:,1:length(YEARS)+1,s), 1));

end

area_w = log(1+META.area_habitat)/sum(log(1+META.area_habitat)); % weight with habitat area

%% For reef selection
lat_cutoff = -10 ; % exclude reefs above (north) this latitude

select.North = find((GBR_REEFS.AIMS_sector==1|GBR_REEFS.AIMS_sector==2|GBR_REEFS.AIMS_sector==3)&GBR_REEFS.LAT<lat_cutoff);
select.Centre = find(GBR_REEFS.AIMS_sector==4|GBR_REEFS.AIMS_sector==5|GBR_REEFS.AIMS_sector==6|GBR_REEFS.AIMS_sector==7|GBR_REEFS.AIMS_sector==8);
select.South = find(GBR_REEFS.AIMS_sector==9|GBR_REEFS.AIMS_sector==10|GBR_REEFS.AIMS_sector==11);

select.North_IN = find((GBR_REEFS.AIMS_sector==1|GBR_REEFS.AIMS_sector==2|GBR_REEFS.AIMS_sector==3) & GBR_REEFS.LAT<lat_cutoff & GBR_REEFS.Shelf_position==1);
select.North_MID = find((GBR_REEFS.AIMS_sector==1|GBR_REEFS.AIMS_sector==2|GBR_REEFS.AIMS_sector==3) & GBR_REEFS.LAT<lat_cutoff & GBR_REEFS.Shelf_position==2);
select.North_OUT = find((GBR_REEFS.AIMS_sector==1|GBR_REEFS.AIMS_sector==2|GBR_REEFS.AIMS_sector==3) & GBR_REEFS.LAT<lat_cutoff & GBR_REEFS.Shelf_position==3);

select.Centre_IN = find((GBR_REEFS.AIMS_sector==4|GBR_REEFS.AIMS_sector==5|GBR_REEFS.AIMS_sector==6|GBR_REEFS.AIMS_sector==7|GBR_REEFS.AIMS_sector==8) & GBR_REEFS.Shelf_position==1);
select.Centre_MID = find((GBR_REEFS.AIMS_sector==4|GBR_REEFS.AIMS_sector==5|GBR_REEFS.AIMS_sector==6|GBR_REEFS.AIMS_sector==7|GBR_REEFS.AIMS_sector==8) & GBR_REEFS.Shelf_position==2);
select.Centre_OUT = find((GBR_REEFS.AIMS_sector==4|GBR_REEFS.AIMS_sector==5|GBR_REEFS.AIMS_sector==6|GBR_REEFS.AIMS_sector==7|GBR_REEFS.AIMS_sector==8) & GBR_REEFS.Shelf_position==3);

select.South_IN = find((GBR_REEFS.AIMS_sector==9|GBR_REEFS.AIMS_sector==10|GBR_REEFS.AIMS_sector==11) & GBR_REEFS.Shelf_position==1);
select.South_MID = find((GBR_REEFS.AIMS_sector==9|GBR_REEFS.AIMS_sector==10|GBR_REEFS.AIMS_sector==11) & GBR_REEFS.Shelf_position==2);
select.South_OUT = find((GBR_REEFS.AIMS_sector==9|GBR_REEFS.AIMS_sector==10|GBR_REEFS.AIMS_sector==11) & GBR_REEFS.Shelf_position==3);

select.GBR = find(GBR_REEFS.LAT<lat_cutoff); % 3,027 reefs in total if lat_cutoff=-13.
select.GBR_IN = find(GBR_REEFS.LAT<lat_cutoff & GBR_REEFS.Shelf_position==1); 
select.GBR_MID = find(GBR_REEFS.LAT<lat_cutoff & GBR_REEFS.Shelf_position==2); 
select.GBR_OUT = find(GBR_REEFS.LAT<lat_cutoff & GBR_REEFS.Shelf_position==3); 

%% Function to calculate mean values across a specific region weighted by reef areas of that region
weighted_mean = @(x,w,select) (w(select,1)'*x(select,:)/sum(w(select,1)))';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1) Trajectories of coral cover 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Store mean trajectories
MEAN_TRAJECTORIES = array2table(YEARS','VariableNames',{'Year'});
MEAN_TRAJECTORIES.GBR = weighted_mean(Coral_tot.M(:,2:end), area_w, select.GBR);
MEAN_TRAJECTORIES.NORTH = weighted_mean(Coral_tot.M(:,2:end), area_w, select.North);
MEAN_TRAJECTORIES.CENTER = weighted_mean(Coral_tot.M(:,2:end), area_w, select.Centre);
MEAN_TRAJECTORIES.SOUTH = weighted_mean(Coral_tot.M(:,2:end), area_w, select.South);

% Calculate GBR_mean for each year
GBR_mean = nan(size(coral_cover_tot,[1 3]));

for simul=1:20
    GBR_mean(simul,2:end) = weighted_mean(squeeze(coral_cover_tot(simul,select.GBR, 2:end)), area_w, select.GBR);
end

disp('average and sd of GBR_mean coral cover')
MEAN_GBR_mean = mean(GBR_mean(:,2:end),1)
SD_GBR_mean = std(GBR_mean(:,2:end),1)

disp('95% prediction interval of the GBR mean')
PI1_GBR_mean = MEAN_GBR_mean - 1.96*sqrt(SD_GBR_mean.^2 + (SD_GBR_mean.^2)/20 )
PI2_GBR_mean = MEAN_GBR_mean + 1.96*sqrt(SD_GBR_mean.^2 + (SD_GBR_mean.^2)/20 )

disp('annual average and sd of GBR_mean coral cover over the simulated period')
Z = GBR_mean(:,2:end);
MEAN_ANNUAL_GBR_mean = mean(Z(:))
SD_ANNUAL_GBR_mean = std(Z(:))

disp('95% prediction interval of the annual average of GBR mean')
PI1_MEAN_GBR_mean = MEAN_ANNUAL_GBR_mean - 1.96*sqrt(SD_ANNUAL_GBR_mean.^2 + (SD_ANNUAL_GBR_mean.^2)/length(Z(:)) )
PI2_MEAN_GBR_mean = MEAN_ANNUAL_GBR_mean + 1.96*sqrt(SD_ANNUAL_GBR_mean.^2 + (SD_ANNUAL_GBR_mean.^2)/length(Z(:)) )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2) Rates of change of coral cover 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CORAL COVER CHANGE
ANNUAL_CORAL_COVER_ini = squeeze(mean(coral_cover_tot(:,:,1:1:(end-1)),1)); % end of winter for years y
ANNUAL_CORAL_COVER_fin = squeeze(mean(coral_cover_tot(:,:,2:1:end),1)); % end of winter for years y+1
ANNUAL_CORAL_COVER_ini(ANNUAL_CORAL_COVER_ini<0.1) = 0.1;

%% Absolute change in coral cover
ANNUAL_ABS_CHANGE = ANNUAL_CORAL_COVER_fin - ANNUAL_CORAL_COVER_ini;

% Store mean annual changes
MEAN_ANNUAL_ABS_CHANGE = array2table(YEARS','VariableNames',{'Year'});
MEAN_ANNUAL_ABS_CHANGE.GBR = weighted_mean(ANNUAL_ABS_CHANGE, area_w, select.GBR);
MEAN_ANNUAL_ABS_CHANGE.NORTH = weighted_mean(ANNUAL_ABS_CHANGE, area_w, select.North);
MEAN_ANNUAL_ABS_CHANGE.CENTER = weighted_mean(ANNUAL_ABS_CHANGE, area_w, select.Centre);
MEAN_ANNUAL_ABS_CHANGE.SOUTH = weighted_mean(ANNUAL_ABS_CHANGE, area_w, select.South);

%% Relative change in coral cover
ANNUAL_REL_CHANGE = 100*(ANNUAL_CORAL_COVER_fin - ANNUAL_CORAL_COVER_ini)./ANNUAL_CORAL_COVER_ini;

% Store mean annual changes
MEAN_ANNUAL_REL_CHANGES = array2table(YEARS','VariableNames',{'Year'});
MEAN_ANNUAL_REL_CHANGES.GBR = weighted_mean(ANNUAL_REL_CHANGE, area_w, select.GBR);
MEAN_ANNUAL_REL_CHANGES.NORTH = weighted_mean(ANNUAL_REL_CHANGE, area_w, select.North);
MEAN_ANNUAL_REL_CHANGES.CENTER = weighted_mean(ANNUAL_REL_CHANGE, area_w, select.Centre);
MEAN_ANNUAL_REL_CHANGES.SOUTH = weighted_mean(ANNUAL_REL_CHANGE, area_w, select.South);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4) Shelf-position specific metrics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-- WHOLE GBR
% select_reefs = find(GBR_REEFS.Shelf_position==1 & GBR_REEFS.LAT<lat_cutoff);
% MEAN_TRAJECTORIES.GBR_inn = weighted_mean(Coral_tot.M(:,2:end), area_w, select_reefs);
% MEAN_ANNUAL_ABS_CHANGE.GBR_inn = weighted_mean(ANNUAL_ABS_CHANGE, area_w, select_reefs);
% MEAN_ANNUAL_REL_CHANGES.GBR_inn = weighted_mean(ANNUAL_REL_CHANGE, area_w, select_reefs);
% 
% select_reefs = find(GBR_REEFS.Shelf_position==2 & GBR_REEFS.LAT<lat_cutoff);
% MEAN_TRAJECTORIES.GBR_mid = weighted_mean(Coral_tot.M(:,2:end), area_w, select_reefs);
% MEAN_ANNUAL_ABS_CHANGE.GBR_mid = weighted_mean(ANNUAL_ABS_CHANGE, area_w, select_reefs);
% MEAN_ANNUAL_REL_CHANGES.GBR_mid = weighted_mean(ANNUAL_REL_CHANGE, area_w, select_reefs);
% 
% select_reefs = find(GBR_REEFS.Shelf_position==3 & GBR_REEFS.LAT<lat_cutoff);
% MEAN_TRAJECTORIES.GBR_out = weighted_mean(Coral_tot.M(:,2:end), area_w, select_reefs);
% MEAN_ANNUAL_ABS_CHANGE.GBR_out = weighted_mean(ANNUAL_ABS_CHANGE, area_w, select_reefs);
% MEAN_ANNUAL_REL_CHANGES.GBR_out = weighted_mean(ANNUAL_REL_CHANGE, area_w, select_reefs);
% 
% %-- NORTHERN
% select_reefs = find((GBR_REEFS.AIMS_sector==1|GBR_REEFS.AIMS_sector==2|GBR_REEFS.AIMS_sector==3) & GBR_REEFS.Shelf_position==1 & GBR_REEFS.LAT<lat_cutoff);
% MEAN_TRAJECTORIES.NORTH_inn = weighted_mean(Coral_tot.M(:,2:end), area_w, select_reefs);
% MEAN_ANNUAL_ABS_CHANGE.NORTH_inn = weighted_mean(ANNUAL_ABS_CHANGE, area_w, select_reefs);
% MEAN_ANNUAL_REL_CHANGES.NORTH_inn = weighted_mean(ANNUAL_REL_CHANGE, area_w, select_reefs);
% 
% select_reefs = find((GBR_REEFS.AIMS_sector==1|GBR_REEFS.AIMS_sector==2|GBR_REEFS.AIMS_sector==3) & GBR_REEFS.Shelf_position==2 & GBR_REEFS.LAT<lat_cutoff);
% MEAN_TRAJECTORIES.NORTH_mid = weighted_mean(Coral_tot.M(:,2:end), area_w, select_reefs);
% MEAN_ANNUAL_ABS_CHANGE.NORTH_mid = weighted_mean(ANNUAL_ABS_CHANGE, area_w, select_reefs);
% MEAN_ANNUAL_REL_CHANGES.NORTH_mid = weighted_mean(ANNUAL_REL_CHANGE, area_w, select_reefs);
% 
% select_reefs = find((GBR_REEFS.AIMS_sector==1|GBR_REEFS.AIMS_sector==2|GBR_REEFS.AIMS_sector==3) & GBR_REEFS.Shelf_position==3 & GBR_REEFS.LAT<lat_cutoff);
% MEAN_TRAJECTORIES.NORTH_out = weighted_mean(Coral_tot.M(:,2:end), area_w, select_reefs);
% MEAN_ANNUAL_ABS_CHANGE.NORTH_out = weighted_mean(ANNUAL_ABS_CHANGE, area_w, select_reefs);
% MEAN_ANNUAL_REL_CHANGES.NORTH_out = weighted_mean(ANNUAL_REL_CHANGE, area_w, select_reefs);
% 
% %-- CENTRAL
% select_reefs = find(GBR_REEFS.Shelf_position==1&(GBR_REEFS.AIMS_sector==4|GBR_REEFS.AIMS_sector==5|GBR_REEFS.AIMS_sector==6|GBR_REEFS.AIMS_sector==7|GBR_REEFS.AIMS_sector==8));
% MEAN_TRAJECTORIES.CENTER_inn = weighted_mean(Coral_tot.M(:,2:end), area_w, select_reefs);
% MEAN_ANNUAL_ABS_CHANGE.CENTER_inn = weighted_mean(ANNUAL_ABS_CHANGE, area_w, select_reefs);
% MEAN_ANNUAL_REL_CHANGES.CENTER_inn = weighted_mean(ANNUAL_REL_CHANGE, area_w, select_reefs);
% 
% select_reefs = find(GBR_REEFS.Shelf_position==2&(GBR_REEFS.AIMS_sector==4|GBR_REEFS.AIMS_sector==5|GBR_REEFS.AIMS_sector==6|GBR_REEFS.AIMS_sector==7|GBR_REEFS.AIMS_sector==8));
% MEAN_TRAJECTORIES.CENTER_mid = weighted_mean(Coral_tot.M(:,2:end), area_w, select_reefs);
% MEAN_ANNUAL_ABS_CHANGE.CENTER_mid = weighted_mean(ANNUAL_ABS_CHANGE, area_w, select_reefs);
% MEAN_ANNUAL_REL_CHANGES.CENTER_mid = weighted_mean(ANNUAL_REL_CHANGE, area_w, select_reefs);
% 
% select_reefs = find(GBR_REEFS.Shelf_position==3&(GBR_REEFS.AIMS_sector==4|GBR_REEFS.AIMS_sector==5|GBR_REEFS.AIMS_sector==6|GBR_REEFS.AIMS_sector==7|GBR_REEFS.AIMS_sector==8));
% MEAN_TRAJECTORIES.CENTER_out = weighted_mean(Coral_tot.M(:,2:end), area_w, select_reefs);
% MEAN_ANNUAL_ABS_CHANGE.CENTER_out = weighted_mean(ANNUAL_ABS_CHANGE, area_w, select_reefs);
% MEAN_ANNUAL_REL_CHANGES.CENTER_out = weighted_mean(ANNUAL_REL_CHANGE, area_w, select_reefs);
% 
% %-- SOUTHERN
% select_reefs = find(GBR_REEFS.Shelf_position==1&(GBR_REEFS.AIMS_sector==9|GBR_REEFS.AIMS_sector==10|GBR_REEFS.AIMS_sector==11));
% MEAN_TRAJECTORIES.SOUTH_inn = weighted_mean(Coral_tot.M(:,2:end), area_w, select_reefs);
% MEAN_ANNUAL_ABS_CHANGE.SOUTH_inn = weighted_mean(ANNUAL_ABS_CHANGE, area_w, select_reefs);
% MEAN_ANNUAL_REL_CHANGES.SOUTH_inn = weighted_mean(ANNUAL_REL_CHANGE, area_w, select_reefs);
% 
% select_reefs = find(GBR_REEFS.Shelf_position==2&(GBR_REEFS.AIMS_sector==9|GBR_REEFS.AIMS_sector==10|GBR_REEFS.AIMS_sector==11));
% MEAN_TRAJECTORIES.SOUTH_mid = weighted_mean(Coral_tot.M(:,2:end), area_w, select_reefs);
% MEAN_ANNUAL_ABS_CHANGE.SOUTH_mid = weighted_mean(ANNUAL_ABS_CHANGE, area_w, select_reefs);
% MEAN_ANNUAL_REL_CHANGES.SOUTH_mid = weighted_mean(ANNUAL_REL_CHANGE, area_w, select_reefs);
% 
% select_reefs = find(GBR_REEFS.Shelf_position==3&(GBR_REEFS.AIMS_sector==9|GBR_REEFS.AIMS_sector==10|GBR_REEFS.AIMS_sector==11));
% MEAN_TRAJECTORIES.SOUTH_out = weighted_mean(Coral_tot.M(:,2:end), area_w, select_reefs);
% MEAN_ANNUAL_ABS_CHANGE.SOUTH_out = weighted_mean(ANNUAL_ABS_CHANGE, area_w, select_reefs);
% MEAN_ANNUAL_REL_CHANGES.SOUTH_out = weighted_mean(ANNUAL_REL_CHANGE, area_w, select_reefs);
% 
%% Old stuff to carry-on recent coral mortality for estimating rubble at the end of the hindcast
% CURRENT_RUBBLE_COVER = squeeze(rubble(:,:,end)) + META.convert_rubble *(sum(coral_cover_lost_bleaching(:,:,(end-5):end),3)+...
%     sum(coral_cover_lost_COTS(:,:,(end-5):end),3));

%% EXPORT NEW CALCULATIONS
writetable(MEAN_TRAJECTORIES,'EXPORT_MEAN_TRAJECTORIES.csv')
writetable(MEAN_ANNUAL_ABS_CHANGE,'EXPORT_ANNUAL_ABS_CHANGES.csv')
writetable(MEAN_ANNUAL_REL_CHANGES,'EXPORT_ANNUAL_REL_CHANGES.csv')
% writetable(MEAN_ANNUAL_MORT,'EXPORT_ANNUAL_MORT.csv')
% writetable(MEAN_ANNUAL_REL_MORT,'EXPORT_ANNUAL_REL_MORT.csv')

clearvars -except ANNUAL_CORAL_COVER_fin ANNUAL_CORAL_COVER_ini ANNUAL_ABS_CHANGE ANNUAL_REL_CHANGE ...
area_w lat_cutoff ...
select weighted_mean YEARS Coral_tot Coral_sp COTS_densities COTS_mantatow CURRENT_RUBBLE_COVER GROWTH_SUMMER GROWTH_WINTER...
IND_MORT_ANNUAL_BLEACHING IND_MORT_ANNUAL_COTS IND_MORT_ANNUAL_CYCLONES IND_REL_MORT_ANNUAL_BLEACHING IND_REL_MORT_ANNUAL_COTS IND_REL_MORT_ANNUAL_CYCLONES...
IND_GROWTH_SUMMER IND_GROWTH_WINTER...
outfilename...
coral_cover_lost_bleaching coral_cover_lost_cyclones coral_cover_lost_COTS...
% MEAN_ANNUAL_ABS_CHANGE MEAN_ANNUAL_MORT MEAN_ANNUAL_REL_CHANGES MEAN_ANNUAL_REL_MORT...
% nb_juveniles nb_adol_5cm coral_recruits 
% MEAN_TRAJECTORIES MORT_ANNUAL_BLEACHING MORT_ANNUAL_COTS MORT_ANNUAL_CYCLONES REL_MORT_ANNUAL_BLEACHING REL_MORT_ANNUAL_COTS REL_MORT_ANNUAL_CYCLONES

save(outfilename)