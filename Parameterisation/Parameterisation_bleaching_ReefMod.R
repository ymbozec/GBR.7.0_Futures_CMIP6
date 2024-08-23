################################################################################
# Parameterisation of bleaching mortality and individual heat tolerance for
# ReefMod-GBR version 7.0. 
# Y-M Bozec, University of Queensland (y.bozec@uq.edu.au)
# Nov 2023
################################################################################
# Includes:
# 1) modelling of depth-related attenuation coefficient of heat stress
# based on Baird et al. (2018) bleaching prevalence at depth in Northern GBR
# 2) generalisation of formulas of coral mortality as a function of heat
# stress (DHW) developed in earlier version of ReefMod-GBR (Bozec et al. 2022)
# for multiple taxa and depths
# 3) parameterisation and integration of individual heat tolerance based
# on experimental data on Acropora digitifera in Palau (Humanes et al. (2002)
################################################################################

rm(list=ls())

library(mgcv)
library(ggplot2); library(plotrix) ; library(ggthemes); library(patchwork); 
library(grid)

# Define graphic parameters:
PanelFontSize = 20
AxisFontSize = 18
TickFontsize = 14
LabelxSize = 5.5

################################################################################
#### Depth-related attenuation coefficient of heat stress
################################################################################
# Data extracted from Baird et al. (2018) MEPS with Engauge Digitizer
# Proportion of bleached corals 4 weeks after the peak of the 2016 heatwave
# as a function of depth at Wood Reef ('Reef_1') and 11-203 Reef ('Reef_2')
DATA = read.table("Baird_etal_2018.csv", header=TRUE, sep=",")

# Simple regression model on proportion of bleached corals relative to 2m depth
M0 = lm(1/Rel_Prop_bleach~Depth, data=DATA)

R2 = summary(M0)$r.squared
slope = round(summary(M0)$coefficients[2],3)
intercept = round(summary(M0)$coefficients[1],3)

# New vector of depths for predictions
MyDepths = data.frame(Depth=seq(2,27,by=0.1))
Y = predict(M0, newdata=MyDepths, interval="predict")

# Plot non-transformed data with model
P0 = ggplot()+ theme_bw() +
  ggtitle('a') + theme(plot.title = element_text(size = PanelFontSize, face = 'bold')) +
  geom_point(aes(x=DATA$Depth[DATA$Reef=='Reef_1'],y=DATA$Rel_Prop_bleach[DATA$Reef=='Reef_1']), shape = 21, colour = "black", fill = "white", size = 3, stroke = 0.6) +
  geom_point(aes(x=DATA$Depth[DATA$Reef=='Reef_2'],y=DATA$Rel_Prop_bleach[DATA$Reef=='Reef_2']), shape = 21, colour = "black", fill = "black", size = 3, stroke = 0.6) +
  geom_line(aes(x=MyDepths$Depth, y= 1/(slope*MyDepths$Depth+intercept)), size = 1, col='DarkGrey') +
  scale_x_continuous(limits = c(0,28),expand = c(0, 0)) +
  scale_y_continuous(limits = c(0,1.05), expand = c(0.02, 0.02)) +
  labs(x="Depth (m)",y='Proportion of bleached colonies') +
  theme(axis.title.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 20))) +
  theme(axis.title.x = element_text(margin = margin(t = 10, r = 0, b = 0, l = 0))) +
  geom_point(aes(x =18, y = 0.9),  shape = 21, colour = "black", fill = "white", size = 3, stroke = 0.7) +
  annotate(geom = 'text', x = 19, y = 0.9, label = 'Wood Reef', size = LabelxSize, hjust = 0) +
  geom_point(aes(x =18, y = 0.82),  shape = 21, colour = "black", fill = "black", size = 3, stroke = 0.7) +
  annotate(geom = 'text', x = 19, y = 0.82, label = '11-203 Reef', size = LabelxSize, hjust = 0) +
  theme(axis.ticks = element_line(linewidth = 0.25), axis.text = element_text(size=TickFontsize), axis.title = element_text(size=AxisFontSize)) +
  theme(axis.title.x = element_text(margin=margin(t=10)), #add margin to x-axis title
      axis.title.y = element_text(margin=margin(r=10))) #add margin to y-axis title


