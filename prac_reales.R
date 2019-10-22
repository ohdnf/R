library(XML)
library(data.table)
library(stringr)
library(ggplot2)

service_key <- "3ONVN470rQ9A9EoQml%2FED8Xcd7%2FcpDOvt9LscKrU%2BwUH04ieq2ZI99TvxqL7mrGyZekbs5DT4%2BzImARpSnO%2FwA%3D%3D"

locCode <-c("11110","11140","11170","11200","11215","11230","11260","11290","11305","11320","11350","11380","11410","11440","11470","11500","11530","11545","11560","11590","11620","11650","11680","11710","11740")
locCode_nm <-c("종로구","중구","용산구","성동구","광진구","동대문구","중랑구","성북구","강북구","도봉구","노원구","은평구","서대문구","마포구","양천구","강서구","구로구","금천구","영등포구","동작구","관악구","서초구","강남구","송파구","강동구")
datelist <-c("201501","201502","201503","201504","201505","201506","201507","201508","201509","201510","201511","201512")

urllist <- list()
cnt <- 0
for(i in 1:length(locCode)){
  for(j in 1:length(datelist)){
    cnt=cnt+1
    urllist[cnt] <-paste0("http://openapi.molit.go.kr/OpenAPI_ToolInstallPackage/service/rest/RTMSOBJSvc/getRTMSDataSvcNrgTrade?serviceKey=",service_key,"&LAWD_CD=",locCode[i],"&DEAL_YMD=",datelist[j])
  }
}

total<-list()
for(i in 1:length(urllist)){
  item <- list()
  item_temp_dt<-data.table()
  raw.data <- xmlTreeParse(urllist[i], useInternalNodes = TRUE, encoding = "UTF-8")
  rootNode <- xmlRoot(raw.data)
  items <- rootNode[[2]][['items']]
  # price','con_year','year','dong','aptnm','month','dat','area','bungi','loc','floor'
  size <- xmlSize(items)
  for(i in 1:size){
    item_temp <- xmlSApply(items[[i]], xmlValue)
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

result_apt_data <- rbindlist(total)
# save(result_apt_data, file="apt_item_sales_dt.Rdata")
# result_apt_data1<-get(load("apt_item_sales_dt.Rdata"))
# apt_data1<-data.table(result_apt_data1)

# 데이터 내 결측 값 확인
colSums(is.na(result_apt_data))

#loc가 잘못 들어가 있는 데이터에 대한 처리
index_na <-is.na(result_apt_data$floor)
result_apt_data[index_na]$floor <- result_apt_data[index_na]$loc
result_apt_data[index_na]$loc <- result_apt_data[index_na]$bungi
result_apt_data[index_na]$bungi <- NA

#컬럼 속성 수정 및 필요한 컬럼 생성
result_apt_data[,price:=as.character(price)%>%str_trim()%>%sub(",","",.)%>%as.numeric()]
result_apt_data[,con_year:=as.character(con_year)%>%str_trim()%>%as.numeric()]
result_apt_data[,year:=as.character(year)%>%str_trim()%>%as.numeric()]
result_apt_data[between(as.numeric(as.character(month)),1,3),qrt:='Q1']
result_apt_data[between(as.numeric(as.character(month)),4,6),qrt:='Q2']
result_apt_data[between(as.numeric(as.character(month)),7,9),qrt:='Q3']
result_apt_data[between(as.numeric(as.character(month)),10,12),qrt:='Q4']
result_apt_data[,dong:=as.character(dong)%>%str_trim()]
result_apt_data[,yyyyqrt:=paste0(year,qrt)]
result_apt_data[,month:=as.character(month)%>%str_trim()%>%as.numeric()]
result_apt_data[,yyyym:=paste0(year,month)]
lapply(locCode,function(x){result_apt_data[loc==x,gu:=locCode_nm[which(locCode==x)]]})

result_apt_data_seo_price <- aggregate(result_apt_data$price,by=list(result_apt_data$yyyyqrt),mean)
names(result_apt_data_seo_price) <- c("yyyyqrt","price")
ggplot(result_apt_data_seo_price,aes(x=yyyyqrt,y=price,group=1))+
  geom_line() +
  xlab("분기별")+
  ylab("평균매매가격")+
  theme(axis.text.x=element_text(angle=90))+
  stat_smooth(method='lm')


result_apt_data_by_gu_qrt <- aggregate(result_apt_data$price, by=list(result_apt_data$yyyyqrt,result_apt_data$gu), mean)
names(result_apt_data_by_gu_qrt) <- c('yyyyqrt','gu','pricemean')

ggplot(result_apt_data_by_gu_qrt,aes(x=yyyyqrt,y=pricemean,group=gu))+
  geom_line()+
  facet_wrap(~gu,scale='free_y', ncol=3)+
  theme(axis.text.x=element_blank())+
  stat_smooth(method="lm")

gu_meanprice <- as.data.table(aggregate(result_apt_data$price,by=list(result_apt_data$yyyyqrt,result_apt_data$gu),mean))
head(gu_meanprice)

names(gu_meanprice)<- c('yyyyqrt','gu','price')
#중복없이 구 추출
gu_list <- unique(gu_meanprice$gu)

#랜덤성 검정을 위한 패키지 로드
library(lawstat)

# 각 구별 매매가격의 랜덤성 검정 결과를 runs_p변수에 추가
runs_p<-c()
for(g in gu_list){
  runs_p <- c(runs_p, runs.test(gu_meanprice[gu %in% g,price])$p.value)
}

ggplot(data.table(gu_list, runs_p), aes(x=gu_list, y=runs_p, group=1)) +
  geom_line() + geom_point() +
  ylab('P-value') + xlab('구') +
  theme(axis.text.x=element_text(angle=90))

gu_list[which(runs_p>0.05)]

gwanak_data <- result_apt_data[gu=="관악구",]
gwanak_price <- aggregate(gwanak_data$price,by=list(gwanak_data$yyyyqrt),mean) 
names(gwanak_price)<-c('yyyyqrt','price')
tot_ts <- ts(gwanak_price$price,start=c(2011,1),frequency = 4)
plot(stl(tot_ts,s.window = 'periodic'))

library(forecast)
arima_mdl <- auto.arima(tot_ts)
arima_mdl

tsdiag(arima_mdl)

accuracy(arima_mdl)

plot(forecast(arima_mdl,h=8))

pred <- predict(arima_mdl, n.ahead = 8)
#미래 예측값 그래프를 점선으로 표시
ts.plot(tot_ts,pred$pred,lty=c(1,3))

