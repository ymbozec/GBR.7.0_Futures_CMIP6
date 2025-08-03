%__________________________________________________________________________
%
% RESULTS OF THE GLOBAL SENSITIVITY ANALYSIS
%
% Yves-Marie Bozec, y.bozec@uq.edu.au, 04/2025
%__________________________________________________________________________
% Uses the outputs of MIROC-6 under SSP1-2.6 simulated 100 times (same sequence of
% cyclones and bleaching for each run) with the values of parameters sampled at random
% within the range -20% to +20% of their default value

clear

SETTINGS_PLOTS
SaveDir = ''

FolderName = '/home/ym/Dropbox/REEFMOD/REEFMOD_GBR_OUTPUTS/GBR.7.0_CMIP6_2024_04/Raw_outputs/Sensititivty_analysis_NEW/';

YEARS = [2008:2100];
NB_RUNS = 100;

CC = nan(NB_RUNS,length(YEARS)+1);
PARMS = nan(NB_RUNS,14);

load('sR0_GBR.7.0_herit0.3_SSP126_MIROC6.mat','coral_cover_per_taxa')
CC_baseline = squeeze(mean(sum(coral_cover_per_taxa(1,:,:,:),4),2))';

for run_id = 1:NB_RUNS
    load(['R0_sensitivity_new_GBR.7.0_herit0.3_SSP126_MIROC6_parm' num2str(run_id) '.mat'],'RESULT','OPTIONS')
    CC(run_id,:) = squeeze(mean(sum(RESULT.coral_pct2D,3),1));
    PARMS(run_id,:) = OPTIONS.SENS_PARMS;
    clear coral_cover_per_taxa
end

A = PARMS(:,8).^(10); % rescale the range for fecundity which was log10 transformed
PARMS(:,8) = 0.8+(A-min(A))*(1.2 - 0.8)/(max(A)-min(A));

% [YEARS ; CC_baseline(2:end)]';

% All_parms = {'w';'s';'σ';'HT.max';'h2';'growth';'fecund.min';'fecundity';...
%     'self.seed';'α.coral';'β.coral';'cycl.adj';'pred.adj';'α.CoTS'};

% Now using more explicit terminology
All_parms = {'bleaching.depth';'s';'HT.sd';'HT.max';'heritability';'growth';'gravid.min';'fecundity';...
    'self.seeding';'α.coral';'β.coral';'cyclone.coeff';'CoTS.coeff';'α.CoTS'};

MySteps = [find(YEARS==2030) find(YEARS==2060) find(YEARS==2090)]+1;

rangeY = 0.75;
vgap = 0.02;
pos_x = 0.5;
pos_y = 0.92;
MyColor = 0.8*[0.8  0.96 0.96];
%------------------------------ PLOT FIGURE ----------------------------------
MyParms(1).parms = [ 1 3:7 ];
MyParms(2).parms = [ 8:14 ];

OUTPUTS(1).Parameter = nan;
OUTPUTS(1).R2 = nan;
OUTPUTS(1).change_for_low = nan(1,3);
OUTPUTS(1).change_for_high = nan(1,3);

for my_batch = 1:2

    MYFIG = figure;
    width=14*2; height=length(MyParms(my_batch).parms)*6.5;
    set(MYFIG,'color','w','units','centimeters','position',[0,0,width,height])
    set(MYFIG, 'Resize', 'off')
    IMAGENAME = ['FIG_Sx_SENSITIVITY_GSA' num2str(my_batch)];

    count = 1;
    count_parms = 1;

    for select_parm = MyParms(my_batch).parms

        count_steps = 1;

        for select_step = MySteps

            g = subplot(length(MyParms(my_batch).parms),length(MySteps),count);
            g.Position(2) = g.Position(2) + count_parms*vgap;

            X = PARMS(:,select_parm) - 1; % minus 1 to express as relative parameter change (-0.2 to 0.2)
            Y = (CC(:,select_step)-CC_baseline(select_step))./CC_baseline(select_step);

            myplot = plot(X, Y, 'o','MarkerFaceColor',MyColor,'MarkerEdgeColor','white','linewidth',0.1);
            hold on
            set(g, 'color','white','Layer', 'top', 'FontName', 'Arial' ,'FontSize', 10);

            if select_parm == 1
                title(num2str(YEARS(select_step)-1),'FontSize', 16)
            end

            [p,S] = polyfit(X,Y,1); % Linear fit
            R_squared = 1 - (S.normr/norm(Y - mean(Y)))^2;
            [y_fit,delta] = polyval(p,X,S);
            [v,o] = sort(X,'ascend');
            plot(X(o), y_fit(o), 'b-', 'linewidth',1.5)
            plot(X(o), y_fit(o)+2*delta,'b--','linewidth',1)
            plot(X(o), y_fit(o)-2*delta,'b--','linewidth',1)

            OUTPUTS(select_parm).Parameter =  All_parms{select_parm} ;
            OUTPUTS(select_parm).R2(count_steps) = round(R_squared,2);
            OUTPUTS(select_parm).change_for_low(count_steps) = round(y_fit(o(1)),2);
            OUTPUTS(select_parm).change_for_high(count_steps) = round(y_fit(o(end)),2);
           
            if select_step == 24
                ylabel('Coral cover change','FontName', 'Arial', 'FontWeight','normal','FontSize',myGraphicParms.FontSizeLabelAxes) ;
            end

            if count_parms == length(MyParms(my_batch).parms)
                xlabel('Parameter change','FontName', 'Arial', 'FontWeight','normal','FontSize',myGraphicParms.FontSizeLabelAxes) ;
            end

            if R_squared > 0.05
                MyR2 = ['R^{2} = ' num2str(round(R_squared,2))];
            else
                MyR2 = '';
            end

            t0 = text(pos_x, pos_y, All_parms{select_parm} ,'Units','normalized','FontName','Arial',...
                'HorizontalAlignment','center','FontWeight','bold','FontSize',12,'Color','k');
            t1 = text(pos_x, 0.1, MyR2 ,'Units','normalized','FontName','Arial','HorizontalAlignment','center','FontSize',10,'Color',rgb('Crimson'));

            % scatter(1,0,60,'filled','MarkerEdgeColor','k','MarkerFaceColor','w')
            axis([-0.21 0.21 rangeY*[-1 1]])

            count = count + 1;
            count_steps = count_steps + 1;
        end
        count_parms = count_parms + 1;
    end

    %-- EXPORT --------------------
    set(gcf, 'InvertHardCopy', 'off');
    print(MYFIG, ['-r' num2str(myGraphicParms.res)], [IMAGENAME '.png' ], ['-d' 'png'] );
    crop([IMAGENAME '.png'],0,myGraphicParms.margins); % don't crop to ease the merging with Fig. 2b and 2c
    close all
end

% For a polynomial fit
% [p,S] = polyfit(X,Y,2);
% newX = [0.8:0.01:1.2];
% newY = p(1)*newX.^2 + p(2)*newX + p(3);
% plot(newX, newY, '-' )
%
% f = polyval(p,X);
% T = table(X,Y,f,Y-f,'VariableNames',{'X','Y','Fit','FitError'})

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
