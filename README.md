# 📱 Smartphone Behavior Analysis using Data Mining

## 👥 Team Members
- Bichu Devnarayan – 2023BCS0102  
- Ravishankar R – 2023BCS0015  
- Aswin Parames – 2023BCD0024  
- Abin V Tomy – 2023BCS0084  

---

## 🎯 Problem Statement
With the rapid increase in smartphone usage, large volumes of behavioral data are generated daily. This project aims to analyze smartphone usage patterns and uncover meaningful behavioral groups and relationships using data mining techniques.

---

## 🎯 Objectives
- Identify distinct user behavior groups using clustering  
- Discover relationships between usage features  
- Perform comprehensive exploratory data analysis  
- Visualize behavioral patterns using multiple graphical techniques  

---

## 📊 Dataset
- **Source:** Kaggle (User Behavior Dataset)  
- **Description:** Contains smartphone usage data including screen time, app usage, battery consumption, and user demographics  
- **Number of Records:** 700  
- **Number of Features:** 10+  

---

## ⚙️ Methodology

### 🔹 1. Data Preprocessing
- Missing value analysis (no missing values found)  
- Outlier detection using IQR method  
- Categorical variables converted to factors  
- Removal of irrelevant attributes (User ID)  

---

### 🔹 2. Exploratory Data Analysis (EDA)
- Distribution analysis using histograms  
- Correlation analysis using heatmaps  
- Feature relationships using scatter plots  
- Category analysis using bar charts  
- Multi-dimensional analysis using pair plots  

---

### 🔹 3. Clustering (K-Means)
- Data scaled using standardization  
- Optimal number of clusters identified using Elbow Method  
- Users grouped into behavioral clusters  
- Cluster-wise feature comparison performed  

---

### 🔹 4. Evaluation & Visualization
- Cluster distribution analysis  
- Feature-wise comparison across clusters  
- Relationship analysis between key variables  
- Advanced visualization techniques (density plots, violin plots)  

---

## 📈 Results

### 🔹 Clustering Insights
- **Cluster 1:** High screen time and app usage → Heavy users  
- **Cluster 2:** Moderate usage → Balanced users  
- **Cluster 3:** Low usage → Minimal users  

---

### 🔹 Behavioral Patterns
- Strong correlation between screen time and app usage  
- Increased screen time leads to higher battery consumption  
- Users with more apps tend to consume more data  

---

### 🔹 Key Observations
- Clear separation of user behavior groups  
- Consistent patterns across multiple features  
- Behavioral insights validated through multiple visualizations  

---

## 📊 Key Visualizations

### 🔹 Correlation Heatmap
![Correlation](results/figures3/correlation.png)

### 🔹 Cluster Distribution
![Cluster](results/figures2/cluster_distribution.png)

### 🔹 Screen Time Distribution
![Screen](results/figures3/screen_time_hist.png)

### 🔹 Screen Time vs App Usage
![Scatter](results/figures3/screen_vs_app.png)

### 🔹 Density Plot
![Density](results/figures3/screen_density.png)

---

## 🚀 How to Run

1. Install required packages:
```r
source("requirements.R")
```

2. Run scripts in order:
```
01_data_preparation.R
02_exploratory_analysis.R
03_modeling.R
04_evaluation.R
```

3. All results will be saved in:
```
results/figures/
results/figures2/
results/figures3/
```

---

## 📌 Conclusion
This project successfully identifies meaningful behavioral patterns in smartphone usage data. The use of clustering and extensive visualization reveals clear distinctions between different types of users, providing valuable insights into digital habits and usage trends.

---

## 👨‍💻 Contribution
- Bichu Devnarayan – Data preprocessing, EDA, report writing  
- Ravishankar R – Clustering and modeling  
- Aswin Parames – Visualization and analysis  
- Abin V Tomy – Evaluation and documentation  

---

## 📚 References
- Kaggle Dataset  
- R Documentation  
- Data Mining Concepts (K-Means Clustering)  

---

## 🔗 GitHub Repository
(Add your repo link here)
