#Load Required Library
library(dygraphs)
library(ggplot2)
library(reshape2)
library(xts)

#Load data
tourist <- read.csv('tourist.csv', stringsAsFactors = FALSE)
tourist <- tourist[,c(1,3,4,5)]
tourist$No.of.Visitors <- as.numeric(tourist$No.of.Visitors)
tourist$Year.AD <- as.factor(tourist$Year.AD)
tourist$Month <- factor(tourist$Month
                        , levels = c("Jan.","Feb.","Mar.","April","May","June","July",
                                     "Aug.","Sept.","Oct.","Nov.","Dec.")
                        , labels = c("01","02","03","04","05","06","07",
                                     "08","09", "10","11","12"))

#Identify top 5 countries with highest number of visitors to Nepal
aggregated_data <- aggregate(No.of.Visitors ~ Country, data = tourist, FUN = sum)
top_5_country <- aggregated_data[order(-aggregated_data$No.of.Visitors),][1:5,]
top_5_country$Country <- factor(top_5_country$Country, levels = top_5_country$Country)

shinyServer(
        function(input, output) {
                datasetInput <- reactive({
                        dataset <- subset(tourist, Country == input$Country)
                        dataset
                })
                
                output$Country  <- renderPrint({input$Country})
                output$dygraph <- renderDygraph({
                        touristData <- datasetInput()
                        tourist_xts <- as.xts(
                                touristData[4]
                                , order.by = as.Date(
                                        paste0(touristData$Year.AD,"-",touristData$Month,
                                               "-01",format = "%Y-%M-01")
                                )
                        )
                        dygraph(data = tourist_xts, 
                                main = paste("Tourist Visit from ",input$Country,
                                             " to Lumbini, Nepal", sep = "")) %>% 
                                dyRangeSelector()
                })
                output$view <- renderPlot({
                        ggplot(top_5_country, aes(x = Country, y = No.of.Visitors)) + 
                                geom_bar(stat = "identity", fill = "red") + 
                                theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
                                ylab("Number of Visitors")
                })
                output$table_output <- renderTable({
                     dataset <- datasetInput()
                     dataset <- aggregate(No.of.Visitors ~ Year.AD, 
                                          data = dataset, FUN = sum)
                     dataset
                })
        }
)

