# install and load necessary packages
install.packages("readxl")
install.packages("tidyr")
install.packages("zoo")
install.packages("dplyr")
install.packages("car")
library(readxl)
library(tidyr)
library(zoo)
library(dplyr)
library(ggplot2)
library(corrplot)
library(car)

# file path
path <- "C:/Users/woofy/Downloads/Data_HomeEx1/Data_HomeEx1/"

# source data paths
source_pass      <- paste0(path, "Result_AK9_Dalarna_Kum.xlsx")
source_elections <- paste0(path, "Dalarna_MunicipalElectionResults.xlsx")
source_income    <- paste0(path, "Dalarna_AverageIncome.xlsx")
source_education <- paste0(path, "Dalarna_Population_HigherEducation.xlsx")
source_animal    <- paste0(path, "df4_5s.txt")

# task 1 passing grades cleaning and pivot to long
df_pass <- read_xlsx(source_pass)
colnames(df_pass) <- c("Municipality","Code","County","Subject",
                       2015,2016,2017,2018,2019,2020,2021,2022,2023,2024)
df_pass <- df_pass[-1, ]
df_pass <- df_pass %>%
  pivot_longer(
    cols      = as.character(2015:2024),
    names_to  = "Year",
    values_to = "Grade"
  ) %>%
  mutate(
    Year  = as.numeric(Year),
    Grade = as.numeric(Grade)
  )

# task 2 cleaning income data
df_income <- read_xlsx(source_income)
df_income$Municipality <- na.locf(df_income$Municipality)
df_income$Year        <- as.numeric(df_income$Year)
df_income <- df_income %>%
  separate(Municipality, into = c("Code","Municipality"), sep = " ") %>%
  select(-Code)

# task 3 cleaning election data
df_elections <- read_xlsx(source_elections)
colnames(df_elections) <- as.character(df_elections[2, ])
df_elections <- df_elections[-c(1,2), ]
for(i in seq_len(nrow(df_elections))) {
  if(is.na(df_elections$Municipality[i])) {
    df_elections$Municipality[i] <- df_elections$Municipality[i-1]
  }
}
df_elections <- df_elections %>%
  separate(Municipality, into = c("Code","Municipality"), sep = " ") %>%
  select(-Code)
df_elections$`Election Year` <- as.numeric(df_elections$`Election Year`)
df_elections <- rename(df_elections, Year = `Election Year`)
party_list <- c(
  "The Moderate Party","The Centre Party","The Liberal Party",
  "The Christian Democratic Party","The Green Party",
  "The Social Democratic Party","The Left Party",
  "The Sweden Democrats","Other Parties"
)
df_elections[party_list] <- lapply(
  df_elections[party_list],
  function(x) as.numeric(as.character(x))
)
total_seats <- rowSums(df_elections[, party_list])
for(i in seq_len(nrow(df_elections))) {
  for(p in party_list) {
    df_elections[i, p] <- (df_elections[i, p] / total_seats[i]) * 100
  }
}

# task 4 cleaning education data skip 1
df_education <- read_xlsx(source_education, skip = 1)
# drop stray unnamed columns
df_education <- df_education[, !grepl("Unnamed", colnames(df_education))]
# carry municipality names down
df_education <- df_education %>%
  fill(Municipality, .direction = "down") %>%
  separate(Municipality, into = c("Code","Municipality"), sep = " ") %>%
  select(-Code) %>%
  mutate(Year = as.numeric(Year))

# task 5 merge all data
df_merged <- merge(df_pass,      df_income,    by = c("Municipality","Year"), all = TRUE)
df_merged <- merge(df_merged,    df_elections, by = c("Municipality","Year"), all = TRUE)
df_merged <- merge(df_merged,    df_education, by = c("Municipality","Year"), all = TRUE)

# task 6 carry election results forward and drop 2014
df_merged <- df_merged %>%
  arrange(Municipality, Year) %>%
  group_by(Municipality) %>%
  fill(all_of(party_list), .direction = "down") %>%
  ungroup() %>%
  filter(Year != 2014)

# shorten the column names
colnames(df_merged) <- c(
  "Municipality", "Year", "Code", "County", "Subject", "Grade", "Income_Inequality", 
  "Average_income", "Median_income", "Mod_Party", "Centre_Party", "Liberal_Party", 
  "Christian_Democratic_Party", "Green_Party", "Social_Democratic_Party", "Left_Party", 
  "Sweden_Democrats", "Others", "Postsec_less_3", "Postsec_3_or_more", "Population"
)

# inspect the final result
head(df_merged)

# select only numeric columns from the merged dataframe
numeric_columns <- df_merged[, sapply(df_merged, is.numeric)]

# compute correlation matrix for numeric columns
cor_matrix_full <- cor(numeric_columns, use = "complete.obs")

# extract only correlation values for grade
cor_grade_only <- cor_matrix_full[, "Grade"]

# view correlation values for grade
cor_df_grade <- as.data.frame(cor_grade_only)
View(cor_df_grade)

# visualize correlation matrix with heatmap
corrplot(cor_matrix_full, 
         method = "color", 
         type = "upper", 
         tl.col = "black", 
         tl.srt = 45, 
         addCoef.col = "black", 
         number.cex = 0.5, 
         title = "correlation matrix of variables",
         mar = c(0, 0, 1, 0))

# simple linear regression of passing rate on year
m0 <- lm(Grade ~ Year, data = df_merged)
summary(m0)
confint(m0, "Year", level = 0.95)


# linear model
m1 <- lm(Grade ~ Year
         + Median_income
         + Average_income
         + Income_Inequality
         + Postsec_less_3       
         + Postsec_3_or_more
         + Mod_Party
         + Centre_Party
         + Liberal_Party
         + Christian_Democratic_Party
         + Green_Party
         + Social_Democratic_Party
         + Left_Party
         + Sweden_Democrats
         + Population,
         data = df_merged)

# view model summary
summary(m1)

# population , both postsec where more than 10 therfore removed , also but postsec_3 back in

m2 <- lm(Grade ~ Year
         + Median_income
         + Average_income
         + Income_Inequality
         + Postsec_3_or_more
         + Mod_Party
         + Centre_Party
         + Liberal_Party
         + Christian_Democratic_Party
         + Green_Party
         + Social_Democratic_Party
         + Left_Party
         + Sweden_Democrats,
         data = df_merged)
  
summary(m2)
vif(m2)

# run diagnostic plots
par(mfrow = c(2,2))
plot(m2)

# confidence intervals for main effects
confint(m2, c("Median_income","Green_Party"), level = 0.95)
