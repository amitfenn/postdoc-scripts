#!/bin/bash
#unless you are running a parallelized task and know what you're doing, ntasks remain 1, modify the next lines to your task.
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=40G
#SBATCH --signal=USR2
#SBATCH --job-name=indexing-minimap.nt

#choose array numbers from various K sizes and step up by 3
#SBATCH --array=22,24,26

#make sure you have the folder ~/logs/slurm/ for the next lines.
#SBATCH -o /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.out 
#SBATCH -e /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=amit.fenn@helmholtz-muenchen.de

#This is where you allocate some of cluster specific parameters.
#SBATCH --partition=cpu_p
#SBATCH --qos=cpu

let k=$SLURM_ARRAY_TASK_ID
let w=$k*2/3
if /home/haicu/amit.fenn/miniconda3/envs/minimap/bin/minimap2 -k $k -w $w -d /lustre/groups/hpc/urban_lab/datasets/ncbi/nt.k${k}.w${w}.mmi /lustre/groups/hpc/urban_lab/datasets/ncbi/nt.fa ; then
    echo "Minimap succeeded k is $k and w is $w"
else
    echo "Minimap failed. Flagging outputs for removal"
    mv /lustre/groups/hpc/urban_lab/datasets/ncbi/nt.k${k}.w${w}.mmi /lustre/groups/hpc/urban_lab/datasets/ncbi/nt.k${k}.w${w}.mmi.x_x
fi

