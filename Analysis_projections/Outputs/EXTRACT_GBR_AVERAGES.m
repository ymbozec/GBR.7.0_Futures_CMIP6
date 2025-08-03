%__________________________________________________________________________
%
% EXTRACT MEAN REEF TRAJECTORIES ACROSS ALL WARMING SCENARIOS
%
% Yves-Marie Bozec, y.bozec@uq.edu.au, 11/2023
%__________________________________________________________________________

clear
SaveDir = ''

All_SSPs = ["119" ; "126" ; "245" ; "370" ; "585" ];
All_GCMs = ["CNRM-ESM2-1" ; "EC-Earth3-Veg" ; "IPSL-CM6A-LR" ; "MRI-ESM2-0" ; "UKESM1-0-LL" ; ...
    "GFDL-ESM4" ; "MIROC-ES2L" ; "MPI-ESM1-2-HR" ; "MIROC6" ; "NorESM2-LM" ];

MyDir = '/home/ym/Dropbox/REEFMOD/REEFMOD_GBR_OUTPUTS/GBR.7.0_CMIP6_2024_04/';
OutputfileName='GBR.7.0_averages_DHW8.mat';

for ssp = 1:5

    ssp

    for gcm = 1:10

        gcm

        % Note SSP1-1.9 is not available for gcm = 6, 8 & 10
        if ismember(gcm, [6 8 10]) == 1 && ssp == 1

            continue

        else

            load([MyDir 'Raw_outputs/sR0_GBR.7.0_herit0.3_SSP' All_SSPs{ssp} '_' All_GCMs{gcm} '.mat'],...
                'coral_cover_per_taxa','nb_coral_adult','nb_coral_adol','nb_coral_recruit','nb_coral_juv','coral_larval_supply',...
                'coral_HT_mean', 'coral_HT_var', ...
                'reef_shelter_volume_relative','META');

            run([MyDir 'Extract_coral_trajectories/EXTRACTION_SETTINGS.m'])

            all_models(ssp,gcm).C_tot = nan(size(coral_cover_tot,1),size(coral_cover_tot,3),'single');
            all_models_NORTH(ssp,gcm).C_tot = all_models(ssp,gcm).C_tot; % only dim 2 is different so that's fine
            all_models_CENTRE(ssp,gcm).C_tot = all_models(ssp,gcm).C_tot; % only dim 2 is different so that's fine
            all_models_SOUTH(ssp,gcm).C_tot = all_models(ssp,gcm).C_tot; % only dim 2 is different so that's fine
            all_models_MA1(ssp,gcm).C_tot = all_models(ssp,gcm).C_tot; % only dim 2 is different so that's fine
            all_models_MA2(ssp,gcm).C_tot = all_models(ssp,gcm).C_tot; % only dim 2 is different so that's fine
            all_models_MA3(ssp,gcm).C_tot = all_models(ssp,gcm).C_tot; % only dim 2 is different so that's fine
            all_models_MA4(ssp,gcm).C_tot = all_models(ssp,gcm).C_tot; % only dim 2 is different so that's fine

            all_models(ssp,gcm).C_taxa = nan(size(coral_cover_per_taxa,1),size(coral_cover_per_taxa,3),size(coral_cover_per_taxa,4),'single');
            all_models_NORTH(ssp,gcm).C_taxa =  all_models(ssp,gcm).C_taxa; % only dim 2 is different so that's fine
            all_models_CENTRE(ssp,gcm).C_taxa =  all_models(ssp,gcm).C_taxa; % only dim 2 is different so that's fine
            all_models_SOUTH(ssp,gcm).C_taxa =  all_models(ssp,gcm).C_taxa; % only dim 2 is different so that's fine

            all_models(ssp,gcm).C_taxa_HT_mean = nan(size(coral_HT_mean,1),size(coral_HT_mean,3),size(coral_HT_mean,4),'single');
            all_models_NORTH(ssp,gcm).C_taxa_HT_mean = all_models(ssp,gcm).C_taxa_HT_mean; % only dim 2 is different so that's fine
            all_models_CENTRE(ssp,gcm).C_taxa_HT_mean = all_models(ssp,gcm).C_taxa_HT_mean; % only dim 2 is different so that's fine
            all_models_SOUTH(ssp,gcm).C_taxa_HT_mean = all_models(ssp,gcm).C_taxa_HT_mean; % only dim 2 is different so that's fine

            all_models(ssp,gcm).C_taxa_HT_var = nan(size(coral_HT_var,1),size(coral_HT_var,3),size(coral_HT_var,4),'single');
            all_models_NORTH(ssp,gcm).C_taxa_HT_var = all_models(ssp,gcm).C_taxa_HT_var; % only dim 2 is different so that's fine
            all_models_CENTRE(ssp,gcm).C_taxa_HT_var = all_models(ssp,gcm).C_taxa_HT_var; % only dim 2 is different so that's fine
            all_models_SOUTH(ssp,gcm).C_taxa_HT_var = all_models(ssp,gcm).C_taxa_HT_var; % only dim 2 is different so that's fine

            all_models(ssp,gcm).nb_coral_adult = nan(size(coral_cover_tot,1),size(coral_cover_tot,3),'single'); % we'll sum across all species
            all_models(ssp,gcm).nb_coral_adol = nan(size(coral_cover_tot,1),size(coral_cover_tot,3),'single'); % we'll sum across all species
            all_models(ssp,gcm).nb_coral_juv = nan(size(coral_cover_tot,1),size(coral_cover_tot,3),'single'); % we'll sum across all species
            all_models(ssp,gcm).nb_coral_recruit = nan(size(coral_cover_tot,1),size(coral_cover_tot,3),'single'); % we'll sum across all species
            all_models(ssp,gcm).coral_larval_supply = nan(size(coral_cover_tot,1),size(coral_cover_tot,3),'single'); % we'll sum across all species
            all_models(ssp,gcm).shelter_volume = nan(size(coral_cover_tot,1),size(coral_cover_tot,3),'single');
            all_models(ssp,gcm).nb_healthy_reefs = nan(size(coral_cover_tot,1),size(coral_cover_tot,3),'single');
            all_models(ssp,gcm).nb_unhealthy_reefs = nan(size(coral_cover_tot,1),size(coral_cover_tot,3),'single');

            for i=1:size(coral_cover_tot,1)

                all_models(ssp,gcm).C_tot(i,:) = (area_w')*squeeze(coral_cover_tot(i,:,:))/sum(area_w);
                all_models_NORTH(ssp,gcm).C_tot(i,:) = (area_w(select.North)')*squeeze(coral_cover_tot(i,select.North,:))/sum(area_w(select.North));
                all_models_CENTRE(ssp,gcm).C_tot(i,:) = (area_w(select.Centre)')*squeeze(coral_cover_tot(i,select.Centre,:))/sum(area_w(select.Centre));
                all_models_SOUTH(ssp,gcm).C_tot(i,:) = (area_w(select.South)')*squeeze(coral_cover_tot(i,select.South,:))/sum(area_w(select.South));
                all_models_MA1(ssp,gcm).C_tot(i,:) = (area_w(select.GBR_MA1)')*squeeze(coral_cover_tot(i,select.GBR_MA1,:))/sum(area_w(select.GBR_MA1));
                all_models_MA2(ssp,gcm).C_tot(i,:) = (area_w(select.GBR_MA2)')*squeeze(coral_cover_tot(i,select.GBR_MA2,:))/sum(area_w(select.GBR_MA2));
                all_models_MA3(ssp,gcm).C_tot(i,:) = (area_w(select.GBR_MA3)')*squeeze(coral_cover_tot(i,select.GBR_MA3,:))/sum(area_w(select.GBR_MA3));
                all_models_MA4(ssp,gcm).C_tot(i,:) = (area_w(select.GBR_MA4)')*squeeze(coral_cover_tot(i,select.GBR_MA4,:))/sum(area_w(select.GBR_MA4));

                all_models(ssp,gcm).nb_coral_adult(i,:) = (area_w')*squeeze(sum(nb_coral_adult(i,:,:,:),4))/sum(area_w);
                all_models(ssp,gcm).nb_coral_adol(i,:) = (area_w')*squeeze(sum(nb_coral_adol(i,:,:,:),4))/sum(area_w);
                all_models(ssp,gcm).nb_coral_juv(i,:) = (area_w')*squeeze(sum(nb_coral_juv(i,:,:,:),4))/sum(area_w);
                all_models(ssp,gcm).nb_coral_recruit(i,:) = (area_w')*squeeze(sum(nb_coral_recruit(i,:,:,:),4))/sum(area_w);
                all_models(ssp,gcm).coral_larval_supply(i,:) = (area_w')*squeeze(sum(coral_larval_supply(i,:,:,:),4))/sum(area_w);
                all_models(ssp,gcm).shelter_volume(i,:) = (area_w')*squeeze(reef_shelter_volume_relative(i,:,:))/sum(area_w);

                X = squeeze(coral_cover_tot(i,:,:));
                Y = zeros(size(X));
                Z = zeros(size(X));
                
                Y(X>=20)=1; % record reefs with total coral cover above 20% (threshold of healthy/constructional state
                Z(X<5)=1; % record reefs with total coral cover above 20% (threshold of healthy/constructional state

                all_models(ssp,gcm).nb_healthy_reefs(i,:) = sum(Y,1);
                all_models(ssp,gcm).nb_unhealthy_reefs(i,:) = sum(Z,1);

                for sp = 1:size(coral_HT_mean,4) % for each coral group

                    all_models(ssp,gcm).C_taxa(i,:,sp) = (area_w')*squeeze(coral_cover_per_taxa(i,:,:,sp))/sum(area_w);
                    all_models_NORTH(ssp,gcm).C_taxa(i,:,sp) = (area_w(select.North)')*squeeze(coral_cover_per_taxa(i,select.North,:,sp))/sum(area_w(select.North));
                    all_models_CENTRE(ssp,gcm).C_taxa(i,:,sp) = (area_w(select.Centre)')*squeeze(coral_cover_per_taxa(i,select.Centre,:,sp))/sum(area_w(select.Centre));
                    all_models_SOUTH(ssp,gcm).C_taxa(i,:,sp) = (area_w(select.South)')*squeeze(coral_cover_per_taxa(i,select.South,:,sp))/sum(area_w(select.South));

                    for yr = 1:size(coral_HT_mean,3) % for each year

                        HT_mean_tmp = squeeze(coral_HT_mean(i,:,yr,sp));
                        %                         HT_mean_tmp(HT_mean_tmp==0)=nan; % replace the zeros by NaN as this is how it should have initialised in f_runmodel
                        HT_var_tmp = squeeze(coral_HT_var(i,:,yr,sp));
                        %                         HT_var_tmp(HT_var_tmp==0)=nan;

                        I = isnan(HT_mean_tmp);
                        J = isnan(HT_mean_tmp(select.North));
                        K = isnan(HT_mean_tmp(select.Centre));
                        L = isnan(HT_mean_tmp(select.South));

                        minN = 40; %minimum number of reefs with HT that is not NaN to calculate mean and var

                        if sum(I)<length(I)-minN % if at least 10 reefs have a non-NaN HT_mean
                            all_models(ssp,gcm).C_taxa_HT_mean(i,yr,sp) = sum(area_w(I==0)'.*HT_mean_tmp(I==0)/sum(area_w(I==0)));
                            all_models(ssp,gcm).C_taxa_HT_var(i,yr,sp) = sum(area_w(I==0)'.*HT_var_tmp(I==0));
                        end

                        if sum(J)<length(J)-minN % if at least 10 reefs have a non-NaN HT_mean
                            all_models_NORTH(ssp,gcm).C_taxa_HT_mean(i,yr,sp) = sum(area_w(select.North(J==0))'.*HT_mean_tmp(select.North(J==0)))/sum(area_w(select.North(J==0)));
                            all_models_NORTH(ssp,gcm).C_taxa_HT_var(i,yr,sp) = sum(area_w(select.North(J==0))'.*HT_var_tmp(select.North(J==0)))/sum(area_w(select.North(J==0)));
                        end

                        if sum(K)<length(K)-minN % if at least 10 reefs have a non-NaN HT_mean
                            all_models_CENTRE(ssp,gcm).C_taxa_HT_mean(i,yr,sp) = sum(area_w(select.Centre(K==0))'.*HT_mean_tmp(select.Centre(K==0)))/sum(area_w(select.Centre(K==0)));
                            all_models_CENTRE(ssp,gcm).C_taxa_HT_var(i,yr,sp) = sum(area_w(select.Centre(K==0))'.*HT_var_tmp(select.Centre(K==0)))/sum(area_w(select.Centre(K==0)));
                        end

                        if sum(L)<length(L)-minN % if at least 10 reefs have a non-NaN HT_mean
                            all_models_SOUTH(ssp,gcm).C_taxa_HT_mean(i,yr,sp) = sum(area_w(select.South(L==0))'.*HT_mean_tmp(select.South(L==0)))/sum(area_w(select.South(L==0)));
                            all_models_SOUTH(ssp,gcm).C_taxa_HT_var(i,yr,sp) = sum(area_w(select.South(L==0))'.*HT_var_tmp(select.South(L==0)))/sum(area_w(select.South(L==0)));
                        end
                    end
                end
            end
        end
    end
end

save(OutputfileName,'all_models','all_models_NORTH','all_models_CENTRE','all_models_SOUTH',...
    'all_models_MA1', 'all_models_MA2', 'all_models_MA3', 'all_models_MA4','select','YEARS')
