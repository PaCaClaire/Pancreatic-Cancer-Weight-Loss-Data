# Source data from meta-analyses of weight loss prior to pancreatic cancer diagnosis

This repository contains the study-level data, code and supporting
materials underlying a systematic review and meta-analyses quantifying
weight loss prior to pancreatic cancer diagnosis.

Authors: Claire A. Price, Debbie Cooke, Freda Mold, Nadia A. S. Smith,
Martyn Winn, Agnieszka Lemanska

Companion research articles:
1. Price et al. (2026). Quantifying Weight Loss Prior to Pancreatic Cancer
   Diagnosis. Cancer Medicine 15(6): e71997.
   https://doi.org/10.1002/cam4.71997
2. Price et al. (2026). Comparing Weight Loss Prior to Pancreatic Cancer
   Diagnosis in Cases and Controls. Studies in Health Technology and
   Informatics 336: 333-337.
   https://ebooks.iospress.nl/doi/10.3233/SHTI260172

PROSPERO registration: CRD42022302985
https://www.crd.york.ac.uk/prospero/display_record.php?ID=CRD42022302985

Zenodo DOI: https://doi.org/10.5281/zenodo.23963455

Corresponding author: Claire A. Price, claire.a.price@surrey.ac.uk

---

## Dataset description

This dataset provides the complete raw and processed data underlying a
systematic review and meta-analyses quantifying weight loss prior to
pancreatic cancer diagnosis. Weight loss is a recognised early feature of
pancreatic cancer, but no previous synthesis had quantified its magnitude
across the published literature. The dataset includes study-level data
extracted from 37 studies identified through a systematic search of five
databases (PubMed, Embase, Scopus, Web of Science, Cochrane Library), risk
of bias assessments (ROBINS-I) for all 39 studies assessed (37 with
extracted data, plus 2 excluded at serious risk of bias before extraction
proceeded) and the R code used to conduct the statistical synthesis. It
is made available to support transparency and reproducibility of the accompanying analyses
and for reuse by researchers conducting related systematic reviews,
meta-analyses or methodological work on outcome measurement and
reporting in this field. Searches were conducted up to March 2025 and the dataset 
includes studies identified up to that date.

---

## Files in this repository

| File | Description |
|---|---|
| `ExtractedData.csv` | Raw extracted dataset, one row per study cohort, 54 columns covering study design, source population, baseline definition and timepoint, meta-analysis-ready outcomes, derived-value flags, verbatim as-reported figures, and risk-of-bias ratings. See the manuscript's column dictionary table for the full description of each column. |
| `WeightLosskg.csv` | Processed outcome file: weight loss in kg, input to the weight-loss meta-analysis. |
| `BMIChange.csv` | Processed outcome file: BMI change, input to the BMI-change meta-analysis. |
| `CasesAndControls_forSMD.csv` | Processed outcome file: case vs. control comparison data, input to the standardised mean difference (SMD) meta-analysis. |
| `NumberLosing.csv` | Processed outcome file: proportion/number of participants losing weight, an outcome not yet synthesised in a published meta-analysis. |
| `ROBINS-I_Ratings.csv` | Domain-level and overall ROBINS-I risk-of-bias ratings for all 39 assessed studies. |
| `MetaAnalysisCode_WeightLoss_.R` | R code for the weight loss (kg) meta-analysis: random/fixed-effects pooling, forest plots, funnel plot, Egger's test, Baujat plot, and leave-one-out sensitivity analysis. |
| `DataExtractionTemplate.csv` | Blank extraction form matching the `ExtractedData.csv` column structure, for researchers wishing to extend or replicate the extraction. |
| `Imputation_Methods.docx` | Methods used to derive values that were not directly reported, including conversion of medians and dispersion measures, imputation of standard deviations and combining of groups. |
| `SearchStrings.txt` | Search strings and database field mapping used across all five databases. |
| `LICENSE` | Full text of the CC-BY 4.0 license under which this repository is released. |

**Note.** Boursi_2017 and Boursi_2022 are retrospective cohort studies. In `CasesAndControls_forSMD.csv` the people without pancreatic cancer are used as controls.

---

## PRISMA record counts

*Identification of studies via databases and registers*

| Database | Records identified |
|---|---|
| Web of Science | 1,271 |
| Scopus | 2,069 |
| PubMed | 1,111 |
| Embase | 2,404 |
| Cochrane Library | 142 |
| **Total** | **6,997** |

