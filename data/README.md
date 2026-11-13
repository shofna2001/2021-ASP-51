# Project data

`golub.csv` is the downloaded Golub acute leukaemia gene-expression dataset used by this project.

- 72 samples
- 7,129 gene-expression probe columns
- Metadata columns include sample ID and leukaemia class
- `allB` and `allT` are mapped to ALL; `aml` is mapped to AML
- Original sample IDs 1–38 are used as training data; 39–72 are used as the independent test data

Keep `golub.csv` in this `data/` folder. The analysis reads it locally and does not download data automatically.
