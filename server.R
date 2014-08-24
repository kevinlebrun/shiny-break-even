library(shiny)
library(ggplot2)

shinyServer(
    function (input, output) {
        dataframe <- reactive({
            df         <- data.frame(x = seq(0, input$periods))
            df$sales   <- df$x * input$periodic_sales * input$price_per_unit
            df$cost    <- input$fixed_cost + df$x * (input$periodic_cost + input$periodic_sales * input$cost_per_unit)
            df$profits <- df$sales - df$cost
            df
        })

        breakeven <- reactive({
            input$fixed_cost / (input$periodic_sales * input$price_per_unit - input$periodic_cost - input$periodic_sales * input$cost_per_unit)
        })

        output$break_even <- renderPlot({
            p <- ggplot(dataframe(), aes(x))
            p <- p + geom_line(aes(y = sales, colour = 'Sales'))
            p <- p + geom_line(aes(y = cost, colour = 'Cost'))

            # Draw the break-event point
            p <- p + geom_vline(xintercept = breakeven(), colour = 'orange')

            p <- p + theme(legend.position = 'bottom')
            p <- p + ylab('$')
            p <- p + xlab('Periods of time')

            p
        })

        output$profits <- renderPlot({
            p <- ggplot(dataframe(), aes(x = x, y = profits))
            p <- p + geom_bar(stat = 'identity')

            p <- p + ylab('$')
            p <- p + xlab('Periods of time')
            # Suppress a warning about stacking when ymin != 0
            suppressWarnings(print(p))
        })

        output$summary <- renderText({
            paste('You should start earning money at period', round(breakeven(), 2), '.')
        })
    }
)
