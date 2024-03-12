renv::use(
  "ggplot2@3.4.0",
  "igraph@1.5.0",
  "ggiraph@0.8.4",
  "ggtree@3.8.2",
  "mrc-ide/tfpscanner@ab29cb0e2126c8792fa471ae3200e12144eaa173"
)

message("Hello world!")

for(pkg in c("ggplot2", "igraph", "ggiraph", "ggtree", "tfpscanner")) {
  message(pkg, " version: ", packageVersion(pkg))
}

tfpscanner::create_browser_data(
  "Some environment",
  output_dir = "Some directory"
)