################################################################################
#### Generalisation of the bleaching mortality model
################################################################################
# w is attenuation coefficient of stress with depth:
#   w=1 to retrieve bleaching mortality observed by Hughes et al. (2018 NATURE) at 2m depth
#   w=0.43 assuming bleaching mortality at 7m is ~half that of 2m depth (Baird et al. 2018 MEPS)
# s is sensitivity coefficient for specific taxa (Hughes et al. 2018)
#   s=1 for community-wide mortality
#   s=1.5 for fast growing corals (acroporids, pocilloporids)
#   s=0.25 for slow growing corals
f.bleach_mort <- function(DHW,w,s)
{
  # Estimate initial mortality as observed by Hughes et al. 2018 on n=63 reefs at 2m depth
  # (see modelling in Bozec et al 2021 ECOL MONOGR).
  # This is mortality at the peak of the bleaching event 
  m = w*s*(exp(0.168 + 0.347 * DHW)-1)/100
  
  # Need to cap mortality to 1 before further calculation 
  m[m>1]=1
  # Approximate long-term (~6 month) mortality based on ReefMod calibrations.
  # This allowed the model to reproduce the loss of total coral cover (losses)percent cover)
  # observed by Hughes et al (2018) on the 63 reefs 8 months after the 2016 beaching
  M = 1 - (1-m)^6
  return(M)
}

# Model parameters
myDHW = seq(0,25,by=0.01)
w = 0.43 # to get mortality at ~7m depth
s = 1.4 # average bleaching sensitivity of corymbose acroporids (Bozec et al. 2022)

m = w*s*(exp(0.168 + 0.347 * myDHW)-1)/100
m[m>1]=1
M = 1 - (1-m)^6

# Legend positioning
y_lgd1 = 0.18
y_lgd2 = 0.08
y_lgd3 = 0.06

## Plot the two steps (initial and total mortality)
P1 = ggplot()+ theme_bw() + 
  ggtitle('b') + theme(plot.title = element_text(size = PanelFontSize, face = 'bold')) +
  geom_line(aes(x=myDHW,y=M), size = 1, col='DarkGrey') +
  geom_line(aes(x=myDHW,y=m), size = 0.5, col='black',linetype="dashed") +
  scale_x_continuous(limits = c(0,22),expand = c(0.025, 0.025)) +
  scale_y_continuous(limits = c(0,1.05), expand = c(0.02, 0.02)) +
  labs(x="Cumulative heat stress (°C-week)",y='Bleaching mortality')+
  theme(axis.ticks = element_line(linewidth = 0.25), axis.text = element_text(size=TickFontsize), axis.title = element_text(size=AxisFontSize)) +
  # "Legend"
  geom_segment(aes(x =11.5, y = y_lgd1, xend = 12.8, yend = y_lgd1), size=0.5, linetype="dashed") +
  annotate(geom = 'text', x = 13.2, y = y_lgd1, label = 'initial (m, capped)', size = LabelxSize, hjust = 0) +
  geom_segment(aes(x =11.5, y = y_lgd2, xend = 12.8, yend =y_lgd2), size=1, colour = 'DarkGrey') +
  annotate(geom = 'text', x = 13.2, y = y_lgd2, label = 'total (M)', size = LabelxSize, hjust = 0) +
  theme(axis.title.x = element_text(margin=margin(t=10)), #add margin to x-axis title
        axis.title.y = element_text(margin=margin(r=10,l=7))) #add margin to y-axis title

color_HS = '#ff9999'
color_HT = '#729fcf'

