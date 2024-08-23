% Script that calls extractdata (each SSP type simulation with each GCM)
% and assembles master table of data
% currently goig to run for just one ssp at a time
%% SECTION 1 CREATE THE DATA FROM UNDERLYING SIMS AND GCMS 
% EARLY CENTURY 2025-2050
% use time steps 18, 43 for early century and 63, 88 for end century
% (2070-2095)

% ssp19_1 = extractdata("sR0_GBR.7.0_herit0.3_SSP119_CNRM-ESM2-1.mat",18,43,1,1);
% ssp19_2 = extractdata("sR0_GBR.7.0_herit0.3_SSP119_EC-Earth3-Veg.mat",18,43,1,2);
% ssp19_3 = extractdata("sR0_GBR.7.0_herit0.3_SSP119_IPSL-CM6A-LR.mat",18,43,1,3);
% ssp19_4 = extractdata("sR0_GBR.7.0_herit0.3_SSP119_MIROC6.mat",18,43,1,4);
% ssp19_5 = extractdata("sR0_GBR.7.0_herit0.3_SSP119_MIROC-ES2L.mat",18,43,1,5);
% ssp19_6 = extractdata("sR0_GBR.7.0_herit0.3_SSP119_MRI-ESM2-0.mat",18,43,1,6);
% ssp19_7 = extractdata("sR0_GBR.7.0_herit0.3_SSP119_UKESM1-0-LL.mat",18,43,1,7);

% ssp19_1 = extractdata("sR0_GBR.7.0_herit0.3_SSP119_CNRM-ESM2-1.mat",63,88,1,1);
% ssp19_2 = extractdata("sR0_GBR.7.0_herit0.3_SSP119_EC-Earth3-Veg.mat",63,88,1,2);
% ssp19_3 = extractdata("sR0_GBR.7.0_herit0.3_SSP119_IPSL-CM6A-LR.mat",63,88,1,3);
% ssp19_4 = extractdata("sR0_GBR.7.0_herit0.3_SSP119_MIROC6.mat",63,88,1,4);
% ssp19_5 = extractdata("sR0_GBR.7.0_herit0.3_SSP119_MIROC-ES2L.mat",63,88,1,5);
% ssp19_6 = extractdata("sR0_GBR.7.0_herit0.3_SSP119_MRI-ESM2-0.mat",63,88,1,6);
% ssp19_7 = extractdata("sR0_GBR.7.0_herit0.3_SSP119_UKESM1-0-LL.mat",63,88,1,7);

% ssp19_1 = extractdata2("sR0_GBR.7.0_herit0.3_SSP126_CNRM-ESM2-1.mat",18,43,1,1);
% ssp19_2 = extractdata2("sR0_GBR.7.0_herit0.3_SSP126_EC-Earth3-Veg.mat",18,43,1,2);
% ssp19_3 = extractdata2("sR0_GBR.7.0_herit0.3_SSP126_IPSL-CM6A-LR.mat",18,43,1,3);
% ssp19_4 = extractdata2("sR0_GBR.7.0_herit0.3_SSP126_MIROC6.mat",18,43,1,4);
% ssp19_5 = extractdata2("sR0_GBR.7.0_herit0.3_SSP126_MIROC-ES2L.mat",18,43,1,5);
% ssp19_6 = extractdata2("sR0_GBR.7.0_herit0.3_SSP126_MRI-ESM2-0.mat",18,43,1,6);
% ssp19_7 = extractdata2("sR0_GBR.7.0_herit0.3_SSP126_MPI-ESM1-2-HR.mat",18,43,1,6);
% ssp19_8 = extractdata2("sR0_GBR.7.0_herit0.3_SSP126_UKESM1-0-LL.mat",18,43,1,7);
% ssp19_9 = extractdata2("sR0_GBR.7.0_herit0.3_SSP126_GFDL-ESM4.mat",18,43,1,8);
% ssp19_10 = extractdata2("sR0_GBR.7.0_herit0.3_SSP126_NorESM2-LM.mat",18,43,1,9);

