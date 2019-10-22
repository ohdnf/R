library(tm)
library(wordcloud)
library(RColorBrewer)
library(SnowballC)
library(KoNLP)
library(rJava)


# Other methods to read text
# docu <- readLines('D:/MyRWorkHome/visual_data/wc/stevejobsstanford.txt', encoding='UTF-8')
# mytext <- Corpus(VectorSource(docu))
# mytext <- Corpus(DirSource('D:/MyRWorkHome/visual_data/wc/'))
# inspect(mytext)

# Load Text
text <- readLines(file.choose())
docs <- readLines('D:/MyRWorkHome/visual_data/wc/stevejobsstanford.txt', encoding='UTF-8')
docs <- Corpus(VectorSource(text))
inspect(docs)

toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")

# Convert the text to lower case
docs <- tm_map(docs, content_transformer(tolower))
# Remove numbers
docs <- tm_map(docs, removeNumbers)
# Remove english common stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))
# Remove your own stop word
# specify your stopwords as a character vector
# docs <- tm_map(docs, removeWords, c("blabla1", "blabla2"))
# Remove punctuations
docs <- tm_map(docs, removePunctuation)
# Eliminate extra white spaces
docs <- tm_map(docs, stripWhitespace)
# Text stemming
# docs <- tm_map(docs, stemDocument)

dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m), decreasing = T)
d <- data.frame(word = names(v), freq = v)
head(d, 10)

set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 1, max.words = 200, random.order = F, 
          rot.per = 0.15, use.r.layout = F, colors = brewer.pal(8, 'Dark2'))

findFreqTerms(dtm, lowfreq = 4)
findAssocs(dtm, terms = "apple", corlimit = 0.3)

barplot(d[1:10,]$freq, las = 2, names.arg = d[1:10,]$word, 
        col = 'lightblue', main = 'Most frequent words', 
        ylab = 'Word frequencies')
