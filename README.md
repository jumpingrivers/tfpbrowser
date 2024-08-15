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
