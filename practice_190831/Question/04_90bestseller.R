library(dplyr)
library(reshape)
load("C:/R/Project3/bestseller2015.RData")
getwd()
#1. 베스트셀러 150위에 들어간 책은 모두 몇권?(Name기준으로 집계)

##책이름 중복, isbn 중복상황에서 이름, isbn 정렬하면 둘중 많은것 개수 나옴.
#-->isbn이 많다(같은 이름의 다른 isbn 책존재.-->다른 책) 


#2. 가장 오랜기간 bestseller의 영예를 누린 책의 이름은?


#3. 동일한 이름에 isbn이 몇 개를 가지고 있는지?


#4. 동일한 Name을 가질 때, isbn이 어떻게 다른지 출력하는 프로그램?

#중복된 Name과 isbn 제거를 통해 결과 산출.

