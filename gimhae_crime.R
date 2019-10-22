# install.packages("car")
# install.packages("plotly")
library(RColorBrewer)
library(lattice)
library(corrplot)
library(car)
library(data.table)
library(ggplot2)
library(plotly)

# Annual Crime in Gimhae(from 2010 to 2015)

df_1.crim <- fread("D:/MyRWorkHome/visual_data/gimhae/01_gimhae_crime.csv", 
                   encoding = "UTF-8", header = T, data.table = F)

# Barplot
barplot(df_1.crim$thief, names.arg = df_1.crim$year, 
        col = "red", 
        border = NA, 
        xlab = "crime", 
        ylab = colnames(df_1.crim)[[4]], 
        main = "Gimhae Crime 2010-2015")
ggplot(df_1.crim, aes(x=df_1.crim$year, 
                      y=df_1.crim$violence))+geom_bar(stat="identity")

# Accumulative Barplot
df_1.crim.t <- data.frame(t(df_1.crim))
names(df_1.crim.t) <- df_1.crim.t[1, ]    # colname
df_1.crim.t <- df_1.crim.t[-1, ]          # -c('year')
df_1.crim.t$crime_name <- rownames(df_1.crim.t)
df_1.crim.t <- melt(df_1.crim.t, id.vars = "crime_name")
ggplot(df_1.crim.t.melt, aes(x = crime_name, y = value, 
                             fill = variable)) + geom_bar(stat = "identity")

# Scatter plot
df_5.police <- fread("D:/MyRWorkHome/visual_data/gimhae/05_gimhae_policeman.csv", 
                     encoding = "UTF-8", header = T, data.table = F)

# Scatter plot 1
df_crime_police <- merge(df_1.crim, df_5.police)
plot(df_crime_police[, 13:19], main = "Scatter Plot Matrix")

# Scatter plot 2
ggplot(data = df_crime_police, aes(x = gambling, y = policeman)) + geom_point(shape = 10, size = 5, colour = "red") + ggtitle("Scatter Plot: gambling vs policeman")
