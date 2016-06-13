## Load packages
library('recount')
library('BiocParallel')

chrs <- paste0('chr', c(1:22, 'X', 'Y'))
bp <- MulticoreParam(workers = 10)

if(!file.exists('regions_SRP032789.Rdata')) {
    regions_list <- bplapply(chrs, function(chr) {
        regs <- expressed_regions('SRP032789', chr, cutoff = 5L,
            maxClusterGap = 3000L, verbose = FALSE)
        return(regs)
    }, BPPARAM = bp)
    names(regions_list) <- chrs
    regions <- unlist(GRangesList(regions_list))
    
    ## Save the regions
    save(regions, regions_list, file = 'regions_SRP032789.Rdata')
} else {
    load('regions_SRP032789.Rdata')
}

print('regions memory usage')
print(object.size(regions), units = 'Mb')

## Compute coverage matrix for study SRP032789, only for chromosome 22
if(!file.exists('covMat_SRP032789.Rdata')) {
    covMat <- bplapply(chrs, function(chr) {
        coverageMatrix <- coverage_matrix('SRP032789', chr,
            regions_list[[chr]], verbose = FALSE)
        return(covMat)
    }, BPPARAM = bp)
    covMat <- do.call(rbind, covMat)

    ## Round the coverage matrix to integers
    covMat <- round(covMat, 0)
    save(covMat, file = 'covMat_SRP032789.Rdata')
} else {
    load('covMat_SRP032789.Rdata')
}

print('covMat memory usage')
print(object.size(covMat), units = 'Mb')

## Reproducibility info
proc.time()
message(Sys.time())
options(width = 120)
devtools::session_info()
