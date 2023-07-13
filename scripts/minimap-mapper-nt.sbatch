#!/bin/bash
#unless you are running a parallelized task and know what you're doing, ntasks remain 1, modify the next lines to your task.
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=120G
#SBATCH --signal=USR2
#SBATCH --job-name=mapping-minimap.nt

#choose array numbers from various K sizes and step up by 3
#SBATCH --array=2,6,8

#make sure you have the folder ~/logs/slurm/ for the next lines.
#SBATCH -o /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.out 
#SBATCH -e /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=amit.fenn@helmholtz-muenchen.de

#This is where you allocate some of cluster specific parameters.
#SBATCH --partition=cpu_p
#SBATCH --qos=cpu

inputfile=$(head /home/haicu/amit.fenn/scripts/minimap-mapper-paths.txt -n 3|tail -n 1)
index=$(find /lustre/groups/hpc/urban_lab/datasets/ncbi/ -name "*mmi"| grep k2${SLURM_ARRAY_TASK_ID}) 
outputfile="/lustre/groups/hpc/urban_lab/projects/amit/metagang/indexer/$(basename $inputfile .fastq)-$(basename $index .mmi).sam"

echo mapping $inputfile to $index at /lustre/groups/hpc/urban_lab/datasets/ncbi/
    
if /home/haicu/amit.fenn/miniconda3/envs/minimap/bin/minimap2 --no-kalloc --print-qname -t 1 -a -x map-ont -o $outputfile $index $inputfile; then
        echo "$inputfile mapped with $index"
    else
        echo "Minimap failed. Flagging outputs for removal"
        mv $outputfile ${outputfile}.x_x
fi
