#!/bin/bash
#SBATCH -p cpu_p
#SBATCH -q cpu_normal
#SBATCH --mem=300G
#SBATCH --nice=10000
#SBATCH --job-name=kraken-build
#SBATCH -c 30

# make sure you have the folder ~/logs/slurm/ for the next lines.
#SBATCH -o /home/haicu/amit.fenn/logs/slurm/%x.out
#SBATCH -e /home/haicu/amit.fenn/logs/slurm/%x.err

kraken2-build --add-to-library /lustre/groups/hpc/urban_lab/datasets/ncbi/nt.fa --db /lustre/groups/hpc/urban_lab/datasets/ncbi/kraken_db_nt/


# Rebuild the Kraken 2 database
kraken2-build --build --db /lustre/groups/hpc/urban_lab/datasets/ncbi/kraken_db_nt/












