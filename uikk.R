library(dygraphs)

tourist <- read.csv('tourist.csv', stringsAsFactors = FALSE)
choices <- unique(tourist$Country)

shinyUI(pageWithSidebar(
        headerPanel('Tourist Visit to Birthplace of Gautam Buddha, Lumbini, Nepal'),
        sidebarPanel(
                selectInput('Country', 'Choose Country', choices = choices),
                p('Total Tourist visit from select country'),
                tableOutput("table_output"),
                p('Top 5 Countries with highest number of tourists'),
                plotOutput("view")
        ),
        mainPanel(
                h4('Dygraph Visualization for tourist data from selected country'),
                dygraphOutput("dygraph"),
                p("For Complete code, visit ",
                  a("Github", href = "https://github.com/kckishan/FirstShinyapp")),
                p("© ", a("Kishan K.C.", href = "https://np.linkedin.com/in/kishankc" ),
                  "2015 All Rights reserved.")
        )
))
