library(tidyverse)

data <- read.csv("user_behavior_dataset.csv")

cat("===== INITIAL DATA =====\n")
print(dim(data))
print(str(data))

# Missing values BEFORE
cat("\n===== MISSING VALUES BEFORE =====\n")
missing_before <- colSums(is.na(data))
print(missing_before)

missing_percent <- (missing_before / nrow(data)) * 100
print(round(missing_percent, 2))

# Save missing plot
missing_df <- data.frame(
  column = names(missing_before),
  missing = missing_before
)

png("../results/figures/missing_before.png")
ggplot(missing_df, aes(x=reorder(column, -missing), y=missing)) +
  geom_bar(stat="identity", fill="red") +
  theme(axis.text.x = element_text(angle=45, hjust=1)) +
  ggtitle("Missing Values Before Cleaning")
dev.off()

# Remove NA
data_clean <- na.omit(data)

# Missing AFTER
cat("\n===== MISSING VALUES AFTER =====\n")
missing_after <- colSums(is.na(data_clean))
print(missing_after)

cat("\nRows before:", nrow(data))
cat("\nRows after:", nrow(data_clean))

# Keep numeric only
data_clean <- data_clean[, sapply(data_clean, is.numeric)]

# Outlier handling (IQR)
Q1 <- quantile(data_clean$ScreenTime, 0.25)
Q3 <- quantile(data_clean$ScreenTime, 0.75)
IQR_val <- Q3 - Q1

data_clean <- data_clean[
  data_clean$ScreenTime >= (Q1 - 1.5*IQR_val) &
  data_clean$ScreenTime <= (Q3 + 1.5*IQR_val),
]

# Save cleaned data
write.csv(data_clean, "../data/cleaned_data.csv", row.names=FALSE)