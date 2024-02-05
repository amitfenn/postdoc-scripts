#!/bin/bash
#unless you are running a parallelized task and know what you're doing, ntasks remain 1, modify the next lines to your task.
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=120G
#SBATCH --signal=USR2
#SBATCH --job-name=kraken-mock
#SBATCH --array=1-17%4

#make sure you have the folder ~/logs/slurm/ for the next lines.
#SBATCH -o /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.out 
#SBATCH -e /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=amit.fenn@helmholtz-muenchen.de

#This is where you allocate some of cluster specific parameters.
#SBATCH --partition=cpu_p
#SBATCH --qos=cpu_normal

reads=$(cat ~/scripts/mock_raw_fastqs.paths  | head -n $SLURM_ARRAY_TASK_ID |tail -n1)
export database="/lustre/groups/hpc/urban_lab/datasets/ncbi/kraken_db_finalized"
outputfile=/lustre/groups/hpc/urban_lab/projects/amit/mock/krakeni/$(basename $reads .fastq)
mkdir -p $( dirname $outputfile)

/lustre/groups/hpc/urban_lab/projects/amit/kraken2/kraken2/bin/kraken2 \
	--memory-mapping \
	--db $database \
	$reads \
	--use-names \
	--threads 2 \
	--output $outputfile.out \
	--report $outputfile.report \
	--report-minimizer-data
