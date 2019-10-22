install.packages(XML)
library(XML)
install.packages("data.table")
library(data.table)
install.packages("stringr")
library(stringr)
install.packages("ggplot2")
library(ggplot2)

service_key <- "Tc4ZYr9LpxqAZg27Ff8u4M6UN2%2FjRojJeGuLnYxaSkKG6%2BEt0AEYp5UixvVnxbPRfX3EAQeLnT%2FPhevExYxYdA%3D%3D"
#서울시 지역코드
locCode <-c("11110","11140","11170","11200","11215","11230","11260","11290","11305","11320","11350","11380","11410","11440","11470","11500","11530","11545","11560","11590","11620","11650","11680","11710","11740")
locCode_nm <-c("종로구","중구","용산구","성동구","광진구","동대문구","중랑구","성북구","강북구","도봉구","노원구","은평구","서대문구","마포구","양천구","강서구","구로구","금천구","영등포구","동작구","관악구","서초구","강남구","송파구","강동구")

datelist <-c("201501","201502","201503","201504","201505","201506","201507","201508","201509","201510","201511","201512","201401","201402","201403","201404","201405","201406","201407","201408","201409","201410","201411","201412","201601","201602","201603","201604","201605","201606","201607","201608","201609","201610","201611","201612")

urllist <- list()
cnt <-0
for(i in 1:length(locCode)){
  for(j in 1:length(datelist)){
    cnt=cnt+1
    urllist[cnt] <-paste0("http://openapi.molit.go.kr/OpenAPI_ToolInstallPackage/service/rest/RTMSOBJSvc/getRTMSDataSvcSilvTrade?serviceKey=",service_key,"&LAWD_CD=",locCode[i],"&DEAL_YMD=",datelist[j]) 
  }
}
urllist[2]

a<-xmlTreeParse('http://openapi.molit.go.kr/OpenAPI_ToolInstallPackage/service/rest/RTMSOBJSvc/getRTMSDataSvcSilvTrade?serviceKey=Tc4ZYr9LpxqAZg27Ff8u4M6UN2%2FjRojJeGuLnYxaSkKG6%2BEt0AEYp5UixvVnxbPRfX3EAQeLnT%2FPhevExYxYdA%3D%3D&LAWD_CD=11110&DEAL_YMD=201512', useInternalNodes = TRUE, encoding = "utf-8")
b<-rootNode <- xmlRoot(a)
b[[2]][['items']]

total<-list()
for(i in 1:length(urllist)){
    item <- list()
  item_temp_dt<-data.table()
  raw.data <- xmlTreeParse(urllist[i], useInternalNodes = TRUE, encoding = "utf-8")
  rootNode <- xmlRoot(raw.data)
  items <- rootNode[[2]][['items']]
  # price','con_year','year','dong','aptnm','month','dat','area','bungi','loc','floor'
  size <- xmlSize(items)
  for(i in 1:size){
    item_temp <- xmlSApply(items[[i]],xmlValue)
    item_temp_dt <- data.table(price=item_temp[1],
                               con_year=item_temp[2],
                               year=item_temp[3],
                               dong=item_temp[4],
                               aptnm=item_temp[5],
                               month=item_temp[6],
                               dat=item_temp[7],
                               area=item_temp[8],
                               bungi=item_temp[9],
                               loc=item_temp[10],
                               floor=item_temp[11])
    item[[i]]<-item_temp_dt
  }
  total[[i]]<-rbindlist(item)
}
total
result_apt_data <- rbindlist(total)
save(result_apt_data, file="apt_item_sales_dt.Rdata")

result_apt_data1<-get(load("apt_item_sales_dt.Rdata")) #load 2014~2016년도 데이터

apt_data1<-data.table(result_apt_data1)
apt_data<-rbindlist(list(apt_data1))
# 데이터 내 결측 값 확인
colSums(is.na(apt_data)) 

#loc가 잘못 들어가 있는 데이터에 대한 처리
index_na <-is.na(apt_data$floor)
apt_data[index_na]$floor <- apt_data[index_na]$loc
apt_data[index_na]$loc <- apt_data[index_na]$bungi
apt_data[index_na]$bungi <- NA

#컬럼 속성 수정 및 필요한 컬럼 생성
apt_data[,price:=as.character(price)%>%str_trim()%>%sub(",","",.)%>%as.numeric()]
apt_data[,con_year:=as.character(con_year)%>%str_trim()%>%as.numeric()]
apt_data[,year:=as.character(year)%>%str_trim()%>%as.numeric()]
apt_data[between(as.numeric(as.character(month)),1,3),qrt:='Q1']
apt_data[between(as.numeric(as.character(month)),4,6),qrt:='Q2']
apt_data[between(as.numeric(as.character(month)),7,9),qrt:='Q3']
apt_data[between(as.numeric(as.character(month)),10,12),qrt:='Q4']
apt_data[,dong:=as.character(dong)%>%str_trim()]
apt_data[,yyyyqrt:=paste0(year,qrt)]
apt_data[,month:=as.character(month)%>%str_trim()%>%as.numeric()]
apt_data[,yyyym:=paste0(year,month)]
lapply(locCode,function(x){apt_data[loc==x,gu:=locCode_nm[which(locCode==x)]]})


apt_data_seo_price <- aggregate(apt_data$price,by=list(apt_data$yyyyqrt),mean)
names(apt_data_seo_price) <- c("yyyyqrt","price")
ggplot(apt_data_seo_price,aes(x=yyyyqrt,y=price,group=1))+
  geom_line() +
  xlab("분기별")+
  ylab("평균매매가격")+
  theme(axis.text.x=element_text(angle=90))+
  stat_smooth(method='lm')