## Plot the response of the 6 taxonomic groups (total mortality only)
P2 = ggplot()+ theme_bw() + 
  ggtitle('c') + theme(plot.title = element_text(size = PanelFontSize, face = 'bold')) +
  geom_line(aes(x=myDHW,y=f.bleach_mort(myDHW,w,s=1.5)), size = 1, col=color_HS) + # staghorn acroporids
  geom_line(aes(x=myDHW,y=f.bleach_mort(myDHW,w,s=1.6)), size = 1, col=color_HS) + # plating acroporids
  geom_line(aes(x=myDHW,y=f.bleach_mort(myDHW,w,s=1.4)), size = 1, col=color_HS) + # corymbose acroporids
  geom_line(aes(x=myDHW,y=f.bleach_mort(myDHW,w,s=1.7)), size = 1, col=color_HS) + # pocilloporids
  geom_line(aes(x=myDHW,y=f.bleach_mort(myDHW,w,s=0.25)), size = 1, col=color_HT) + # mix small massive/encrusting
  geom_line(aes(x=myDHW,y=f.bleach_mort(myDHW,w,s=0.25)), size = 1, col=color_HT) + # large massive corals
  scale_x_continuous(limits = c(0,22),expand = c(0.025, 0.025)) +
  scale_y_continuous(limits = c(0,1.05), expand = c(0.02, 0.02)) +
  labs(x="Cumulative heat stress (°C-week)",y='Bleaching mortality M')+
  theme(axis.ticks = element_line(linewidth = 0.25), axis.text = element_text(size=TickFontsize), axis.title = element_text(size=AxisFontSize)) +
  geom_segment(aes(x =11.5, y = y_lgd1, xend = 12.8, yend = y_lgd1), size=1, col=color_HS) +
  annotate(geom = 'text', x = 13.2, y = y_lgd1, label = 'heat-sensitive', size = LabelxSize, hjust = 0) +
  geom_segment(aes(x =11.5, y = y_lgd2, xend = 12.8, yend =y_lgd2), size=1, colour = color_HT) +
  annotate(geom = 'text', x = 13.2, y = y_lgd2, label = 'heat-resistant', size = LabelxSize, hjust = 0) +
  theme(axis.title.x = element_text(margin=margin(t=10)), #add margin to x-axis title
        axis.title.y = element_text(margin=margin(r=10,l=7))) #add margin to y-axis title

## EXPORT FIGURE
ggsave('FIG_BLEACHING_MORTALITY.png', plot= wrap_plots(P0,P1,P2,ncol=3), width = 16, height = 5.5)


################################################################################
#### Parameterisation of heat tolerance
################################################################################
# Thermal tolerance (DELTA_DHW) is introduced by shifting the mortality function to the right of the DHW gradient, 
# so that the same mortality is experienced at greater DHW values. This comes down to adjusting
# the sensitivity coefficient (s) # of the species of reference as follows:
# s_new = s*exp(0.347*(-4)) # greater heat tolerance of +4 °C-week
# s_new = s*exp(0.347*(-8))  # greater heat tolerance of +8 °C-week

# Note the resulting mortality curve is not symmetrical around its inflexion point (not like a logistic curve)
# so that the difference in DHW between two mortality curves varies along the mortality axis.
# Here, heat tolerance corresponds to the difference in DHW at 100% mortality

## Plot within-population variability based on Humanes et al. 2022
# DELTA = 2.87 
# average difference in heat stress tolerated between highs (RHHT) and lows (LHHT), with 95% CI = 2.16 - 3.77
# this corresponds to a conservative estimate of heat tolerance variability, obtained at 0.34 mortality index cut-off
# DELTA = 4.84
# average difference in heat stress tolerated between the 10th percentiles of high and low resistant corals,
# with 95% CI = 3.12 - 6.77, ontained at 0.12 mortality index cut-off
DELTA = 6.37 # GLOBAL DELTA that gives at M=0.12 the same delta obtained experimentally at cut-off BMI=0.12 (4.84 °C-week)
my_w = 0.43 # playing with different w will give different DELTA, but we assume here that the range of HT around the mean
# does not change with depth

