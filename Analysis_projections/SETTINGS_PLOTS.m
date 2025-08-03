%__________________________________________________________________________
%
% GENERAL SETTINGS FOR ALL PLOTS
% 
% Yves-Marie Bozec, y.bozec@uq.edu.au, 04/2023
%__________________________________________________________________________

%% Graphic parameters
myGraphicParms.FontSizeLabelTicks = 9;
myGraphicParms.FontSizeLabelAxes = 12;
myGraphicParms.FontSizeLabelTitles = 13;
myGraphicParms.DotSize = 1;
myGraphicParms.res = 600 ; %resolution
myGraphicParms.margins = 10 ;

% Test - accepted Fonts for NCC (need to double size of figure)
myGraphicParms.FontSizeLabelTicks = 5*2;
myGraphicParms.FontSizeLabelAxes = 6*2;
myGraphicParms.FontSizeLabelTitles = 7*2;
myGraphicParms.DotSize = 1;
myGraphicParms.res = 400 ; %resolution
myGraphicParms.margins = 10 ;

%% WARMING SCENARIOS
All_GCMs = ["CNRM-ESM2-1" ; "EC-Earth3-Veg" ; "IPSL-CM6A-LR" ; "MRI-ESM2-0" ; "UKESM1-0-LL" ; ...
    "GFDL-ESM4" ; "MIROC-ES2L" ; "MPI-ESM1-2-HR" ; "MIROC6" ; "NorESM2-LM" ];
All_SSPs = ["119" ; "126" ; "245" ; "370" ; "585" ];
All_SSP_names = ["SSP1-1.9" ; "SSP1-2.6" ; "SSP2-4.5" ; "SSP3-7.0" ; "SSP5-8.5" ];
% All_SSP_colours = ["ForestGreen"; "RoyalBlue" ; "Chocolate" ; "Crimson" ; "Maroon"]; % used at submission stages
All_SSP_colours = ["ForestGreen"; "RoyalBlue" ; "Goldenrod" ; "Crimson" ; "Maroon"]; % better contrasts for colour-blind

All_group_names = ["acro.stag";"acro.plate";"acro.corym";"pocillo";"small.mix";"large.mass"];
All_group_colours = ["OrangeRed";"DarkOrange";"Gold";"ForestGreen";"Magenta";"DodgerBlue"];
     