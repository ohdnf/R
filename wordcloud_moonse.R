library(tm)
library(wordcloud)
library(RColorBrewer)
library(SnowballC)
library(KoNLP)
library(rJava)


ktext <- readLines('D:/MyRWorkHome/visual_data/wc/moonse.txt', encoding='UTF-8')
head(ktext, 5)

kdocs <- Corpus(VectorSource(ktext))
inspect(kdocs)

kwords <- unlist(sapply(kdocs, extractNoun, USE.NAMES = F))

wordfreq <- table(kwords)

wordcloud(names(wordfreq), freq = wordfreq, max.words = 50)

wordcloud(names(wordfreq), freq = wordfreq, scale = c(5, 1), rot.per = 0.15, min.freq = 1, 
          random.order = F, random.color = T, colors = brewer.pal(8, "Dark2"))
