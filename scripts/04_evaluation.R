library(ggplot2)
library(corrplot)
library(GGally)
library(dplyr)

# ===============================
# 🔹 GLOBAL THEME (IMPORTANT 🔥)
# ===============================
theme_set(theme_minimal())

# ===============================
# 🔹 SETUP
# ===============================
dir.create("results", showWarnings = FALSE)
dir.create("results/figures3", showWarnings = FALSE)

data <- read.csv("data/clustered_data.csv")
numeric_data <- data[sapply(data, is.numeric)]

# ===============================
# 🔹 CORRELATION HEATMAP
# ===============================
png("results/figures3/correlation.png", width=800, height=800)

corrplot(cor(numeric_data),
         method="color",
         tl.cex=0.8,
         number.cex=0.7)

dev.off()

# ===============================
# 🔹 HISTOGRAMS
# ===============================

png("results/figures3/screen_time_hist.png", 800, 600)
ggplot(data, aes(x=`Screen.On.Time..hours.day.`)) +
  geom_histogram(bins=30, fill="#4C72B0", color="white") +
  labs(title="Screen Time Distribution",
       x="Screen Time (hours/day)", y="Count")
dev.off()

png("results/figures3/app_usage_hist.png", 800, 600)
ggplot(data, aes(x=`App.Usage.Time..min.day.`)) +
  geom_histogram(bins=30, fill="#55A868", color="white") +
  labs(title="App Usage Distribution",
       x="App Usage (min/day)", y="Count")
dev.off()

png("results/figures3/age_hist.png", 800, 600)
ggplot(data, aes(x=Age)) +
  geom_histogram(bins=30, fill="#C44E52", color="white") +
  labs(title="Age Distribution", x="Age", y="Count")
dev.off()

png("results/figures3/data_usage_hist.png", 800, 600)
ggplot(data, aes(x=`Data.Usage..MB.day.`)) +
  geom_histogram(bins=30, fill="#8172B2", color="white") +
  labs(title="Data Usage Distribution",
       x="Data Usage (MB/day)", y="Count")
dev.off()

# ===============================
# 🔹 BOXPLOTS
# ===============================

png("results/figures3/screen_box.png", 800, 600)
ggplot(data, aes(y=`Screen.On.Time..hours.day.`)) +
  geom_boxplot(fill="#4C72B0") +
  labs(title="Screen Time Distribution", y="Hours/day")
dev.off()

png("results/figures3/age_cluster.png", 800, 600)
ggplot(data, aes(x=Cluster, y=Age, fill=Cluster)) +
  geom_boxplot() +
  labs(title="Age Distribution by Cluster", x="Cluster", y="Age")
dev.off()

png("results/figures3/multi_boxplot.png", 900, 600)
boxplot(numeric_data,
        main="Distribution of Numeric Features",
        col="lightblue",
        las=2)
dev.off()

# ===============================
# 🔹 CATEGORICAL DISTRIBUTIONS
# ===============================

png("results/figures3/gender_dist.png", 800, 600)
ggplot(data, aes(x=Gender, fill=Gender)) +
  geom_bar() +
  labs(title="Gender Distribution", x="Gender", y="Count")
dev.off()

png("results/figures3/os_dist.png", 800, 600)
ggplot(data, aes(x=Operating.System, fill=Operating.System)) +
  geom_bar() +
  labs(title="Operating System Distribution", x="OS", y="Count")
dev.off()

png("results/figures3/behavior_class.png", 800, 600)
ggplot(data, aes(x=User.Behavior.Class, fill=User.Behavior.Class)) +
  geom_bar() +
  labs(title="Behavior Class Distribution", x="Class", y="Count")
dev.off()

# ===============================
# 🔹 CLUSTER VS CATEGORIES
# ===============================

png("results/figures3/cluster_gender.png", 800, 600)
ggplot(data, aes(x=Cluster, fill=Gender)) +
  geom_bar(position="dodge") +
  labs(title="Cluster vs Gender", x="Cluster", y="Count")
dev.off()

png("results/figures3/cluster_os.png", 800, 600)
ggplot(data, aes(x=Cluster, fill=Operating.System)) +
  geom_bar(position="dodge") +
  labs(title="Cluster vs Operating System", x="Cluster", y="Count")
dev.off()

png("results/figures3/cluster_behavior.png", 800, 600)
ggplot(data, aes(x=Cluster, fill=User.Behavior.Class)) +
  geom_bar(position="dodge") +
  labs(title="Cluster vs Behavior Class", x="Cluster", y="Count")
dev.off()

# ===============================
# 🔹 SCATTER PLOTS
# ===============================

png("results/figures3/screen_vs_app.png", 800, 600)
ggplot(data, aes(
  x=`Screen.On.Time..hours.day.`,
  y=`App.Usage.Time..min.day.`,
  color=Cluster
)) +
  geom_point(alpha=0.7) +
  labs(title="Screen Time vs App Usage",
       x="Screen Time (hours/day)",
       y="App Usage (min/day)")
dev.off()

png("results/figures3/battery_vs_screen.png", 800, 600)
ggplot(data, aes(
  x=`Screen.On.Time..hours.day.`,
  y=`Battery.Drain..mAh.day.`,
  color=Cluster
)) +
  geom_point(alpha=0.7) +
  labs(title="Battery Drain vs Screen Time",
       x="Screen Time", y="Battery Drain")
dev.off()

png("results/figures3/apps_vs_data.png", 800, 600)
ggplot(data, aes(
  x=`Number.of.Apps.Installed`,
  y=`Data.Usage..MB.day.`,
  color=Cluster
)) +
  geom_point(alpha=0.7) +
  labs(title="Apps Installed vs Data Usage",
       x="Apps Installed", y="Data Usage")
dev.off()

# ===============================
# 🔹 DENSITY & VIOLIN
# ===============================

png("results/figures3/screen_density.png", 800, 600)
ggplot(data, aes(x=`Screen.On.Time..hours.day.`, fill=Cluster)) +
  geom_density(alpha=0.4) +
  labs(title="Screen Time Density", x="Screen Time")
dev.off()

png("results/figures3/screen_violin.png", 800, 600)
ggplot(data, aes(x=Cluster, y=`Screen.On.Time..hours.day.`, fill=Cluster)) +
  geom_violin(trim=FALSE) +
  labs(title="Screen Time Distribution", x="Cluster", y="Screen Time")
dev.off()

# ===============================
# 🔹 PAIR PLOT
# ===============================

png("results/figures3/pairs.png", 900, 800)
ggpairs(numeric_data)
dev.off()