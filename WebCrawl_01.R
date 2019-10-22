## 크롤링 패키지 불러오기

library("rvest")
library("R6")

# html 주소를 url에 저장
# url <- 'https://www1.president.go.kr/articles/4253'
url <- 'https://www.samsungsds.com/global/ko/support/insights/1207951_2284.html'

# read_html 함수를 사용하여 html 페이지를 htxt 변수에 저장
htxt <- read_html(url)
# html_nodes 함수를 사용하여 cs_body class에 해당하는 부분을 content 변수에 저장
# content <- html_nodes(htxt, '.cs_body')
content <- html_nodes(htxt, '.txt_wrap')
# html_text 함수를 사용하여 text 부분을 speech 변수에 저장
speech <- html_text(content)
# speech

## 한글에 대한 텍스트 마이닝 페이지 KoNLP 설치
## 워드클라우드 패키지 wordcloud
## 워드클라우드 단어에 색상을 입히는 RColorBrewer
# install.packages("KoNLP")
# install.packages("wordcloud")
# install.packages("RColorBrewer")
# install.packages("tm")
# install.packages("NLP")

library("KoNLP")
library("wordcloud")
library("RColorBrewer")
library("tm")
library("NLP")

## 세종사전 설치
useSejongDic()

## Step2. 데이터 정제
## 크롤링된 데이터에서 단어 추출하기
## 명사 추출 함수인 extractNoun 함수 사용
pword <- sapply(speech, extractNoun, USE.NAMES = F)

## 필터링을 위해 unlist 함수를 사용해서 저장
data1 <- unlist(pword)

## 글자수 2개 이상만 취급
data1 <- Filter(function(x){nchar(x)>=2},data1)

## 불필요한 데이터 처리
## 한 번 이상의 숫자
data1 <- gsub("\\d+","",data1)

## 새로운 라인
data1 <- gsub("\\n","",data1)

## 줄 끝 문자를 제외한 모든 문자
data1 <- gsub("\\.","",data1)
data1 <- gsub("\n","",data1)
data1 <- gsub(" ","",data1)
data1 <- gsub("-","",data1)
data1

## Step3. 워드클라우드
## 빈도표 작성
data_cnt <- table(data1)

## 내림차순 정렬 후 상위 20개 표시
head(sort(data_cnt, decreasing = T), 20)

## RColorBrewer를 이용해 그래픽 창을 생성
palette <- brewer.pal(9, "Set1")
x11()

## 워드클라우드 실행
wordcloud(
  names(data_cnt),
  freq=data_cnt,
  scale = c(3,1),
  max.words = 50,
  random.order = FALSE,
  rot.per = 0.100,
  use.r.layout = FALSE,
  color = brewer.pal(8, "Dark2")
)
