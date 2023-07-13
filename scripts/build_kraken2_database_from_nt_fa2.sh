#!/bin/bash
#unless you are running a parallelized task and know what you're doing, ntasks remain 1, modify the next lines to your task.
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=40G
#SBATCH --signal=USR2
#SBATCH --job-name=2build_kraken_database

#make sure you have the folder ~/logs/slurm/ for the next lines.
#SBATCH -o /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.out 
#SBATCH -e /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=amit.fenn@helmholtz-muenchen.de

#This is where you allocate some of cluster specific parameters.
#SBATCH --partition=cpu_p
#SBATCH --qos=cpu

/lustre/groups/hpc/urban_lab/projects/amit/kraken2/kraken2/bin/kraken2-build --build --threads 12  --db /lustre/groups/hpc/urban_lab/projects/KrakenDatabase/nt