% ssp19_1 = extractdata2("sR0_GBR.7.0_herit0.3_SSP126_CNRM-ESM2-1.mat",68,93,1,1);
% ssp19_2 = extractdata2("sR0_GBR.7.0_herit0.3_SSP126_EC-Earth3-Veg.mat",68,93,1,2);
% ssp19_3 = extractdata2("sR0_GBR.7.0_herit0.3_SSP126_IPSL-CM6A-LR.mat",68,93,1,3);
% ssp19_4 = extractdata2("sR0_GBR.7.0_herit0.3_SSP126_MIROC6.mat",68,93,1,4);
% ssp19_5 = extractdata2("sR0_GBR.7.0_herit0.3_SSP126_MIROC-ES2L.mat",68,93,1,5);
% ssp19_6 = extractdata2("sR0_GBR.7.0_herit0.3_SSP126_MRI-ESM2-0.mat",68,93,1,6);
% ssp19_7 = extractdata2("sR0_GBR.7.0_herit0.3_SSP126_MPI-ESM1-2-HR.mat",68,93,1,6);
% ssp19_8 = extractdata2("sR0_GBR.7.0_herit0.3_SSP126_UKESM1-0-LL.mat",68,93,1,7);
% ssp19_9 = extractdata2("sR0_GBR.7.0_herit0.3_SSP126_GFDL-ESM4.mat",68,93,1,8);
% ssp19_10 = extractdata2("sR0_GBR.7.0_herit0.3_SSP126_NorESM2-LM.mat",68,93,1,9);


% ssp19_1 = extractdata("sR0_GBR.7.0_herit0.3_SSP126_IPSL-CM6A-LR.mat",63,88,1,3);
% ssp19_2 = extractdata("sR0_GBR.7.0_herit0.3_SSP126_MIROC6.mat",63,88,1,4);
% ssp19_3 = extractdata("sR0_GBR.7.0_herit0.3_SSP126_MIROC-ES2L.mat",63,88,1,5);
% ssp19_4 = extractdata("sR0_GBR.7.0_herit0.3_SSP126_MRI-ESM2-0.mat",63,88,1,6);
% ssp19_5 = extractdata("sR0_GBR.7.0_herit0.3_SSP126_MPI-ESM1-2-HR.mat",63,88,1,6);
% ssp19_6 = extractdata("sR0_GBR.7.0_herit0.3_SSP126_UKESM1-0-LL.mat",63,88,1,7);
% ssp19_7 = extractdata("sR0_GBR.7.0_herit0.3_SSP126_GFDL-ESM4.mat",63,88,1,8);
% ssp19_8 = extractdata("sR0_GBR.7.0_herit0.3_SSP126_NorESM2-LM.mat",63,88,1,9);


% ssp19_1 = extractdata2("sR0_GBR.7.0_herit0.3_SSP245_IPSL-CM6A-LR.mat",63,93,1,3);
% ssp19_2 = extractdata2("sR0_GBR.7.0_herit0.3_SSP245_MIROC6.mat",63,93,1,4);
% ssp19_3 = extractdata2("sR0_GBR.7.0_herit0.3_SSP245_MIROC-ES2L.mat",63,93,1,5);
% ssp19_4 = extractdata2("sR0_GBR.7.0_herit0.3_SSP245_MRI-ESM2-0.mat",63,93,1,6);
% ssp19_5 = extractdata2("sR0_GBR.7.0_herit0.3_SSP245_MPI-ESM1-2-HR.mat",63,93,1,6);
% ssp19_6 = extractdata2("sR0_GBR.7.0_herit0.3_SSP245_UKESM1-0-LL.mat",63,93,1,7);
% ssp19_7 = extractdata2("sR0_GBR.7.0_herit0.3_SSP245_GFDL-ESM4.mat",63,93,1,8);
% ssp19_8 = extractdata2("sR0_GBR.7.0_herit0.3_SSP245_NorESM2-LM.mat",63,93,1,9);
% ssp19_9 = extractdata2("sR0_GBR.7.0_herit0.3_SSP245_CNRM-ESM2-1.mat",63,93,1,1);
% ssp19_10 = extractdata2("sR0_GBR.7.0_herit0.3_SSP245_EC-Earth3-Veg.mat",63,93,1,2);
% 

