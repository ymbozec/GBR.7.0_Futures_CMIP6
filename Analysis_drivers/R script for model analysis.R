library(tidyverse) ## for data wrangling
library(cowplot) ## for multi-panel plots using ggplot
library(lme4) ## for (generalised) mixed-effects models
library(lmerTest) ## for getting p-values from lmer models
library(emmeans) ## for posthoc multiple comparisons
library(readxl) ## to import xl
library(MASS)
library(forecast)
library(r2glmm)
library(broom)
library(broom.mixed)
#install.packages('car')        # To check multicollinearity 
#install.packages("corrplot")   # plot correlation plot
library('car')
library('corrplot')
##library(corrplot)
ssp19 <- read.csv("SSP19results.txt")
ssp19$reefnum=as.factor(ssp19$reefnum)
ssp19$sector=as.factor(ssp19$sector)
ssp19$ssp=as.factor(ssp19$ssp)
ssp19$gcm=as.factor(ssp19$gcm)

## varnames={'reefnum','sector','startyr','censusyr','ssp','gcm','sim',...
##  'cover','numcyclones','cyclonestrength','timesincecyclone','numbleaching',...
##  'meandhw','timesincebleaching','totalcots','meancots','numcotscontrol',...
##'timesincecotscontrol','larvaelongterm','larvae5yrs','rubble','wqrep',...
##'wqrecruit','wqjuv','zcover','znumcyclones','zcyclonestrength','ztimesincecyclone',...
##'znumbleaching','zmeandhw','ztimesincebleaching','ztotalcots','zmeancots',...
##'znumcotscontrol','ztimesincecotscontrol','zlarvaelongterm','zlarvae5yrs',...
##'zrubble','zwqrep','zwqrecruit','zwqjuv'};



# check for multicollinearity. Finds that zwqjuv is >5
#vif(m0)
#vif_values <- vif(m0)
#barplot(vif_values, main = "VIF Values", horiz = TRUE, col = "steelblue") #create horizontal bar chart to display each VIF value
#abline(v = 5, lwd = 3, lty = 2)    #add vertical line at 5 as after 5 there is severe correlation
#print(vif_values)

# now remove that variable

m1<-lm(zcover ~ znumcyclones+zcyclonestrength+ztimesincecyclone+
               +znumbleaching+zmeandhw+ztimesincebleaching+zmeancots
       +znumcotscontrol+ztimesincecotscontrol+zwqrep+zwqrecruit+zsinkreefs, data = ssp19)

sum_m1=summary(m1)
summary(m1)
capture.output(sum_m1, file = "m1summary.txt")

r2m1=r2beta(m1,partial=TRUE,method="nsj",data=ssp19)
capture.output(r2m1, file = "m1R2.txt")

m1coeff=m1$coefficients
write.csv(m1coeff,'m1estimates.csv')


pval<-broom.mixed::tidy(m1)
output <- data.frame(pval$estimate[])
predictors<- data.frame(pval$term)
write.csv(output,'m1estimates.csv')
write.csv(predictors,'m1predictors.csv')
