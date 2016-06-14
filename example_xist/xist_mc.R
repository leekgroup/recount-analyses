library('recount')
library('GenomicRanges')
library('GenomeInfoDb')
library('derfinder')
library('BiocParallel')

xist_exons <- recount_exons[names(recount_exons) == recount_genes$gene_id[which(recount_genes$symbol == 'XIST')]][[1]]
xist_exons <- keepSeqlevels(xist_exons, 'chrX')
names(xist_exons) <- seq_len(length(xist_exons))

index <- tapply(recount_url$file_name, recount_url$project, function(x) {
    any(grepl('\\.bw$', x))
})
projects <- names(index)[index]

## Check that it's not including GTEx
stopifnot(names(index)[!index] == 'SRP012682')

print('Number of projects used')
length(projects)

## Define parallel environment to use
bp <- MulticoreParam(workers = 10, outfile = Sys.getenv('SGE_STDERR_PATH'))

message(paste(Sys.time(), 'Start computing coverageMatrix'))
coverageMatrix <- bplapply(projects, function(project) {
    message(paste(Sys.time(), 'processing project', project))
    coverage_matrix(project, chr = 'chrX', regions = xist_exons,
        chunksize = length(xist_exons), verbose = FALSE,
        outdir = file.path('/dcl01/leek/data/sra_to_upload3/', project),
        bpparam = SerialParam())
}, BPPARAM = bp)

message(paste(Sys.time(), 'Combining across all projects'))
coverageMatrix <- do.call(cbind, coverageMatrix)


message(paste(Sys.time(), 'Saving coverageMatrix'))
save(coverageMatrix, file = 'coverageMatrix_xist.Rdata')

print('Object size')
print(object.size(coverageMatrix), units = 'Mb')

print('Dimensions of the matrix')
dim(coverageMatrix)

## Reproducibility info
proc.time()
message(Sys.time())
options(width = 120)
devtools::session_info()
