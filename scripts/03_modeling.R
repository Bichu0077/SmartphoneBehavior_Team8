library(cluster)
library(factoextra)

data <- read.csv("../data/cleaned_data.csv")

# Scaling
data_scaled <- scale(data)

# Find optimal K
png("../results/figures/elbow.png")
fviz_nbclust(data_scaled, kmeans, method="wss")
dev.off()

# KMeans
set.seed(123)
kmeans_model <- kmeans(data_scaled, centers=3, nstart=25)

data$Cluster <- kmeans_model$cluster

# Cluster visualization
png("../results/figures/cluster_plot.png")
fviz_cluster(kmeans_model, data=data_scaled)
dev.off()

# Cluster summary
cluster_summary <- aggregate(data, by=list(data$Cluster), mean)

write.csv(cluster_summary,
          "../results/tables/cluster_summary.csv",
          row.names=FALSE)

# Save clustered data
write.csv(data, "../data/clustered_data.csv", row.names=FALSE)