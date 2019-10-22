# Set Working Directory

PATH <- "D:/MyRWorkHome"
if (dir.exists(PATH)) {
  setwd(PATH)
} else {
  print("current working directory is...")
  print(getwd())
  dir.create(PATH)
  setwd(PATH)
}

# Install Packages
# installed.packages()
pkg_list <- c("ggplot2", "dplyr", "stringr")
install.packages(pkg_list)

# Load Packages
library("ggplot2")
library("dplyr")
library("stringr")

# Data type
# 1. vector
# 2. matrix

df <- iris
dim(df)[1]
NROW(df)
NCOL(df)
length(df)

# 3. array

# 4. list

# 5. dataframe
colnames(df)
rownames(df)

# access by key and return vector
df$Species
df[["Species"]]
x = df[[5]]

# return sub-list
df["Species"]

d_aq <- airquality

# Access Data
# from list
d_aq$Ozone      # vector
d_aq["Ozone"]   # list(data.frame)
d_aq[["Ozone"]] # vector
d_aq[1]         # list(data.frame)
d_aq[[1]]       # vector

# from matrix
d_aq[,1]
d_aq[, "Ozone"]

which(is.na(d_aq$Ozone))
d_omit <- na.omit(d_aq)


# Using "dflyr"
result <- df %>% select(Sepal.Length, Sepal.Width, Species) %>% 
  group_by(Species) %>% summarise_all(mean)

# %in%
c_names <- c("Kim", "Lee", "Park", "Choi")
c("Lee") %in% c_names
c_names %in% c("Lee")

# Practice accessing
members <- list(name='hyo', addr='seoul', tel='010', pay=c(500, 600))
members$pay[1]
members$pay[][1]
members[['pay']][1]
members[['pay']][[1]]
members[[4]][1]
members[[4]][[1]]
members[4]$pay[1]
members[4][[1]][1]

# Vector Arithmetics
# 1
tmp <- c()
for (i in 1:length(d_aq)) {
  tmp <- c(tmp, mean(d_aq[[i]], na.rm=T))
}
# 2

# NA?
ex <- c(1, 3, 6, NA, 12)
ex[ex < 10]
ex[ex > 10]

filename = "./data/example_coffee.csv"
df_coffee <- read.csv(filename, stringsAsFactors = F, encoding = 'CP949')
# df_coffee <- read.table(filename, sep = ",", fileEncoding = "CP949")
library(data.table)
df_coffee <- fread(filename, sep = ",", data.table = FALSE)

str(df_coffee)

# melt & cast
library(reshape2)
head(french_fries)
m <- melt(french_fries, id.vars = 1:4)
head(m)

dcast(m, time+treatment+subject+rep~variable)