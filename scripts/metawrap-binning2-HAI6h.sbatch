#!/bin/bash
#unless you are running a parallelized task and know what you're doing, ntasks remain 1, modify the next lines to your task.
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=10G
#SBATCH --signal=USR2
#SBATCH --job-name=metaWRAP_binning
#SBATCH --array=1-6%1

#make sure you have the folder ~/logs/slurm/ for the next lines.
#SBATCH -o /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.out  
#SBATCH -e /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=amit.fenn@helmholtz-muenchen.de

#This is where you allocate some of cluster specific parameters.
#SBATCH --partition=cpu_p
#SBATCH --qos=cpu_normal


source /home/haicu/amit.fenn/miniconda3/bin/activate metawrap-env
PATH=$PATH:/lustre/groups/hpc/urban_lab/tools/metaWRAP/bin
mkdir -p /lustre/groups/hpc/urban_lab/projects/amit/metagang/amit_metawrap/BIN_REFINEMENT/HAI_6h/${SLURM_ARRAY_TASK_ID}

metawrap bin_refinement \
-o /lustre/groups/hpc/urban_lab/projects/amit/metagang/amit_metawrap/BIN_REFINEMENT/HAI_6h/${SLURM_ARRAY_TASK_ID} \
-t 96 \
-A /lustre/groups/hpc/urban_lab/projects/amit/metagang/amit_metawrap/binning/HAI_6h/${SLURM_ARRAY_TASK_ID}/metabat2_bins/ \
-B /lustre/groups/hpc/urban_lab/projects/amit/metagang/amit_metawrap/binning/HAI_6h/${SLURM_ARRAY_TASK_ID}/maxbin2_bins/ \
-C /lustre/groups/hpc/urban_lab/projects/amit/metagang/amit_metawrap/binning/HAI_6h/${SLURM_ARRAY_TASK_ID}/concoct_bins/ \
-c 30 \
-x 30

