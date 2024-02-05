#!/bin/bash
#unless you are running a parallelized task and know what you're doing, ntasks remain 1, modify the next lines to your task.
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=40G
#SBATCH --signal=USR2
#SBATCH --job-name=indexing-minimap.nt

#choose array numbers from various K sizes and step up by 3

#make sure you have the folder ~/logs/slurm/ for the next lines.
#SBATCH -o /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.out 
#SBATCH -e /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.err

#This is where you allocate some of cluster specific parameters.
#SBATCH --partition=cpu_p
#SBATCH --qos=cpu_long

if /home/haicu/amit.fenn/miniconda3/envs/minimap/bin/minimap2 -d /lustre/groups/hpc/urban_lab/datasets/ncbi/nt.mmi /lustre/groups/hpc/urban_lab/datasets/ncbi/nt.fa ; then
    echo "Minimap succeeded" 
else
    echo "Minimap failed. Flagging outputs for removal"
    rm /lustre/groups/hpc/urban_lab/datasets/ncbi/nt.mmi
fi
