#!/bin/bash
#unless you are running a parallelized task and know what you're doing, ntasks remain 1, modify the next lines to your task.
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --signal=USR2
#SBATCH --job-name=build_kraken_database

#make sure you have the folder ~/logs/slurm/ for the next lines.
#SBATCH -o /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.out 
#SBATCH -e /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=amit.fenn@helmholtz-muenchen.de

#This is where you allocate some of cluster specific parameters.
#SBATCH --partition=cpu_p
#SBATCH --qos=cpu_long

/lustre/groups/hpc/urban_lab/projects/amit/kraken2/kraken2/bin/kraken2-build --add-to-library /lustre/groups/hpc/urban_lab/datasets/ncbi/nt.fa --db /lustre/groups/hpc/urban_lab/projects/KrakenDatabase/nt
