library(tidyverse)
library(ggplot2)

# ===============================
# 🔹 LOAD DATA
# ===============================

data <- read.csv("data/user_behavior_dataset.csv")

cat("===== INITIAL DATA =====\n")
print(dim(data))
print(str(data))

# ===============================
# 🔹 MISSING VALUE ANALYSIS
# ===============================

cat("\n===== MISSING VALUES BEFORE =====\n")
missing_before <- colSums(is.na(data))
print(missing_before)

missing_percent <- (missing_before / nrow(data)) * 100
print(round(missing_percent, 2))

# Create dataframe for plotting missing values
missing_df <- data.frame(
  column = names(missing_before),
  missing = missing_before
)

# Save missing values plot
png("results/figures/missing_before.png")
ggplot(missing_df, aes(x=reorder(column, -missing), y=missing)) +
  geom_bar(stat="identity", fill="red") +
  geom_text(aes(label=missing), vjust=-0.5) +
  theme(axis.text.x = element_text(angle=45, hjust=1)) +
  ggtitle("Missing Values Before Cleaning") +
  ylim(0, max(missing_df$missing + 1))
dev.off()

# ===============================
# 🔹 REMOVE MISSING VALUES
# ===============================

data_clean <- na.omit(data)

cat("\n===== MISSING VALUES AFTER =====\n")
missing_after <- colSums(is.na(data_clean))
print(missing_after)

cat("\nRows before:", nrow(data))
cat("\nRows after:", nrow(data_clean))

# ===============================
# 🔹 HANDLE CATEGORICAL VARIABLES
# ===============================

data_clean$Gender <- as.factor(data_clean$Gender)
data_clean$Operating.System <- as.factor(data_clean$Operating.System)
data_clean$Device.Model <- as.factor(data_clean$Device.Model)

# ===============================
# 🔹 OUTLIER HANDLING (IQR METHOD)
# ===============================

col <- "Screen.On.Time..hours.day."

if(col %in% names(data_clean)) {
  
  Q1 <- quantile(data_clean[[col]], 0.25)
  Q3 <- quantile(data_clean[[col]], 0.75)
  IQR_val <- Q3 - Q1
  
  before_rows <- nrow(data_clean)
  
  data_clean <- data_clean[
    data_clean[[col]] >= (Q1 - 1.5*IQR_val) &
      data_clean[[col]] <= (Q3 + 1.5*IQR_val),
  ]
  
  after_rows <- nrow(data_clean)
  
  cat("\n===== OUTLIER REMOVAL =====\n")
  cat("Rows before:", before_rows, "\n")
  cat("Rows after:", after_rows, "\n")
}

# ===============================
# 🔹 FINAL PREPROCESSING
# ===============================

# Ensure categorical variables are factors
data_clean$Gender <- as.factor(data_clean$Gender)
data_clean$Operating.System <- as.factor(data_clean$Operating.System)
data_clean$Device.Model <- as.factor(data_clean$Device.Model)

str(data_clean)

# Remove ID column
data_clean$User.ID <- NULL

# Convert target variable to factor
data_clean$User.Behavior.Class <- as.factor(data_clean$User.Behavior.Class)

str(data_clean)

# ===============================
# 🔹 SAVE CLEANED DATA
# ===============================

write.csv(data_clean, "data/cleaned_data.csv", row.names=FALSE)