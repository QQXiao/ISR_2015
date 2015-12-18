#!usr/bin/env Rscript
library(methods)
library(Matrix)
library(MASS)
library(Rcpp)
library(lme4)
# Read in your data as an R dataframe
basedir <- c("/seastor/helenhelen/ISR_2015")
resultdir <- paste(basedir,"/me/results/pspc",sep="/")
setwd(resultdir)
r.itemInfo <- matrix(data=NA, nr=2, nc=4)
## read data
#get data for each trial
item_file <- paste(basedir,"/me/data/item/ERS.txt",sep="")
item_data <- read.table(item_file,header=FALSE)
colnames(item_data) <- c("subid","pid",
"VVC_actln1","VVC_actln2","VVC_actmem1","VVC_actmem2","VVC_rsaI","VVC_rsaIBall","VVC_rsaIBwc","VVC_rsaD","VVC_rsaDBall","VVC_rsaDBwc",
"dLOC_actln1","dLOC_actln2","dLOC_actmem1","dLOC_actmem2","dLOC_rsaI","dLOC_rsaIBall","dLOC_rsaIBwc","dLOC_rsaD","dLOC_rsaDBall","dLOC_rsaDBwc",
"IPL_actln1","IPL_actln2","IPL_actmem1","IPL_actmem2","IPL_rsaI","IPL_rsaIBall","IPL_rsaIBwc","IPL_rsaD","IPL_rsaDBall","IPL_rsaDBwc",
"IFG_actln1","IFG_actln2","IFG_actmem1","IFG_actmem2","IFG_rsaI","IFG_rsaIBall","IFG_rsaIBwc","IFG_rsaD","IFG_rsaDBall","IFG_rsaDBwc",
"HIP_actln1","HIP_actln2","HIP_actmem1","HIP_actmem2","HIP_rsaI","HIP_rsaIBall","HIP_rsaIBwc","HIP_rsaD","HIP_rsaDBall","HIP_rsaDBwc",
"CA1_actln1","CA1_actln2","CA1_actmem1","CA1_actmem2","CA1_rsaI","CA1_rsaIBall","CA1_rsaIBwc","CA1_rsaD","CA1_rsaDBall","CA1_rsaDBwc",
"CA2_actln1","CA2_actln2","CA2_actmem1","CA2_actmem2","CA2_rsaI","CA2_rsaIBall","CA2_rsaIBwc","CA2_rsaD","CA2_rsaDBall","CA2_rsaDBwc",
"DG_actln1","DG_actln2","DG_actmem1","DG_actmem2","DG_rsaI","DG_rsaIBall","DG_rsaIBwc","DG_rsaD","DG_rsaDBall","DG_rsaDBwc",
"CA3_actln1","CA3_actln2","CA3_actmem1","CA3_actmem2","CA3_rsaI","CA3_rsaIBall","CA3_rsaIBwc","CA3_rsaD","CA3_rsaDBall","CA3_rsaDBwc",
"subiculum_actln1","subiculum_actln2","subiculum_actmem1","subiculum_actmem2","subiculum_rsaI","subiculum_rsaIBall","subiculum_rsaIBwc","subiculum_rsaD","subiculum_rsaDBall","subiculum_rsaDBwc",
"ERC_actln1","ERC_actln2","ERC_actmem1","ERC_actmem2","ERC_rsaI","ERC_rsaIBall","ERC_rsaIBwc","ERC_rsaD","ERC_rsaDBall","ERC_rsaDBwc",
"aPHG_actln1","aPHG_actln2","aPHG_actmem1","aPHG_actmem2","aPHG_rsaI","aPHG_rsaIBall","aPHG_rsaIBwc","aPHG_rsaD","aPHG_rsaDBall","aPHG_rsaDBwc",
"pPHG_actln1","pPHG_actln2","pPHG_actmem1","pPHG_actmem2","pPHG_rsaI","pPHG_rsaIBall","pPHG_rsaIBwc","pPHG_rsaD","pPHG_rsaDBall","pPHG_rsaDBwc")

item_data$subid <- as.factor(item_data$subid)
item_data$pid <- as.factor(item_data$pid)

subdata <- cbind(item_data$subid,item_data$pid,item_data$DG_rsaI,item_data$DG_rsaI
itemInfo_rsaI <- lmer(IPL_rsa~CA1_rsadiff+CA1_actmean+(1+CA1_rsadiff+CA1_actmean|subid)+(1+CA1_rsadiff+CA1_actmean|pid),REML=FALSE,data=subdata)
itemInfo_rsadiff.null <- lmer(p90_rsadiff~CA1_actmean+(1+CA1_rsadiff+CA1_actmean|subid)+(1+CA1_rsadiff+CA1_actmean|pid),REML=FALSE,data=subdata)

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