% ssp19_1 = extractdata2("sR0_GBR.7.0_herit0.3_SSP245_IPSL-CM6A-LR.mat",18,43,1,3);
% ssp19_2 = extractdata2("sR0_GBR.7.0_herit0.3_SSP245_MIROC6.mat",18,43,1,4);
% ssp19_3 = extractdata2("sR0_GBR.7.0_herit0.3_SSP245_MIROC-ES2L.mat",18,43,1,5);
% ssp19_4 = extractdata2("sR0_GBR.7.0_herit0.3_SSP245_MRI-ESM2-0.mat",18,43,1,6);
% ssp19_5 = extractdata2("sR0_GBR.7.0_herit0.3_SSP245_MPI-ESM1-2-HR.mat",18,43,1,6);
% ssp19_6 = extractdata2("sR0_GBR.7.0_herit0.3_SSP245_UKESM1-0-LL.mat",18,43,1,7);
% ssp19_7 = extractdata2("sR0_GBR.7.0_herit0.3_SSP245_GFDL-ESM4.mat",18,43,1,8);
% ssp19_8 = extractdata2("sR0_GBR.7.0_herit0.3_SSP245_NorESM2-LM.mat",18,43,1,9);
% ssp19_9 = extractdata2("sR0_GBR.7.0_herit0.3_SSP245_CNRM-ESM2-1.mat",18,43,1,1);
% ssp19_10 = extractdata2("sR0_GBR.7.0_herit0.3_SSP245_EC-Earth3-Veg.mat",18,43,1,2);

ssp19_1 = extractdata2("sR0_GBR.7.0_herit0.3_SSP370_IPSL-CM6A-LR.mat",68,93,1,3);
ssp19_2 = extractdata2("sR0_GBR.7.0_herit0.3_SSP370_MIROC6.mat",68,93,1,4);
ssp19_3 = extractdata2("sR0_GBR.7.0_herit0.3_SSP370_MIROC-ES2L.mat",68,93,1,5);
ssp19_4 = extractdata2("sR0_GBR.7.0_herit0.3_SSP370_MRI-ESM2-0.mat",68,93,1,6);
ssp19_5 = extractdata2("sR0_GBR.7.0_herit0.3_SSP370_MPI-ESM1-2-HR.mat",68,93,1,6);
ssp19_6 = extractdata2("sR0_GBR.7.0_herit0.3_SSP370_UKESM1-0-LL.mat",68,93,1,7);
ssp19_7 = extractdata2("sR0_GBR.7.0_herit0.3_SSP370_GFDL-ESM4.mat",68,93,1,8);
ssp19_8 = extractdata2("sR0_GBR.7.0_herit0.3_SSP370_NorESM2-LM.mat",68,93,1,9);
ssp19_9 = extractdata2("sR0_GBR.7.0_herit0.3_SSP370_CNRM-ESM2-1.mat",68,93,1,1);
ssp19_10 = extractdata2("sR0_GBR.7.0_herit0.3_SSP370_EC-Earth3-Veg.mat",68,93,1,2);

% ssp19_1 = extractdata2("sR0_GBR.7.0_herit0.3_SSP370_IPSL-CM6A-LR.mat",18,43,1,3);
% ssp19_2 = extractdata2("sR0_GBR.7.0_herit0.3_SSP370_MIROC6.mat",18,43,1,4);
% ssp19_3 = extractdata2("sR0_GBR.7.0_herit0.3_SSP370_MIROC-ES2L.mat",18,43,1,5);
% ssp19_4 = extractdata2("sR0_GBR.7.0_herit0.3_SSP370_MRI-ESM2-0.mat",18,43,1,6);
% ssp19_5 = extractdata2("sR0_GBR.7.0_herit0.3_SSP370_MPI-ESM1-2-HR.mat",18,43,1,6);
% ssp19_6 = extractdata2("sR0_GBR.7.0_herit0.3_SSP370_UKESM1-0-LL.mat",18,43,1,7);
% ssp19_7 = extractdata2("sR0_GBR.7.0_herit0.3_SSP370_GFDL-ESM4.mat",18,43,1,8);
% ssp19_8 = extractdata2("sR0_GBR.7.0_herit0.3_SSP370_NorESM2-LM.mat",18,43,1,9);
% ssp19_9 = extractdata2("sR0_GBR.7.0_herit0.3_SSP370_CNRM-ESM2-1.mat",18,43,1,1);
% ssp19_10 = extractdata2("sR0_GBR.7.0_herit0.3_SSP370_EC-Earth3-Veg.mat",18,43,1,2);

