#!/usr/bin/env Rscript

if(Sys.getenv("VIRTUAL_ENV") == ""){ stop("An active virtualenv is required") }
source(file.path(Sys.getenv('VIRTUAL_ENV'), 'bin', 'rvenv'))

suppressPackageStartupMessages(library(argparse, quietly = TRUE))
suppressPackageStartupMessages(library(dplyr, quietly = TRUE))
suppressPackageStartupMessages(library(magrittr, quietly = TRUE))
suppressPackageStartupMessages(library(readr, quietly = TRUE))
suppressPackageStartupMessages(library(ggplot2, quietly = TRUE))
suppressPackageStartupMessages(library(reshape2, quietly = TRUE))
suppressPackageStartupMessages(library(tidyr, quietly = TRUE))

options(scipen=999)


main <- function(arguments){
  ## reads in data from markergene pipeline classification and details files, returns tab delimited grouped details file suitable for Krona plot rendering
  parser <- ArgumentParser()
  parser$add_argument('--data', help='data to munge')

  args <- parser$parse_args(arguments)

  data <- read_csv(file.path(args$data))

}

main(commandArgs(trailingOnly=TRUE))
