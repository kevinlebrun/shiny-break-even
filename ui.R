library(shiny)

disable <- function(x) {
    if (inherits(x, 'shiny.tag')) {
        if (x$name %in% c('input', 'select'))
            x$attribs$disabled <- 'disabled'
         x$children <- disable(x$children)
    }

    else if (is.list(x) && length(x) > 0) {
        for (i in 1:length(x))
            x[[i]] <- disable(x[[i]])
    }

    x
}

shinyUI(pageWithSidebar(
    headerPanel('Find your break even point'),
    sidebarPanel(
        numericInput('periods', 'Periods of time:', value = 24, min = 1, max = 1e6, step = 1),
        numericInput('periodic_sales', 'Expected periodic sales:', value = 100, min = 0, max = 1e9, step = 1),
        disable(selectInput('growth_model', 'Growth model:',
                    list('Linear' = 'linear', 'Logarithmic' = 'log', 'Exponential' = 'exp'))),
        numericInput('price_per_unit', 'Price of an unit:', value = 5, min = 0, max = 1e9, step = 0.01),
        numericInput('cost_per_unit', 'Cost per unit:', value = 2, min = 0, max = 1e9, step = 0.01),
        numericInput('fixed_cost', 'Fixed cost:', value = 4000, min = 0, max = 1e9, step = 0.1),
        numericInput('periodic_cost', 'Reccuring periodic cost:', value = 10, min = 0, max = 1e9, step = 0.1),
        checkboxInput('show_revenue', 'Show revenues', FALSE)
    ),
    mainPanel(
        h3('Adjust the settings and find out when your business will earn money'),
        p('The break even point is the moment when your business stop loosing money. This model is generic. The period may be months, weeks, days, or whatever your need.
          Try to change the settings and see how the break even point is moving. You may want to increase the periods of time to see the break even point. The point is given
          by the orange vertical line in the graph below.'),
        textOutput('summary'),
        plotOutput('break_even'),
        conditionalPanel(condition = "input.show_revenue == 1",
            plotOutput('profits')
        )
    )
))
