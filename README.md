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

Before running the app, we must ensure that the packages it depends upon are available and a dataset
for presentation is in place.

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

### Directing the app to the dataset

### Running

```
tfpbrowser::run_app()
```

## Updating with new data

* See the notes on using `tfpscanner::create_browser_data()` with tfpbrowser in the README for
  {tfpscanner}
* Either:
  - configure {tfpbrowser} to use the output data directory used in `create_browser_data()` (see the
  next section); or
  - copy the contents of that directory into `inst/app/www/data/` and re-install {tfpbrowser}

## Configuring the deployed app

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
