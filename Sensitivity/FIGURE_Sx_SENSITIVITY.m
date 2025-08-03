%__________________________________________________________________________
%
% RESULTS OF SENSITIVITY ANALYSIS
% 
% Yves-Marie Bozec, y.bozec@uq.edu.au, 11/2024
%__________________________________________________________________________
clear

SETTINGS_PLOTS
SaveDir = ''

gcm = 9;
run_id = 1;

CC(3).base = [];
CC(3).low = [];
CC(3).high = [];

FolderName = '/home/ym/Dropbox/REEFMOD/REEFMOD_GBR_OUTPUTS/GBR.7.0_CMIP6_2024_04/Raw_outputs/Sensititivty_analysis/';

for ssp = 2:4

    load(['sR0_GBR.7.0_herit0.3_SSP' All_SSPs{ssp} '_' All_GCMs{gcm} '.mat'],'coral_cover_per_taxa','YEARS')
    CC(ssp).base = squeeze(mean(sum(coral_cover_per_taxa(run_id,:,:,:),4),2))'; % baseline
    clear coral_cover_per_taxa

    for parm = 1:14

        load([FolderName 'R0_sensitivity_GBR.7.0_herit0.3_SSP' All_SSPs{ssp} '_' All_GCMs{gcm} '_parm' num2str(parm) '.mat'],'RESULT')
        CC(ssp).low = [CC(ssp).low ; squeeze(mean(sum(RESULT.coral_pct2D,3),1))]; % -20% variation in each parameter (14 parms -> 14 rows)
        clear RESULT

        load([FolderName 'R0_sensitivity_GBR.7.0_herit0.3_SSP' All_SSPs{ssp} '_' All_GCMs{gcm} '_parm' num2str(parm+14) '.mat'],'RESULT')
        CC(ssp).high = [CC(ssp).high ; squeeze(mean(sum(RESULT.coral_pct2D,3),1))]; % +20% variation in each parameter (14 parms -> 14 rows)
        clear RESULT
    end
end

% PARAMETERS LISTED IN THIS ORDER:
% 1- CORAL.bleaching_depth = OPTIONS.SENS_PARMS(1)*CORAL.bleaching_depth;
% 2- CORAL.sensitivity_bleaching = OPTIONS.SENS_PARMS(2)*CORAL.sensitivity_bleaching;
% 3- CORAL.VAR_HT = OPTIONS.SENS_PARMS(3)*CORAL.VAR_HT;
% 4- CORAL.MAX_HT = OPTIONS.SENS_PARMS(4)*CORAL.MAX_HT;
% 5- CORAL.heritability_HT = OPTIONS.SENS_PARMS(5)*CORAL.heritability_HT;
% 6- CORAL.growth_rate = OPTIONS.SENS_PARMS(6)*CORAL.growth_rate;
% 7- CORAL.fecund_min_size = OPTIONS.SENS_PARMS(7)*CORAL.fecund_min_size;
% 8- CORAL.fecund_b = OPTIONS.SENS_PARMS(8)*CORAL.fecund_b;
% 9- META.coral_min_selfseed = OPTIONS.SENS_PARMS(9)*META.coral_min_selfseed;
% 10- CORAL.BH_alpha = OPTIONS.SENS_PARMS(10)*CORAL.BH_alpha;
% 11- CORAL.BH_beta = OPTIONS.SENS_PARMS(11)*CORAL.BH_beta;
% 12- CORAL.sensitivity_hurricane = OPTIONS.SENS_PARMS(12)*CORAL.sensitivity_hurricane;
% 13- META.COTS_feeding_rates = OPTIONS.SENS_PARMS(13)*META.COTS_feeding_rates;
% 14- META.COTS_BH_alpha = OPTIONS.SENS_PARMS(14)*META.COTS_BH_alpha;

