## HEADER ####
## Temperature distribution over certain Australian cities by year ####
## Georgina Wager ####
## 2021-03-04 ####

## installing the required packages 
if(!require("tidyverse"))install.packages("tidyverse")
if(!require("shiny"))install.packages("shiny") ## for data tidying
if(!require("shinydashboard"))install.packages("shinydashboard") ## for data tidying
if(!require("viridis"))install.packages("viridis") ## colors

## loading the required packages 
library(tidyverse) 
library(shiny)
library(shinydashboard)
library(viridis)
## reading in the data and calling it "temperature"
temperature <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-01-07/temperature.csv')

temp <- temperature %>% ## creating a new data frame with some data wrangling called "temp"
    filter(complete.cases(.) & temp_type == "max") %>% ## filtering the max temps to include in the data
    mutate(year = as.integer(lubridate::year(date))) %>% ## turn the year into a date format
    group_by(city_name) %>%  ## group by city
    mutate(mean_by_city = mean(temperature), 
           sd_by_city = sd(temperature)) %>% ## Create a mean temperature 
    ungroup() %>% 
    group_by(city_name, year) %>% ## group by city for each independent year
    mutate(mean_temp = mean(temperature), 
           temp_score = (mean_temp - mean_by_city) / sd_by_city) %>% 
    ungroup() 


ui <- fluidPage( ## define UI for application to draw a histogram
    
    # Application title
    titlePanel("Yearly temperature distribution comparisons between Australian Cities"),
    
    fluidRow(
        column(width = 4,
               sliderInput(inputId = "year1", label = "Year 1", ## creating a slider to pick a year 
                           min = min(temp$year), 
                           max = max(temp$year),
                           step = 1, 
                           value = 1975,
                           sep = "",
                           animate = TRUE)
        ),
        column(width = 4,
               sliderInput(inputId = "year2", label = "Year 2", ## creating another slider to pick a year so to compare two years temperatures
                           min = min(temp$year), 
                           max = max(temp$year),
                           step = 1, 
                           value = 2018,
                           sep = "",
                           animate = TRUE),
        ),
        column(width = 4,
               selectInput(inputId = "cities", label = "City", ## selecting the cities as an input
                           choices =  unique(temp$city_name), 
                           selected = c("SYDNEY", "PERTH"),## choosing two cities
                           multiple = TRUE,
                           selectize = TRUE)
        ),
        column(
            width = 12,
            plotOutput("p1")
            
        )
    )
)

## defining the inputs and outputs for the server to make the plot
server <- function(input, output) {
    
    b <- reactive({
        temp %>% 
            filter(city_name %in% input$cities &
                       (year == input$year1 | year == input$year2))
    })
    
    output$p1 <- renderPlot({ ## creating the output plot
        ggplot(b()) + 
            geom_density(aes(x = temperature, fill = temp_score, ## temperature shown by density 
                             group = interaction(city_name, year)), alpha = 0.5) + 
            scale_fill_viridis_c(option = "magma") +
            geom_vline(aes(xintercept = mean_temp, color = factor(year)), size = 1, linetype = "dashed") + 
            scale_color_viridis_d(option = "inferno") + ## providing colour map for discrete variable 
            cowplot::theme_cowplot() + ## setting the theme
            theme(axis.line.y = element_blank(),
                  axis.text.y = element_blank(),
                  axis.ticks.y = element_blank(),
                  axis.title.y = element_blank()) +
            facet_wrap(~city_name) + ## differing blocks by city name 
            labs(x = "Temperature", ## providing labels
                 fill = "Temp Score",
                 color = "Mean Temp",
                 title = "Temperature Distribution by Year", 
                 subtitle = paste("Years:", input$year1, "and", input$year2),
                 caption = "Australian Temperatures")
    })
}

## run the application 
shinyApp(ui = ui, server = server)