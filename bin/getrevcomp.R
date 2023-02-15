#!/usr/bin/env Rscript

library(Biostrings)
library(readr)
library(stringr)

fname = commandArgs(TRUE)[1]
oname = commandArgs(TRUE)[2]
#input = read_tsv(fname, col_names = c("alignment", "crRNA", "DNA", "chr", "location", "strand", "mm", "indel"))
input = read_tsv(fname, guess_max = 1e6, col_names = c("X1", 
                                                       "sgRNA", 
                                                       "Index", 
                                                       "Searchmotif", 
                                                       "Foundmotif", 
                                                       "chromosome", 
                                                       "coordinate", 
                                                       "strand", 
                                                       "mismatches", 
                                                       "bulge_size",
                                                       "pattern_id",
                                                       "fetched_seq",
                                                       "barcode",
                                                       "final_library_member"))
input$coordinate <- input$coordinate + 1 # added this because bcftools 1-based, casoffinder output 0-based
input$end <- ifelse(str_detect(string = input$pattern_id, pattern = "RNA"), input$coordinate + 22 - input$bulge_size, input$coordinate + 22 + input$bulge_size)
input$chr <- paste0("chr", input$chromosome)
input$DNA <- ifelse(input$strand == "+", toupper(input$Foundmotif), toupper(reverseComplement(DNAStringSet(input$Foundmotif))))
input$DNA <- str_replace_all(input$DNA, pattern = "-", replacement = "")
write_tsv(input[,c("chr", "coordinate", "end", "DNA", "strand")] %>% unique(), oname, col_names = FALSE)
