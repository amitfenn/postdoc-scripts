#!/bin/bash
#unless you are running a parallelized task and know what you're doing, ntasks remain 1, modify the next lines to your task.
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=10G
#SBATCH --signal=USR2
#SBATCH --job-name=metaWRAP_binning_Green1h
#SBATCH --array=1-30%1

#make sure you have the folder ~/logs/slurm/ for the next lines.
#SBATCH -o /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.out  
#SBATCH -e /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=amit.fenn@helmholtz-muenchen.de

#This is where you allocate some of cluster specific parameters.
#SBATCH --partition=cpu_p
#SBATCH --qos=cpu_normal

# Activate Conda environment.
source /home/haicu/amit.fenn/miniconda3/bin/activate metawrap-env

#Update PATH variable to be able to call metaWrAP
PATH=$PATH:/lustre/groups/hpc/urban_lab/tools/metaWRAP/bin

#Selecting an reference fasta from collection of contigs.
fasta=$( head -n ${SLURM_ARRAY_TASK_ID} /home/haicu/amit.fenn/scripts/barcelona_racon_polished_fasta.paths | tail -n 1)
export fasta

# Making sure the output directories exist
outputdir=$(echo $fasta |sed 's/racon\/polished_/metawrap\//g' | sed 's/.fasta$//g' ) 
mkdir $outputdir -p

#Sanity Check
echo Sanity_check: TASK_ID: ${SLURM_ARRAY_TASK_ID} Fasta:$fasta Outputdir:$outputdir

#Payload
metawrap binning \
-o $outputdir \
-t 20 \
-a $fasta \
--run-checkm \
--metabat2 --maxbin2 --concoct --single-end \
$(echo $fasta | sed 's/racon/nanofilt/g' | sed 's/polished/combined/g'|sed 's/.fasta/_passed.fastq/g')
