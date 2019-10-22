library(ggplot2)
library(dplyr)
getwd()
setwd("./Project6")
code <- read.csv("code.csv", header=T)
product<- read.csv("product.csv", header=T)

########################
#
# 돼지고기의 가격을 지역별로 년별, 월별, 일별 평균 가격을 정리하고 싶다.
# 단, "의정부","용인","창원","안동","포항","순천","춘천" 지역은 제외하고 싶다. 
#
########################

#####################
### producet 필드 설명
# `product`을 구성하는 변수에 대한 설명은 다음과 같음  
#  + 부류코드 : 농축산물의 범주에 따라 분류한 코드. 100(식량작물), 200(채소류). 300(특용작물), 400(과일류), 500(축산물)  
#  + 품목코드 : 품목에 따른 코드  
#  + 지역코드 : 지역에 따른 코드  
#  + 마트코드 : 마트에 따른 코드  
#####################

# > 데이터의 변수명을 한글에서 영어로 변환해준다.  
#   `product`의 변수명은 date(일자), category(부류코드), item(품목코드), region(지역코드), mart(마트코드), price(가격)로 변환

# > 'code'(객체)에서 구분코드설명이 품목코드에 해당하는 값만 추출하여 'category'(객체)에 저장

# > 데이터의 변수명을 한글에서 영어로 변환해준다.  
# `category`의 변수명은 code(구분코드), exp(구분코드설명), item(분류코드), name(분류코드설명)으로 변환된다.  


# > `product`에서 돼지고기에대한 데이터만 추출하여 `total.pig`(객체) 에 저장
# 'category'에서 name(분류코드설명)이 돼지고기인 item 값을 확인하여 product에서 추출해야 한다.

# > `code`에서 exp(구분코드설명)이 "지역코드"에 해당하는 값만 추출하여 'local_region'(객체)에 저장

# > `local_region`의 변수명은 code(구분코드), exp(구분코드설명), region(분류코드), name(분류코드설명)으로 변환된다. 

# > 'total.pig'에 'local_region'을 region필드로 merge (all outer join으로 수행)하여, 'day.pig'(객체)에 저장

# > 관심없는 7개의 지역은 삭제를 하겠다.
# "의정부","용인","창원","안동","포항","순천","춘천" 지역을 제거하여 'day.pig'로 다시 저장한다.


# > 일별 지역의 돼지고기 평균가격
# `day.pig`을 date, region, name별로 돼지고기의 평균가격(mean.price 필드로 생성)을 구한 후, 
# 생성된 결과를 데이터 프레임형태로, 'daily.mean'(객체)에 저장

                    
### 이름을 명명한 대로 사용했다면, 다음 코드를 수행하면 그래프가 나올 것이다.  
ggplot(daily.mean, aes(x=date, y=mean.price, colour=name, group=name)) + 
  geom_line() + theme_bw() + geom_point(size=6, shape=20, alpha=0.5) + 
  ylab("돼지고기 가격") + xlab("")

#> 월별 지역 평균가격
# 'daily.mean'의 date에서 month만 추출하여 month, region, name별로 돼지고기의 평균가격을 구하여 `monthly.mean` 데이터 저장

### 이름을 명명한 대로 사용했다면, 다음 코드를 수행하면 그래프가 나올 것이다.  

#> 연별 지역 평균가격
# 'daily.mean'의 date에서 year만 추출하여 year, region, name별로 돼지고기의 평균가격을 구하여 `yearly.mean` 데이터 저장

### 이름을 명명한 대로 사용했다면, 다음 코드를 수행하면 그래프가 나올 것이다.  
ggplot(yearly.mean, aes(x=year, y=mean.price, colour=name, group=name)) + 
  geom_line() + theme_bw() + geom_point(size=6, shape=20, alpha=0.5) + 
  ylab("돼지고기 가격") + xlab("")
