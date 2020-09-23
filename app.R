## COVID-19 Travel Policy Tracking App
## Ben Day
## Created: 17/7/2020
## Modified: 23/09/2020
##
## Source: https://covidtracker.bsg.ox.ac.uk/



# Initialisation ----------------------------------------------------------

library(shiny)
library(tidyverse)
library(lubridate)
library(readxl)

# Function
addline_format <- function(x,...){
    gsub('\\s\\s','\n',x)
}


# Update and read raw data -----------------------------------------------------------

source(file = 'updatedata.R')

df <- read_rds('covid_country_data.rds')


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("International Travel Restrictions: HPSNZ App",
               "HPSNZ Travel Restrictions App"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(

            h3("View recent travel restrictions for your country of interest."),
            tags$br(),
            selectInput("country",
                        HTML("By Country<br /><br />(To type, first clear field with backspace)"),
                        choices = unique(df$CountryName),
                        selected = 'Spain',
                        width = '200px'
                            ),
            actionButton(inputId = "submit", 
                         label = "What's the travel status?"),
            tags$br(),
            tags$br(),
            tags$br(),
            selectizeInput("status",
                           "By Status",
                           choices = c("1 - Screening arrivals", 
                                       "2 - Quarantine some  or all arrivals", 
                                       "3 - Ban arrivals  from some regions", 
                                       "4 - Border closed to  foreign travellers"),
                           selected = "1 - Screening arrivals",
                           width = '300px'),
            actionButton(inputId = "apply", 
                         label = "Find countries at this level"),
            tags$br(),
            tags$br(),
            uiOutput("tab")
        ),

        # Show a plot of the generated distribution
        mainPanel(

            #HPSNZ logo
            img(src = "HPSNZ.png", height = 140, width = 500),
            
            plotOutput("outputPlot"),
            tags$br(),
            #h3("Countries at restriction level",
            #   tags$br()),
            textOutput("text"),
            dataTableOutput("outputTable"),
            tags$br(),
            # Button to download plot as png
            downloadButton("downloadPlot", "Download plot"),
            # Button to download data
            downloadButton("downloadData", "Download data"),
            tags$br()
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    country_data <- eventReactive(input$submit,{
        
        df <- df %>% mutate(date = dmy(date),
                            code = code,
                            daysold = as.numeric(difftime(today(), date, units = c("days")))) %>% 
            filter(CountryName == input$country,
                   code != 0)
        
        return(df)
        
    })
    
    date_updated <- df %>% 
        mutate(date = dmy(date)) %>%
        arrange(desc(date)) %>% 
        select(date) %>% 
        slice(1) %>% 
        pull(date)
    
    status_data <- eventReactive(input$apply,{
        
        df <- df %>% mutate(date = dmy(date),
                            code = code,
                            daysold = as.numeric(difftime(today(), date, units = c("days"))))
        
        if (input$status == "1 - Screening arrivals") {
            df <- df %>% filter(code == 1 & daysold < 14) %>%
                group_by(CountryName) %>%
                summarise(date = max(date)) %>%
                rename('Date' = date,
                       'Country' = CountryName)
                
        }
        else if (input$status == "2 - Quarantine some  or all arrivals") {
            df <- df %>% filter(code == 2 & daysold < 14) %>%
                group_by(CountryName) %>%
                summarise(date = max(date)) %>%
                rename('Date' = date,
                       'Country' = CountryName)
        }
        else if (input$status == "3 - Ban arrivals  from some regions") {
            df <- df %>% filter(code == 3 & daysold < 14) %>%
                group_by(CountryName) %>%
                summarise(date = max(date)) %>%
                rename('Date' = date,
                       'Country' = CountryName)
        }
        else if (input$status == "4 - Border closed to  foreign travellers") {
            df <- df %>% filter(code == 4 & daysold < 14) %>%
                group_by(CountryName) %>%
                summarise(date = max(date)) %>%
                rename('Date' = date,
                       'Country' = CountryName)
        }
            
        return(df)
        
    })
    
    names_plot <- eventReactive(input$submit,{
        input$country
    })
    
    status_level <- eventReactive(input$apply,{
        input$status
    })
        
    graph <- reactive({
        
        df = country_data()
        
        g <- ggplot(df, aes(x = date, y = code, fill = factor(code))) + 
            geom_area() +  
            xlab('Date') + ylab('') +
            scale_x_date(position = "top") +
            scale_y_continuous(limits = c(0, 4.5), breaks = c(0, 1, 2, 3, 4), 
                               labels = addline_format(c("", "1 - Screening arrivals", 
                                          "2 - Quarantine some  or all arrivals", 
                                          "3 - Ban arrivals  from some regions", 
                                          "4 - Border closed to  foreign travellers")),
                               position = "right") +
            scale_fill_manual(values = c("1" = '#34bc6e', "2" = "#648fff", "3" = "#ffb000", "4" = "#fe6100")) +
            labs(subtitle = paste0('Data last updated ', date_updated)) +
            ggtitle(addline_format(paste0(as.character(names_plot()), '  Travel restrictions in 2020'))) +
            theme(legend.position = "none", 
                  text = element_text(size=16),
                  plot.subtitle = element_text(size=12, face="italic", color="grey"),
                  panel.grid.minor = element_blank(),
                  axis.ticks = element_blank())
        
        g
        
    })

    output$outputPlot <- renderPlot({
        graph()
    }, height = "auto", width = "auto")
    
    
    output$text <- renderText({
        paste0("Countries at level ", status_level())
    })
    
    output$outputTable <- renderDataTable({
        
        df = status_data()
        df %>% 
            rename('Date last updated' = Date) %>%
            arrange(desc(`Date last updated`))
        
    }, options = list(dom  = '<"top">t<"bottom">', autoWidth = TRUE,
                      columnDefs = list(list(targets = c(0), width = '200px'),
                                        list(targets = c(1), width = '150px')),
                      scrollX = TRUE, searching = F, pageLength = -1,
                      lengthMenu = list(c(-1), c("All"))))
    
    
    
    # Download plot as png
    output$downloadPlot <- downloadHandler(
        
        filename = function() {
            "plot.pdf"
        },
        content = function(file){
            ggsave(file, plot = graph(), width= 10, height = 6)
        }
    )
    
    # Downloadable csv of selected dataset ----
    output$downloadData <- downloadHandler(
        
        filename = function() {
            paste(input$country, "_covid_travel", ".csv", sep = "")
        },
        content = function(file) {
            write.csv(country_data(), file, row.names = FALSE)
        }
    )
    
    
    # Put Gov tracker link at page bottom
    url <- a("Government Response Tracker", href="https://covidtracker.bsg.ox.ac.uk/stringency-scatter")
    output$tab <- renderUI({
        tagList("Link:", url)
    })
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
