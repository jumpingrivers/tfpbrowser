# {tfpbrowser}

An R package to build a Shiny application to explore {tfpscanner} outputs.
The outputs from {tfpscanner} can be stored in the `inst/app/www/data/` folder and tfpbrowser will
present data in this directory by default.

## Installation

The recommended way to use this application, is to clone the associated `git` repository and work
within that directory. This can be achieved using `git` from the command line:

```bash
# Using SSH
git clone git@github.com:mrc-ide/tfpbrowser.git
# Or using HTTPS
git clone https://github.com/mrc-ide/tfpbrowser.git
```
  
Or from inside RStudio (`File -> New Project -> Version Control -> Git` then enter the repository
URL "https://github.com/mrc-ide/tfpbrowser.git").

To get the latest version of the code, use the `git pull` command (or the `Git -> Pull` workflow in
RStudio).

Then open an R session in the directory for the git repository. A simple way to do this is to
open RStudio and use the `File -> Open Project` workflow, navigating to the `tfpbrowser.Rproj` file
in the `tfpbrowser` directory.

## Running the Shiny application

Before running the app, we must ensure that

- the packages it depends upon are available; and
- a dataset for presentation is in place.

Note that the bioconductor packages used by `tfpbrowser` are tied to a specific version of R.
As of 2024, you should use R v4.2.x.

### Activating the environment for the application

The specific versions of the packages used by the app (the package environment) are declared in an
`renv.lock` file. See the [{renv} documentation](https://rstudio.github.io/renv/) for further
details. `renv` isolates the environment for this app away from the R packages installed elsewhere
on your machine.

The first time that you open the `tfpbrowser` project in an R session, activating the package
environment may fail. You will need to follow these steps:

- Install `renv` (`install.packages("renv")`)
- Install the `tfpbrowser` package environment (`renv::restore()`)
- Restart the session (In RStudio `Session -> Restart R`)

The package environment will be automatically loaded when the project is opened on subsequent
occasions. On successfully loading the environment, `renv` will print out the following comment:

```
- Project '~/path/to/tfpbrowser' loaded. [renv 1.0.7]
```

The packages defined in the `renv.lock` file may change over time. If you receive a message that
`The project is out-of-sync...` when you load the `tfpbrowser` project, it is likely that the
package environment in `renv.lock` has updated, but your local machine is using an older
environment. Run `renv::restore()` to sync your `tfpbrowser` environment with the current
`renv.lock` file.

### Directing the app to a dataset

`tfpbrowser` relies on data preprocessing by [`tfpscanner`](https://github.com/mrc-ide/tfpscanner).
See the section on "Creating a new `tfpbrowser` dataset"

`tfpscanner` acts upon a directory of data (which must contain a `scanner_output` subdirectory) and
adds `treeview`, `sequences` and `mutations` directories to its input. Content in all four of these
subdirectories is needed for `tfpbrowser` to work.

So, a dataset for `tfpbrowser` must be structured like this:

```
/path/to/my_data
├── mutations
├── scanner_output
├── sequences
└── treeview
```

There are two ways to make `tfpbrowser` use such a dataset:

- Copy the `mutations`, `scanner_output`, `sequences` and `treeview` directories into the
  `inst/app/www/data` directory of the `tfpbrowser` repository, then either reinstall `tfpbrowser`
  or load the package temporarily in your current session (using
  [`pkgload::load_all()`](https://search.r-project.org/CRAN/refmans/pkgload/html/load_all.html)) 

- Configure the app to read data from the dataset directory without moving its contents by setting
  the `APP_DATA_DIR` variable to contain the path to that directory. See the section "Configuring
  the deployed app".

### Running

The most robust way to run the application is to start an R session inside the repository that
houses the source code for {tfpbrowser}. This will ensure that the environment within which the app
runs is activated before the app is started (see section "Activating the environment for the
application").

Once the environment is activated, the app can be run using the following R commands:

```r
# Load the contents of the {tfpbrowser} package
pkgload::load_all()

# Optionally define the directory that contains the tfpscanner data for presentation
# - Alternative ways to define the data-path are described in "Configuring the app"
Sys.setenv(APP_DATA_DIR = "/path/to/data")

# Run the app
run_app()
```

An alternative way to run the app is by using the `run_app()` function from the installed
{tfpbrowser} package. However, you may find that the tfpscanner data used is incompatible with
tfpbrowser. As such, we recommend generating tfpscanner output using the `create_browser_data.R`
script and running tfpbrowser within it's defined R environment, as described above.

```
tfpbrowser::run_app()
```

## Creating a new `tfpbrowser` dataset

In the repository for {tfpbrowser} there is a script `./scripts/create_browser_data.R`. This can be
used to generate a dataset for presentation by {tfpbrowser}. The script contains detailed
instructions for its use.

Briefly:

- "create_browser_data.R" runs the `tfpscanner::create_browser_data()` function
- It takes scanner output, and creates a number of tree-views that can be presented in the
  {tfpbrowser} app
- Input:
  - The user should modify `create_browser_data.R` to point the script to a directory
    containing {tfpscanner} input (`/path/to/tfpscanner_input/`)
  - That directory contains a `scanner_output/` subdirectory
    (`/path/to/tfpscanner_input/scanner_output/`)
  - That subdirectory contains a file containing an R environment object
    `scanner-env-YYYY-MM-DD.rds`
- Output:
  - `create_browser_data.R` appends some files to the `/path/to/tfpscanner_input/` directory
  - After running the script, that directory will contain subdirectories `mutations`,
    `scanner_output`, `sequences` and `treeview`

`create_browser_data.R` _must_ run from the repository for {tfpbrowser} because it uses a similar
mechanism to the {tfpbrowser} app to define the versions of R packages used when it runs. This is
important because the 'treeview' outputs that are generated are binary R objects that the
{tfpbrowser} app will import. The R packages used to generate those objects must match those used
when importing them. By running from the {tfpbrowser} directory we can use the environment
definition for the {tfpbrowser} app to precisely specify the packages needed when {tfpscanner} runs.

Once the data has been appended by `create_browser_data.R`, it can be used by the {tfpbrowser} app.
To do this either:

  - configure {tfpbrowser} to use the output data directory used in `create_browser_data()` (see the
  next section); or
  - copy the contents of that directory into `inst/app/www/data/` and re-install {tfpbrowser}

### Configuring the app

Data presented by the app can be obtained from an arbitrary directory on the server.
To configure the data-directory, use the environment variable `APP_DATA_DIR`.
For example, if the app is to present data from the directory `/home/me/tfpdata/`, then the app can
be configured from the command line:

```bash
APP_DATA_DIR=/home/me/tfpdata/
# start the app
```

... or from inside R:

```r
Sys.setenv("APP_DATA_DIR" = "/home/me/tfpdata/")
pkgload::load_all()
run_app()
```

An alternative way to specify this data directory is to add the line
`APP_DATA_DIR="/home/me/tfpdata/"` to a `.Renviron` file in the project root.

## Deploying the app

Please see the vignette `deploy` in {tfpbrowser} which provides a walk-through for deploying to
[shinyapps.io](https://www.shinyapps.io/). This is in `./vignettes/deploy.Rmd` in the {tfpbrowser}
repository.

If working in the tfpbrowser repository, developers may need to build the vignettes:

```r
# Build the vignette (Optional, if you haven't installed tfpbrowser)
# In the repository for {tfpbrowser}
devtools::build_vignettes()
pkgload::load_all()

# View the vignette
vignette("deploy", package = "tfpbrowser")
```