% ssp19_1 = extractdata("sR0_GBR.7.0_herit0.3_SSP126_CNRM-ESM2-1.mat",18,43,1,1);
% ssp19_2 = extractdata("sR0_GBR.7.0_herit0.3_SSP126_EC-Earth3-Veg.mat",18,43,1,2);
% ssp19_3 = extractdata("sR0_GBR.7.0_herit0.3_SSP126_IPSL-CM6A-LR.mat",18,43,1,3);
% ssp19_4 = extractdata("sR0_GBR.7.0_herit0.3_SSP126_MIROC6.mat",18,43,1,4);
% ssp19_5 = extractdata("sR0_GBR.7.0_herit0.3_SSP126_MIROC-ES2L.mat",18,43,1,5);
% ssp19_6 = extractdata("sR0_GBR.7.0_herit0.3_SSP126_MRI-ESM2-0.mat",18,43,1,6);
% ssp19_7 = extractdata("sR0_GBR.7.0_herit0.3_SSP126_UKESM1-0-LL.mat",18,43,1,7);
% ssp19_8 = extractdata("sR0_GBR.7.0_herit0.3_SSP126_GFDL-ESM4.mat",18,43,1,8);
% ssp19_9 = extractdata("sR0_GBR.7.0_herit0.3_SSP126_IPSL-CM6A-LR.mat",18,43,1,9);
% ssp19_10 = extractdata("sR0_GBR.7.0_herit0.3_SSP126_NorESM2-LM.mat",18,43,1,9);

% ssp19_1 = extractdata("sR0_GBR.6.9_SSP119_CNRM-ESM2-1.mat",18,43,1,1);
% ssp19_2 = extractdata("sR0_GBR.6.9_SSP119_EC-Earth3-Veg.mat",18,43,1,2);
% ssp19_3 = extractdata("sR0_GBR.6.9_SSP119_IPSL-CM6A-LR.mat",18,43,1,3);
% ssp19_4 = extractdata("sR0_GBR.6.9_SSP119_MRI-ESM2-0.mat",18,43,1,4);
% ssp19_5 = extractdata("sR0_GBR.6.9_SSP119_UKESM1-0-LL.mat",18,43,1,5);
% ssp19_1 = extractdata("sR0_GBR.6.9_SSP126_CNRM-ESM2-1.mat",18,43,1,1);
% ssp19_2 = extractdata("sR0_GBR.6.9_SSP126_EC-Earth3-Veg.mat",18,43,1,2);
% ssp19_3 = extractdata("sR0_GBR.6.9_SSP126_IPSL-CM6A-LR.mat",18,43,1,3);
% ssp19_4 = extractdata("sR0_GBR.6.9_SSP126_MRI-ESM2-0.mat",18,43,1,4);
% ssp19_5 = extractdata("sR0_GBR.6.9_SSP126_UKESM1-0-LL.mat",18,43,1,5);
% ssp19_1 = extractdata("sR0_GBR.6.9_SSP245_CNRM-ESM2-1.mat",18,43,1,1);
% ssp19_2 = extractdata("sR0_GBR.6.9_SSP245_EC-Earth3-Veg.mat",18,43,1,2);
% ssp19_3 = extractdata("sR0_GBR.6.9_SSP245_IPSL-CM6A-LR.mat",18,43,1,3);
% ssp19_4 = extractdata("sR0_GBR.6.9_SSP245_MRI-ESM2-0.mat",18,43,1,4);
% ssp19_5 = extractdata("sR0_GBR.6.9_SSP245_UKESM1-0-LL.mat",18,43,1,5);
% ssp19_1 = extractdata("sR0_GBR.6.9_SSP370_CNRM-ESM2-1.mat",18,43,1,1);
% ssp19_2 = extractdata("sR0_GBR.6.9_SSP370_EC-Earth3-Veg.mat",18,43,1,2);
% ssp19_3 = extractdata("sR0_GBR.6.9_SSP370_IPSL-CM6A-LR.mat",18,43,1,3);
% ssp19_4 = extractdata("sR0_GBR.6.9_SSP370_MRI-ESM2-0.mat",18,43,1,4);
% ssp19_5 = extractdata("sR0_GBR.6.9_SSP370_UKESM1-0-LL.mat",18,43,1,5);
% ssp19_1 = extractdata("sR0_GBR.6.9_SSP585_CNRM-ESM2-1.mat",18,43,1,1);
% ssp19_2 = extractdata("sR0_GBR.6.9_SSP585_EC-Earth3-Veg.mat",18,43,1,2);
% ssp19_3 = extractdata("sR0_GBR.6.9_SSP585_IPSL-CM6A-LR.mat",18,43,1,3);
% ssp19_4 = extractdata("sR0_GBR.6.9_SSP585_MRI-ESM2-0.mat",18,43,1,4);
% ssp19_5 = extractdata("sR0_GBR.6.9_SSP585_UKESM1-0-LL.mat",18,43,1,5);




