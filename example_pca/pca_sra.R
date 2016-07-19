##
library(parallel)
library(recount)
library(SummarizedExperiment)
# library(pryr)

## load data
load("/dcl01/leek/data/recount-website/rse/rse_sra/all/rse_list_gene.Rdata")

## scale counts
rse_list_scaled = mclapply(rse_list, scale_counts,mc.cores=8)

## log counts
log_scaled_gene = mclapply(rse_list_scaled, function(x) {
	log2(assays(x)$counts+1)
}, mc.cores=8)

## initiate matrix
theSamples = unlist(lapply(rse_list_scaled,function(x) colData(x)$run))
theGenes = rowData(rse_list_scaled[[1]])$gene_id

## by project
pIndexes = rep(1:length(log_scaled_gene), 
	times = sapply(rse_list_scaled,ncol))
pIndexes = split(seq(along=pIndexes), pIndexes)

#####################
#### merge###########

### join pheno
pd = do.call("rbind", lapply(rse_list_scaled, colData))

## pull annotation
map = rowData(rse_list_scaled[[1]])

### joint joints
log_geneCounts = matrix(NA, nc = length(theSamples),
	nr = length(theGenes), dimnames = list(theGenes, theSamples))
for(i in seq(along=pIndexes)) {
	cat(".")
	ii = pIndexes[[i]]
	log_geneCounts[,ii] = log_scaled_gene[[i]]
}

#############
## do PCA ###