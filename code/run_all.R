# Run this script from the REG_NO_REPO project root:
# source("code/run_all.R")

if (!requireNamespace("rmarkdown", quietly = TRUE)) {
  install.packages("rmarkdown", repos = "https://cloud.r-project.org")
}

project_root <- normalizePath(getwd(), winslash = "/", mustWork = TRUE)
if (!file.exists(file.path(project_root, "code", "analysis.Rmd"))) {
  stop("Please set the working directory to the REG_NO_REPO project folder.")
}
if (!file.exists(file.path(project_root, "data", "golub.csv"))) {
  stop("Missing data/golub.csv. The downloaded dataset must be in the data folder.")
}

rmarkdown::render(
  input = file.path(project_root, "code", "analysis.Rmd"),
  output_dir = file.path(project_root, "code"),
  output_file = "analysis.html",
  envir = new.env(parent = globalenv())
)
