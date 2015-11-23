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
roi_name <- c('LHIP','LpPHG','LdLOC')

r.vvc_itemInfo <- matrix(data=NA, nr=length(roi_name), nc=3)
## read data
#get data for each trial
item_file <- paste(basedir,"/me/data/item/ln.txt",sep="")
item_data <- read.table(item_file,header=FALSE)
colnames(item_data) <- c("subid","roi",
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



