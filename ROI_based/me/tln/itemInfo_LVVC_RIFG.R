#!usr/bin/env Rscript
library(methods)
library(Matrix)
library(MASS)
#library(Rcpp)
library(lme4)
# Read in your data as an R dataframe
basedir <- c("/seastor/helenhelen/ISR_2015")
resultdir <- paste(basedir,"/me/results/mem",sep="/")
setwd(resultdir)
r.itemInfo <- matrix(data=NA, nr=2, nc=4)
## read data
#get data for each trial
item_file <- paste(basedir,"/me/tmap/data/item/mem.txt",sep="")
item_data <- read.table(item_file,header=FALSE)
colnames(item_data) <- c("subid","pid",
"p97_act1","p97_act2","p97_actmean","p97_rsaD","p97_rsaDBwc","p97_rsadiff",
"LVVC_act1","LVVC_act2","LVVC_actmean","LVVC_rsaD","LVVC_rsaDBwc","LVVC_rsadiff",
"LANG_act1","LANG_act2","LANG_actmean","LANG_rsaD","LANG_rsaDBwc","LANG_rsadiff",
"LSMG_act1","LSMG_act2","LSMG_actmean","LSMG_rsaD","LSMG_rsaDBwc","LSMG_rsadiff",
"LIFG_act1","LIFG_act2","LIFG_actmean","LIFG_rsaD","LIFG_rsaDBwc","LIFG_rsadiff",
"RVVC_act1","RVVC_act2","RVVC_actmean","RVVC_rsaD","RVVC_rsaDBwc","RVVC_rsadiff",
"RANG_act1","RANG_act2","RANG_actmean","RANG_rsaD","RANG_rsaDBwc","RANG_rsadiff",
"RSMG_act1","RSMG_act2","RSMG_actmean","RSMG_rsaD","RSMG_rsaDBwc","RSMG_rsadiff",               
"RIFG_act1","RIFG_act2","RIFG_actmean","RIFG_rsaD","RIFG_rsaDBwc","RIFG_rsadiff",               
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
itemInfo_actmean <- lmer(LVVC_rsadiff~RIFG_actmean+(1+RIFG_actmean|subid)+(1+RIFG_actmean|pid),REML=FALSE,data=subdata)
itemInfo_actmean.null <- lmer(LVVC_rsadiff~1+(1+RIFG_actmean|subid)+(1+RIFG_actmean|pid),REML=FALSE,data=subdata)
itemInfo_di <- lmer(LVVC_rsadiff~RIFG_actmean+(1+RIFG_rsadiff|subid)+(1+RIFG_rsadiff|pid),REML=FALSE,data=subdata)
itemInfo_di.null <- lmer(LVVC_rsadiff~1+(1+RIFG_rsadiff|subid)+(1+RIFG_rsadiff|pid),REML=FALSE,data=subdata)

mainEffect.itemInfo_actmean <- anova(itemInfo_actmean,itemInfo_actmean.null)
r.itemInfo[1,1]=mainEffect.itemInfo_actmean[2,6]
r.itemInfo[1,2]=mainEffect.itemInfo_actmean[2,7]
r.itemInfo[1,3]=mainEffect.itemInfo_actmean[2,8]
r.itemInfo[1,4]=fixef(itemInfo_actmean)[2];
mainEffect.itemInfo_di <- anova(itemInfo_di,itemInfo_di.null)
r.itemInfo[2,1]=mainEffect.itemInfo_di[2,6]
r.itemInfo[2,2]=mainEffect.itemInfo_di[2,7]
r.itemInfo[2,3]=mainEffect.itemInfo_di[2,8]
r.itemInfo[2,4]=fixef(itemInfo_di)[2];
write.matrix(r.itemInfo,file="itemInfso_LVVC_RIFG.txt",sep="\t")
