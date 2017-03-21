#!/bin/bash
#$ -S /bin/bash
#$ -N slope
#$ -cwd
#$ -j Y
#$ -V
#$ -m be
#$ -M water.read@gmail.com
#$ -q long.q
s=$1
scriptdir=/home/helenhelen/DQ/project/gitrepo/ISR_2015/ROI_based/me/ERS/ln
R CMD BATCH $scriptdir/$s
