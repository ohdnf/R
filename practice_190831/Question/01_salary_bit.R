library(data.table)
getwd()

### salary 데이터는 통계청에서 발표한 2013년도 전국 연령,남녀, 경력별 평균월급 데이터 셋이다. 

### > 파일을 읽어 salary2013 객체에 담으세요.
salary2013 <- fread("./Data/01/example_salary.csv", data.table = FALSE)
salary2013$연령 <- as.factor(salary2013$연령)
salary2013$경력구분 <- as.factor(salary2013$경력구분)
salary2013$성별 <- as.factor(salary2013$성별)
for(i in 2:5){
  salary2013[[i]] <- as.numeric(salary2013[[i]])
}

#sapply(salary2013, function(x)sum(is.na(x)))

str(salary2013)
summary(salary2013)


###> 한글로 된 컬럼 이름을 다음과 같은 영어로 바꾸세요. 
# "age", "salary", "specialSalary", "workingTime", "numberOfWorker", "career", "sex"

colnames(salary2013) <- c("age", "salary", "specialSalary", "workingTime", "numberOfWorker", "career", "sex")
names(salary2013)

###> 우리나라 평균 월급은 얼마인가요? (평균값 : mean()함수를 사용 )
# (답)
mean(salary2013$salary, na.rm = TRUE)

###> 월급의 중앙값은 얼마인가요? (중앙값 : median() 함수 사용 )
# (답)
median(salary2013$salary, na.rm = TRUE)

###> 월급을 최대로 받으면 얼마고, 최소로 받으면 얼마인가요? (최대값 : max() 함수 사용, 최소값 : min()함수 사용)
# (답)
min(salary2013$salary, na.rm = TRUE)
max(salary2013$salary, na.rm = TRUE)
range(salary2013$salary, na.rm = TRUE)

###> 최대 월급을 받고 있는 사람은 어떤 특징을 가지고 있나요?
# (답)
idx <- which(salary2013$salary == max(salary2013$salary, na.rm = TRUE))
salary2013[idx, ]

###> 남녀별 평균월급은 얼마나 차이가 나나요?
# (답)
sal_w <- mean(salary2013[salary2013$sex=='여', ]$salary, na.rm=TRUE)
sal_m <- mean(salary2013[salary2013$sex=='남', ]$salary, na.rm=TRUE)
sal_m - sal_w

###########################################################
#apply()군을 배웠다면!! - tapply()를 사용하여 아래의 내용을 구해보자. 

# apply() apply a function to the matrix and return the result of function.
# lapply() does the same jobs as apply() and the output of lapply() is a list.
# sapply() does the same jobs as lapply() function but returns a vector.
# tapply() computes a measure(mean, median, range...) or a function for each factor vairable in a vector. 
###########################################################
###> 남, 여별 평균월급은? 
# (답)
tapply(salary2013$salary, salary2013$sex, mean, na.rm=TRUE)

###> 연령대별 평균월급은? tapply() 사용
# (답)
tapply(salary2013$salary, salary2013$age, mean, na.rm=TRUE)
with(salary2013, {tapply(salary, sex, mean, na.rm=TRUE)})

###> 경력별 평균월급은? 
# (답)
# tapply(salary2013$salary, salary2013$career, mean, na.rm=TRUE)
attach(salary2013)
tapply(salary, career, mean, na.rm=TRUE)

###> 경력별 월급의 범위는?
# (답)
#tapply(salary2013$salary, salary2013$career, range, na.rm=TRUE)
tapply(salary, career, range, na.rm=TRUE)
detach(salary2013)

###########################################################
# dplyr 패키지를 사용해본다면?
###########################################################
library(dplyr)
salary2013 %>% group_by(sex) %>% summarise(mean=mean(salary, na.rm=TRUE))