% All_parms = {'w';'s';'σ';'HT.max';'h2';'growth';'fecund.min';'fecundity';...
%     'self.seed';'α.coral';'β.coral';'cycl.adj';'pred.adj';'α.CoTS'};

% Now using more explicit terminology
All_parms = {'bleaching.depth';'s';'HT.sd';'HT.max';'heritability';'growth';'gravid.min';'fecundity';...
    'self.seeding';'α.coral';'β.coral';'cyclone.coeff';'CoTS.coeff';'α.CoTS'};

hgap = -0.043;
vgap = 0.02;
MyLimits1 = [2008 2100  0  52];

Color1 = 0.3*[1 1 1]; % Dark grey for legend
bkg_color1 = [0.8  0.96 0.96];

MyYlabel1 = 'Mean coral cover (%)';

MyLineWidth = 0.75;
LabelFontSize = 12;

pos_x = 0.5;
pos_y =0.9;

MyTokenSize = 1.5*[6 6];

% Select whether we plot relative or absolute difference with the baseline
% sensitivity = 'absolute';
sensitivity = 'relative';

%------------------------------ PLOT FIGURE ----------------------------------
MYFIG = figure;
width=18*2; height=21*2; %19.6*2;
set(MYFIG,'color','w','units','centimeters','position',[0,0,width,height])
set(MYFIG, 'Resize', 'off')

ID_plot = [1:3:18];
count = 0;

