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

# User parameters
# - The scanner environment file ("path/to/scanner_output/scanner-env-YYYY-MM-DD.rds")
# - The output directory for the treeviews
# - Any non-default arguments for the `treeview()` function
#
# File paths can be specified either relative to the working directory, or as absolute paths
env_file <- file.path()
output_dir <- file.path()
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

## ============================================================================================== ##

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

# =============================================================================================== ##

app_message <- glue::glue('
# To run the "tfpbrowser" app over this dataset, please perform the following in R:

Sys.setenv(APP_DATA_DIR = "{output_dir}")
pkgload::load_all()
run_app()
')

message(app_message)
