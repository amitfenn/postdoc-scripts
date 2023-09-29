#!/bin/bash
#unless you are running a parallelized task and know what you're doing, ntasks remain 1, modify the next lines to your task.
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=120G
#SBATCH --signal=USR2
#SBATCH --job-name=3h_kraken-classification_greenhouse
#SBATCH --array=1-240%4

#make sure you have the folder ~/logs/slurm/ for the next lines.
#SBATCH -o /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.out 
#SBATCH -e /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=amit.fenn@helmholtz-muenchen.de

#This is where you allocate some of cluster specific parameters.
#SBATCH --partition=cpu_p
#SBATCH --qos=cpu

reads=$(cat ~/scripts/Greenhouse_HAC.paths | grep 3h | head -n $SLURM_ARRAY_TASK_ID |tail -n1)
database=/lustre/groups/hpc/urban_lab/projects/KrakenDatabase/nt/kraken_db
outputfile=/lustre/groups/hpc/urban_lab/projects/amit/metagang/Greenhouse/2_3h/$(basename $reads .fastq)

/lustre/groups/hpc/urban_lab/projects/amit/kraken2/kraken2/bin/kraken2 \
	--db $database \
	$reads \
	--use-names \
	--threads 2 \
	--output $outputfile.out \
	--report $outputfile.report \
	--report-minimizer-data
