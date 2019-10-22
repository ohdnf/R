library(readxl)
library(dplyr)


## cust 필드 설명
### CUST_ID : 고객번호 
### SEX : 성별 - 성별 1은 '남성' 2는 '여성'
### AGE : 나이

## cntt 필드 설명
### POLY_NO : 증권번호 
### CUST_ID : 고객번호
### GOOD_CLSF_CDNM : 가입한 보험의 종
getwd()
cntt <- read_excel(path="../data/03/cntt_small.xlsx")
cust <- read_excel(path="../data/03/cust_small.xlsx")

#### cust 데이터에 cntt 데이터를 합친다.
df <- merge(cust, cntt, by = "CUST_ID")
str(df)
summary(df)
sum(is.na(df))
#### 성별에 대한 고객의 비율은 어떠한가? 위에서 합친 데이터로 산출 하여라.

# 고객의 수는 몇명일까
length(unique(df$CUST_ID))
table(df$SEX)   #내가 한 방법

# 방법1
df %>% group_by(CUST_ID) %>% summarise(sex = unique(SEX)) %>% group_by(sex) %>% summarise(n=n(), p = n/22400)   # n : count

# 방법2
sex_prob <- (df %>% group_by(CUST_ID, SEX) %>% summarize(N=n()))
# 방법2-1
sex_prob %>% group_by(SEX) %>% summarise(N=n())
# 방법2-2
table(sex_prob$SEX)
#### GOOD_CLSF_CDNM별로 가입한 사람의 수는? + 가장 많이 가입한 보험은?
a <- table(df$GOOD_CLSF_CDNM)
names(a)
table(df$GOOD_CLSF_CDNM)
max(table(df$GOOD_CLSF_CDNM))
# 대리님 방법
df %>% group_by(GOOD_CLSF_CDNM) %>% tally() %>% arrange(desc(n))

#### 각 고객별로 몇개의 보험에 가입했는가? + 가장 많이 가입한 사람은?
table(df$CUST_ID)
df_user <- table(df$CUST_ID)
names(df_user)
max(table(df$CUST_ID))
# 대리님 방법
tmp <- df %>% group_by(CUST_ID) %>% summarise(n=n(), sex = unique(SEX)) %>% arrange(desc(n))
tmp

#### 50개이상의 보험에 가입한 고객들은 어떤 보험(GOOD_CLSF_CDNM)을 많이 들었을까?
df_user_a <- df_user[df_user>=50]
df_user_a
df_user50 <- names(df_user_a)
selectuser <- subset(df, subset = (df$CUST_ID %in% df_user50))
str(selectuser)
head(selectuser)
table(selectuser$GOOD_CLSF_CDNM)
# 대리님 방법
custID50 <- tmp %>% filter(n>=50)
good50 <- df[df$CUST_ID %in% custID50$CUST_ID,]
sort(table(good50$GOOD_CLSF_CDNM), decreasing = T)
# 보장, 일반연금, 일반저축 이 많다.


#### 50개이상의 보험에 가입한 고객들의 남/녀 비율은 어떠한가?
table(selectuser$SEX)

table(custID50$sex)



