# set working directory
setwd("~/Desktop")
maindir <- getwd()
datadir <- file.path("~/Desktop/")

# load packages
library("readxl")
library("ggplot2")
library("ggpubr")
library("reshape2")
library("emmeans")
library("hrbrthemes")
library("umx")
library("interactions")
library("car")

# import covariates
covariates <- read_excel("C:/Users/tul03789/Documents/GitHub/UGDG_Analysis/code/final_output_composite.xls")

usedir = "C:/Users/tul03789/Documents/GitHub/UGDG_Analysis/derivatives/imaging_plots/"
ROI= "seed-ACC_50_thr" #seed-vmPFC-5mm-thr_ seed-NAcc_ seed-dlPFC-thr 
type = "_type-ppi_seed-NAcc_" # type-ppi_seed-NAcc_"
covariate = "cov-COMPOSITE_"
model = "model-GLM3_noINT_" # add noINT for no interactions

#import ROIs.

# 7,8,9 = Endowment Phase
# 14,15,16 = Decision Phase

DGP <- read.table(paste(usedir, ROI, type, covariate, model, "cope-07.txt", sep = ""))
UGP <- read.table(paste(usedir, ROI, type, covariate, model, "cope-08.txt", sep = ""))
UGR <- read.table(paste(usedir, ROI, type, covariate, model, "cope-09.txt", sep = ""))

colnames(DGP)[1] <- "DGP"
colnames(UGP)[1] <- "UGP"
colnames(UGR)[1] <- "UGR"

model_test1 = cbind(covariates,DGP)
model_test2 = cbind(covariates,UGP)
model_test3 = cbind(covariates,UGR)

#+ Composite_SubstanceXReward + Composite_SubstanceXReward_Squared
model1 <- lm(DGP ~ Strategic_Behavior + Composite_Substance + Composite_Reward + Composite_Reward_Squared + Composite_SubstanceXReward + Composite_SubstanceXReward_Squared, data=model_test1)
summary(model1)
crPlots(model1, smooth=FALSE)

model2 <- lm(UGP ~ Strategic_Behavior + Composite_Substance + Composite_Reward + Composite_Reward_Squared + Composite_SubstanceXReward + Composite_SubstanceXReward_Squared, data=model_test2)
summary(model2)
crPlots(model2, smooth=FALSE)

model3 <- lm(UGR ~ Strategic_Behavior + Composite_Substance + Composite_Reward + Composite_Reward_Squared + Composite_SubstanceXReward + Composite_SubstanceXReward_Squared, data=model_test3)
summary(model3)
crPlots(model3, smooth=FALSE)

