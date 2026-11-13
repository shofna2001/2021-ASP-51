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

## 4. Methods

The analysis was completed in R using the R Markdown file `code/analysis.Rmd`.

### 4.1 Data import and quality control

The training and test expression matrices were combined for exploratory and differential-expression analyses, while their original split labels were retained. The code checked missing values, intensity ranges, negative values and class balance. The dataset contained 72 samples and 7,129 probe sets.

### 4.2 Pre-processing

The expression values were:
- limited to a minimum value of 100 and a maximum value of 16,000;
- filtered to retain probes with a maximum-to-minimum ratio greater than 5 and a maximum-minus-minimum difference greater than 500;
- transformed using log base 2.

After filtering, **3,571 probes** remained from the original 7,129. The filtering was based on expression values rather than class labels.

Log2 transformation reduces the effect of highly skewed intensity values and makes the distribution easier to analyse. Filtering removes probes with little variation across samples, which are less useful for distinguishing groups.

### 4.3 Exploratory data analysis

The following methods were used:

- **Principal Component Analysis (PCA):** reduces the expression data to a smaller number of dimensions for visualisation. PC1 explained **16.1%** of the variation and PC2 explained **11.4%**. The plot shows a general difference between the ALL and AML samples, although the groups are not perfectly separated in the first two components.
- **Heatmap:** displays the 50 probes with the highest variation across samples. It helps show patterns of similar expression between samples.
- **Hierarchical clustering:** Ward's D2 method was used to group samples without using their class labels.

The two-cluster result was:

| Cluster | ALL samples | AML samples |
|---|---:|---:|
| 1 | 43 | 2 |
| 2 | 4 | 23 |

This indicates that the unsupervised clustering separated most samples according to their leukaemia class. It was not a perfect separation: six samples were grouped with the cluster mainly containing the other class.

### 4.4 Differential gene expression

The `limma` package was used to compare AML with ALL. It fits a linear model for each probe and uses empirical Bayes moderation to improve variance estimation, which is useful for datasets with a relatively small number of samples.

P-values were adjusted using the Benjamini-Hochberg method to control the false discovery rate. A probe was considered significant when:

- adjusted p-value (FDR) < 0.01; and
- absolute log2 fold change > 1.

**Result: 266 probes** met both criteria. A positive log2 fold change means higher expression in AML than ALL; a negative value means higher expression in ALL than AML.

The ten top-ranked results in the exported differential-expression table are shown below.

| Gene symbol | log2 fold change (AML − ALL) | Adjusted p-value |
|---|---:|---:|
| CFD | 4.726 | 5.63 × 10⁻²¹ |
| CST3 | 4.808 | 7.74 × 10⁻²⁰ |
| MGST1 | 3.190 | 4.49 × 10⁻¹⁹ |
| CD33 | 2.171 | 2.19 × 10⁻¹⁷ |
| ZYX | 3.290 | 1.23 × 10⁻¹⁵ |
| CSTA | 3.320 | 1.86 × 10⁻¹⁵ |
| TCF3 | −2.074 | 8.94 × 10⁻¹⁵ |
| DNTT | −3.783 | 4.66 × 10⁻¹⁴ |
| APLP2 | 2.568 | 1.25 × 10⁻¹² |
| SPTAN1 | −1.995 | 4.40 × 10⁻¹² |

The direction of change is consistent with the AML-minus-ALL comparison. For example, CD33 is more highly expressed in the AML group in this analysis, while TCF3 and DNTT are more highly expressed in ALL.

### 4.5 Gene Ontology enrichment

GO Biological Process enrichment was carried out using `clusterProfiler`. The results highlight biological processes represented among the significant genes. Important enriched terms include:

- regulation of immune response;
- B-cell receptor signalling pathway;
- leukocyte activation;
- cell activation;
- regulation of cell activation;
- humoral immune response;
- myeloid leukocyte migration.

These findings suggest that immune-cell and blood-cell functions are important in the expression differences between ALL and AML.

### 4.6 Classification using a linear SVM

A linear Support Vector Machine (SVM) was used because it can work with high-dimensional gene-expression data, where the number of features is much larger than the number of samples.

The number of selected genes was tested at 5, 10, 25, 50 and 100. The top genes were selected using `limma`.

**Important validation step:** feature selection was performed inside each cross-validation training fold. This reduces selection bias because the validation samples are not used to select the genes for that fold.

Repeated stratified five-fold cross-validation was performed five times.

| Number of selected genes | Mean CV accuracy | Standard deviation |
|---:|---:|---:|
| 5 | 94.7% | 4.6% |
| 10 | 93.9% | 5.7% |
| 25 | **96.1%** | 4.6% |
| 50 | 94.2% | 4.3% |
| 100 | 95.0% | 5.4% |

The best mean cross-validation accuracy was **96.1%**, obtained with **25 genes**. Therefore, 25 genes were selected for the final hold-out model.

### 4.7 Independent hold-out validation

The final model was trained on the original 38 training samples and evaluated on the untouched 34-sample test set.

**Confusion matrix** (rows are predicted classes and columns are actual/reference classes):

| Predicted class | Actual ALL | Actual AML |
|---|---:|---:|
| ALL | 20 | 4 |
| AML | 0 | 10 |

| Evaluation measure | Result |
|---|---:|
| Accuracy | **88.24%** |
| 95% confidence interval | 72.55%–96.70% |
| Sensitivity for AML | **71.43%** |
| Specificity for AML | **100.00%** |
| Positive predictive value for AML | 100.00% |
| Negative predictive value for AML | 83.33% |
| Balanced accuracy | 85.71% |
| Cohen's kappa | 0.7463 |

The model correctly classified all 20 ALL samples and 10 of the 14 AML samples. It classified four AML samples as ALL and did not classify any ALL samples as AML. Therefore, the model had perfect specificity for AML in this test set, but its sensitivity was lower because some AML samples were missed.