# =============================================================================
# Meta-analysis of weight loss prior to pancreatic cancer diagnosis
# Random- and fixed-effects pooling, forest/funnel/Baujat plots,
# publication bias check (Egger's test), and leave-one-out sensitivity analysis
# =============================================================================

library(here)
library(dplyr)
library(tidyverse)
library(metafor)
library(metaviz)

# -----------------------------------------------------------------------------
# Read in data
# -----------------------------------------------------------------------------
# Expects "WeightLosskg.csv" in the project root (see here::here())
WeightLoss <- read.csv(here("WeightLosskg.csv"), encoding = "UTF-8")

# -----------------------------------------------------------------------------
# Select the relevant cohort for analysis
# -----------------------------------------------------------------------------
# Studies report diabetes status for their cohort(s) as one or more of:
# "mixed" (combined sample), "yes" (diabetic subgroup), "no" (non-diabetic
# subgroup), or "unknown" (diabetes status not reported/determinable).
# Some studies report BOTH a "mixed" row and "yes"/"no" subgroup rows for the
# same underlying sample. To avoid double-counting participants, for any
# study (identified by Author + Year) that has a "mixed" row, we keep only
# that row and drop its "yes"/"no" rows. Studies with no "mixed" row keep all
# of their "yes"/"no" rows as-is, since there is no overlap to remove.
# "unknown" rows are always retained regardless of what else the study
# reports, as diabetes status is simply not a distinguishing factor for them.
WeightLoss <- WeightLoss %>%
  mutate(StudyID = paste0(Author, "_", Year))

studies_with_mixed <- WeightLoss %>%
  filter(DiabetesCohort == "mixed") %>%
  pull(StudyID) %>%
  unique()

WeightAnalysisSet <- WeightLoss %>%
  filter(
    DiabetesCohort == "mixed" |
      DiabetesCohort == "unknown" |
      (DiabetesCohort %in% c("yes", "no") & !(StudyID %in% studies_with_mixed))
  )


# Convert weight loss to a negative number (loss is recorded as negative)
WeightAnalysisSet <- WeightAnalysisSet %>%
  mutate(WeightLosskg = WeightLosskg * -1)

# -----------------------------------------------------------------------------
# Compute effect sizes
# -----------------------------------------------------------------------------
# Effect size = raw mean (MN), using each study's mean, SD, and sample size
WeightOutcomeMeasure <- escalc(
  measure = "MN",
  mi = WeightLosskg,
  sdi = SD,
  ni = SampleSize,
  data = WeightAnalysisSet
)

# -----------------------------------------------------------------------------
# Meta-analytic pooling
# -----------------------------------------------------------------------------
# Random-effects model (primary model; allows for between-study heterogeneity)
WeightRandomEffects <- rma(
  yi = yi, vi = vi, data = WeightOutcomeMeasure,
  measure = "MN", slab = paste0(Author, " ", Year)
)

# Fixed-effects model (reported alongside for comparison)
WeightFixedEffects <- rma(
  yi = yi, vi = vi, data = WeightOutcomeMeasure,
  measure = "MN", method = "FE", slab = paste0(Author, " ", Year)
)

# -----------------------------------------------------------------------------
# Forest plot (random-effects, with fixed-effects summary added)
# -----------------------------------------------------------------------------
tiff(
  file = here("WeightLossRandomForest.tiff"),
  width = 21, height = 15, units = "cm", res = 300
)

par(mar = c(4, 1, 1, 1))

# Helper to format the summary line (Q statistic, I^2, tau^2) under each model
mlabfun <- function(text, x) {
  list(bquote(paste(.(text),
    " (Q = ", .(fmtx(x$QE, digits = 2)),
    ", df = ", .(x$k - x$p), ", ",
    .(fmtp2(x$QEp)), "; ",
    I^2, " = ", .(fmtx(x$I2, digits = 1)), "%, ",
    tau^2, " = ", .(fmtx(x$tau2, digits = 2)), ")"
  )))
}

forest(WeightRandomEffects,
  top = 4,
  cex = 0.75,
  xlab = expression(Mean ~ Weight ~ Loss ~ (kg)),
  mlab = mlabfun("RE Model for All Studies", WeightRandomEffects),
  header = FALSE,
  xlim = c(-25, 5),
  ylim = c(-3, 24)
)

# Column headers
op <- par(cex = 0.75)
text(-25, 22, "Author(s) and Year", pos = 4, font = 2, cex = 1)
text(5.1, 22, "Weight Loss [95% CI]", pos = 2, font = 2, cex = 1)
par(op)

# Add fixed-effects summary as an additional polygon on the same plot
addpoly(WeightFixedEffects, row = -2, mlab = mlabfun("FE Model for All Studies", WeightFixedEffects))

dev.off()

# -----------------------------------------------------------------------------
# Publication bias and heterogeneity diagnostics
# -----------------------------------------------------------------------------

# Funnel plot: checks for asymmetry suggestive of publication/small-study bias
WeightFunnelRandom <- funnel(
  WeightRandomEffects,
  level = c(90, 95, 99),
  shade = c("white", "gray55", "gray75"),
  legend = FALSE, label = 3,
  xlab = "Mean Weight Loss (kg)", xlim = c(-16, 3)
)

# Egger's regression test: formal test for small-study / publication bias
WeightRandomEgger <- regtest(WeightRandomEffects, ret.fit = TRUE)

# Baujat plot: identifies studies contributing most to heterogeneity and/or
# exerting disproportionate influence on the pooled estimate
baujat(WeightRandomEffects, symbol = "ids")
legend("topleft",
  cex = 0.9, text.width = 0.015,
  c(WeightRandomEffects$ids, WeightRandomEffects$slab),
  ncol = 2, bty = "n", text.col = "black"
)

# -----------------------------------------------------------------------------
# Sensitivity analysis
# -----------------------------------------------------------------------------
# Leave-one-out analysis: re-estimates the pooled effect with each study
# removed in turn, to check whether any single study drives the result
viz_forest(WeightRandomEffects,
  study_labels = paste0(WeightOutcomeMeasure$Author, " ", WeightOutcomeMeasure$Year),
  xlab = "Weight Loss",
  annotate_CI = TRUE,
  summary_label = "Random Effects Summary",
  text_size = 6,
  col = "Blues",
  type = "sensitivity"
)

# NB: Warnings from viz_forest() relate to metaviz passing arguments to ggplot2
# that have since been deprecated. These do not affect the validity of the
# output; the function still runs and produces the intended plot.

# =============================================================================
# END OF SCRIPT
# =============================================================================
