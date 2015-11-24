#!usr/bin/env Rscript
library(methods)
library(Matrix)
library(MASS)
library(Rcpp)
library(lme4)
#
#roi_name={'p95','dLOC','dLOC',...
#>---'SMG','SMG','IFG','HIP',...
#>---'CA1','CA2','DG','CA3','subiculum','ERC'};
# Read in your data as an R dataframe
basedir <- c("/seastor/helenhelen/ISR_2015")
resultdir <- paste(basedir,"/me/results/ln_cact",sep="/")
setwd(resultdir)
r.itemInfo <- matrix(data=NA, nr=8, nc=4)
## read data
#get data for each trial
item_file <- paste(basedir,"/me/data/item/ln.txt",sep="")
item_data <- read.table(item_file,header=FALSE)
colnames(item_data) <- c("subid","pid",
"p95_act1","p95_act2","p95_actmean","p95_rsaD","p95_rsaDBwc","p95_rsadiff",
"VVC_act1","VVC_act2","VVC_actmean","VVC_rsaD","VVC_rsaDBwc","VVC_rsadiff",
"dLOC_act1","dLOC_act2","dLOC_actmean","dLOC_rsaD","dLOC_rsaDBwc","dLOC_rsadiff",
"ANG_act1","ANG_act2","ANG_actmean","ANG_rsaD","ANG_rsaDBwc","ANG_rsadiff",
"SMG_act1","SMG_act2","SMG_actmean","SMG_rsaD","SMG_rsaDBwc","SMG_rsadiff",
"IFG_act1","IFG_act2","IFG_actmean","IFG_rsaD","IFG_rsaDBwc","IFG_rsadiff",
"HIP_act1","HIP_act2","HIP_actmean","HIP_rsaD","HIP_rsaDBwc","HIP_rsadiff",
"CA1_act1","CA1_act2","CA1_actmean","CA1_rsaD","CA1_rsaDBwc","CA1_rsadiff",
"CA2_act1","CA2_act2","CA2_actmean","CA2_rsaD","CA2_rsaDBwc","CA2_rsadiff",
"DG_act1","DG_act2","DG_actmean","DG_rsaD","DG_rsaDBwc","DG_rsadiff",
"CA3_act1","CA3_act2","CA3_actmean","CA3_rsaD","CA3_rsaDBwc","CA3_rsadiff",
"subiculum_act1","subiculum_act2","subiculum_actmean","subiculum_rsaD","subiculum_rsaDBwc","subiculum_rsadiff",
"ERC_act1","ERC_act2","ERC_actmean","ERC_rsaD","ERC_rsaDBwc","ERC_rsadiff")
item_data$subid <- as.factor(item_data$subid)
item_data$pid <- as.factor(item_data$pid)

subdata <- item_data
subdata$SMG_actrep <- item_data$SMG_act1-item_data$SMG_act2
itemInfo_actmean <- lmer(dLOC_rsadiff~SMG_actmean+dLOC_actmean+(1+SMG_actmean+dLOC_actmean|subid)+(1+SMG_actmean+dLOC_actmean|pid),REML=FALSE,data=subdata)
itemInfo_actmean.null <- lmer(dLOC_rsadiff~dLOC_actmean+(1+SMG_actmean+dLOC_actmean|subid)+(1+SMG_actmean+dLOC_actmean|pid),REML=FALSE,data=subdata)
itemInfo_actrep <- lmer(dLOC_rsadiff~SMG_actrep+dLOC_actmean+(1+SMG_actrep+dLOC_actmean|subid)+(1+SMG_actrep+dLOC_actmean|pid),REML=FALSE,data=subdata)
itemInfo_actrep.null <- lmer(dLOC_rsadiff~dLOC_actmean+(1+SMG_actrep+dLOC_actmean|subid)+(1+SMG_actrep+dLOC_actmean|pid),REML=FALSE,data=subdata)
itemInfo_rsadiff <- lmer(dLOC_rsadiff~SMG_rsadiff+dLOC_actmean+(1+SMG_rsadiff+dLOC_actmean|subid)+(1+SMG_rsadiff+dLOC_actmean|pid),REML=FALSE,data=subdata)
itemInfo_rsadiff.null <- lmer(dLOC_rsadiff~dLOC_actmean+(1+SMG_rsadiff+dLOC_actmean|subid)+(1+SMG_rsadiff+dLOC_actmean|pid),REML=FALSE,data=subdata)
itemInfo_rsaD <- lmer(dLOC_rsadiff~SMG_rsaD+dLOC_actmean+(1+SMG_rsaD+dLOC_actmean|subid)+(1+SMG_rsaD+dLOC_actmean|pid),REML=FALSE,data=subdata)
itemInfo_rsaD.null <- lmer(dLOC_rsadiff~dLOC_actmean+(1+SMG_rsaD+dLOC_actmean|subid)+(1+SMG_rsaD+dLOC_actmean|pid),REML=FALSE,data=subdata)

