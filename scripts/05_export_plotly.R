# ==========================================
# 05_export_plotly.R
# Converts static plots to interactive Plotly
# HTML widgets for the Option 1 Dashboard
# ==========================================

library(ggplot2)
library(plotly)
library(htmlwidgets)

# Load the cleaned data
data <- read.csv("data/cleaned_data.csv")

# Ensure directory exists
dir.create("results/interactive_widgets", showWarnings = FALSE)

# 1. Interactive Histogram
p_hist <- ggplot(data, aes(x=`Screen.On.Time..hours.day.`)) +
  geom_histogram(bins=30, fill="blue", color="white") +
  theme_minimal() +
  ggtitle("Screen Time Distribution")

p_hist_inter <- ggplotly(p_hist)
saveWidget(p_hist_inter, "results/interactive_widgets/screen_time_hist.html", selfcontained = TRUE)
cat("Widget exported: screen_time_hist.html\n")

# 2. Interactive Scatter
p_scatter <- ggplot(data, aes(
  x=`Screen.On.Time..hours.day.`,
  y=`App.Usage.Time..min.day.`,
  color=`User.Behavior.Class` # Using a relevant variable if available, otherwise solid
)) +
  geom_point(alpha=0.7) +
  theme_minimal() +
  ggtitle("Screen Time vs App Usage")

p_scatter_inter <- ggplotly(p_scatter)
saveWidget(p_scatter_inter, "results/interactive_widgets/scatter.html", selfcontained = TRUE)
cat("Widget exported: scatter.html\n")

# 3. Interactive Boxplot
p_box <- ggplot(data, aes(y=`Screen.On.Time..hours.day.`)) +
  geom_boxplot(fill="blue", alpha=0.5) +
  theme_minimal() +
  ggtitle("Screen Time Boxplot")

p_box_inter <- ggplotly(p_box)
saveWidget(p_box_inter, "results/interactive_widgets/screen_time_boxplot.html", selfcontained = TRUE)
cat("Widget exported: screen_time_boxplot.html\n")

cat("\nAll interactive widgets successfully generated in results/interactive_widgets/!\n")
