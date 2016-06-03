require(tm)
setwd('C:\\Users\\v-aritse\\Google Drive\\Coursera\\DS Capstone')
corpora_dir <- paste(getwd(), 'final/en_US', sep='/')

blogs_file <- paste(corpora_dir, 'en_US.blogs', sep='/')
news_file <- paste(corpora_dir, 'en_US.news', sep='/')
twitter_file <- paste(corpora_dir, 'en_US.twitter', sep='/')

combo_sample_file <- paste(corpora_dir, 'en_US.combo.sample.txt', sep='/')

sample_data <- function(f) {
  sample_file <- paste(f, 'sample', 'txt', sep='.')
  con <- file(paste(f, 'txt', sep='.'), 'rb')
  lines <- readLines(con, skipNul=T)
  close(con)
  sample_lines <- lines[as.logical(rbinom(length(lines), 1, 0.01))]    # sample 5% of each
  writeLines(sample_lines, sample_file)
  file.append(combo_sample_file, sample_file)  # combined samples of blogs, news, & tweets
}

for (f in c(blogs_file, news_file, twitter_file)) { sample_data(f) }

