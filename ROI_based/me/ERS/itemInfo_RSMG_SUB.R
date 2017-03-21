#!usr/bin/env Rscript
library(methods)
library(Matrix)
library(MASS)
#library(Rcpp)
library(lme4)
# Read in your data as an R dataframe
basedir <- c("/seastor/helenhelen/ISR_2015")
resultdir <- paste(basedir,"/me/tmap/results/ERS",sep="/")
setwd(resultdir)
r.itemInfo <- matrix(data=NA, nr=2, nc=4)
## read data
#get data for each trial
item_file <- paste(basedir,"/me/tmap/data/item/ERS.txt",sep="")
item_data <- read.table(item_file,header=FALSE)
load(paste("/home/helenhelen/DQ/project/gitrepo/ISR_2015/ROI_based/me/col_names_ERS.Rda",sep=""))
colnames(item_data) <- col_names 
item_data$subid <- as.factor(item_data$subid)
item_data$pid <- as.factor(item_data$pid)

subdata <- item_data
itemInfo_actmean <- lmer(RSMG_rsadiff~SUB_actmean+(1+SUB_actmean|subid),REML=FALSE,data=subdata)
itemInfo_actmean.null <- lmer(RSMG_rsadiff~1+(1+SUB_actmean|subid),REML=FALSE,data=subdata)
itemInfo_di <- lmer(RSMG_rsadiff~SUB_actmean+(1+SUB_rsadiff|subid),REML=FALSE,data=subdata)
itemInfo_di.null <- lmer(RSMG_rsadiff~1+(1+SUB_rsadiff|subid),REML=FALSE,data=subdata)

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
write.matrix(r.itemInfo,file="itemInfso_RSMG_SUB.txt",sep="\t")
