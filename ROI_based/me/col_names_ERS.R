#!usr/bin/env Rscript
col_names <- c("subid","pid",
"LVVC_actln1","LVVC_actln2","LVVC_actmem1","LVVC_actmem2","LVVC_rsaD","LVVC_rsaDBwc","LVVC_ln_actmean","LVVC_actmean","LVVC_rsadiff",
"LANG_actln1","LANG_actln2","LANG_actmem1","LANG_actmem2","LANG_rsaD","LANG_rsaDBwc","LANG_ln_actmean","LANG_actmean","LANG_rsadiff",
"LSMG_actln1","LSMG_actln2","LSMG_actmem1","LSMG_actmem2","LSMG_rsaD","LSMG_rsaDBwc","LSMG_ln_actmean","LSMG_actmean","LSMG_rsadiff",
"LIFG_actln1","LIFG_actln2","LIFG_actmem1","LIFG_actmem2","LIFG_rsaD","LIFG_rsaDBwc","LIFG_ln_actmean","LIFG_actmean","LIFG_rsadiff",
"LMFG_actln1","LMFG_actln2","LMFG_actmem1","LMFG_actmem2","LMFG_rsaD","LMFG_rsaDBwc","LMFG_ln_actmean","LMFG_actmean","LMFG_rsadiff",
"RVVC_actln1","RVVC_actln2","RVVC_actmem1","RVVC_actmem2","RVVC_rsaD","RVVC_rsaDBwc","RVVC_ln_actmean","RVVC_actmean","RVVC_rsadiff",
"RANG_actln1","RANG_actln2","RANG_actmem1","RANG_actmem2","RANG_rsaD","RANG_rsaDBwc","RANG_ln_actmean","RANG_actmean","RANG_rsadiff",
"RSMG_actln1","RSMG_actln2","RSMG_actmem1","RSMG_actmem2","RSMG_rsaD","RSMG_rsaDBwc","RSMG_ln_actmean","RSMG_actmean","RSMG_rsadiff",
"RIFG_actln1","RIFG_actln2","RIFG_actmem1","RIFG_actmem2","RIFG_rsaD","RIFG_rsaDBwc","RIFG_ln_actmean","RIFG_actmean","RIFG_rsadiff",
"RMFG_actln1","RMFG_actln2","RMFG_actmem1","RMFG_actmem2","RMFG_rsaD","RMFG_rsaDBwc","RMFG_ln_actmean","RMFG_actmean","RMFG_rsadiff",
"LaPHG_actln1","LaPHG_actln2","LaPHG_actmem1","LaPHG_actmem2","LaPHG_rsaD","LaPHG_rsaDBwc","LaPHG_ln_actmean","LaPHG_actmean","LaPHG_rsadiff",
"LpPHG_actln1","LpPHG_actln2","LpPHG_actmem1","LpPHG_actmem2","LpPHG_rsaD","LpPHG_rsaDBwc","LpPHG_ln_actmean","LpPHG_actmean","LpPHG_rsadiff",
"RaPGH_actln1","RaPGH_actln2","RaPGH_actmem1","RaPGH_actmem2","RaPGH_rsaD","RaPGH_rsaDBwc","RaPHG_ln_actmean","RaPHG_actmean","RaPHG_rsadiff",
"RpPHG_actln1","RpPHG_actln2","RpPHG_actmem1","RpPHG_actmem2","RpPHG_rsaD","RpPHG_rsaDBwc","RpPHG_ln_actmean","RpPHG_actmean","RpPHG_rsadiff",
"HIP_actln1","HIP_actln2","HIP_actmem1","HIP_actmem2","HIP_rsaD","HIP_rsaDBwc","HIP_ln_actmean","HIP_actmean","HIP_rsadiff",
"CA1_actln1","CA1_actln2","CA1_actmem1","CA1_actmem2","CA1_rsaD","CA1_rsaDBwc","CA1_ln_actmean","CA1_actmean","CA1_rsadiff",
"CA2_actln1","CA2_actln2","CA2_actmem1","CA2_actmem2","CA2_rsaD","CA2_rsaDBwc","CA2_ln_actmean","CA2_actmean","CA2_rsadiff",
"DG_actln1","DG_actln2","DG_actmem1","DG_actmem2","DG_rsaD","DG_rsaDBwc","DG_ln_actmean","DG_actmean","DG_rsadiff",
"CA3_actln1","CA3_actln2","CA3_actmem1","CA3_actmem2","CA3_rsaD","CA3_rsaDBwc","CA3_ln_actmean","CA3_actmean","CA3_rsadiff",
"SUB_actln1","SUB_actln2","SUB_actmem1","SUB_actmem2","SUB_rsaD","SUB_rsaDBwc","SUB_ln_actmean","SUB_actmean","SUB_rsadiff",
"ERC_actln1","ERC_actln2","ERC_actmem1","ERC_actmem2","ERC_rsaD","ERC_rsaDBwc","ERC_ln_actmean","ERC_actmean","ERC_rsadiff",
"PRC_actln1","PRC_actln2","PRC_actmem1","PRC_actmem2","PRC_rsaD","PRC_rsaDBwc","PRC_ln_actmean","PRC_actmean","PRC_rsadiff",
"pPHG_actln1","pPHG_actln2","pPHG_actmem1","pPHG_actmem2","pPHG_rsaD","pPHG_rsaDBwc","pPHG_ln_actmean","pPHG_actmean","pPHG_rsadiff")
save(col_names,file=paste("col_names_ERS.Rda",sep=""))
