#!/bin/bash
#$ -cwd
#$ -m e
#$ -l mem_free=1G,h_vmem=2G
#$ -pe local 10
#$ -N mc_xist

echo "**** Job starts ****"
date

mkdir -p logs

## Determine ERs
module load R/3.3.x
Rscript xist_mc.R

# Move log files into the logs directory
mv mc_xist.* logs/

echo "**** Job ends ****"
date
