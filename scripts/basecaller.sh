#!/bin/bash
#SBATCH --signal=USR2
#SBATCH --ntasks=1
#SBATCH --mem=10G
#SBATCH --partition=gpu_p
#SBATCH --qos=gpu
#SBATCH --gres=gpu:1
#SBATCH --job-name=ela.basecalling
#SBATCH -o /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.out
#SBATCH -e /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=amit.fenn@helmholtz-muenchen.de
/lustre/groups/hpc/urban_lab/tools/ont/ont-guppy/bin/guppy_basecaller \
    -i /lustre/groups/hpc/urban_lab/backup/mk1c/elaklebsiella/no_sample/20230420_1408_MC-113930_FAU45941_b634e857/ \
    -s /lustre/groups/hpc/urban_lab/backup/mk1c/elaklebsiella/no_sample/20230420_1408_MC-113930_FAU45941_b634e857/ \
    --barcode_kits SQK-RBK004 \
    -c dna_r9.4.1_450bps_hac.cfg \
    -r \
    -x "cuda:0"