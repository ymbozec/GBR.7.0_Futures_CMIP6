%__________________________________________________________________________
%
% REEFMOD BLEACHING MODEL TESTING
% Uses AIMS data only (LTMP+MMP), with updated dataset downloaded from RimREP DMS
% Yves-Marie Bozec, y.bozec@uq.edu.au, 11/2024
%__________________________________________________________________________

clear
SETTINGS_PLOTS
MyFolder = 'OCTOBER_2024/';

load('/home/ym/Dropbox/REEFMOD/REEFMOD.7.0_GBR/data/GBR_REEF_POLYGONS_2024.mat')
load('/home/ym/Dropbox/REEFMOD/REEFMOD.7.0_GBR/data/Corals/LTMP_Transect2Tow_2024.mat')

load('HINDCAST_METRICS_2008-2023.mat')
load('sR0_GBR.7.0_herit0.3_SSP119_CNRM-ESM2-1.mat','record_applied_DHWs')

load('/home/ym/Dropbox/REEFMOD/REEFMOD.7.0_GBR/data/Climatology/Past/GBR_past_DHW_CRW_5km_1985_2023.mat')
% 39 years between 1985 and 2023 (2016 is column 32)

BleachingYear = [2016; 2017 ; 2020 ; 2022];
CC_YearId = [10 ; 11 ; 14 ; 16]; % corresponding year in the coral cover output
DHW_YearID = [32 ; 33 ; 36 ; 38]; % corresponding year in the DHW matrix

CC_threshold = 0; % minimum cover before bleaching (reefs with lower cover would bias the observed relative change)

%% SELECT THE PLOTTED VARIABLES
showing_HT = 'no' ; % to plot the observed and predicted cover change
% showing_HT = 'yes' ; % to plot predicted cover changes with HT before/after bleaching

select_region = 1:3806 ; % select all regions
% select_region = find(GBR_REEFS.AREA_DESCR=='Far Northern');

%% PLOT FIGURES
sc1_color = [0 190 205]/255;
% sc1_color = rgb('LightBlue');
scenario = {'after';'before'};

