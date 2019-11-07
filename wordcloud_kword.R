library(tm)
library(wordcloud)
library(RColorBrewer)
library(SnowballC)
library(KoNLP)
library(rJava)

# 사전 추가
useSejongDic()

# 사용자 단어 추가
mergeUserDic(data.frame(c("젠틀"), "ncn"))

# Font 설정
windowsFonts(font=windowsFont("KoPubWorld돋움체 Bold"))

# display.brewer.all()

setwd('D:/MyRWorkHome/visual_data/wc')
ktext <- readLines('uniqlo_thanku.txt', encoding='UTF-8')
tail(ktext, 5)

# 분석을 위한 벡터화
kdocs <- Corpus(VectorSource(ktext))
inspect(kdocs)

# 명사 추출
kwords <- unlist(sapply(kdocs, extractNoun, USE.NAMES = F))

# 전처리: 두 글자 이상 단어만 추출
kwords <- Filter(function(x){nchar(x)>=2}, kwords)

# 전처리: 불용어 삭제
kwords <- gsub('[~!@#$%&*()_+=?<>]','', kwords)
kwords <- gsub('[ㄱ-ㅎ]','', kwords)
kwords <- gsub('(ㅜ|ㅠ)','', kwords)
kwords <- gsub("\\^","", kwords)
kwords <- gsub("하\\S*", "", kwords)
kwords <- gsub("주표씨\\S*", "", kwords)
kwords <- gsub("화이팅\\S*", "화이팅", kwords)
kwords <- gsub("감사\\S*", "", kwords)
kwords <- gsub("모습", "", kwords)
kwords <- gsub("하\\S*", "", kwords)
kwords <- gsub("거예요", "", kwords)

wordfreq <- table(kwords)
head(wordfreq)

wordfreq_top <- head(sort(wordfreq, decreasing = T), 70)
wordfreq_top
wordcloud(names(wordfreq_top), wordfreq_top, scale = c(10,4), 
          rot.per = 0, random.color = T, random.order = F,
          colors = brewer.pal(12, "Dark2"), family = "font")


# scale 가장 빈도가 큰 단어와 가장 빈도가 작은단어 폰트사이의 크기차이 scale=c(10,1)
# minfreq 출력될 단어들의 최소빈도
# maxwords 출력될 단어들의 최대빈도(inf:제한없음)
# random.order(true면 랜덤, false면 빈도수가 큰 단어를 중앙에 배치하고 작은순)
# random.color(true면 색 랜덤, false면 빈도순)
# rot.per(90도 회전된 각도로 출력되는 단어비율)
# colors 가장 작은빈도부터 큰 빈도까지의 단어색
# family 글씨체

# wordcloud(names(wordfreq), freq = wordfreq, max.words = 50)
# wordcloud(names(wordfreq), freq = wordfreq, scale = c(10, 1), rot.per = 0, min.freq = 2, 
#           random.order = F, random.color = F, colors = brewer.pal(8, "Dark2"))
