# ==========================================
# Shiny Application (Option 2)
# Dynamic Plot Explorer (User Builder)
# ==========================================

library(shiny)
library(bslib)
library(ggplot2)
library(plotly)
library(dplyr)
library(cluster)

# Load data
data <- read.csv("../data/cleaned_data.csv")
numeric_vars <- names(data)[sapply(data, is.numeric)]
cat_vars <- c("Gender", "Operating.System", "Device.Model", "User.Behavior.Class")

# Theme
custom_theme <- bs_theme(
  bg = "#0d1117",
  fg = "#e6edf3",
  primary = "#58a6ff",
  secondary = "#8b949e",
  base_font = font_google("Inter"),
  heading_font = font_google("Outfit"),
  "card-bg" = "rgba(22, 27, 34, 0.4)",
  "card-border-radius" = "16px"
)

# Common Plotly Theme configuration
gen_theme <- function() {
  theme_minimal() +
    theme(
      plot.background = element_rect(fill = "transparent", color = NA),
      panel.background = element_rect(fill = "transparent", color = NA),
      text = element_text(color = "#e6edf3"),
      axis.text = element_text(color = "#8b949e"),
      panel.grid.major = element_line(color = "rgba(255,255,255,0.05)"),
      panel.grid.minor = element_blank()
    )
}

style_plotly <- function(p) {
  p %>% 
    layout(plot_bgcolor  = "rgba(0,0,0,0)",
           paper_bgcolor = "rgba(0,0,0,0)",
           font = list(color = "#e6edf3")) %>%
    config(displayModeBar = FALSE)
}

# UI Definition
ui <- page_sidebar(
  theme = custom_theme,
  fillable = TRUE, 
  title = "Smartphone Behavior | Plot Explorer",
  
  sidebar = sidebar(
    title = "Plot Configuration",
    width = 320,
    bg = "#161b22",
    
    selectInput("plot_type", "Plot Type", 
                choices = c("Scatter Plot", "Histogram", "Density Plot", "Boxplot", "Bar Chart", "Correlation Matrix")),
    
    hr(),
    
    accordion(
      accordion_panel(
        "Axes Selection",
        icon = icon("chart-line"),
        selectInput("x_var", "Primary Variable (X)", choices = numeric_vars, selected = "Screen.On.Time..hours.day."),
        
        # Only show Y-axis if the plot type uses two continuous variables
        conditionalPanel(
          condition = "input.plot_type == 'Scatter Plot'",
          selectInput("y_var", "Secondary Variable (Y)", choices = numeric_vars, selected = "App.Usage.Time..min.day.")
        )
      ),
      
      accordion_panel(
        "Color / Grouping Overlay",
        icon = icon("paint-roller"),
        selectInput("cat_var", "Overlay Group", 
                    choices = c("Dynamic K-Means Cluster", "None", cat_vars), 
                    selected = "Dynamic K-Means Cluster"),
        helpText("Color codes your graph. (For Boxplots and Bar Charts, this acts as the primary category).")
      ),
      
      accordion_panel(
        "Dynamic K-Means Clustering",
        icon = icon("project-diagram"),
        
        sliderInput("k_clusters", "Number of Clusters (K)", min = 2, max = 5, value = 3, step = 1),
        
        tooltip(
          icon("info-circle"),
          paste("Dragging this recalculates K-Means instantly to group data logically into K clusters based on your selected Continuous Variables.")
        )
      )
    )
  ),
  
  # Master Main Window
  layout_columns(
    fill = TRUE,
    col_widths = c(12),
    card(
      full_screen = TRUE,
      card_header(
        textOutput("plot_header"),
        class = "text-primary fw-bold fs-5"
      ),
      plotlyOutput("mainPlot", height = "100%")
    )
  )
)