for yr = 1:length(BleachingYear)

    % select the DHW values of the corresponding year
    DHW = GBR_PAST_DHW(:,DHW_YearID(yr));
    % select modelled reefs showing at least 10% total coral cover before bleaching
    s = find(Coral_tot.M(select_region,CC_YearId(yr)-1)>= CC_threshold);
    % Calculate relative change in coral cover following bleaching
    Y = 100*(Coral_tot.M(select_region,CC_YearId(yr))-Coral_tot.M(select_region,CC_YearId(yr)-1))./Coral_tot.M(select_region,CC_YearId(yr)-1);

    hfig = figure;
    set(gca, 'Layer', 'top', 'FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);

    switch showing_HT  % whether we display mean heat tolerance or not

        case 'yes'
            for i= 1:length(scenario)

                % HT = Coral_tot.M_HT(select_region,CC_YearId(yr)+1-i); % which selects CC_YearId(yr)-1 before bleaching, CC_YearId(yr) after
                % To focus on thermally sensitive groups only:
                HT_sensit = nanmean(cat(3,Coral_sp(1).M_HT, Coral_sp(2).M_HT, Coral_sp(3).M_HT, Coral_sp(4).M_HT),3);
                HT = HT_sensit(select_region,CC_YearId(yr)+1-i); % which selects CC_YearId(yr)-1 before bleaching, CC_YearId(yr) after
                max(HT)
                [~,r]=sort(HT(s));

                plot([-1 20],[0 0],'--k'); hold on

                sc1 = scatter(DHW(s(r)),Y(s(r)),25,HT(s(r)),'o','filled','MarkerEdgeColor','k');

                cb = colorbar;
                limits = [-0.5, 4.5];
                set(gca,'clim',limits([1,end]))
                cb.Limits = [-0.5 4.5];
                cb.Location='east';
                cb.Position = [0.82 0.5 0.03 0.3];
                cb.FontName = 'Arial';
                cb.Ticks = [0:1:4];
                cb.TickLabels = {'0';'+1';'+2';'+3';'+4'};
                t=title(cb,{'HT';'(°C-week)'});
                t.FontWeight = 'bold';

                sc1.MarkerFaceAlpha = 1;
                axis([-0.2 15.2 -100 190]); title([num2str(BleachingYear(yr)) ' MHW'])

                savefig(hfig,[MyFolder 'GBR.7.0_DHW8_Hindcast_RelChange_' num2str(BleachingYear(yr)) '_with_HT' scenario{i} '.fig'])

                if yr == 1 % export data for 2016 bleaching only

                    % Cannot order per increasing HT because order differ pre/post bleaching

                    DATA_BLEACHING_2016 = table;
                    DATA_BLEACHING_2016.DHW = DHW(s);
                    DATA_BLEACHING_2016.COVER_CHANGE = Y(s);

                    HT = HT_sensit(select_region,CC_YearId(yr)-1);
                    DATA_BLEACHING_2016.HTinit = HT(s);

                    HT = HT_sensit(select_region,CC_YearId(yr));
                    DATA_BLEACHING_2016.HTfinal = HT(s);

                    disp('Mean average shift in HT at 8-10 DHW')
                    s8_10 = find(DHW(s)>=8 & DHW(s)<=10);
                    HT_DIFF = DATA_BLEACHING_2016.HTfinal(s8_10)-DATA_BLEACHING_2016.HTinit(s8_10);
                    round(mean(HT_DIFF),1)

                    disp('95% prediction interval')
                    PI1 = mean(HT_DIFF) - 1.96*sqrt(std(HT_DIFF)^2 + std(HT_DIFF)^2/length(s8_10))
                    PI2 = mean(HT_DIFF) + 1.96*sqrt(std(HT_DIFF)^2 + std(HT_DIFF)^2/length(s8_10))

                    writetable(DATA_BLEACHING_2016, [MyFolder 'DATA_BLEACHING_2016.csv'])

                end

            end

        case 'no'
            sc1 = scatter(DHW(s),Y(s),'MarkerFaceColor',sc1_color,'MarkerEdgeColor','none');
            sc1.MarkerFaceAlpha = 0.3;

            hold on
            plot([-1 20],[0 0],'--k')
            axis([-0.2 15.2 -100 190]); title([num2str(BleachingYear(yr)) ' MHW'])

            % Load all AIMS observations including manta and fixed transect data (LTMP+MMP)
            load('/home/ym/Dropbox/REEFMOD/REEFMOD_DATA/Coral_observations_GBR/2024_from_RIMRep_DMS/GBR_AIMS_OBS_CORAL_COVER_2024.mat')
            all_project_codes = [1:3];

            % Display key metrics of the coral response
            num2str(BleachingYear(yr))
            s8_10 = find(DHW(s)>=8 & DHW(s)<=10);
            Z = Y(s);
            disp('mean relative loss at DHW between 8-10')
            mean(Z(s8_10))
            disp('95% prediction interval')
            PI1 = mean(Z(s8_10)) - 1.96*sqrt(std(Z(s8_10))^2 + std(Z(s8_10))^2/length(s8_10))
            PI2 = mean(Z(s8_10)) + 1.96*sqrt(std(Z(s8_10))^2 + std(Z(s8_10))^2/length(s8_10))

            disp('associated ICR')
            prctile(Z(s8_10),[25 75])

            MASTER_CC_CHANGE = nan(1,6);

            for i = 1:length(all_project_codes)

                switch all_project_codes(i)
                    case 1
                        MY_DATA = GBR_AIMS_OBS_CORAL_COVER(strcmp(string(GBR_AIMS_OBS_CORAL_COVER.project_code),'LTMP')==1 & ...
                            strcmp(string(GBR_AIMS_OBS_CORAL_COVER.data_type),'photo-transect')==1,:);
                        MY_DATA.CCOVER = 100*MY_DATA.mean; % calculate percent coral cover
                        my_marker = 'o';
                        my_fill = 'k';

                    case 2
                        MY_DATA = GBR_AIMS_OBS_CORAL_COVER(strcmp(string(GBR_AIMS_OBS_CORAL_COVER.project_code),'MMP')==1 & ...
                            strcmp(string(GBR_AIMS_OBS_CORAL_COVER.data_type),'photo-transect')==1 & ...
                            GBR_AIMS_OBS_CORAL_COVER.depth>=5,:); % exclude shallow observations (2m depth)
                        MY_DATA.CCOVER = 100*MY_DATA.mean; % calculate percent coral cover
                        my_marker = '^';
                        my_fill = 'k';

                    case 3
                        MY_DATA = GBR_AIMS_OBS_CORAL_COVER(strcmp(string(GBR_AIMS_OBS_CORAL_COVER.project_code),'LTMP')==1 & ...
                            strcmp(string(GBR_AIMS_OBS_CORAL_COVER.data_type),'manta')==1,:);
                        MY_DATA.CCOVER = predict(LTMP_Transect2Tow_Model2, sqrt(100*MY_DATA.mean)).^2; % calculate percent coral cover (transect equivalent

                        my_marker = 'o';
                        my_fill = 'w';
                end

                select_pre = find(MY_DATA.date >= [num2str(BleachingYear(yr)-2) '-11-01'] & MY_DATA.date <= [num2str(BleachingYear(yr)) '-04-30']);
                select_post = find(MY_DATA.date >= [num2str(BleachingYear(yr)) '-05-01'] & MY_DATA.date <= [num2str(BleachingYear(yr)+1) '-10-31']);

                List_ID_pre = unique(MY_DATA.Reef_ID(select_pre));
                List_ID_post = unique(MY_DATA.Reef_ID(select_post));

                DATA_MT_BLEACHING = MY_DATA([select_pre ; select_post],:);

                A = ismember(List_ID_pre, List_ID_post);
                B = ismember(DATA_MT_BLEACHING.Reef_ID, List_ID_pre(A==1));
                DATA_SELECT = DATA_MT_BLEACHING(B==1,:);

                List_reef_ID = unique(DATA_SELECT.Reef_ID);

                CC_CHANGE = nan(length(List_reef_ID),6);

                for reef = 1:length(List_reef_ID)

                    reef_id = List_reef_ID(reef);
                    X = DATA_SELECT(DATA_SELECT.Reef_ID==reef_id ,:);
                    pre_bleaching = X(X.date<=[num2str(BleachingYear(yr)) '-04-30'],:);

                    if size(pre_bleaching,1) > 1
                        pre_bleaching = sortrows(pre_bleaching,'date','descend');
                        pre_bleaching = pre_bleaching(1,:);
                    end

                    post_bleaching = X(X.date>[num2str(BleachingYear(yr)) '-04-30'],:);

                    if size(post_bleaching,1) > 1
                        O2 = sort(post_bleaching.YearReefMod,'descend');
                        post_bleaching = sortrows(post_bleaching,'date','ascend');
                        post_bleaching = post_bleaching(1,:);
                    end

                    CC_CHANGE(reef,1) = reef_id;
                    CC_CHANGE(reef,2) = 100*(post_bleaching.CCOVER - pre_bleaching.CCOVER)/pre_bleaching.CCOVER ;
                    CC_CHANGE(reef,4) = pre_bleaching.CCOVER;
                    CC_CHANGE(reef,5) = post_bleaching.CCOVER;
                    CC_CHANGE(reef,6) = all_project_codes(i);
                end

                CC_CHANGE(:,3)  = DHW(CC_CHANGE(:,1),1);

                I = find(CC_CHANGE(:,4)>= CC_threshold); % select reefs with minimum coral cover before bleaching
                hold on
                p(all_project_codes(i)).obs = plot(CC_CHANGE(I,3),CC_CHANGE(I,2),my_marker,'MarkerFaceColor',my_fill,'MarkerEdgeColor','k');

                MASTER_CC_CHANGE = [MASTER_CC_CHANGE ; CC_CHANGE];
            end

            ll = legend([p(1).obs, p(2).obs, p(3).obs], {'LTMP fixed transects'; 'MMP fixed transects'; 'LTMP manta tows' });

            MASTER_CC_CHANGE = MASTER_CC_CHANGE(2:end,:); % remove the starter

            % Master summary table
            OBS_RelChanges = table;
            OBS_RelChanges.Reef_ID = single(MASTER_CC_CHANGE(:,1));
            OBS_RelChanges.LAT = GBR_REEFS.LAT(MASTER_CC_CHANGE(:,1));
            OBS_RelChanges.LON = GBR_REEFS.LON(MASTER_CC_CHANGE(:,1));
            OBS_RelChanges.LABEL_ID = GBR_REEFS.LABEL_ID(MASTER_CC_CHANGE(:,1));
            OBS_RelChanges.GBR_NAME = GBR_REEFS.GBR_NAME(MASTER_CC_CHANGE(:,1));
            OBS_RelChanges.Shelf_position = GBR_REEFS.Shelf_position(MASTER_CC_CHANGE(:,1));
            OBS_RelChanges.AREA_DESCR = GBR_REEFS.AREA_DESCR(MASTER_CC_CHANGE(:,1));
            OBS_RelChanges.BleachingYear = BleachingYear(yr)*ones(size(OBS_RelChanges,1),1);
            OBS_RelChanges.DHW = MASTER_CC_CHANGE(:,3);
            OBS_RelChanges.INIT_CC = MASTER_CC_CHANGE(:,4);
            OBS_RelChanges.FINAL_CC = MASTER_CC_CHANGE(:,5);
            OBS_RelChanges.REL_CHANGE_CC = MASTER_CC_CHANGE(:,2);
            OBS_RelChanges.project_code = MASTER_CC_CHANGE(:,6);

            writetable(OBS_RelChanges, [MyFolder 'SUMMARY_OBS_REL_CHANGE_CC_' num2str(BleachingYear(yr)) '.csv'])

            savefig(hfig,[MyFolder 'GBR.7.0_DHW8_Hindcast_RelChange_' num2str(BleachingYear(yr)) '.fig'])
    end
end
close all