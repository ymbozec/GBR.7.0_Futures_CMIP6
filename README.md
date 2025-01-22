# GBR_futures
This repository contains the scripts and data used in the analyses of possible coral futures for Australia's Great Barrier Reef under CMIP-6 scenarios of greenhouse gas emissions.

Model projections were obtained using version 7.0 of the eco-evolutionary model ReefMod-GBR, available here:
https://github.com/ymbozec/REEFMOD.7.0_GBR

The repository is organised as follow:

**/Parameterisation**

Contains scripts and data to parameterise the bleaching model at depth and extract the relative likelihoods of equilibrium climate sensitivity of the ten CMIP6 climate models following Sherwood et al. (2000).

**/ReefMod_input_data**

Contains the input data of ReefMod-GBR (v7.0) required to run the analyses of model outputs.

**/ReefMod_output_data**

Contains the outputs of the eco-evolutionary simulations, stored in two Matlab files:

* HINDCAST_METRICS_2008-2023.mat, which includes:
  
   + Coral_tot.VAR which are individual reef predictions for each year of the hindcast (3806 reefs, 17 years) averaged across 20 runs
      - M: mean total coral cover (%)
      - M_nb_coral_recruit: mean total number of recruits over 400m2 area
      - M_nb_coral_juv: mean total number of juveniles over 400m2 area
      - M_nb_coral_adol: mean total number of subadults over 400m2 area 
      - M_nb_coral_adult: mean total number of adults over 400m2 area
      - M_nb_coral_offspring: mean total number of offspring produced over 400m2 area
      - M_coral_larval_supply: mean total number of incoming larvae over 400m2 area
      - M_HT: mean heat tolerance
   + Coral_sp(sp).VAR same but this time by species sp
   + area_w: weights for coral reef area (as proportion of total area of the GBR)
   + select: select ID of reefs given their regional location, shelf position

* GBR.7.0_averages_DHW8.mat, which includes multiple coral variables averaged across the GBR.
They can be accessed from **all_models(ssp,gcm).var**, where ssp denote the emission scenario:
1: SSP1-1.9, 2: SSP1-2.6, 3: SSP2-4.5, 4:SSP3-7.0, 5:SSP5-8.5
and gcm the ID of the CMIP6 climate model:
"CNRM-ESM2-1" ; "EC-Earth3-Veg" ; "IPSL-CM6A-LR" ; "MRI-ESM2-0" ; "UKESM1-0-LL" ; 
    "GFDL-ESM4" ; "MIROC-ES2L" ; "MPI-ESM1-2-HR" ; "MIROC6" ; "NorESM2-LM" 
Coral variables include:
   + C_tot: percent total coral cover (20 runs, 94 years)
   + C_taxa: cover of each coral group (20 runs, 94 years, 6 groups)
   + C_taxa_HT_mean: mean heat tolerance (°C-week) of each coral group (20 runs, 94 years, 6 groups)
   + C_taxa_HT_var: variance of heat tolerance per coral group (20 runs, 94 years, 6 groups)
   + nb_coral_adult: total number of coral adults (20 runs, 94 years) over 400m2 area
   + nb_coral_adol: total number of coral subadults (20 runs, 94 years) over 400m2 area
   + nb_coral_juv: total number of coral juveniles (20 runs, 94 years) over 400m2 area
   + nb_coral_recruit: total number of coral juveniles (20 runs, 94 years) over 400m2 area
   + coral_larval_supply: total number of incoming coral larvae (20 runs, 94 years) over 400m2 area 
   + shelter_volume: relative index of structural complexity between 0-1 (20 runs, 94 years)
   + nb_healthy_reefs: number of reefs above 20% total cover (20 runs, 94 years) out of 3,806
   + nb_unhealthy_reefs: number of reefs below 5% total cover (20 runs, 94 years) out of 3,806
 
* GBR.7.0_likely_runs_NEW2.mat, which includes the ID of model runs sampled by bootstrap (1,000 samples for each year for the 5 SSPs) for the construction of likely distributions of the coral variables

**/Analysis_hindcast**
Contains scripts for the hindcast reconstruction (2008-2023)

**/Analysis_projections**
Contains scripts for the analysis of foreward projections (2024-2100)

**/Analysis_drivers**
Contains the scripts for running the statistical models of drivers

**/Validation**
Contains the scripts for the validation of the hindcast coral cover reconstruction and the predictions of past bleaching
