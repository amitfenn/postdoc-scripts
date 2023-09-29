#!/bin/bash
#unless you are running a parallelized task and know what you're doing, ntasks remain 1, modify the next lines to your task.
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=10G
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

source /home/haicu/amit.fenn/miniconda3/bin/activate metawrap-env
/lustre/groups/hpc/urban_lab/tools/metaWRAP/bin/metawrap binning -t 20 \
	-o /lustre/groups/hpc/urban_lab/projects/amit/metagang/amit_metawrap/binning \
	-a /lustre/groups/hpc/urban_lab/projects/amit/Coriolis_HAI_HAC/HAI_3h_HAC/processing/racon/*.fasta \
	--metabat2 --maxbin2 --concoct
	/lustre/groups/hpc/urban_lab/projects/amit/Coriolis_HAI_HAC/HAI_3h_HAC/processing/nanofilt/*fastq

