#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --signal=USR2
#SBATCH --partition=cpu_p
#SBATCH --qos icb
#SBATCH --job-name=varitest
#SBATCH -o /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.out
#SBATCH -e /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=amit.fenn@helmholtz-muenchen.de

#Variable test for SLURM + singularity. 
variA=test1
APPTAINERENV_variB=test2
export variB=test3

singularity exec /lustre/groups/hpc/urban_lab/workspace/rstudio/singularity-rstudio.simg /bin/dash -c "ls /bin/ -lah && echo $variA $variB and now $APPTAINERENV_variB and $SHELL"
exit
# RESULT: All three variable assignments work. dash is bash.