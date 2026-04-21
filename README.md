# ADS500B
# E-Commerce User Behavior Analysis

## Overview
This project analyzes user behavior in an e-commerce setting to understand and predict purchasing outcomes. Using the Online Shoppers Intention dataset, we explored how user engagement, browsing patterns, and session characteristics influence the likelihood of a completed purchase.

The project was completed as part of a final team assignment focused on applying data cleaning, exploratory data analysis (EDA), and supervised machine learning techniques.

## Dataset
The dataset contains 12,330 online shopping sessions collected over one year. Each row represents a unique user session, minimizing bias from repeated users.

Features include:
- Page interaction metrics (Administrative, Informational, Product Related)
- Engagement durations
- Behavioral metrics (Bounce Rate, Exit Rate, Page Value)
- Contextual variables (Month, Visitor Type, Weekend)

The target variable:
- Revenue (1 = purchase, 0 = no purchase)

Source: UCI Machine Learning Repository: contentReference[oaicite:0]{index=0}

---

## Objective
The goal of this project is to:
- Analyze user behavior patterns in e-commerce sessions
- Identify key predictors of purchasing behavior
- Build a classification model to predict whether a session results in a purchase

---

## Tools & Technologies
- R
- ggplot2
- dplyr
- tidyr
- corrplot
- Statistical modeling (Logistic Regression)

---

## Project Structure

├── data/
│   └── online_shoppers_intention.csv  
│
├── analysis.Rmd  
├── FinalProject-Team4.pdf  
└── README.md
---

## Methods

### Data Cleaning & Preparation
- Replaced missing numerical values with median
- Replaced missing categorical values with "NA"
- Normalized BounceRates and ExitRates
- Removed unclear variables (OperatingSystems, Browser, Region, TrafficType)
- Created new features:
  - Binary engagement variables (Product, Info, Admin)
  - Time-per-page metrics

### Exploratory Data Analysis
- Summary statistics (mean, median, variance)
- Distribution analysis (histograms, boxplots)
- Correlation analysis
- Engagement behavior analysis

### Modeling
- Logistic Regression model used to predict purchase behavior
- Train/test split (70/30)
- Evaluated using:
  - Accuracy
  - Precision
  - Recall
  - Confusion Matrix

---

## Key Findings

- **PageValues is the strongest predictor of revenue** (~0.49 correlation)
- **ExitRates and BounceRates negatively impact purchases**
- **User engagement is the biggest driver of conversions**
- Product engagement occurs in ~94% of sessions
- Informational engagement is significantly lower (~19%)

From modeling:
- Accuracy: ~88%
- Precision: ~0.74
- Recall: ~0.34

The model performs well overall but is better at predicting non-purchases than purchases.

---

## Visual Insights

- Highly **skewed and zero-inflated dataset**
- Clear separation in PageValues between purchase vs non-purchase sessions
- Increased product engagement correlates with higher conversion probability
- Log transformations improve the interpretability of engagement distributions

---

## How to Run This Project

1. Clone the repository
2. Open the R Markdown file in RStudio
3. Install required packages:
   ```r
   install.packages(c("ggplot2", "dplyr", "tidyr", "corrplot"))
4. Run all code chunks

## Project Workflow & Collaboration

This project was completed through a combination of **individual analysis and collaborative integration**.

Each team member independently worked on different components of the project, developing their own approaches to data cleaning, exploratory analysis, and modeling. These individual efforts allowed for a broader exploration of techniques and perspectives across the dataset.

The final R Markdown file represents a **combined and refined version** of the team’s work. Key sections from each member’s individual project were selected, integrated, and standardized into a single cohesive analysis pipeline.

To maintain transparency and showcase individual contributions, each team member’s original work is also included in this repository. This provides insight into the development process, alternative approaches, and how the final analysis evolved.

This workflow allowed the team to:
- Explore multiple analytical approaches in parallel  
- Compare and evaluate different methods  
- Combine the strongest components into a unified final deliverable 
