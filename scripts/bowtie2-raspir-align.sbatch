#!/bin/bash
#unless you are running a parallelized task and know what you're doing, ntasks remain 1, modify the next lines to your task.
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=10G
#SBATCH --signal=USR2
#SBATCH --job-name=bowtie2-raspir-build
#SBATCH --array=1-21%4

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

index=/lustre/groups/hpc/urban_lab/tools/raspir/reference_database2/2021_10_human_bact_arch_fungi_vir
paths=/home/haicu/amit.fenn/scripts/air_paper_reads.paths

#Assign one of the reads to variable $read based on array index.
read=$(cat $paths| head -n ${SLURM_ARRAY_TASK_ID} | tail -n1 )

#make sure outdir exists.
outdir=/lustre/groups/hpc/urban_lab/projects/amit/raspir/$(echo $read | cut -d "/" -f 8-9)
mkdir $outdir -p

#Sanity check
echo "Aligning $read to $index; results in $outdir/$(basename $read)" 
echo "=========================================================================================="

#Alignment with bowtie.
bowtie2 --threads 4 -x $index -U ${read} -S "$outdir/$(basename $read).bowtie2.sam"
echo "------------------------------------------------------------Run complete------------------------------------------------"
