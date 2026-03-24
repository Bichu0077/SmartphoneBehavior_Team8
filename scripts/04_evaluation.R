library(arules)
library(arulesViz)

data <- read.csv("../data/clustered_data.csv")

# Convert to categorical
data$ScreenTime <- cut(data$ScreenTime, 3,
                      labels=c("Low","Medium","High"))

# Convert to transactions
trans <- as(data, "transactions")

# Apply Apriori
rules <- apriori(trans,
                 parameter=list(support=0.1, confidence=0.6))

# Save rules
sink("../results/tables/rules.txt")
inspect(rules)      
sink()

# Plot rules
png("../results/figures/rules_graph.png")
plot(rules, method="graph")
dev.off()