% LATE CENTURY
% ssp19_1 = extractdata("sR0_GBR.6.9_SSP119_CNRM-ESM2-1.mat",43,88,1,1);
% ssp19_2 = extractdata("sR0_GBR.6.9_SSP119_EC-Earth3-Veg.mat",43,88,1,2);
% ssp19_3 = extractdata("sR0_GBR.6.9_SSP119_IPSL-CM6A-LR.mat",43,88,1,3);
% ssp19_4 = extractdata("sR0_GBR.6.9_SSP119_MRI-ESM2-0.mat",43,88,1,4);
% ssp19_5 = extractdata("sR0_GBR.6.9_SSP119_UKESM1-0-LL.mat",43,88,1,5);
% ssp19_1 = extractdata("sR0_GBR.6.9_SSP126_CNRM-ESM2-1.mat",43,88,1,1);
% ssp19_2 = extractdata("sR0_GBR.6.9_SSP126_EC-Earth3-Veg.mat",43,88,1,2);
% ssp19_3 = extractdata("sR0_GBR.6.9_SSP126_IPSL-CM6A-LR.mat",43,88,1,3);
% ssp19_4 = extractdata("sR0_GBR.6.9_SSP126_MRI-ESM2-0.mat",43,88,1,4);
% ssp19_5 = extractdata("sR0_GBR.6.9_SSP126_UKESM1-0-LL.mat",43,88,1,5);
% ssp19_1 = extractdata("sR0_GBR.6.9_SSP245_CNRM-ESM2-1.mat",43,88,1,1);
% ssp19_2 = extractdata("sR0_GBR.6.9_SSP245_EC-Earth3-Veg.mat",43,88,1,2);
% ssp19_3 = extractdata("sR0_GBR.6.9_SSP245_IPSL-CM6A-LR.mat",43,88,1,3);
% ssp19_4 = extractdata("sR0_GBR.6.9_SSP245_MRI-ESM2-0.mat",43,88,1,4);
% ssp19_5 = extractdata("sR0_GBR.6.9_SSP245_UKESM1-0-LL.mat",43,88,1,5);
% ssp19_1 = extractdata("sR0_GBR.6.9_SSP370_CNRM-ESM2-1.mat",43,88,1,1);
% ssp19_2 = extractdata("sR0_GBR.6.9_SSP370_EC-Earth3-Veg.mat",43,88,1,2);
% ssp19_3 = extractdata("sR0_GBR.6.9_SSP370_IPSL-CM6A-LR.mat",43,88,1,3);
% ssp19_4 = extractdata("sR0_GBR.6.9_SSP370_MRI-ESM2-0.mat",43,88,1,4);
% ssp19_5 = extractdata("sR0_GBR.6.9_SSP370_UKESM1-0-LL.mat",43,88,1,5);
% ssp19_1 = extractdata("sR0_GBR.6.9_SSP585_CNRM-ESM2-1.mat",43,88,1,1);
% ssp19_2 = extractdata("sR0_GBR.6.9_SSP585_EC-Earth3-Veg.mat",43,88,1,2);
% ssp19_3 = extractdata("sR0_GBR.6.9_SSP585_IPSL-CM6A-LR.mat",43,88,1,3);
% ssp19_4 = extractdata("sR0_GBR.6.9_SSP585_MRI-ESM2-0.mat",43,88,1,4);
% ssp19_5 = extractdata("sR0_GBR.6.9_SSP585_UKESM1-0-LL.mat",43,88,1,5);
ssp19=[ssp19_1;ssp19_2;ssp19_3;ssp19_4;ssp19_5;ssp19_6;ssp19_7;ssp19_8;ssp19_9;ssp19_10];
ssp19(:,61:62)=zeros(length(ssp19),2);
 [rows,cols]=size(ssp19);
tablesize=[rows,cols];
varnames={'reefnum','sector','startyr','censusyr','ssp','gcm','sim',...
    'logcover','normnumcyclones','logcyclonestrength','sqrttimesincecyclone','lognumbleaching',...
    'logmeandhw','sqrttimesincebleaching','sqrttotalcots','sqrtmeancots','lognumcotscontrol',...
    'logtimesincecotscontrol','loglarvaelongterm','loglarvae5yrs','normrubble','sqrtwqrep',...
    'sqrtwqrecruit','sqrtwqjuv','zcover','znumcyclones','zcyclonestrength','ztimesincecyclone',...
    'znumbleaching','zmeandhw','ztimesincebleaching','ztotalcots','zmeancots',...
    'znumcotscontrol','ztimesincecotscontrol','zlarvaelongterm','zlarvae5yrs',...
    'zrubble','zwqrep','zwqrecruit','zwqjuv','cover','numcyclones','cyclonestrength',...
    'timesincecyclone','numbleaching','meandhw','timesincebleaching',...
    'totalcots','meancots','numcotscontrol','timesincecotscontrol',...
    'larvaelongterm','larvae5yrs','rubble','wqrep','wqrecruit','wqjuv','meanHT','zmeanHT',...
    'sinkreefs','zsinkreefs'};
