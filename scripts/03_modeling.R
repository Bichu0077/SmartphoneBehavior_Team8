library(cluster)
library(ggplot2)
library(dplyr)

# Create folders if not exist
dir.create("results", showWarnings = FALSE)
dir.create("results/figures2", showWarnings = FALSE)
dir.create("results/tables", showWarnings = FALSE)

# ===============================
# 🔹 LOAD DATA
# ===============================
data <- read.csv("data/cleaned_data.csv")

# Keep only numeric columns for clustering
numeric_data <- data[sapply(data, is.numeric)]

# Scaling
data_scaled <- scale(numeric_data)

# ===============================
# 🔹 ELBOW METHOD (MANUAL)
# ===============================
wss <- numeric(10)

for (k in 1:10) {
  km <- kmeans(data_scaled, centers = k, nstart = 10)
  wss[k] <- km$tot.withinss
}

png("results/figures2/elbow.png")

plot(1:10, wss, type="b", pch=19,
     xlab="Number of Clusters",
     ylab="Within Sum of Squares",
     main="Elbow Method")

dev.off()

# ===============================
# 🔹 KMEANS
# ===============================
set.seed(123)
kmeans_model <- kmeans(data_scaled, centers=3, nstart=25)

data$Cluster <- as.factor(kmeans_model$cluster)

# ===============================
# 🔹 CLUSTER VISUALIZATION (2D)
# ===============================
png("results/figures2/cluster_plot.png")

plot(data_scaled[,1:2],
     col=kmeans_model$cluster,
     pch=19,
     xlab="Feature 1",
     ylab="Feature 2",
     main="Cluster Visualization")

dev.off()

# ===============================
# 🔹 CLUSTER DISTRIBUTION
# ===============================
png("results/figures2/cluster_distribution.png")

ggplot(data, aes(x=Cluster, fill=Cluster)) +
  geom_bar() +
  ggtitle("Cluster Distribution")

dev.off()

# ===============================
# 🔹 FEATURE DISTRIBUTION BY CLUSTER
# ===============================
png("results/figures2/screen_time_cluster.png")

ggplot(data, aes(x=Cluster, y=`Screen.On.Time..hours.day.`, fill=Cluster)) +
  geom_boxplot() +
  ggtitle("Screen Time by Cluster")

dev.off()

png("results/figures2/app_usage_cluster.png")

ggplot(data, aes(x=Cluster, y=`App.Usage.Time..min.day.`, fill=Cluster)) +
  geom_boxplot() +
  ggtitle("App Usage by Cluster")

dev.off()

# ===============================
# 🔹 CLUSTER SUMMARY
# ===============================
cluster_summary <- data %>%
  group_by(Cluster) %>%
  summarise(across(where(is.numeric), mean))

write.csv(cluster_summary, "results/tables/cluster_summary.csv", row.names=FALSE)

# ===============================
# 🔹 SAVE DATA
# ===============================
write.csv(data, "data/clustered_data.csv", row.names=FALSE)