REF = f.bleach_mort(myDHW, w=my_w, s=1.4) # corymbose Acropora at ~ 7m depth
RLHT = f.bleach_mort(myDHW, w=my_w, s=1.4*exp(0.347*(+DELTA/2))) # 'relatively low heat tolerance' colonies
RHHT = f.bleach_mort(myDHW, w=my_w, s=1.4*exp(0.347*(-DELTA/2))) # 'relatively high heat tolerance' colonies

G = as.data.frame(cbind(myDHW,REF,RLHT,RHHT))

RLHT_12 = which(round(RLHT,2)>0.115 & round(RLHT,2)<0.125)
RHHT_12 = which(round(RHHT,2)>0.115 & round(RHHT,2)<0.125)
DeltaDHW_12 = mean(myDHW[RHHT_12])-mean(myDHW[RLHT_12])

RLHT_25 = which(round(RLHT,2)>0.2495 & round(RLHT,2)<0.2505)
RHHT_25 = which(round(RHHT,2)>0.2495 & round(RHHT,2)<0.2505)
DeltaDHW_25 = mean(myDHW[RHHT_25])-mean(myDHW[RLHT_25])

RLHT_50 = which(round(RLHT,2)>0.495 & round(RLHT,2)<0.505)
RHHT_50 = which(round(RHHT,2)>0.495 & round(RHHT,2)<0.505)
DeltaDHW_50 = mean(myDHW[RHHT_50])-mean(myDHW[RLHT_50])

RLHT_75 = which(round(RLHT,2)>0.7495 & round(RLHT,2)<0.7505)
RHHT_75 = which(round(RHHT,2)>0.7495 & round(RHHT,2)<0.7505)
DeltaDHW_75 = mean(myDHW[RHHT_75])-mean(myDHW[RLHT_75])

RLHT_90 = which(round(RLHT,2)>0.895 & round(RLHT,2)<0.905)
RHHT_90 = which(round(RHHT,2)>0.895 & round(RHHT,2)<0.905)
DeltaDHW_90 = mean(myDHW[RHHT_90])-mean(myDHW[RLHT_90])

RLHT_100 = which(RLHT==1)
RHHT_100 = which(RHHT==1)
DeltaDHW_100 = mean(myDHW[min(RHHT_100)])-mean(myDHW[min(RLHT_100)]) # as close as it gets to DELTA/2


#### APPLICATION: show the resulting variability for random DHW values
N = 10000 # number of random heat stress events
binwidth = 0.2
# x1 = 4.84/2 ; breaks = seq(-8, 8, binwidth)
x2 = 6.37/2; breaks = seq(-12, 12, binwidth)
HT_max = 8 # as +/- degC-week that delimit the possible range of HT values

# Generate randon DHW values
myDHW_rand = sample(myDHW, N, replace = T)

# Determine sd of the normal distribution (from known mean and percentile)
m=0
p=0.9 # 90th percentile
# sd1 = (x1-m)/qnorm(p)
sd2 = (x2-m)/qnorm(p)

# Generate N random values from this normal distribution
# Z1 = rnorm(N, mean=0, sd=sd1)
Z2 = rnorm(N, mean=0, sd=sd2)

# Apply boundary limits
outliers = which(abs(Z2)>HT_max)
Z2[outliers]=0 

# Estimate total mortality
M = f.bleach_mort(myDHW_rand, w=0.43, s=s * exp(-0.347*Z2)) # (default s already integrated to s_rand)

# hist(M, seq(0,1, by=0.05),xlim=c(0.1,0.9),ylim=c(0,200))
text1 = paste(round(DeltaDHW_12,2), '°C-week',sep='')
text2 = paste(round(DELTA,2), '°C-week',sep='')
hgap = 5

