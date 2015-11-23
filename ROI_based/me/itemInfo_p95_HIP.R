#!usr/bin/env Rscript
library(methods)
library(Matrix)
library(MASS)
library(Rcpp)
library(lme4)
library(MBESS)
# Read in your data as an R dataframe
basedir <- c("/seastor/helenhelen/ISR_2015")
resultdir <- paste(basedir,"me/result/ln",sep="/")
r.itemInfo <- matrix(data=NA, nr=4, nc=4)
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

subdata=item_data
#subdata=cbind(item_data$subid,item_data$pid,
#           item_data$p95_act1,item_data$p95_act2,item_data$p95_actmean,
#           item_data$p95_rsaD,item_data$p95_rsaDBwc,item_data$p95_rsadiff,
#           item_data$HIP_act1,item_data$HIP_act2,item_data$HIP_actmean,
#           item_data$HIP_rsaD,item_data$HIP_rsaDBwc,item_data$HIP_rsadiff)
subdata$HIP_actrep <- item_data$$HIP_act1-item_data$HIP_act2
itemInfo_actmean <- lmer(p95_rsadiff~HIP_actmean+(1+HIP_actmean|subid)+(1+HIP_actmean|pid),REML=FALSE,data=subdata)
itemInfo_actmean.null <- lmer(p95_rsadiff~1+(1+HIP_actmean|subid)+(1+HIP_actmean|pid),REML=FALSE,data=subdata)
itemInfo_actrep <- lmer(p95_rsadiff~HIP_actrep+(1+HIP_actrep|subid)+(1+HIP_actrep|pid),REML=FALSE,data=subdata)
itemInfo_actrep.null <- lmer(p95_rsadiff~1+(1+HIP_actrep|subid)+(1+HIP_actrep|pid),REML=FALSE,data=subdata)
itemInfo_rsadiff <- lmer(p95_rsadiff~HIP_rsadiff+(1+HIP_rsadiff|subid)+(1+HIP_rsadiff|pid),REML=FALSE,data=subdata)
itemInfo_rsadiff.null <- lmer(p95_rsadiff~1+(1+HIP_rsadiff|subid)+(1+HIP_rsadiff|pid),REML=FALSE,data=subdata)
itemInfo_rsaD <- lmer(p95_rsaD~HIP_rsaD+(1+HIP_rsaD|subid)+(1+HIP_rsaD|pid),REML=FALSE,data=subdata)
itemInfo_rsaD.null <- lmer(p95_rsaD~1+(1+HIP_rsaD|subid)+(1+HIP_rsaD|pid),REML=FALSE,data=subdata)
mainEffect.itemInfo_actmean <- anova(itemInfo_actmean,itemInfo_actmean.null)
mainEffect.itemInfo_actrep <- anova(itemInfo_actrep,itemInfo_actrep.null)
mainEffect.itemInfo_rsadiff <- anova(itemInfo_rsadiff,itemInfo_rsadiff.null)
mainEffect.itemInfo_rsaD <- anova(itemInfo_rsaD,itemInfo_rsaD.null)
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
write.matrix(r.itemInfo,file="itemInfo_p95_HIP.txt",sep="\t")
