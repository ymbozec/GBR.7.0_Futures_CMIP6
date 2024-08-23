################################################################################
# Estimate relative likelihood of the 10 climate models (AOGCMs) given their
# Equilibrium Climate Sensitivity (ECS) and the probability distribution of 
# Earth’s climate sensitivity inferred by Sherwood et al. (2020)
#
# Y-M Bozec, University of Queensland (y.bozec@uq.edu.au)
# April 2024
################################################################################

library(ggplot2); library(plotrix) ; library(ggthemes); library(patchwork); 
library(grid);

rm(list=ls())
graphics.off()

# Load curve digitalised from sherwood et al. (2020) using Engauge Digitizer.
# Data gives the baseline posterior probability density function (PDF)
# of the effective climate sensitivity (S).
X = read.table("Likelihood_Sherwood.csv", header=T, sep=",") 

# Correct for DensProba = 0 at ECS = 1 and ECS = 8
X$S[1] = 1 ; X$DensProba[1] = 0
X$S[70] = 8 ; X$DensProba[70] = 0

plot(X$S,X$DensProba,'l',lwd=3)

# Capture curve fit
M = loess(X$DensProba~X$S,span=0.1)

# List of available AOGCMs
GCM_names = c("CNRM-ESM2-1", "EC-Earth3-Veg", "IPSL-CM6A-LR", "MRI-ESM2-0", "UKESM1-0-LL", 
         "GFDL-ESM4", "MIROC-ES2L", "MPI-ESM1-2-HR", "MIROC6", "NorESM2-LM")

# Their associated ECS (Tokarska et al 2020)
GCM_ECS = c(4.7, 4.3, 4.5, 3.1, 5.3, 2.6, 2.7, 3.0, 2.6, 2.6)

# Capture relative likelihood of each GCM to be used as weight when building ensemble scenarios
GCM_lik = predict(M, GCM_ECS)
# Note that the density of probability at a specific S value doesn't represent the probability associated to that S. 
# The PDF describes the relative likelihood of the random variable falling within a particular range of values.
# While we can make relative comparisons between different values based on their density function values, we can't
# directly infer actual probabilities without integrating over intervals.
# Here, we are solely interested in comparing the relative likelihood of different values based on their PDF values

## Draw resulting figure
AxisFontSize = 18
TickFontsize = 14
LabelxSize = 5

I = which(GCM_ECS>2.8)

P1 = ggplot()+ theme_bw() + 
  geom_line(aes(x=X$S,y=X$DensProba), linewidth = 2, col='Coral2') +
  scale_x_continuous(limits = c(1,8),expand = c(0.025, 0.025)) +
  labs(x="Climate sensitivity (°C)",y='Density of probability')+
  geom_point(aes(x=GCM_ECS,y=GCM_lik), size = 4, col='black') +
  annotate(geom = 'text', x = GCM_ECS[I], y = GCM_lik[I], label = GCM_names[I], size = LabelxSize, hjust = -0.1, vjust = -0.1) +
  annotate(geom = 'text', x = GCM_ECS[7], y = GCM_lik[7], label = GCM_names[7], size = LabelxSize, hjust = 1.1, vjust = -0.1) +
  annotate(geom = 'text', x = GCM_ECS[9], y = GCM_lik[9], label = GCM_names[9], size = LabelxSize, hjust = -0.15, vjust = 0.8) +
  annotate(geom = 'text', x = GCM_ECS[6], y = GCM_lik[6], label = GCM_names[6], size = LabelxSize, hjust = 1.1, vjust = 1.6) +
  annotate(geom = 'text', x = GCM_ECS[10], y = GCM_lik[10], label = GCM_names[10], size =LabelxSize, hjust = 1.1, vjust = -0.4) +
  theme(axis.ticks = element_line(linewidth = 0.5), axis.text = element_text(size=TickFontsize), axis.title = element_text(size=AxisFontSize)) +
  theme(axis.title.x = element_text(margin=margin(t=10)), #add margin to x-axis title
        axis.title.y = element_text(margin=margin(r=10,l=20))) #add margin to y-axis title

ggsave('FIG_REL_LIKELIHOOD.png', P1, width = 8, height =5) 
