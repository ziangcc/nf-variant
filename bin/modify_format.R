#!/usr/bin/env Rscript

library(readr)
library(dplyr)
library(stringr)

infile <- commandArgs(TRUE)[1]
reffile <- commandArgs(TRUE)[2]
outfile <- commandArgs(TRUE)[3]
str(infile)
df <- read.table(infile,fill = TRUE)
rf <- read.table(reffile)
colnames(df) <- c('V1','V2','V3','V4','V5','V6','position','V8','V9','V10','V11')

colnames(rf) <- c('chr','position','position2','sample', 'count')
new <- df %>% left_join(rf, by=c('position'))
for (i in length(new$position)){
  if (is.na(new$V11[i])){
    new$V11[i] <- new$V10[i]
    new$V10[i] <- new$count[i]
  }
}
out <- new %>% select('V1','V2','V3','V4','V5','V6','position','V8','sample','count','V11')
out$sample[is.na(out$sample)] <- '.'
out$count[out$sample == '.'] <- -1
out2 <- out[!duplicated(out), ]

write.table(out2,  file=outfile, sep = "\t",row.names = FALSE, quote = FALSE, col.names = FALSE)