# Server Logic
server <- function(input, output, session) {
  
  # Master header
  output$plot_header <- renderText({ paste("Interactive", input$plot_type) })
  
  # Reactive K-Means clustering -> Recalculates whenever inputs change!
  cluster_data <- reactive({
    req(input$x_var)
    
    # Scale selected data (if Y is null, use X for 1D cluster, else both)
    if(input$plot_type == "Scatter Plot" && !is.null(input$y_var)) {
      selected_data <- data %>% select(all_of(c(input$x_var, input$y_var)))
    } else {
       # Fallback to general numeric clustering if not scatter
      selected_data <- data %>% select(all_of(numeric_vars))
    }
    
    scaled_data <- scale(selected_data)
    
    set.seed(42)
    km <- kmeans(scaled_data, centers = input$k_clusters, nstart = 25)
    
    result <- data
    result$DynamicCluster <- factor(as.numeric(km$cluster))
    return(result)
  })
  
  # Default brand colors
  color_map <- c("#58A6FF", "#3FB950", "#D2A8FF", "#F85149", "#FDAEB7")
  
  # MASTER PLOT RENDERER
  output$mainPlot <- renderPlotly({
    df <- cluster_data()
    
    # Define color logic
    color_col <- if(input$cat_var == "Dynamic K-Means Cluster") "DynamicCluster" else if(input$cat_var == "None") NULL else input$cat_var
    
    # ---------- Plot Builder Switch Logic ----------
    
    if (input$plot_type == "Correlation Matrix") {
      # Custom logic for heatmap (ignoring individual axis vars)
      num_data <- data[, numeric_vars]
      cormatrix <- cor(num_data, use="complete.obs")
      
      p <- plot_ly(
        z = cormatrix,
        x = colnames(cormatrix),
        y = rownames(cormatrix),
        type = "heatmap",
        zmin = 0, zmax = 1,
        colorscale = "RdBu"
      ) %>%
        layout(
          plot_bgcolor  = "rgba(0,0,0,0)",
          paper_bgcolor = "rgba(0,0,0,0)",
          font = list(color = "#e6edf3"),
          xaxis = list(tickangle = 45),
          margin = list(b = 100) # give room for labels
        ) %>% config(displayModeBar = FALSE)
      
      return(p)
      
    } else {
      
      # Base ggplot object
      p <- ggplot(df) + gen_theme()
      
      # 1. Histogram
      if (input$plot_type == "Histogram") {
        if (!is.null(color_col)) {
           p <- p + geom_histogram(aes_string(x = paste0("`", input$x_var, "`"), fill = color_col), bins = 30, color = "white", alpha = 0.8, position = "identity")
        } else {
           p <- p + geom_histogram(aes_string(x = paste0("`", input$x_var, "`")), bins = 30, fill = "#58a6ff", color = "white", alpha = 0.8)
        }
        
      # 2. Density Plot
      } else if (input$plot_type == "Density Plot") {
        if (!is.null(color_col)) {
           p <- p + geom_density(aes_string(x = paste0("`", input$x_var, "`"), fill = color_col), alpha = 0.5)
        } else {
           p <- p + geom_density(aes_string(x = paste0("`", input$x_var, "`")), fill = "#58a6ff", alpha = 0.5)
        }
        
      # 3. Boxplot (Mapped X=Category, Y=Variable)
      } else if (input$plot_type == "Boxplot") {
        if (!is.null(color_col)) {
           p <- p + geom_boxplot(aes_string(x = color_col, y = paste0("`", input$x_var, "`"), fill = color_col), alpha = 0.7, color="#e6edf3")
        } else {
           # If no category, just plot single boxplot
           p <- p + geom_boxplot(aes_string(y = paste0("`", input$x_var, "`")), fill = "#58a6ff", alpha = 0.7, color="#e6edf3")
        }
        
      # 4. Bar Chart (Cat Counts)
      } else if (input$plot_type == "Bar Chart") {
        if (!is.null(color_col)) {
           p <- p + geom_bar(aes_string(x = color_col, fill = color_col), alpha = 0.9) +
             labs(title = paste("Count of", color_col), y = "Total Count")
        } else {
           # Fallback if no category selected
           p <- p + geom_bar(aes_string(x = paste0("`", input$x_var, "`")), fill = "#58a6ff", alpha = 0.9)
        }
        
      # 5. Scatter Plot
      } else if (input$plot_type == "Scatter Plot") {
        req(input$y_var) # Requires Y axis
        if (!is.null(color_col)) {
           p <- p + geom_point(aes_string(x = paste0("`", input$x_var, "`"), y = paste0("`", input$y_var, "`"), color = color_col), alpha = 0.8, size = 3)
        } else {
           p <- p + geom_point(aes_string(x = paste0("`", input$x_var, "`"), y = paste0("`", input$y_var, "`")), color = "#58a6ff", alpha = 0.8, size = 3)
        }
      }
      
      # Final logic for manual colors if Cluster is used
      if (!is.null(color_col) && color_col == "DynamicCluster") {
        p <- p + scale_fill_manual(values = color_map) + scale_color_manual(values = color_map)
      }
      
      # Send final object to plotly
      p_ly <- ggplotly(p) %>% style_plotly()
      
      # Clean up Plotly's known tuple bug in legends e.g. "(2,1)" -> "2"
      for (i in seq_along(p_ly$x$data)) {
        if (!is.null(p_ly$x$data[[i]]$name)) {
          p_ly$x$data[[i]]$name <- gsub("^\\((.*),1\\)$", "\\1", p_ly$x$data[[i]]$name)
        }
      }
      
      return(p_ly)
    }
  })
}

shinyApp(ui = ui, server = server)
