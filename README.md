# CAR_DTAmeta

Reproducible code and extracted study-level dataset for a diagnostic test accuracy meta-analysis of CAR.

## Files
- `data/data_CAR_DTA.csv`: extracted 2x2 table data (TP/FP/FN/TN) with study labels
- `analysis/01_run.R`: entry script to reproduce analyses and outputs

## How to reproduce
In R (or RStudio), run:

```r
source("analysis/01_run.R")
