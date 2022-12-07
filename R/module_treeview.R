#' Shiny module for presenting the treeview data
#'
#' @param   id   Shiny/HTML ID for the module.
#' @return   fluidRow UI elements for the module.

treeviewUI = function(id) {
  ns = shiny::NS(id)

  shiny::fluidRow(
    shiny::column(12,
                  # choose type of treeview
                  shiny::radioButtons(
                    inputId = ns("widgetChoice"),
                    label = "Select treeview",
                    choices = c(
                      "Logistic growth rate",
                      "Simple logistic growth rate",
                      "Simple trait log odds"
                    ),
                    inline = TRUE
                  ),

                  # show treeview widget
                  shiny::wellPanel(
                    ggiraph::girafeOutput(ns("treeview")),
                    style = "background: white",
                  ),
                  shiny::br()
    )
  ) # end fluid row
}

#' Shiny server function for presenting the treeview data
#'
#' @inheritParams   treeviewUI
#'
#' @return   Creates a \code{moduleServer} that returns a reactive containing the cluster ID for
#'   whichever node the user most recently hovered on.

treeviewServer = function(id) {
  shiny::moduleServer(
    id,
    function(input, output, session) {
      # get selected cluster ID based on widget choice
      selected_cluster_id = shiny::reactive({
        get_selected_cluster_id(widgetChoice = input$widgetChoice,
                                treeviewSelected = input$treeview_selected)
      })

      imported_ggtree = shiny::reactive({
        filename = get_filename(input$widgetChoice)
        readRDS(filename)
      })

      # create plotly output from saved ggplot2 outputs
      output$treeview = ggiraph::renderGirafe({
        tooltip_css = paste0(
          "background-color:black;",
          "color:grey;",
          "padding:14px;",
          "border-radius:8px;",
          "font-family:\"Courier New\",monospace;"
        )
        girafe_options = list(
          ggiraph::opts_selection(type = "single"),
          ggiraph::opts_sizing(width = 0.8),
          ggiraph::opts_tooltip(
            css = tooltip_css,
            use_fill = FALSE
          )
        )
        suppressWarnings(
          ggiraph::girafe(
            ggobj = imported_ggtree(),
            options = girafe_options
          )
        )
      })

     return(selected_cluster_id)
    }
  )
}