P3 = ggplot()+ theme_bw() +
  ggtitle('a') + theme(plot.title = element_text(size = PanelFontSize, face = 'bold')) +
  geom_point(aes(x=myDHW_rand[myDHW_rand<3],y=M[myDHW_rand<3]), size = 1, col='LightGrey') +
  geom_point(aes(x=myDHW_rand[myDHW_rand>=3],y=M[myDHW_rand>=3]), size = 1, col='LightGrey') +
  geom_line(data=G,aes(x=myDHW,y=REF), linewidth = 1, col='DarkGrey') +
  geom_line(data=G,aes(x=myDHW,y=RLHT), linewidth = 1, col='#1b98e0') +
  geom_line(data=G,aes(x=myDHW,y=RHHT), linewidth = 1, col='#E0911B') +
  # Add DELTA at M=0.12
  geom_segment(aes(x = mean(myDHW[RLHT_12]), y = 0.12, xend = mean(myDHW[RHHT_12]), yend = 0.12)) +
  geom_point(aes(x=mean(myDHW[RLHT_12]), y=0.12), shape = 21, colour = "black", fill = "RED", size = 2, stroke = 1) +
  geom_point(aes(x=mean(myDHW[RHHT_12]), y=0.12), shape = 21, colour = "black", fill = "RED", size = 2, stroke = 1) +
  # annotate(geom = 'label', label.size = NA, x = 1.1*mean(myDHW[RLHT_12]) + DeltaDHW_12/2 , y = 0.12, label = text1, size = LabelxSize) +
  annotate(geom = 'label', x = mean(myDHW[RLHT_12]) + DeltaDHW_12/2 , y = 0.12, label = text1, size = LabelxSize-1) +
  # Add DELTA at M=1
  geom_segment(aes(x = min(myDHW[RLHT_100]), y = 1, xend = min(myDHW[RHHT_100]), yend = 1)) +
  geom_point(aes(x = min(myDHW[RLHT_100]), y = 1), shape = 21, colour = "black", fill = "black", size = 2, stroke = 1) +
  geom_point(aes(x =  min(myDHW[RHHT_100]), y = 1), shape = 21, colour = "black", fill = "black", size = 2, stroke = 1) +
  annotate(geom = 'label', x = min(myDHW[RLHT_100]) + DELTA/2 , y = 1, label = text2, size = LabelxSize-1) +
  scale_x_continuous(limits = c(0,22),expand = c(0, 0)) +
  scale_y_continuous(limits = c(0,1.05), expand = c(0.02, 0.02)) +
  labs(x="Cumulative heat stress (°C-week)",y='Bleaching mortality') +
  theme(axis.ticks = element_line(linewidth = 0.25), axis.text = element_text(size=TickFontsize), axis.title = element_text(size=AxisFontSize))+
  theme(axis.title.x = element_text(margin=margin(t=10)), #add margin to x-axis title
        axis.title.y = element_text(margin=margin(r=10))) + #add margin to y-axis title
  # "Legend"
  geom_segment(aes(x =11+hgap, y = 0.17, xend = 12+hgap, yend = 0.17), size=1, colour = '#1b98e0') +
  annotate(geom = 'text', x = 12.5+hgap, y = 0.17, label = '10%', size = LabelxSize-0.5, hjust = 0) +
  geom_segment(aes(x =11+hgap, y = 0.10, xend = 12+hgap, yend = 0.10), size=1, colour = 'DarkGrey') +
  annotate(geom = 'text', x = 12.5+hgap, y = 0.10, label = 'mean', size = LabelxSize-0.5, hjust = 0) +
  geom_segment(aes(x =11+hgap, y = 0.03, xend = 12+hgap, yend = 0.03), size=1, colour = '#E0911B') +
  annotate(geom = 'text', x = 12.5+hgap, y = 0.03, label = '90%', size = LabelxSize-0.5, hjust = 0)


# Histogram of the resulting distribution of heat tolerance value
maxY = 350
MyLinewidth = 0.8