itemInfo_actmeanD <- lmer(dLOC_rsaD~SMG_actmean+dLOC_actmean+(1+SMG_actmean+dLOC_actmean|subid)+(1+SMG_actmean+dLOC_actmean|pid),REML=FALSE,data=subdata)
itemInfo_actmeanD.null <- lmer(dLOC_rsaD~dLOC_actmean+(1+SMG_actmean+dLOC_actmean|subid)+(1+SMG_actmean+dLOC_actmean|pid),REML=FALSE,data=subdata)
itemInfo_actrepD <- lmer(dLOC_rsaD~SMG_actrep+dLOC_actmean+(1+SMG_actrep+dLOC_actmean|subid)+(1+SMG_actrep+dLOC_actmean|pid),REML=FALSE,data=subdata)
itemInfo_actrepD.null <- lmer(dLOC_rsaD~dLOC_actmean+(1+SMG_actrep+dLOC_actmean|subid)+(1+SMG_actrep+dLOC_actmean|pid),REML=FALSE,data=subdata)
itemInfo_rsadiffD <- lmer(dLOC_rsaD~SMG_rsadiff+dLOC_actmean+(1+SMG_rsadiff+dLOC_actmean|subid)+(1+SMG_rsadiff+dLOC_actmean|pid),REML=FALSE,data=subdata)
itemInfo_rsadiffD.null <- lmer(dLOC_rsaD~dLOC_actmean+(1+SMG_rsadiff+dLOC_actmean|subid)+(1+SMG_rsadiff+dLOC_actmean|pid),REML=FALSE,data=subdata)
itemInfo_rsaDD <- lmer(dLOC_rsaD~SMG_rsaD+dLOC_actmean+(1+SMG_rsaD+dLOC_actmean|subid)+(1+SMG_rsaD+dLOC_actmean|pid),REML=FALSE,data=subdata)
itemInfo_rsaDD.null <- lmer(dLOC_rsaD~dLOC_actmean+(1+SMG_rsaD+dLOC_actmean|subid)+(1+SMG_rsaD+dLOC_actmean|pid),REML=FALSE,data=subdata)

mainEffect.itemInfo_actmean <- anova(itemInfo_actmean,itemInfo_actmean.null)
mainEffect.itemInfo_actrep <- anova(itemInfo_actrep,itemInfo_actrep.null)
mainEffect.itemInfo_rsadiff <- anova(itemInfo_rsadiff,itemInfo_rsadiff.null)
mainEffect.itemInfo_rsaD <- anova(itemInfo_rsaD,itemInfo_rsaD.null)
mainEffect.itemInfo_actmeanD <- anova(itemInfo_actmeanD,itemInfo_actmeanD.null)
mainEffect.itemInfo_actrepD <- anova(itemInfo_actrepD,itemInfo_actrepD.null)
mainEffect.itemInfo_rsadiffD <- anova(itemInfo_rsadiffD,itemInfo_rsadiffD.null)
mainEffect.itemInfo_rsaDD <- anova(itemInfo_rsaDD,itemInfo_rsaDD.null)
r.itemInfo[1,1]=mainEffect.itemInfo_actmean[2,6]
r.itemInfo[1,2]=mainEffect.itemInfo_actmean[2,7]
r.itemInfo[1,3]=mainEffect.itemInfo_actmean[2,8]
r.itemInfo[1,4]=fixef(itemInfo_actmean)[2];
r.itemInfo[2,1]=mainEffect.itemInfo_actrep[2,6]
r.itemInfo[2,2]=mainEffect.itemInfo_actrep[2,7]
r.itemInfo[2,3]=mainEffect.itemInfo_actrep[2,8]
r.itemInfo[2,4]=fixef(itemInfo_actrep)[2];
r.itemInfo[3,1]=mainEffect.itemInfo_rsadiff[2,6]
r.itemInfo[3,2]=mainEffect.itemInfo_rsadiff[2,7]
r.itemInfo[3,3]=mainEffect.itemInfo_rsadiff[2,8]
r.itemInfo[3,4]=fixef(itemInfo_rsadiff)[2];
r.itemInfo[4,1]=mainEffect.itemInfo_rsaD[2,6]
r.itemInfo[4,2]=mainEffect.itemInfo_rsaD[2,7]
r.itemInfo[4,3]=mainEffect.itemInfo_rsaD[2,8]
r.itemInfo[4,4]=fixef(itemInfo_rsaD)[2];

r.itemInfo[5,1]=mainEffect.itemInfo_actmeanD[2,6]
r.itemInfo[5,2]=mainEffect.itemInfo_actmeanD[2,7]
r.itemInfo[5,3]=mainEffect.itemInfo_actmeanD[2,8]
r.itemInfo[5,4]=fixef(itemInfo_actmeanD)[2];
r.itemInfo[6,1]=mainEffect.itemInfo_actrepD[2,6]
r.itemInfo[6,2]=mainEffect.itemInfo_actrepD[2,7]
r.itemInfo[6,3]=mainEffect.itemInfo_actrepD[2,8]
r.itemInfo[6,4]=fixef(itemInfo_actrepD)[2];
r.itemInfo[7,1]=mainEffect.itemInfo_rsadiffD[2,6]
r.itemInfo[7,2]=mainEffect.itemInfo_rsadiffD[2,7]
r.itemInfo[7,3]=mainEffect.itemInfo_rsadiffD[2,8]
r.itemInfo[7,4]=fixef(itemInfo_rsadiffD)[2];
r.itemInfo[8,1]=mainEffect.itemInfo_rsaDD[2,6]
r.itemInfo[8,2]=mainEffect.itemInfo_rsaDD[2,7]
r.itemInfo[8,3]=mainEffect.itemInfo_rsaDD[2,8]
r.itemInfo[8,4]=fixef(itemInfo_rsaDD)[2];
write.matrix(r.itemInfo,file="itemInfo_dLOC_SMG.txt",sep="\t")
