#!usr/bin/env Rscript
library(methods)
library(Matrix)
library(MASS)
library(Rcpp)
library(lme4)
#
#roi_name={'p90','p90','dLOC',...
#>---'CA1','SMG','IFG','HIP',...
#>---'CA1','CA2','DG','CA3','subiculum','ERC'};
# Read in your data as an R dataframe
basedir <- c("/seastor/helenhelen/ISR_2015")
resultdir <- paste(basedir,"/me/results/mem_cact_unique",sep="/")
setwd(resultdir)
r.itemInfo <- matrix(data=NA, nr=2, nc=4)
## read data
#get data for each trial
item_file <- paste(basedir,"/me/data/item/mem.txt",sep="")
item_data <- read.table(item_file,header=FALSE)
colnames(item_data) <- c("subid","pid",
"p90_act1","p90_act2","p90_actmean","p90_rsaD","p90_rsaDBwc","p90_rsadiff",
"p95_act1","p95_act2","p95_actmean","p95_rsaD","p95_rsaDBwc","p95_rsadiff",
"VVC_act1","VVC_act2","VVC_actmean","VVC_rsaD","VVC_rsaDBwc","VVC_rsadiff",
"dLOC_act1","dLOC_act2","dLOC_actmean","dLOC_rsaD","dLOC_rsaDBwc","dLOC_rsadiff",
"IPL_act1","IPL_act2","IPL_actmean","IPL_rsaD","IPL_rsaDBwc","IPL_rsadiff",
"IFG_act1","IFG_act2","IFG_actmean","IFG_rsaD","IFG_rsaDBwc","IFG_rsadiff",
"HIP_act1","HIP_act2","HIP_actmean","HIP_rsaD","HIP_rsaDBwc","HIP_rsadiff",
"CA1_act1","CA1_act2","CA1_actmean","CA1_rsaD","CA1_rsaDBwc","CA1_rsadiff",
"CA2_act1","CA2_act2","CA2_actmean","CA2_rsaD","CA2_rsaDBwc","CA2_rsadiff",
"DG_act1","DG_act2","DG_actmean","DG_rsaD","DG_rsaDBwc","DG_rsadiff",
"CA3_act1","CA3_act2","CA3_actmean","CA3_rsaD","CA3_rsaDBwc","CA3_rsadiff",
"subiculum_act1","subiculum_act2","subiculum_actmean","subiculum_rsaD","subiculum_rsaDBwc","subiculum_rsadiff",
"ERC_act1","ERC_act2","ERC_actmean","ERC_rsaD","ERC_rsaDBwc","ERC_rsadiff",
"aPHG_act1","aPHG_act2","aPHG_actmean","aPHG_rsaD","aPHG_rsaDBwc","aPHG_rsadiff",
"pPHG_act1","pPHG_act2","pPHG_actmean","pPHG_rsaD","pPHG_rsaDBwc","pPHG_rsadiff")
item_data$subid <- as.factor(item_data$subid)
item_data$pid <- as.factor(item_data$pid)

subdata <- item_data
itemInfo_actmean <- lmer(p90_rsadiff~CA1_actmean+CA1_rsadiff+(1+CA1_actmean+CA1_rsadiff|subid)+(1+CA1_actmean+CA1_rsadiff|pid),REML=FALSE,data=subdata)
itemInfo_actmean.null <- lmer(p90_rsadiff~CA1_rsadiff+(1+CA1_actmean+CA1_rsadiff|subid)+(1+CA1_actmean+CA1_rsadiff|pid),REML=FALSE,data=subdata)
itemInfo_rsadiff <- lmer(p90_rsadiff~CA1_rsadiff+CA1_actmean+(1+CA1_rsadiff+CA1_actmean|subid)+(1+CA1_rsadiff+CA1_actmean|pid),REML=FALSE,data=subdata)
itemInfo_rsadiff.null <- lmer(p90_rsadiff~CA1_actmean+(1+CA1_rsadiff+CA1_actmean|subid)+(1+CA1_rsadiff+CA1_actmean|pid),REML=FALSE,data=subdata)

mainEffect.itemInfo_actmean <- anova(itemInfo_actmean,itemInfo_actmean.null)
mainEffect.itemInfo_rsadiff <- anova(itemInfo_rsadiff,itemInfo_rsadiff.null)
r.itemInfo[1,1]=mainEffect.itemInfo_actmean[2,6]
r.itemInfo[1,2]=mainEffect.itemInfo_actmean[2,7]
r.itemInfo[1,3]=mainEffect.itemInfo_actmean[2,8]
r.itemInfo[1,4]=fixef(itemInfo_actmean)[2];
r.itemInfo[2,1]=mainEffect.itemInfo_rsadiff[2,6]
r.itemInfo[2,2]=mainEffect.itemInfo_rsadiff[2,7]
r.itemInfo[2,3]=mainEffect.itemInfo_rsadiff[2,8]
r.itemInfo[2,4]=fixef(itemInfo_rsadiff)[2];
write.matrix(r.itemInfo,file="itemInfo_p90_CA1.txt",sep="\t")