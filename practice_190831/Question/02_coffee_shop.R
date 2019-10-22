###########################################
# 전국 커피숍 폐업/영업 상황 알아보기
###########################################
library("data.table")
library("ggplot2")
getwd()
list.files

# 데이터 로드 및 기본정보 파악
df <- read.csv("D:/MyRWorkHome/practice_190831/data/02/example_coffee.csv")

head(df)
str(df)
summary(df)

# 필요없는 필드는 제외
df<-subset(df, select=c(-adress, -adressBystreet, -dateOfclosure, -startdateOfcessation,-duedateOfcessation,-dateOfreOpen,-zip))
#df %>% select(-address, -adressBystreet, -dateOfclosure, -startdateOfcessation, -duedateOfcessation, 
#              -dateOfreOpen, -zip)
names(df)

# Q1. 언제 커피숍이 처음 생겼을까?
min(df$yearOfStart, na.rm = TRUE)

# Q1-1. 처음 생긴 커피숍의 특징
df[which(df$yearOfStart==1964), ]

# Q2. 현재 운영중인 커피숍 중에서 제일 오래된 곳은?
unique(df$stateOfbusiness)
df_sub <- df %>% filter(stateOfbusiness=="운영중")
min(df_sub$yearOfStart, na.rm = TRUE)

# Q3. 해마다 오픈한 커피숍 개수 (hint: table())
table(df$yearOfStart)

# Q4. 그래프로 확인해보자.
plot(table(df$yearOfStart))

# Q5. 영업상태 및 연도에 따른 분할표
freq <- table(df$stateOfbusiness, df$yearOfStart)
#table(df$yearOfStart, df$stateOfbusiness)

# Q6. 1997이후 데이터만 저장해보자.
start_idx <- which(colnames(freq) == 1997)
end_idx <- dim(freq)[2]
freq <- freq[, c(start_idx:end_idx)]

df1997 <- df[df$yearOfStart > 1997, ]

# Q7. 비율을 알아보자(prop.table())
prop.freq <- prop.table(freq, margin=2)
prop.freq
colnames(prop.freq)

# Q8. 그래프를 그리기 위해서 데이터 프레임을 새로 생성해보자
#newdf <- data.frame(year=colnames(freq), Open=freq[1,], Close=freq[2,], POpen=prop.freq[1,], PClose=)
# Q8-1. 열이름 재설정(#Q5, )

# Q9. 연도별 영업 수, 폐업 수 그래프 그려보기
## 
str(newdf$year)
ob<-ggplot(newdf, aes(x=(year), y=Close, group=1)) + geom_line(colour="blue", size=1)
ob + geom_point(colour="blue", size=3) + 
  geom_line(aes(y=Open), colour="tomato2", size=1)+ 
  geom_point(aes(y=Open), colour="red", size=6)+
  theme_bw() #빨간색 : 영업, 폐업
