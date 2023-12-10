#!/bin/bash
#unless you are running a parallelized task and know what you're doing, ntasks remain 1, modify the next lines to your task.
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=10G
#SBATCH --signal=USR2
#SBATCH --job-name=bowtie2-raspir-build

#make sure you have the folder ~/logs/slurm/ for the next lines.
#SBATCH -o /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.out  
#SBATCH -e /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=amit.fenn@helmholtz-muenchen.de

#This is where you allocate some of cluster specific parameters.
#SBATCH --partition=cpu_p
#SBATCH --qos=cpu_normal

# Activate Conda environment.
source /home/haicu/amit.fenn/miniconda3/bin/activate bowtie

# Making sure the output directories exist
outputprefix=/lustre/groups/hpc/urban_lab/tools/raspir/reference_database2/2021_10_human_bact_arch_fungi_vir

# Payload
bowtie2-build --threads 4 ${outputprefix}.fa-003 ${outputprefix} 
