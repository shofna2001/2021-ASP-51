# Gene-Expression Classification of Acute Leukaemia (ALL vs AML)

**Student:** M.J. Thisho Shofna  
**Registration number:** 2021/ASP/51  
**Module:** Bioinformatics ICA3 2026

## 1. Abstract

This project analyses gene-expression data to distinguish acute lymphoblastic leukaemia (ALL) from acute myeloid leukaemia (AML). The Golub et al. (1999) dataset contains 72 samples and 7,129 Affymetrix probe sets. After intensity filtering and log2 transformation, 3,571 probes remained. Differential expression was tested using `limma`, and Gene Ontology (GO) enrichment was performed using `clusterProfiler`. A linear support vector machine (SVM) was evaluated using repeated stratified five-fold cross-validation, with feature selection performed inside each fold to reduce selection bias. The best cross-validation result was 96.1% accuracy using 25 genes. On the independent 34-sample test set, the model achieved 88.24% accuracy, with 71.43% sensitivity and 100% specificity for AML. The results show that gene-expression profiles contain useful information for distinguishing ALL from AML, although further validation is required.

## 2. Introduction

Acute leukaemia includes different diseases that develop in blood-forming cells. Two important types are acute lymphoblastic leukaemia (ALL) and acute myeloid leukaemia (AML). Correctly distinguishing these types is important because their treatments are different.

Traditional diagnosis uses methods such as cell morphology, cytochemistry and immunophenotyping. Gene-expression profiling provides another way to identify differences between the two diseases. Golub et al. (1999) demonstrated that gene-expression patterns can be used to classify ALL and AML.

### Aim

1. Identify genes that are differentially expressed between ALL and AML.
2. Explore the expression patterns using PCA, heatmaps and clustering.
3. Build and evaluate a machine-learning model to classify ALL and AML.
4. Assess model performance using cross-validation and an independent test set.

### Hypothesis

A small group of genes can classify ALL and AML with high accuracy. The cross-validation result exceeded 90%, but the independent test accuracy was below 90%.

## 3. Dataset

The project uses the publicly available Golub leukaemia dataset from the Bioconductor package `golubEsets`.

| Dataset detail | Description |
|---|---|
| Total samples | 72 |
| Training samples | 38 (27 ALL, 11 AML) |
| Independent test samples | 34 (20 ALL, 14 AML) |
| Original probe sets | 7,129 |
| Technology | Affymetrix Hu6800 microarray |
| Expression data | Gene-expression intensity values |
| Target classes | ALL and AML |

The dataset includes gene-expression measurements and sample information. The original training and test groups were kept separate for independent model evaluation. No raw data files are stored in this repository because the dataset is loaded directly from `golubEsets`.

