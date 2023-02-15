#!/usr/bin/env Rscript

library(readr)
library(dplyr)
library(Biostrings)

infile <- commandArgs(TRUE)[1]
outfile <- commandArgs(TRUE)[2]


tmp1 <- read_tsv(infile, col_names = c("chr", "start", "end", "target", "strand", "alt", "samplename")) %>%
  group_by(chr, start, end, target, strand, alt) %>%
  summarize("samples_with_alt_allele" = paste(samplename, collapse=","))

tmp1$final_target <- ifelse(tmp1$strand == "+", tmp1$target, reverseComplement(DNAStringSet(tmp1$target)))
tmp1$final_altallele <- ifelse(tmp1$strand == "+", tmp1$alt, reverseComplement(DNAStringSet(tmp1$alt)))

write_tsv(tmp1, path=outfile)

cat("done grouping\n")