P4 =  ggplot() + 
  ggtitle('b') + theme_bw() + theme(plot.title = element_text(size = PanelFontSize, face = 'bold')) +
  geom_histogram(aes(x=Z2), binwidth = binwidth, color = 'white', fill = 'LightGrey', alpha=1) +
  geom_line(aes(x=breaks, y= N*dnorm(breaks, mean=m, sd=sd2)*binwidth), linewidth = 1, col='black') +
  scale_x_continuous(limits = 9.5*c(-1,1),expand = c(0, 0),breaks=seq(-10,10,by=2)) +
  scale_y_continuous(limits = c(0,maxY), expand = c(0.02, 0.02),labels=NULL,breaks=NULL) +
  labs(x="Individual HT (ºC-week)",y='Frequency') +
  theme(axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0))) +
  theme(axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0))) +
  geom_line(aes(x=qnorm(c(0.1),mean=m,sd=sd2)*c(1,1), y= c(0,maxY-50)), linetype=2, linewidth = MyLinewidth, col='#1b98e0') +
  annotate(geom = 'text', x = qnorm(0.1,mean=m,sd=sd2), y = maxY-30, label = '10%', size = LabelxSize, hjust = 0.5) +
  annotate(geom = 'text', x = qnorm(0.1,mean=m,sd=sd2), y = -10, label = qnorm(0.1,mean=m,sd=sd2), size = LabelxSize, hjust = 0.5) +
  geom_line(aes(x=qnorm(c(0.5),mean=m,sd=sd2)*c(1,1), y= c(0,maxY-50)), linetype=2, linewidth = MyLinewidth, col='DarkGrey') +
  # annotate(geom = 'text', x = qnorm(c(0.9),mean=m,sd=sd2), y = maxY-30, label = '50%', size = LabelxSize, hjust = 0.5) +
  geom_line(aes(x=qnorm(c(0.9),mean=m,sd=sd2)*c(1,1), y= c(0,maxY-50)), linetype=2, linewidth = MyLinewidth, col='#E0911B') +
  annotate(geom = 'text', x = qnorm(c(0.9),mean=m,sd=sd2), y = maxY-30, label = '90%', size = LabelxSize, hjust = 0.5) +
  geom_line(aes(x=qnorm(c(0.01),mean=m,sd=sd2)*c(1,1), y= c(0,maxY-50)), linetype=2, linewidth = MyLinewidth, col='black') +
  annotate(geom = 'text', x = qnorm(c(0.01),mean=m,sd=sd2), y = maxY-30, label = '1%', size = LabelxSize, hjust = 0.5) +
  geom_line(aes(x=qnorm(c(0.99),mean=m,sd=sd2)*c(1,1), y= c(0,maxY-50)), linetype=2, linewidth = MyLinewidth, col='black') +
  annotate(geom = 'text', x = qnorm(c(0.99),mean=m,sd=sd2), y = maxY-30, label = '99%', size = LabelxSize, hjust = 0.5) +
  geom_line(aes(x=HT_max*c(1,1), y= c(0,maxY-50)), linetype=2, linewidth = MyLinewidth, col='darkred') +
  annotate(geom = 'text', x = HT_max*c(1,1), y = maxY-30, label = '+HT*', col='darkred', size = LabelxSize, hjust = 0.5) +  
  geom_line(aes(x=-HT_max*c(1,1), y= c(0,maxY-50)), linetype=2, linewidth = MyLinewidth, col='darkred') +
  annotate(geom = 'text', x = -HT_max*c(1,1), y = maxY-30, label = '-HT*', col='darkred', size = LabelxSize, hjust = 0.5) +  
  theme(axis.ticks = element_line(linewidth = 0.25), axis.text = element_text(size=TickFontsize), axis.title = element_text(size=AxisFontSize)) +
  theme(axis.title.x = element_text(margin=margin(t=10)), #add margin to x-axis title
        axis.title.y = element_text(margin=margin(r=10,l=10))) #add margin to y-axis title


## EXPORT FIGURE
ggsave('FIG_HEAT_TOLERANCE.png', plot= wrap_plots(P3,P4,ncol=2), width = 13, height =5.5) 
