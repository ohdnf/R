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

cntt <- read_excel(path="cntt_small.xlsx")
cust <- read_excel(path="cust_small.xlsx")

#### cust 데이터에 cntt 데이터를 합친다.


#### 성별에 대한 고객의 비율은 어떠한가? 위에서 합친 데이터로 산출 하여라.


#### GOOD_CLSF_CDNM별로 가입한 사람의 수는? + 가장 많이 가입한 보험은?


#### 각 고객별로 몇개의 보험에 가입했는가? + 가장 많이 가입한 사람은?


#### 50개이상의 보험에 가입한 고객들은 어떤 보험(GOOD_CLSF_CDNM)을 많이 들었을까?


#### 50개이상의 보험에 가입한 고객들의 남/녀 비율은 어떠한가?
