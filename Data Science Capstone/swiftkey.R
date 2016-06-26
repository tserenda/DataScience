setwd('C:\\Users\\v-aritse\\Google Drive\\GIT\\DataScience\\Data Science Capstone')
library(quanteda)
library(tm)
library(qdap)
library(RWeka)

subset_data = function(fname) {
  fn = paste('sample', fname, sep = '_')
  con = file(fname, 'rb')
  lines = readLines(con, warn = F)
  close(con)
  lines = sample(lines, length(lines) * 0.05)
  writeLines(lines, fn)
}

coverage = function(x) {
  total = 0
  words = ntokens * x #  words within 'x' sd
  for (i in 1:nfeatures) {
    total = total + sorted[i]
    if (total > words) {
      return(i)
    }
  }
}

zf = 'Coursera-SwiftKey.zip'
if (!file.exists(zf)) {
  download.file('https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip', zf)
}
unzip(zf, overwrite = T)
file.copy('final\\en_US\\en_US.blogs.txt'  , 'blogs.txt'  , overwrite = T)
file.copy('final\\en_US\\en_US.news.txt'   , 'news.txt'   , overwrite = T)
file.copy('final\\en_US\\en_US.twitter.txt', 'twitter.txt', overwrite = T)

for (fname in c('blogs.txt', 'news.txt', 'twitter.txt')) {
  subset_data(fname)
}

unlink('sample.txt')
file.append('sample.txt', 'sample_blogs.txt'  )
file.append('sample.txt', 'sample_news.txt'   )
file.append('sample.txt', 'sample_twitter.txt')

txt = tolower(readLines('sample.txt'))
txt = removeWords(txt, readLines('profanities.txt'))
tokens = tokenize(txt, removeNumbers = T, removePunct = T, removeSymbols = T,
                            removeTwitter = T, removeURL = T, removeHyphens = T)
fm = dfm(tokens) # frequency matrix
sorted = topfeatures(fm, nfeatures) # sort features by frequency


# Basic statistics of the data
ntokens = sum(ntoken(fm)) # num of tokens
nfeatures = nfeature(fm)  # num of features
cat("Total number of tokens:"  , ntokens)
cat("Total number of features:", nfeatures)

# What percentage of the data can be covered by top words?
topx = c(10, 100, 1000, 10000) # top 'x' words
coverage_by_top_words = sapply(topx, function(x) { sum(topfeatures(fm, x)) / ntokens })
names(coverage_by_top_words) = c('top10', 'top100', 'top1000', 'top10000')
round(coverage_by_top_words, 2)

# How many words (or %) can represent the data within 1, 2, 3 standard deviation(s)?
sd = c('(68.0%)' = 0.680, '(95.0%)' = 0.950, '(99.7%)' = 0.997)
Features = sapply(sd, coverage)
Percent = round(Features / nfeatures * 100, 2)
rbind(Features, Percent)

# What are the most common 200 words?
topfeatures(fm, 200)
plot(fm, max.words = 200, colors = brewer.pal(6, 'Dark2'), scale = c(20, 0.5))

## hist of word counts
h = hist(log(ntoken(fm)), main='Word Count (Absolute Value)', xlab='Log(Count)', ylab='Word')
h$density = h$counts / sum(h$counts) * 100
plot(h, freq=F, main='Word Count (Percent)', xlab='Log(Count)', ylab='Word (%)')

# create ngrams
ugram = unlist(quanteda::ngrams(tokens, n = 1))
bgram = unlist(quanteda::ngrams(tokens, n = 2))
tgram = unlist(quanteda::ngrams(tokens, n = 3))

tokens = MC_tokenizer(txt)
tokens = tokens[tokens != '']  # remove empty tokens
tokens = tokens[!(tokens %in% letters)]  # remove single characters
#tokens = tokens[tokens %in% DICTIONARY$word]  # include only dictionary words

words = concatenate(tokens)
string.summary(words) # summarize string

(unigram = ngram(words, n=1))
(bigram = ngram(words, n = 2))
(trigram = ngram(words, n = 3))

## print frequency tables of top 20 phrases
table1 = get.phrasetable(unigram)
table2 = get.phrasetable(bigram)
table3 = get.phrasetable(trigram)
table1[1:20,]
table2[1:20,]
table3[1:20,]

## frequency analysis of pairs of bigram and trigrams
hist(log(table1$freq), main='Unigram Count', xlab='Log(Count)', ylab='Unigram')
hist(log(table1$prop), main='Unigram Proportion', xlab='Log(Proportion)', ylab='Unigram')
hist(log(table2$freq), main='Bigram Count', xlab='Log(Count)', ylab='Bigram')
hist(log(table2$prop), main='Bigram Proportion', xlab='Log(Proportion)', ylab='Bigram')
hist(log(table3$freq), main='Trigram Count', xlab='Log(Count)', ylab='Trigram')
hist(log(table3$prop), main='Trigram Proportion', xlab='Log(Proportion)', ylab='Trigram')


