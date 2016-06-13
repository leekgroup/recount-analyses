#!/bin/bash
#$ -cwd
#$ -m e
#$ -l mem_free=15G,h_vmem=20G,h_fsize=100G
#$ -pe local 10
#$ -N SRP032789_der

echo "**** Job starts ****"
date

mkdir -p logs

## Determine ERs
module load R/3.3.x
Rscript recount_DER_SRP032789_mc.R

# Move log files into the logs directory
mv SRP032789_der.* logs/

echo "**** Job ends ****"
date