for ssp = 2:4
    % ----------------------------------------------------------------
    % Base plot (mean GBR cover over time for that run of that GCM
    % ----------------------------------------------------------------
    subplot(length(ID_plot),3,ID_plot(1)+count);
    Baseline = CC(ssp).base(2:end);
    if isequal(sensitivity, 'absolute')==1
        B = 1;
        MyLimits2 = [2008 2100  -8.2  8.2];
        IMAGENAME = [SaveDir 'FIG_Sx_SENSITIVITY_ABS'];
        select_t = []; % empty -> all time steps will be plotted
        MyYlabel2 = 'Δ coral cover (%)';
    else
        B = Baseline;
        MyLimits2 = [2008 2100  -0.8  0.8];
        IMAGENAME = [SaveDir 'FIG_Sx_SENSITIVITY_REL'];
        select_t = find(Baseline<1); % time steps where GBR mean coral cover is lower than 1%
        MyYlabel2 = 'Relative change';
    end

    LOWS = CC(ssp).low(:,2:end);
    LOWS(:,select_t) = nan(size(LOWS,1), length(select_t));

    HIGHS = CC(ssp).high(:,2:end);
    HIGHS(:,select_t) = nan(size(LOWS,1), length(select_t));

    plot(YEARS,Baseline,'-k','LineWidth',1.5)
    axis(MyLimits1)
    P = gca;
    set(P, 'color',bkg_color1,'Layer', 'top', 'FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
    P.Position(1) = P.Position(1) + count*hgap;

    if ssp == 2
        ylabel(MyYlabel1,'FontName', 'Arial', 'FontWeight','normal','FontSize',myGraphicParms.FontSizeLabelAxes) ;
        P.YLabel.Position(1) = 1998;
    end

    t1 = text(pos_x, pos_y, All_SSP_names(ssp),'Units','normalized','FontName', 'Arial','HorizontalAlignment','center',...
        'FontWeight','bold','FontSize',12,'Color',rgb(All_SSP_colours(ssp)));
    t2 = text(pos_x, pos_y-0.2, [All_GCMs{gcm} ' (run #1)'],'Units','normalized','FontName', 'Arial','HorizontalAlignment','center',...
        'FontWeight','normal','FontSize',10,'Color','k');

    % ----------------------------------------------------------------
    % Differences between scenario parameter and baseline
    % ----------------------------------------------------------------
    subplot(length(ID_plot),3,ID_plot(2)+count); axis(MyLimits2) ; hold on
    P = gca;
    set(P, 'Box','on', 'Layer', 'top', 'FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
    P.Position(1) = P.Position(1) + count*hgap;
    P.Position(2) = P.Position(2) + vgap;
    plot([YEARS(1) YEARS(end)], 0*[YEARS(1) YEARS(end)],'-k')

    parm = 1; % 1- CORAL.bleaching_depth
    plot(YEARS,(LOWS(parm,:) - Baseline)./B,'-','LineWidth',MyLineWidth, 'Color',rgb('RoyalBlue'))
    plot(YEARS,(HIGHS(parm,:) - Baseline)./B,'-','LineWidth',MyLineWidth, 'Color',rgb('Crimson'))

    % parm = 2; % 2- CORAL.sensitivity_bleaching (can be ignored because same effect as CORAL.bleaching_depth
    parm = 3; % 3- CORAL.VAR_HT
    plot(YEARS,(LOWS(parm,:) - Baseline)./B,'--','LineWidth',MyLineWidth, 'Color',rgb('RoyalBlue'))
    plot(YEARS,(HIGHS(parm,:) - Baseline)./B,'--','LineWidth',MyLineWidth, 'Color',rgb('Crimson'))

    if ssp == 2
        ylabel(MyYlabel2,'FontName', 'Arial', 'FontWeight','normal','FontSize',myGraphicParms.FontSizeLabelAxes) ;
        P.YLabel.Position(1) = 1998;
    end

    % Legend
    plot(nan,nan,'-','Color',Color1,'LineWidth',MyLineWidth);
    plot(nan,nan,'--','Color',Color1,'LineWidth',MyLineWidth);

    h = get(gca,'Children');
    X = legend([h(2) h(1)], All_parms{[1 3]});
    X.FontSize = LabelFontSize-2;
    X.ItemTokenSize = MyTokenSize;
    X.Location = 'northwest';
    X.Orientation = 'horizontal';
    X.Box = 'off';

    % ---------------------------
    subplot(length(ID_plot),3,ID_plot(3)+count); axis(MyLimits2) ; hold on
    P = gca;
    set(P, 'Box','on', 'Layer', 'top', 'FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
    P.Position(1) = P.Position(1) + count*hgap;
    P.Position(2) = P.Position(2) + 2*vgap;
    plot([YEARS(1) YEARS(end)], 0*[YEARS(1) YEARS(end)],'-k')

    parm = 4; % 4- CORAL.MAX_HT
    plot(YEARS,(LOWS(parm,:) - Baseline)./B,'-','LineWidth',MyLineWidth, 'Color',rgb('RoyalBlue'))
    plot(YEARS,(HIGHS(parm,:) - Baseline)./B,'-','LineWidth',MyLineWidth, 'Color',rgb('Crimson'))

    parm = 5; % 5- CORAL.heritability_HT
    plot(YEARS,(LOWS(parm,:) - Baseline)./B,'--','LineWidth',MyLineWidth, 'Color',rgb('RoyalBlue'))
    plot(YEARS,(HIGHS(parm,:) - Baseline)./B,'--','LineWidth',MyLineWidth, 'Color',rgb('Crimson'))

    if ssp == 2
        ylabel(MyYlabel2,'FontName', 'Arial', 'FontWeight','normal','FontSize',myGraphicParms.FontSizeLabelAxes) ;
        P.YLabel.Position(1) = 1998;
    end

    % Legend
    plot(nan,nan,'-','Color',Color1,'LineWidth',MyLineWidth);
    plot(nan,nan,'--','Color',Color1,'LineWidth',MyLineWidth);

    h = get(gca,'Children');
    X = legend([h(2) h(1)], All_parms{4:5});
    X.FontSize = LabelFontSize-2;
    X.ItemTokenSize = MyTokenSize;
    X.Location = 'northwest';
    X.Orientation = 'horizontal';
    X.Box = 'off';

    % ---------------------------
    subplot(length(ID_plot),3,ID_plot(4)+count); axis(MyLimits2) ; hold on
    P = gca;
    set(P, 'Box','on', 'Layer', 'top', 'FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
    P.Position(1) = P.Position(1) + count*hgap;
    P.Position(2) = P.Position(2) + 3*vgap;
    plot([YEARS(1) YEARS(end)], 0*[YEARS(1) YEARS(end)],'-k')

    parm = 6; % 6- CORAL.growth_rate
    plot(YEARS,(LOWS(parm,:) - Baseline)./B,'-','LineWidth',MyLineWidth, 'Color',rgb('RoyalBlue'))
    plot(YEARS,(HIGHS(parm,:) - Baseline)./B,'-','LineWidth',MyLineWidth, 'Color',rgb('Crimson'))

    parm = 7; % 7- CORAL.fecund_min_size
    plot(YEARS,(LOWS(parm,:) - Baseline)./B,'--','LineWidth',MyLineWidth, 'Color',rgb('RoyalBlue'))
    plot(YEARS,(HIGHS(parm,:) - Baseline)./B,'--','LineWidth',MyLineWidth, 'Color',rgb('Crimson'))

    parm = 8; % 8- CORAL.fecund_b
    plot(YEARS,(LOWS(parm,:) - Baseline)./B,':','LineWidth',MyLineWidth, 'Color',rgb('RoyalBlue'))
    plot(YEARS,(HIGHS(parm,:) - Baseline)./B,':','LineWidth',MyLineWidth, 'Color',rgb('Crimson'))

    if ssp == 2
        ylabel(MyYlabel2,'FontName', 'Arial', 'FontWeight','normal','FontSize',myGraphicParms.FontSizeLabelAxes) ;
        P.YLabel.Position(1) = 1998;
    end

    % Legend
    plot(nan,nan,'-','Color',Color1,'LineWidth',MyLineWidth);
    plot(nan,nan,'--','Color',Color1,'LineWidth',MyLineWidth);
    plot(nan,nan,':','Color',Color1,'LineWidth',MyLineWidth);

    h = get(gca,'Children');
    X = legend([h(3) h(2) h(1)], All_parms{6:8});
    X.FontSize = LabelFontSize-2;
    X.ItemTokenSize = MyTokenSize;
    X.Location = 'northwest';
    X.Orientation = 'horizontal';
    X.Box = 'off';

    % ---------------------------
    subplot(length(ID_plot),3,ID_plot(5)+count); axis(MyLimits2) ; hold on
    P = gca;
    set(P, 'Box','on', 'Layer', 'top', 'FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
    P.Position(1) = P.Position(1) + count*hgap;
    P.Position(2) = P.Position(2) + 4*vgap;
    plot([YEARS(1) YEARS(end)], 0*[YEARS(1) YEARS(end)],'-k')

    parm = 9; % 9- META.coral_min_selfseed
    plot(YEARS,(LOWS(parm,:) - Baseline)./B,'-','LineWidth',MyLineWidth, 'Color',rgb('RoyalBlue'))
    plot(YEARS,(HIGHS(parm,:) - Baseline)./B,'-','LineWidth',MyLineWidth, 'Color',rgb('Crimson'))

    parm = 10; % 10- CORAL.BH_alpha
    plot(YEARS,(LOWS(parm,:) - Baseline)./B,'--','LineWidth',MyLineWidth, 'Color',rgb('RoyalBlue'))
    plot(YEARS,(HIGHS(parm,:) - Baseline)./B,'--','LineWidth',MyLineWidth, 'Color',rgb('Crimson'))

    parm = 11; % 11- CORAL.BH_beta
    plot(YEARS,(LOWS(parm,:) - Baseline)./B,':','LineWidth',MyLineWidth, 'Color',rgb('RoyalBlue'))
    plot(YEARS,(HIGHS(parm,:) - Baseline)./B,':','LineWidth',MyLineWidth, 'Color',rgb('Crimson'))

    if ssp == 2
        ylabel(MyYlabel2,'FontName', 'Arial', 'FontWeight','normal','FontSize',myGraphicParms.FontSizeLabelAxes) ;
        P.YLabel.Position(1) = 1998;
    end

    % Legend
    plot(nan,nan,'-','Color',Color1,'LineWidth',MyLineWidth);
    plot(nan,nan,'--','Color',Color1,'LineWidth',MyLineWidth);
    plot(nan,nan,':','Color',Color1,'LineWidth',MyLineWidth);

    h = get(gca,'Children');
    X = legend([h(3) h(2) h(1)], All_parms{9:11});
    X.FontSize = LabelFontSize-2;
    X.ItemTokenSize = MyTokenSize;
    X.Location = 'northwest';
    X.Orientation = 'horizontal';
    X.Box = 'off';

    % ---------------------------
    subplot(length(ID_plot),3,ID_plot(6)+count); axis(MyLimits2) ; hold on
    P = gca;
    set(P, 'Box','on', 'Layer', 'top', 'FontName', 'Arial' ,'FontSize',myGraphicParms.FontSizeLabelTicks);
    P.Position(1) = P.Position(1) + count*hgap;
    P.Position(2) = P.Position(2) + 5*vgap;
    plot([YEARS(1) YEARS(end)], 0*[YEARS(1) YEARS(end)],'-k')

    parm = 12; % 12- CORAL.sensitivity_hurricane
    plot(YEARS,(LOWS(parm,:) - Baseline)./B,'-','LineWidth',MyLineWidth, 'Color',rgb('RoyalBlue'))
    plot(YEARS,(HIGHS(parm,:) - Baseline)./B,'-','LineWidth',MyLineWidth, 'Color',rgb('Crimson'))

    parm = 13; % 13- META.COTS_feeding_rates
    plot(YEARS,(LOWS(parm,:) - Baseline)./B,'--','LineWidth',MyLineWidth, 'Color',rgb('RoyalBlue'))
    plot(YEARS,(HIGHS(parm,:) - Baseline)./B,'--','LineWidth',MyLineWidth, 'Color',rgb('Crimson'))

    parm = 14; % 14- META.COTS_BH_alpha
    plot(YEARS,(LOWS(parm,:) - Baseline)./B,':','LineWidth',MyLineWidth, 'Color',rgb('RoyalBlue'))
    plot(YEARS,(HIGHS(parm,:) - Baseline)./B,':','LineWidth',MyLineWidth, 'Color',rgb('Crimson'))

    xlabel('Year','FontName', 'Arial', 'FontWeight','normal','FontSize',myGraphicParms.FontSizeLabelAxes)

    if ssp == 2
        ylabel(MyYlabel2,'FontName', 'Arial', 'FontWeight','normal','FontSize',myGraphicParms.FontSizeLabelAxes) ;
        P.YLabel.Position(1) = 1998;
    end

    % Legend
    plot(nan,nan,'-','Color',Color1,'LineWidth',MyLineWidth);
    plot(nan,nan,'--','Color',Color1,'LineWidth',MyLineWidth);
    plot(nan,nan,':','Color',Color1,'LineWidth',MyLineWidth);

    h = get(gca,'Children');
    X = legend([h(3) h(2) h(1)], All_parms{12:14});
    X.FontSize = LabelFontSize-2;
    X.ItemTokenSize = MyTokenSize;
    X.Location = 'northwest';
    X.Orientation = 'horizontal';
    X.Box = 'off';

    % ---------------------------
    count = count+1;

end

%-- EXPORT --------------------
set(gcf, 'InvertHardCopy', 'off');
print(MYFIG, ['-r' num2str(myGraphicParms.res)], [IMAGENAME '.png' ], ['-d' 'png'] );
crop([IMAGENAME '.png'],0,myGraphicParms.margins); % don't crop to ease the merging with Fig. 2b and 2c

close all
