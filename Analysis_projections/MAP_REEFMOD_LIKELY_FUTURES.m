%__________________________________________________________________________
%
% REEFMOD COUNTERFACTUAL CORAL TRAJECTORIES (MEAN GBR)
%
% Yves-Marie Bozec, y.bozec@uq.edu.au, 07/2023
%__________________________________________________________________________
clear
SaveDir = '';

SETTINGS_PLOTS % general settings for plotting

load('GBR.7.0_likely_runs_NEW.mat') % gives the IDs of runs sampled by bootstrap

load('GBR_REEF_POLYGONS_2024.mat')% reef definition file
load('GBR_MAPS.mat') ; % shapefiles, include map of islands and mainland

N = 100; % number of bootstrap samples
MyPalette1 = makeColorMap([1 0 0] , [1 1 0] , [0 0.5 0.1]);

for ssp = 1:5

    if ssp == 1
        gcm_list = [1:5 7 9];
    else
        gcm_list = [1:10];
    end

    % Concatenate all gcm runs
    X = nan(1,3806,94); % primer

    for gcm = gcm_list

        % Load the raw output files iteratively
        % Each file contains all coral outputs per reef, year and replicate run (20 runs for each scenario)
        % There are 47 files (44 GB in total) available upon request
        MyDir = '/home/ym/Dropbox/REEFMOD/REEFMOD_GBR_OUTPUTS/GBR.7.0_CMIP6_2024_04/';
        load([MyDir 'Raw_outputs/sR0_GBR.7.0_herit0.3_SSP' All_SSPs{ssp} '_' All_GCMs{gcm} '.mat'],'coral_cover_per_taxa','META');

        coral_cover_tot = sum(coral_cover_per_taxa,4);

        X = [X ; coral_cover_tot]; OutputName = 'CCOVER'; cctitle = {'Coral cover'; '(%)';''}; RANGE = 0:10:40 ; RANGE_lab = {' 0';'10';'20';'30';'40'} ; MyPalette = MyPalette1;

    end

    X = X(2:end,:,:); % remove te primer

    % Now sample the runs following the list of bootstrapped run IDs
    X_lik = nan(1,3806,94); % primer
    select_run  = LIKELY_RUNS(ssp).select; % list of sampled run IDs

    for n = 1:N % for every bootstrap sample
        X_lik = [X_lik ; X(select_run(:,n),:,:)];
    end

    clear X
    X_lik = X_lik(2:end,:,:); % remove te primer

    % Mapping parameters
    FontSizeTowns = 11 ;
    FontSizeCoord = 14 ;
    FontSizeTitleCC = 12 ; % for some reason needs to be downsized when printed

    YearLabRange = {'2030-2040' ; '2050-2060' ; '2070-2080' ; '2090-2100'};
    All_years = [ 2035 2055 2075 2095 ];

    %% Setup chronology
    % Initial step is end of 2007 (winter), first step is summer 2008
    % Last step is winter
    start_year = 2007.5 ;
    TIME =  start_year + (0:META.nb_time_steps)/2 ;
    YEARS = TIME(2:2:end) ;

    for decade = 1:length(All_years)

        select_year = All_years(decade);
        I = find(YEARS > select_year-5 & YEARS <= select_year+5);
        Y = squeeze(nanmean(X_lik(:,:,I),1));
        Z = nanmean(Y,2);

        hfig = figure('visible','on');
        width=400; height=600; set(hfig,'color','w','units','points','position',[0,0,width,height])
        [hm1,cc1] = f_map(map_MAINLAND, map_ISLANDS, RANGE, RANGE_lab, GBR_REEFS.LON, GBR_REEFS.LAT, Z, cctitle, '', '',MyPalette);

        savefig(hfig,[SaveDir OutputName '_SSP_' All_SSPs{ssp} '_DECADE' num2str(decade)])
        close all

    end
end
