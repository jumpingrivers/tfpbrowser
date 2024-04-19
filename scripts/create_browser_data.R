# create_browser_data.R -----------------------------------------------------------------------

# To run this script for a new dataset:
# - modify the "User parameters" section below (see the comments in that section)
# - Either run it using
#   - `Rscript ./scripts/create_browser_data.R` at the command line
#   - or `source("./scripts/create_browser_data.R")` in R
# - Once finished, this script will explain how to use the created figures within tfpbrowser.

# Ensure that the R session used when running this script is closed before running the app, because
# this script runs in a defined environment that doesn't contain some of the packages needed by the
# app.

# Script environment --------------------------------------------------------------------------

# Here we define a running environment that is compatible with the versions of ggplot2, igraph etc
# that are used when running the app.
#
# If the renv.lock for the app is updated, the versions of the packages defined here should be
# updated to be in-sync with the renv.lock.
#
# {tfpscanner} is not directly used by the app, so it isn't present in the renv.lock for the app.

renv::use(
  # The CRAN versions of these packages should match those used in the 'renv.lock' for tfpbrowser,
  # to ensure that the figure formatting
  "ggplot2@3.4.0",
  "igraph@1.5.0",
  "ggiraph@0.8.4",
  "ggtree@3.8.2",
  # This is the HEAD of `jumpingrivers:dev-202403` as of 2024-04-15
  # If the commit ID is absent, this will use the latest 'master' branch
  # Including the commit ID allows us to use development-versions of the 'tfpscanner' package
  "mrc-ide/tfpscanner@7ee27416d69ec3eaf7e4158f38c31125b3c38c7d"
)

# User parameters -----------------------------------------------------------------------------

# File paths can be specified either relative to the working directory, or as absolute paths
#
# 1) The scanner environment file ("path/to/scanner_output/scanner-env-YYYY-MM-DD.rds")
env_file <- file.path()

# 2) The output directory for the treeviews (typically the parent of the 'scanner_output' directory)
output_dir <- file.path()

# 3) Any non-default arguments for the `treeview()` function
treeview_args <- list(
  # branch_cols = c("logistic_growth_rate", "clock_outlier"),
  # mutations = c("S:A222V", "S:Y145H", "N:Q9L", "S:E484K"),
  # lineages = c("AY\\.9", "AY\\.43", "AY\\.4\\.2"),
  # output_format = c("rds", "html"),
  # dendrogram_colours = c("#2166ac", "#738fc0", "#afbad4", "#e8e8e8", "#e0a9a4", "#ce6964", "#b2182b"),
  # heatmap_width = 0.075,
  # heatmap_offset = 8,
  # heatmap_lab_offset = -6,
  # heatmap_fill = c(`FALSE` = "grey90", `TRUE` = "grey70")
)

# Create the browser data / figures -----------------------------------------------------------

# Please don't edit this section

# Arguments for `create_browser_data`
browser_args <- append(
  list(
    e0 = normalizePath(env_file),
    output_dir = normalisePath(output_dir)
  ),
  treeview_args
)

stopifnot(file.exists(browser_args$e0))
stopifnot(dir.exists(browser_args$output_dir))

do.call(
  tfpscanner::create_browser_data,
  browser_args
)

# How to use the new browser data -------------------------------------------------------------

app_message <- glue::glue('
# To run the "tfpbrowser" app over this dataset, please perform the following in R:

# Start a new session first
# - the environment for this script will interfere with that used by the app
Sys.setenv(APP_DATA_DIR = "{output_dir}")
pkgload::load_all()
run_app()
')

message(app_message)
