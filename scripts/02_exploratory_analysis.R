library(ggplot2)
library(corrplot)
library(GGally)

data <- read.csv("data/cleaned_data.csv")

# Histogram
png("results/figures/screen_time_hist.png")
ggplot(data, aes(x=`Screen.On.Time..hours.day.`)) +
  geom_histogram(bins=30, fill="blue")
dev.off()

png("results/figures/screen_time_boxplot.png")

ggplot(data, aes(y=`Screen.On.Time..hours.day.`)) +
  geom_boxplot(fill="blue") +
  ggtitle("Screen Time Distribution")

dev.off()

# Correlation Heatmap
numeric_data <- data[sapply(data, is.numeric)]
png("results/figures/correlation.png")
corrplot(cor(numeric_data), method="color")
dev.off()

# Scatter plot
png("results/figures/scatter.png")

ggplot(data, aes(
  x=`Screen.On.Time..hours.day.`,
  y=`App.Usage.Time..min.day.`
)) +
  geom_point(color="blue") +
  ggtitle("Screen Time vs App Usage")

dev.off()

# Pair plot (optional but strong)
png("results/figures/pairs.png")

ggpairs(numeric_data)

dev.off()