renv::use(
  # The CRAN versions of these packages should match those used in the 'renv.lock' for tfpbrowser,
  # to ensure that the figure formatting
  "ggplot2@3.4.0",
  "igraph@1.5.0",
  "ggiraph@0.8.4",
  "ggtree@3.8.2",
  # This is the HEAD of `jumpingrivers:draft-all-features-202403` as of 2024-04-15
  # If the commit ID is absent, this will use the latest 'master' branch
  # Including the commit ID allows us to use development-versions of the 'tfpscanner' package
  "mrc-ide/tfpscanner@7ee27416d69ec3eaf7e4158f38c31125b3c38c7d"
)

message("Hello world!")

for(pkg in c("ggplot2", "igraph", "ggiraph", "ggtree", "tfpscanner")) {
  message(pkg, " version: ", packageVersion(pkg))
}

tfpscanner::create_browser_data(
  "Some environment",
  output_dir = "Some directory"
)
