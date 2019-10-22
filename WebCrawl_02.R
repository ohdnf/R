## Open API로 공공데이터 정보 활용

# install.packages("XML")
library(XML)
library(data.table)

api_url <- ("http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnStatsSvc/getMsrstnAcctoLastDcsnDnsty")

data3 <- xmlTreeParse(api_url, useInternalNodes = T, encoding = "UTF-8")
rootNode <- xmlRoot(data3)
items = rootNode[[2]]["items"]
size = xmlSize(items)
data_subtotal <- list()
test2 <- data.frame()
test3 <- list()

for(i in 1:size)
{
  test <- xmlSApply(items[[i]],xmlValue)  
  test2 <- data.table(Time=test[[1]],
                      Name=test[[2]],
                      so2=test[[3]],
                      co=test[[4]],
                      o3=test[[5]],
                      no2=test[[6]],
                      pm10=test[[7]],
                      pm1024=test[[8]],
                      pm25=test[[9]],
                      pm2524=test[[10]],
                      khai=test[[11]],
                      khaigrade=test[[12]],
                      so2grade=test[[13]],
                      cograde=test[[14]],
                      o3grade=test[[15]],
                      no2grade=test[[16]],
                      pm10grade=test[[17]],
                      pm25grade=test[[18]],
                      pm101hgrade=test[[19]],
                      pm251hgrade=test[[20]])
  test3[[i]]=test2
}
test4 <- rbindlist(test3)
View(test4)