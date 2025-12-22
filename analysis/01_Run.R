# analysis/01_run.R

if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(mada, dmetatools, metafor, MVPBT, tidyverse)

dir.create("outputs", showWarnings = FALSE)

df <- readr::read_csv("data/data_CAR_DTA.csv", show_col_types = FALSE)

# Summary
DTA_summary <- mada::madad(df)
print(DTA_summary)
capture.output(DTA_summary, file = "outputs/madad_summary.txt")

# Forest: sensitivity
pdf("outputs/forest_sens.pdf", width = 8, height = 10)
forest(mada::madad(df), type = "sens", xlab = "sensitivity", snames = df$study)
dev.off()

# Forest: specificity
pdf("outputs/forest_spec.pdf", width = 8, height = 10)
forest(mada::madad(df), type = "spec", xlab = "specificity", snames = df$study)
dev.off()

# Reitsma model
bm1 <- reitsma(df)
sum_bm1 <- summary(bm1)
print(sum_bm1)
capture.output(sum_bm1, file = "outputs/reitsma_summary.txt")

# AUC (bootstrap) — 再現性を厳密にするなら seed を有効化
# set.seed(1)
auc_res <- AUC_boot(df$TP, df$FP, df$FN, df$TN)
print(auc_res)
capture.output(auc_res, file = "outputs/auc_boot.txt")

# LR+ / LR-
res_LR <- summary(SummaryPts(bm1))
print(res_LR)
capture.output(res_LR, file = "outputs/summary_points_LR.txt")

# Publication bias (Generalized Egger) — attach()を使わずに書く
dta1 <- edta(df$TP, df$FN, df$TN, df$FP)
res1 <- rma(dta1$y[,1], dta1$S[,1])
res2 <- rma(dta1$y[,2], dta1$S[,3])
mvp <- MVPBT3(dta1$y, dta1$S)

print(mvp)
capture.output(mvp, file = "outputs/MVPBT3_generalized_egger.txt")

sink("outputs/sessionInfo.txt")
print(sessionInfo())
sink()

message("Done. Check outputs/.")

