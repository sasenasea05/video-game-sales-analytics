library(shiny)
library(shinydashboard)
library(tidyverse)
library(plotly)

# ---------------------------------------------------------
# 1. LOAD DATASET VGSALES
# ---------------------------------------------------------
df <- read_csv("vgsales.csv", show_col_types = FALSE)

# Filter data NA pada kolom Year jika ada
df <- df %>% filter(!is.na(Year))

# ---------------------------------------------------------
# 2. USER INTERFACE (UI)
# ---------------------------------------------------------
ui <- dashboardPage(
  skin = "purple",
  
  dashboardHeader(title = "🎮 Video Game Sales - R"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("gamepad")),
      
      br(),
      h4(" 🔍 Filter Data", style = "margin-left: 15px; color: white;"),
      
      # Filter 1: Dropdown Genre
      selectInput(
        inputId = "genre_filter",
        label = "Pilih Genre:",
        choices = c("Semua Genre", sort(unique(df$Genre))),
        selected = "Semua Genre"
      ),
      
      # Filter 2: Dropdown Platform
      selectInput(
        inputId = "platform_filter",
        label = "Pilih Platform:",
        choices = c("Semua Platform", sort(unique(df$Platform))),
        selected = "Semua Platform"
      )
    )
  ),
  
  dashboardBody(
    tags$head(
      tags$style(HTML("
        .content-wrapper { background-color: #f4f6f9; }
        .small-box { border-radius: 8px; }
      "))
    ),
    
    # ROW 1: KPI CARDS
    fluidRow(
      valueBoxOutput("kpi_total_sales", width = 3),
      valueBoxOutput("kpi_total_games", width = 3),
      valueBoxOutput("kpi_total_publishers", width = 3),
      valueBoxOutput("kpi_total_platforms", width = 3)
    ),
    
    # ROW 2: CHARTS 1 & 2
    fluidRow(
      box(
        title = "1. Top 10 Genre Terlaris (Bar Chart)", 
        status = "primary", solidHeader = TRUE, width = 6,
        plotlyOutput("bar_chart", height = "350px")
      ),
      box(
        title = "2. Tren Penjualan Global per Tahun (Line Chart)", 
        status = "primary", solidHeader = TRUE, width = 6,
        plotlyOutput("line_chart", height = "350px")
      )
    ),
    
    # ROW 3: CHARTS 3 & 4
    fluidRow(
      box(
        title = "3. Donut Chart - Komposisi Penjualan Regional", 
        status = "primary", solidHeader = TRUE, width = 6,
        plotlyOutput("donut_chart", height = "350px")
      ),
      box(
        title = "4. Top 10 Publisher Berdasarkan Global Sales", 
        status = "primary", solidHeader = TRUE, width = 6,
        plotlyOutput("publisher_chart", height = "350px")
      )
    ),
    
    # ROW 4: CHARTS 5 & 6 (BARU)
    fluidRow(
      box(
        title = "5. Komposisi Penjualan Regional di Top 5 Platform", 
        status = "primary", solidHeader = TRUE, width = 6,
        plotlyOutput("platform_regional_chart", height = "350px")
      ),
      box(
        title = "6. Korelasi Penjualan NA vs EU Sales (Scatter Plot)", 
        status = "primary", solidHeader = TRUE, width = 6,
        plotlyOutput("scatter_na_eu", height = "350px")
      )
    ),
    
    # ROW 5: KEY INSIGHTS
    fluidRow(
      box(
        title = "💡 Key Insights (Analisis Video Games)", 
        status = "info", solidHeader = TRUE, width = 12,
        p("• Dashboard R Shiny ini menganalisis lebih dari 16.000 data penjualan game secara global."),
        p("• Wilayah North America (NA) dan Europe (EU) menjadi kontributor penjualan industri game terbesar."),
        p("• Genre Action dan Sports secara konsisten memimpin total akumulasi penjualan global.")
      )
    )
  )
)

# ---------------------------------------------------------
# 3. SERVER LOGIC
# ---------------------------------------------------------
server <- function(input, output, session) {
  
  # Reactive Data Berdasarkan Filter Input
  filtered_data <- reactive({
    data <- df
    
    if (input$genre_filter != "Semua Genre") {
      data <- data %>% filter(Genre == input$genre_filter)
    }
    
    if (input$platform_filter != "Semua Platform") {
      data <- data %>% filter(Platform == input$platform_filter)
    }
    
    return(data)
  })
  
  # --- KPI CARDS ---
  output$kpi_total_sales <- renderValueBox({
    total_val <- sum(filtered_data()$Global_Sales, na.rm = TRUE)
    valueBox(
      value = paste0("$", format(round(total_val, 1), big.mark = ","), "M"),
      subtitle = "Total Global Sales",
      icon = icon("dollar-sign"),
      color = "purple"
    )
  })
  
  output$kpi_total_games <- renderValueBox({
    valueBox(
      value = format(nrow(filtered_data()), big.mark = ","),
      subtitle = "Jumlah Judul Game",
      icon = icon("gamepad"),
      color = "blue"
    )
  })
  
  output$kpi_total_publishers <- renderValueBox({
    pub_count <- n_distinct(filtered_data()$Publisher)
    valueBox(
      value = pub_count,
      subtitle = "Total Publisher",
      icon = icon("building"),
      color = "teal"
    )
  })
  
  output$kpi_total_platforms <- renderValueBox({
    plat_count <- n_distinct(filtered_data()$Platform)
    valueBox(
      value = plat_count,
      subtitle = "Total Platform",
      icon = icon("tv"),
      color = "maroon"
    )
  })
  
  # --- CHARTS ---
  
  # 1. Bar Chart: Top 10 Genre
  output$bar_chart <- renderPlotly({
    req(nrow(filtered_data()) > 0)
    
    p_data <- filtered_data() %>%
      group_by(Genre) %>%
      summarise(Total_Sales = sum(Global_Sales, na.rm = TRUE)) %>%
      arrange(desc(Total_Sales)) %>%
      head(10)
    
    p <- ggplot(p_data, aes(x = reorder(Genre, Total_Sales), y = Total_Sales, fill = Genre)) +
      geom_col() +
      coord_flip() +
      theme_minimal() +
      theme(legend.position = "none") +
      labs(x = "", y = "Global Sales ($ Millions)")
    
    ggplotly(p)
  })
  
  # 2. Line Chart: Tren Penjualan per Tahun
  output$line_chart <- renderPlotly({
    req(nrow(filtered_data()) > 0)
    
    yearly_data <- filtered_data() %>%
      group_by(Year) %>%
      summarise(Total_Sales = sum(Global_Sales, na.rm = TRUE)) %>%
      filter(Year <= 2016)
    
    p <- ggplot(yearly_data, aes(x = Year, y = Total_Sales)) +
      geom_line(color = "#605ca8", size = 1) +
      geom_point(color = "#605ca8") +
      theme_minimal() +
      labs(x = "Tahun", y = "Global Sales ($ Millions)")
    
    ggplotly(p)
  })
  
  # 3. Donut Chart: Regional Sales
  output$donut_chart <- renderPlotly({
    req(nrow(filtered_data()) > 0)
    
    reg_sales <- data.frame(
      Region = c("North America", "Europe", "Japan", "Other"),
      Sales = c(
        sum(filtered_data()$NA_Sales, na.rm = TRUE),
        sum(filtered_data()$EU_Sales, na.rm = TRUE),
        sum(filtered_data()$JP_Sales, na.rm = TRUE),
        sum(filtered_data()$Other_Sales, na.rm = TRUE)
      )
    )
    
    plot_ly(reg_sales, labels = ~Region, values = ~Sales, type = 'pie', hole = 0.4) %>%
      layout(showlegend = TRUE)
  })
  
  # 4. Top 10 Publisher Chart
  output$publisher_chart <- renderPlotly({
    req(nrow(filtered_data()) > 0)
    
    pub_data <- filtered_data() %>%
      group_by(Publisher) %>%
      summarise(Total_Sales = sum(Global_Sales, na.rm = TRUE)) %>%
      arrange(desc(Total_Sales)) %>%
      head(10)
    
    p <- ggplot(pub_data, aes(x = reorder(Publisher, Total_Sales), y = Total_Sales, fill = Publisher)) +
      geom_col() +
      coord_flip() +
      theme_minimal() +
      theme(legend.position = "none") +
      labs(x = "", y = "Global Sales ($ Millions)")
    
    ggplotly(p)
  })
  
  # 5. Stacked Bar Chart: Regional Sales pada Top 5 Platform
  output$platform_regional_chart <- renderPlotly({
    req(nrow(filtered_data()) > 0)
    
    top_plat <- filtered_data() %>%
      group_by(Platform) %>%
      summarise(Total_Global = sum(Global_Sales, na.rm = TRUE)) %>%
      arrange(desc(Total_Global)) %>%
      head(5) %>%
      pull(Platform)
    
    plat_reg_data <- filtered_data() %>%
      filter(Platform %in% top_plat) %>%
      group_by(Platform) %>%
      summarise(
        NA_Sales = sum(NA_Sales, na.rm = TRUE),
        EU_Sales = sum(EU_Sales, na.rm = TRUE),
        JP_Sales = sum(JP_Sales, na.rm = TRUE),
        Other_Sales = sum(Other_Sales, na.rm = TRUE)
      ) %>%
      pivot_longer(cols = -Platform, names_to = "Region", values_to = "Sales")
    
    p <- ggplot(plat_reg_data, aes(x = Platform, y = Sales, fill = Region)) +
      geom_col(position = "stack") +
      theme_minimal() +
      labs(x = "Platform", y = "Sales ($ Millions)")
    
    ggplotly(p)
  })
  
  # 6. Scatter Plot: NA Sales vs EU Sales
  output$scatter_na_eu <- renderPlotly({
    req(nrow(filtered_data()) > 0)
    
    p_data <- filtered_data() %>% head(300)
    
    p <- ggplot(p_data, aes(x = NA_Sales, y = EU_Sales, color = Genre, text = Name)) +
      geom_point(alpha = 0.7, size = 2) +
      theme_minimal() +
      labs(x = "NA Sales ($ Millions)", y = "EU Sales ($ Millions)")
    
    ggplotly(p, tooltip = c("text", "x", "y", "color"))
  })
}

# ---------------------------------------------------------
# 4. RUN APPLICATION
# ---------------------------------------------------------
shinyApp(ui = ui, server = server)