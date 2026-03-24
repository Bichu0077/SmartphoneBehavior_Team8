library(ggplot2)
library(corrplot)
library(GGally)

data <- read.csv("../data/cleaned_data.csv")

# Histogram
png("../results/figures/screen_time_hist.png")
ggplot(data, aes(x=ScreenTime)) +
  geom_histogram(bins=30, fill="blue")
dev.off()

# Boxplot
png("../results/figures/boxplot.png")
boxplot(data, main="Boxplot for Outliers")
dev.off()

# Correlation Heatmap
png("../results/figures/correlation.png")
corrplot(cor(data), method="color")
dev.off()

# Scatter plot
png("../results/figures/scatter.png")
ggplot(data, aes(x=ScreenTime, y=SocialMediaUsage)) +
  geom_point()
dev.off()

# Pair plot (optional but strong)
png("../results/figures/pairs.png")
pairs(data)
dev.off()