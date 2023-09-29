#!/bin/bash
#unless you are running a parallelized task and know what you're doing, ntasks remain 1, modify the next lines to your task.
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=120G
#SBATCH --signal=USR2
#SBATCH --job-name=metaWRAP_srprism_hg

#make sure you have the folder ~/logs/slurm/ for the next lines.
#SBATCH -o /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.out 
#SBATCH -e /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=amit.fenn@helmholtz-muenchen.de

#This is where you allocate some of cluster specific parameters.
#SBATCH --partition=cpu_p
#SBATCH --qos=cpu_normal

/lustre/groups/hpc/urban_lab/tools/metaWRAP/bin/bmtagger/srprism mkindex -i /lustre/groups/hpc/urban_lab/tools/metaWRAP/BMTAGGER_INDEX/hg38.fa -o /lustre/groups/hpc/urban_lab/tools/metaWRAP/BMTAGGER_INDEX/hg38.srprism -M 100000
