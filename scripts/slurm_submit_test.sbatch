#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1M
#SBATCH --signal=USR2
#SBATCH --partition=cpu_p
#SBATCH --qos icb
#SBATCH --job-name=sub-test
#SBATCH -o /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.out
#SBATCH -e /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.err

#Variable test for SLURM + singularity. 
variA=test1
echo $variA tested.