- Duplicate records removed: 2,893
- Records screened: 4,104
- Records excluded at title/abstract screening: 3,733
- Reports sought for retrieval: 371 (22 not retrieved)
- Reports assessed for eligibility: 349
- Reports excluded, with reasons: ineligible article type (115), not English (7),
  binary weight loss (14), treatment-related weight loss (18), fat
  proportion change only (7), not specific to PaCa (61),
  weight loss not quantified (78), no measure of dispersion (3),
  incomplete results (12)
- Studies included via database search: 34

*Identification of studies via other methods*

- Records identified (PubMed Similar Articles: 38; citation searching: 43): 81
- Reports assessed for eligibility: 81 (0 not retrieved)
- Reports excluded, with reasons: ineligible article type (19), binary weight loss (8),
  treatment-related weight loss (5), fat proportion change only (2), not
  specific to PaCa (11), weight loss not quantified (31)
- Studies included via other methods: 5

**Total studies included in review: 39**

All 39 studies underwent the same search, eligibility assessment and
ROBINS-I risk-of-bias evaluation. Following ROBINS-I assessment, 2 studies
were excluded at serious risk of bias, leaving 29 studies contributing to
the primary weight-loss-kg, BMI-change and SMD meta-analyses reported in
the companion articles above. A further 8 studies are included in this
dataset for a secondary outcome not yet reported elsewhere (5 reporting
the proportion of participants losing weight; 3 reporting percentage
weight loss without sufficient baseline data to convert to an absolute
value).


---

## Statistical software

Statistical analysis was conducted using RStudio version 2021.09.1 using
the packages `meta` (version 8.2-1), `metaviz` (version 0.3.1), `metafor`
(version 4.8-0), `dplyr` (version 1.1.4), `here` (version 1.0.1) and `tidyverse` (version 2.0.0).

To run the script, download the repository, open R in the repository folder
and run `MetaAnalysisCode_WeightLoss_.R`. The script reads
`WeightLosskg.csv` from the repository folder using `here` and saves the
forest plot (`WeightLossRandomForest.tiff`) to the same folder. The funnel,
Baujat and leave-one-out plots appear in the R graphics window and are not
saved. It covers the weight loss (kg) meta-analysis only. The BMI change, SMD and proportion data files
are provided as inputs for the corresponding analyses but no script is
included for them.

---

## Coding schemes

- **DiabetesCohort**: mixed = combined diabetes status; yes = diabetic
  subgroup; no = non-diabetic subgroup; unknown = diabetes status not
  reported or not applicable (prediabetes cohort).
- **SourcePopulationID**: equals StudyID except where reports share a
  source population (Dugnani_2016a and Dugnani_2016b share Dugnani_2016).
  Other reports may draw on the same institution or population, for example
  Mayo Clinic or Olmsted County for Chari_2008, Pannala_2008, Hart_2011 and
  Sah_2019, but the reports do not state whether participants are shared so
  overlap between them cannot be excluded.
- **BaselineDefinition**: Usual adult weight or Weight at fixed interval
  before diagnosis.
- **TimepointMonths**: interval in months before diagnosis at which the
  comparison weight was recorded. NA = baseline is usual adult weight.
- **MeasurementType, WeightMeasurementUnit, DispersionType**: N/A = no weight value extracted (proportion outcome only); Not
  extracted = percentage weight loss only.
- **MeasurementsConverted, SDConverted, WeightChangeCalculated,
  BMIChangeCalculated, GroupsCombined, AnyDerivedValues**: Yes or No.
  WeightChangeCalculated and BMIChangeCalculated can also be N/A where the
  paper does not report weight or BMI.
  MeasurementsConverted = weight converted from pounds to kilograms.
  SDConverted = SD converted from an SE, CI, IQR or range.
  WeightChangeCalculated and BMIChangeCalculated = change calculated from
  baseline and diagnosis values with the SD imputed. GroupsCombined = groups reported separately
  were combined. AnyDerivedValues = any of these applies. The methods are
  described in the imputation methods file.
- **CancerType**: PDAC = pancreatic ductal adenocarcinoma only; all = all
  pancreatic malignancy types.
- **DataSource**: records = data obtained from medical records; self =
  self-reported.
- **ROBINS_Overall**: Low / Moderate / Serious / Critical, per the ROBINS-I
  tool (version for cohort-type studies, Version 1, August 2016).

---

## Funding

This research was funded in whole, or in part, by an EPSRC iCASE
studentship awarded to CP [EP/W522272/1, studentship number 2702921]. The
work of the NPL co-authors was funded by the UK Government's Department
for Science, Innovation & Technology through the UK's National Measurement
System programmes.

---

## License

This dataset is openly available on Zenodo under a CC-BY 4.0 license and
can be accessed and downloaded directly via the DOI link without any
restrictions.
