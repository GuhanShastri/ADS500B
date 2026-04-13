setwd("C:/Users/guhan/Desktop/Course Work")
data <- read_csv("online_shoppers_intention.csv")

install.packages(c("ggplot2", "moments", "corrplot", "tidyr"))
library(ggplot2)
library(moments)
library(corrplot)
library(tidyr)
library(dplyr)

spec(data)
summary(data)


quant_cols <- c("Administrative", "Administrative_Duration", "Informational",
"Informational_Duration", "ProductRelated", "ProductRelated_Duration",
"BounceRates", "ExitRates", "PageValues", "SpecialDay",
"OperatingSystems", "Browser", "Region", "TrafficType")

colSums(is.na(data[, quant_cols]))

for (col in quant_cols) {
data[[col]][is.na(data[[col]])] <- mean(data[[col]], na.rm = TRUE)
}

colSums(is.na(data[, quant_cols]))


cat_cols <- c("Month", "VisitorType", "Weekend", "Revenue")


for (col in cat_cols) {
data[[col]][is.na(data[[col]]) | data[[col]] == ""] <- "NA"
}



data_clean <- data

for (col in quant_cols) {
z_scores <- scale(data_clean[[col]])
data_clean <- data_clean[abs(z_scores) <= 3, ]
}






normalize <- function(x) {
return((x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE)))
}

data_normalized <- data
data_normalized[, quant_cols] <- lapply(data[, quant_cols], normalize)
summary(data_normalized[, quant_cols])


data_combined <- cbind(data[, quant_cols], data[, cat_cols])

names(data_combined)
head(data_combined)

data_ready <- data_combined[, !names(data) %in% c("OperatingSystems", "Browser", "Region")]


## End Part 1 ##

str(data_ready)            
sapply(data_ready, class)  


numerical_vars <- names(data_ready[sapply(data_ready, is.numeric)])
cat("Numerical Variables:\n")
print(numerical_vars)


categorical_vars <- names(data_ready[, sapply(data_ready, function(x) 
is.character(x) | is.logical(x) | is.factor(x))])

cat("Categorical Variables:\n")
print(categorical_vars)



get_mode <- function(x) {
unique_x <- unique(x)
unique_x[which.max(tabulate(match(x, unique_x)))]
}

stats_table <- data.frame(
Column   = numerical_vars,
Mean     = sapply(data_ready[, numerical_vars], function(x) round(mean(x, na.rm = TRUE), 3)),
Median   = sapply(data_ready[, numerical_vars], function(x) round(median(x, na.rm = TRUE), 3)),
Mode     = sapply(data_ready[, numerical_vars], function(x) get_mode(x)),
Std_Dev  = sapply(data_ready[, numerical_vars], function(x) round(sd(x, na.rm = TRUE), 3)),
Variance = sapply(data_ready[, numerical_vars], function(x) round(var(x, na.rm = TRUE), 3)),
Skewness = sapply(data_ready[, numerical_vars], function(x) round(skewness(x, na.rm = TRUE), 3)),
Kurtosis = sapply(data_ready[, numerical_vars], function(x) round(kurtosis(x, na.rm = TRUE), 3)),
Min      = sapply(data_ready[, numerical_vars], function(x) round(min(x, na.rm = TRUE), 3)),
Max      = sapply(data_ready[, numerical_vars], function(x) round(max(x, na.rm = TRUE), 3))
)


data_long <- pivot_longer(data_ready[, numerical_vars],
cols = everything(),
names_to = "Variable",
values_to = "Value")

ggplot(data_long, aes(x = Value, fill = Variable)) +
geom_histogram(bins = 30, color = "white", show.legend = FALSE) +
facet_wrap(~Variable, scales = "free") +
theme_minimal() +
labs(title = "Distribution of Numerical Variables",
x = "Value", y = "Frequency")


ggplot(data_long, aes(x = Variable, y = Value, fill = Variable)) +
geom_boxplot(outlier.colour = "red", outlier.size = 0.8, show.legend = FALSE) +
facet_wrap(~Variable, scales = "free") +
theme_minimal() +
theme(axis.text.x = element_blank()) +
labs(title = "Boxplots of Numerical Variables",
x = "", y = "Value")


for (col in categorical_vars) {
p <- ggplot(data_ready, aes(x = as.factor(.data[[col]]), 
fill = as.factor(.data[[col]]))) +
geom_bar(show.legend = FALSE) +
theme_minimal() +
labs(title = paste("Distribution of", col),
x = col, y = "Count")
  print(p)
}


cor_matrix <- cor(data_ready[, numerical_vars], use = "complete.obs")

corrplot(cor_matrix,
method = "color",
type = "upper",
tl.cex = 0.7,
addCoef.col = "black",
number.cex = 0.6,
title = "Correlation Heatmap",
mar = c(0, 0, 1, 0))


## End Part 2 ##


dependent_var <- "Revenue"
cat("Dependent Variable:", dependent_var, "\n")
cat("Type: Binary Classification (TRUE = purchase, FALSE = no purchase)\n")
cat("Unique values:\n")


independent_vars <- names(data_ready)[names(data_ready) != "Revenue"]
cat("\nIndependent Variables:\n")




numerical_independent <- names(data_ready)[
  sapply(data_ready, is.numeric) & names(data_ready) != "Revenue"
]
cat("Numerical Independent Variables:\n")

categorical_independent <- names(data_ready)[
  (sapply(data_ready, is.factor) | 
     sapply(data_ready, is.character) | 
     sapply(data_ready, is.logical)) & 
    names(data_ready) != "Revenue"
]
cat("\nCategorical Independent Variables:\n")


data_ready$Revenue_binary <- ifelse(data_ready$Revenue == "TRUE", 1, 0)

correlations <- sapply(data_ready[, numerical_independent], function(x)
  cor(x, data_ready$Revenue_binary, use = "complete.obs"))


correlations_sorted <- sort(abs(correlations), decreasing = TRUE)
cat("Correlation with Revenue (sorted by strength):\n")


corr_df <- data.frame(
  Variable    = names(correlations_sorted),
  Correlation = as.numeric(correlations_sorted)
)

ggplot(corr_df, aes(x = reorder(Variable, Correlation), 
                    y = Correlation, fill = Correlation)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Correlation of Numerical Variables with Revenue",
       x = "Variable", y = "Absolute Correlation")