vartypes={'double','double','double','double','double','double','double',...
    'double','double','double','double','double','double','double','double',...
    'double','double','double','double','double','double','double','double',...
    'double','double','double','double','double','double','double','double',...
    'double','double','double','double','double','double','double','double',...
    'double','double','double','double','double','double','double','double',...
    'double','double','double','double','double','double','double','double',...
    'double','double','double','double','double','double','double'};
%SSP45results_sim=table('Size',tablesize,'VariableTypes',vartypes,'VariableNames',varnames); % the sim means this will not be normalized globally but by simulation
SSP19results=table('Size',tablesize,'VariableTypes',vartypes,'VariableNames',varnames);

% the extractdata code does within-simulation transformation and z-score
% positioning. This does emphasize the conditions that led to better reef
% outcomes within individual reef futures but presents challenges for
% working with it when analysing all the data combined as the meands and
% sds of individual simulations will differ. So instead there is an option
% here to both (1) ignore the pre-transformation step seeing that you can
% apply zscoring to any distribution (just can't assume percentiles) and
% (2) to z-score all collected raw data relative to the full dataset.

PERCENTRANK = @(YourArray, TheProbes) reshape( mean( bsxfun(@le, YourArray(:), TheProbes(:).') ) * 100, size(TheProbes) ); %This program determines the percentile of data popint X in vector Y
ssp19table=array2table(ssp19); % converts to a table
SSP19results(:,:)=ssp19table(:,:); %updatess table with the headings 
 
use_post_processing_zscore=1

if use_post_processing_zscore==1
SSP19results(:,25:41)=normalize(SSP19results(:,42:58));%untransformed data
SSP19results(:,60)=normalize(SSP19results(:,59));%untransformed data
else
SSP19results(:,25:41)=normalize(SSP19results(:,8:24));% transformed data
end

 %also create a data input on sinkvalue of reefs that can be appended.
 sinkvalue2=full(sinkvalue); % makes it non sparse matrix
 sinkreefsR=zeros(length(ssp19),1);
for i=1:200
    x=(3806*i)-3805;
    sinkreefsR(x:x+3805,1)=sinkvalue2(:,1);
end

SSP19results(:,61)=array2table(sinkreefsR(:,1));
SSP19results(:,62)=normalize(SSP19results(:,61));
%writematrix(sinkreefsR)

% ADDED CODE TO REMOVE CASES WHERE LOGLARVAE5YRS IS NAN
SSP19results=SSP19results(isnan(SSP19results.loglarvae5yrs)==0,:);
% alternate code to set nans to zero
% for i=1:rows
%     if isnan(SSP19results.loglarvae5yrs(i))==1
%         SSP19results.loglarvae5yrs(i)=0;
%     end
% end
 writetable(SSP19results)



%% SECTION 2 IF YOU WANT TO WORK WITH THE R OUTPUTS AND TRANSLATE TO MEANINGFUL COEFFICIENTS
% Now we take the output from R and import to a table in matlab
%m1estimates=readtable('m1estimates.csv');
%m1predictors=readtable('m1predictors.csv','range','B2:B15','TextType','string');
% note actually easier to import text stuff manually and specify string and
% b2 as the first cell so that way it removes the annoying commas around the text
% in lastest I just bring these both in manually and relabel m1predictors
%m1predictors(1,:)=[]; % need to do this to the output if manually importing
 %m1estimates=table2array(m1estimates);
 %m1estimates(1,:)=[];
%need to go through and extract estimates, divide by SD, and express in terms of what they mean
%m1predictors(15:16)=[]; % only needed when applying the lmer model from R because the last two are random effects and residual
%m1estimates(15:16,:)=[];
[numpreds,col]=size(m1estimates);
results=zeros(numpreds, 15); % output results where col 1 is estimate, col 2
% is impact of 1 SD or predictor on actual coral, 3 is the std of the predictor
% pre-zscoring, 4 is the mean of the pretransformed predictor, 5 is the percentile of the mean
% in the original predictor data, 6 is the percentile for mean+1sd of predictor, 7 
% is the size, in percentiles, of the SD, 8 is the effects of the predictor on coral zscores per 
% unit of predictor; 9 is the 1-increment increase in predictor expressed in coral
% 10 is sign

meancoralcover=mean(SSP19results.cover);
stdcover=std(SSP19results.cover);

for i=1:numpreds
    % first check if the coefficient is negative or not
    if isreal(sqrt(m1estimates(i,1)))==0
        neg=1;
    else
        neg=0;
    end
    name=m1predictors(i,1);
    name2=erase(name,'z'); % name of predictor that we want to estimate std of
    results(i,1)=abs(m1estimates(i,1)); % abs value of coefficient
    results(i,2)=results(i,1).*stdcover; % 1SD of predictor impact on coral because response is z scores of coral
    results(i,3)=std(SSP19results.(name2),'omitnan'); %std of predictor
    results(i,4)=mean(SSP19results.(name2),'omitnan'); % mean of predictor
    d=SSP19results.(name2); % subsets out predictor
    results(i,5)=PERCENTRANK(d,results(i,4)); % mean as percentile of all values of predictor
    results(i,6)=PERCENTRANK(d,results(i,3)+results(i,4)); % Upper SD as a percentile of all values of predictor
    results(i,7)=results(i,6)-results(i,5);    % range of the predictor values (as a percentile of all) that constitute the sd
    results(i,8)=results(i,1)./results(i,3);% value of coefficient on normal scale (not zscores) - i.e., per unit increment not per sd
    results(i,9)=results(i,8).*stdcover; %gives change in coral cover from mean as a function of unit increase in predictor (again multiplied by sdcoral bedcause response was zscores)
    results(i,10)=neg; % note that 1 is negative effect, 0 is positive
    results(i,11)=range(SSP19results.(name2),'omitnan'); % range of predictor
    if name2=='wqrep' || name2=='wqrecruit'
        results(i,12)=results(i,9)./100; % adjusted coral response per unit predictor
    elseif name2=='sinkreefs' || name2=='meancots'
        results(i,12)=results(i,9).*(results(i,11)./100); % 1% of range
    else
        results(i,12)=results(i,9);
    end
    results(i,13)=1./results(i,11).*100;%Percentage of predictor's range represented by an increment of 1 unit 
    if name2=='wqrep' || name2=='wqrecruit'
        results(i,14)=0.01./results(i,11).*100; % Percentage of predictor's range represented 
    elseif name2=='sinkreefs' || name2=='meancots'
        results(i,14)=1;
    else
        results(i,14)=results(i,13);
    end
    results(i,15)=results(i,12).*(1./results(i,14));% effect of 1% of predictors range on coral cover
end

statstablesize=[numpreds,16];
statsvarnames={'predictor','abs_estimate_zscores','SD_predict_on_coral','std_pre_zscore','mean_pre_zscore',...
    'pctile_mean','prctile_meanplussd','prctile_sd','abs_estimate_unit','coral_response_per_unit','direction',...
    'range','adj_crl_rsp','pct_pred_rep_1_unit','pct_pred_range','effect_1pc_pred_range_on_coral'};
statsvartypes={'string','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double'};
statresultsSSP19=table('Size',statstablesize,'VariableTypes',statsvartypes,'VariableNames',statsvarnames);
resultstable=array2table(results); % converts to a table
statresultsSSP19(:,2:16)=resultstable(:,:);
statresultsSSP19.predictor=m1predictors(:,:);

 PERCENTRANK = @(YourArray, TheProbes) reshape( mean( bsxfun(@le, YourArray(:), TheProbes(:).') ) * 100, size(TheProbes) )

 %% ALTERNATIVE SECTION 2 IF USING M2 WHICH INCLUDES THE NON-ZSCORE JUST LOG0.1 TRANSFORMED LARVAE5YRS

 % Now we take the output from R and import to a table in matlab
%m1estimates=readtable('m1estimates.csv');
%m1predictors=readtable('m1predictors.csv','range','B2:B15','TextType','string');
% note actually easier to import text stuff manually and specify string and
% b2 as the first cell so that way it removes the annoying commas around the text
% in lastest I just bring these both in manually and relabel m1predictors
%m1predictors(1,:)=[]; % need to do this to the output if manually importing
 %m1estimates=table2array(m1estimates);
 %m1estimates(1,:)=[];
%need to go through and extract estimates, divide by SD, and express in terms of what they mean
%m1predictors(15:16)=[]; % only needed when applying the lmer model from R because the last two are random effects and residual
%m1estimates(15:16,:)=[];
[numpreds,col]=size(m2estimates);
results=zeros(numpreds, 15); % output results where col 1 is estimate, col 2
% is impact of 1 SD or predictor on actual coral, 3 is the std of the predictor
% pre-zscoring, 4 is the mean of the pretransformed predictor, 5 is the percentile of the mean
% in the original predictor data, 6 is the percentile for mean+1sd of predictor, 7 
% is the size, in percentiles, of the SD, 8 is the effects of the predictor on coral zscores per 
% unit of predictor; 9 is the 1-increment increase in predictor expressed in coral
% 10 is sign

meancoralcover=mean(SSP19results.cover);
stdcover=std(SSP19results.cover);

for i=1:numpreds
    % first check if the coefficient is negative or not
    if isreal(sqrt(m2estimates(i,1)))==0
        neg=1;
    else
        neg=0;
    end
    name=m2predictors(i,1);
    name2=erase(name,'z'); % name of predictor that we want to estimate std of
    results(i,1)=abs(m2estimates(i,1)); % abs value of coefficient
    results(i,2)=results(i,1).*stdcover; % 1SD of predictor impact on coral because response is z scores of coral
    results(i,3)=std(SSP19results.(name2),'omitnan'); %std of predictor
    results(i,4)=mean(SSP19results.(name2),'omitnan'); % mean of predictor
    d=SSP19results.(name2); % subsets out predictor
    results(i,5)=PERCENTRANK(d,results(i,4)); % mean as percentile of all values of predictor
    results(i,6)=PERCENTRANK(d,results(i,3)+results(i,4)); % Upper SD as a percentile of all values of predictor
    results(i,7)=results(i,6)-results(i,5);    % range of the predictor values (as a percentile of all) that constitute the sd
    results(i,8)=results(i,1)./results(i,3);% value of coefficient on normal scale (not zscores) - i.e., per unit increment not per sd
    if name2=='loglarvae5yrs'
        results(i,8)=results(i,1);%exp(results(i,1))-0.1;
    end
    
    results(i,9)=results(i,8).*stdcover; %gives change in coral cover from mean as a function of unit increase in predictor (again multiplied by sdcoral bedcause response was zscores)
    results(i,10)=neg; % note that 1 is negative effect, 0 is positive
    results(i,11)=range(SSP19results.(name2),'omitnan'); % range of predictor
    if name2=='wqrep' || name2=='wqrecruit'
        results(i,12)=results(i,9)./100; % adjusted coral response per unit predictor
    elseif name2=='sinkreefs' || name2=='meancots'
        results(i,12)=results(i,9).*(results(i,11)./100); % 1% of range
    else
        results(i,12)=results(i,9);
    end
    results(i,13)=1./results(i,11).*100;%Percentage of predictor's range represented by an increment of 1 unit 
    if name2=='wqrep' || name2=='wqrecruit'
        results(i,14)=0.01./results(i,11).*100; % Percentage of predictor's range represented 
    elseif name2=='sinkreefs' || name2=='meancots'
        results(i,14)=1;
    else
        results(i,14)=results(i,13);
    end
    results(i,15)=results(i,12).*(1./results(i,14));% effect of 1% of predictors range on coral cover
end

statstablesize=[numpreds,16];
statsvarnames={'predictor','abs_estimate_zscores','SD_predict_on_coral','std_pre_zscore','mean_pre_zscore',...
    'pctile_mean','prctile_meanplussd','prctile_sd','abs_estimate_unit','coral_response_per_unit','direction',...
    'range','adj_crl_rsp','pct_pred_rep_1_unit','pct_pred_range','effect_1pc_pred_range_on_coral'};
statsvartypes={'string','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double'};
statresultsSSP19=table('Size',statstablesize,'VariableTypes',statsvartypes,'VariableNames',statsvarnames);
resultstable=array2table(results); % converts to a table
statresultsSSP19(:,2:16)=resultstable(:,:);
statresultsSSP19.predictor=m2predictors(:,:);

 PERCENTRANK = @(YourArray, TheProbes) reshape( mean( bsxfun(@le, YourArray(:), TheProbes(:).') ) * 100, size(TheProbes) )

