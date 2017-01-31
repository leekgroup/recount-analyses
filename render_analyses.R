## Install all dependencies if needed

source("https://bioconductor.org/biocLite.R")
## No longer needed now that Bioc 3.4 was released in Oct 2016
# useDevel(TRUE) ## recount requires the devel version of rtracklayer (>= 1.33.10)


## Bioconductor or CRAN packages
biocLite(c('ballgown', 'BiocParallel', 'BiocStyle', 'coop', 'derfinder',
    'devtools', 'dplyr', 'downloader', 'edgeR', 'ffpe', 'GenomicRanges', 'IHW',
    'knitcitations', 'limma', 'magrittr', 'matrixStats', 'org.Hs.eg.db',
    'qvalue', 'readr', 'recount', 'rmarkdown', 'stringr',
    'SummarizedExperiment', 'topGO'))

## GitHub packages
devtools::install_github('alyssafrazee/RSkittleBrewer')

## Render all the files in this repo:
library('rmarkdown')
library('BiocStyle')

## The following code assumes that your current working directory is where
## the file "render.R" is located at. If you need to change your working
## directory use the functions getwd() and setwd().

## Use code like this to render a specific file (HTML output by default)
render('example_meta/meta_analysis.Rmd')

## Renders the same file but in PDF format and doesn't clean the output files
## which can be useful for keeping figures in PDF format.
render('example_meta/meta_analysis.Rmd', output_format = 'pdf_document',
    clean = FALSE)

## This code renders the index.Rmd files for all protocols, which you might
## not want to do.
files <- dir(pattern = 'Rmd', full.names = TRUE, include.dirs = TRUE,
    recursive = TRUE)

## Creates HTML versions
sapply(files, render)

## Creates PDF versions and save the files (useful for keeping PDF versions of
## the plots)
sapply(files[-which(files == './index.Rmd')], render,
    output_format = 'pdf_document', clean = FALSE)

## Manually
library('rmarkdown')
library('BiocStyle')

render('example_de/recount_DER_SRP032789.Rmd')
render('example_de/recount_DER_SRP032789.Rmd', output_format = 'pdf_document',
    clean = FALSE)
render('example_de/recount_SRP019936.Rmd')
render('example_de/recount_SRP019936.Rmd', output_format = 'pdf_document',
    clean = FALSE)
render('example_de/recount_SRP032789.Rmd')
render('example_de/recount_SRP032789.Rmd', output_format = 'pdf_document',
    clean = FALSE)
render('example_gtex/compare_with_GTEx_reproducible.Rmd')
render('example_gtex/compare_with_GTEx_reproducible.Rmd',
    output_format = 'pdf_document', clean = FALSE) 
render('example_meta/meta_analysis.Rmd')
render('example_meta/meta_analysis.Rmd', output_format = 'pdf_document',
    clean = FALSE)