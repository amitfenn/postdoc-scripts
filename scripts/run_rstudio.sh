#!/bin/bash

# THIS IS WORK IN PROGRESS

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=8G
#SBATCH --signal=USR2
#SBATCH --partition=interactive_cpu_p
#SBATCH --qos=interactive_cpu
#SBATCH --job-name=RStudio-FENN
#SBATCH -o /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.out
#SBATCH -e /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=amit.fenn@helmholtz-muenchen.de
#SBATCH --time=12:00:00


#Loading users bash preferences.
source ~/.bashrc
#Setting bash to strict mode. (see: http://redsymbol.net/articles/unofficial-bash-strict-mode/#expect-nonzero-exit-status)
set -euo pipefail

#quick bash debugging functions.
trap 'catch $? $LINENO' ERR
catch() {
  echo "Error $1 occurred on $2"
}


echo "Starting rstudio..."
export RSTUDIO_PASSWORD=$(openssl rand -base64 15)
export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}

#Identifying a free port to broadcast Rstudio.
readonly PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')

#Letting the user know where and how to access Rstudio.
cat 1>&2 <<END
1. SSH tunnel from your workstation using the following command:

   ssh -N -L 8787:${HOSTNAME}:${PORT} ${USER}@${HOSTNAME}

   and point your web browser to http://localhost:8787

2. log in to RStudio Server using the following credentials:

   user: $USER
   password: ${RSTUDIO_PASSWORD}

When done using RStudio Server, terminate the job by:

1. Exit the RStudio Session ("power" button in the top right corner of the RStudio window)
2. Issue the following command on the login node:

      scancel -f ${SLURM_JOB_ID}
END

#make directory ~/rstudio-mount if it doesn not exist.
if [ ! -d "$HOME/rstudio-mount" ] 
then
    echo making ~/rstudio-mount && mkdir ~/rstudio-mount    
fi

# Setting Rstudio up for a multi-user env. (See https://github.com/grst/rstudio-server-conda#running-rstudio-server-with-singularity)
uuidgen > ~/rstudio-mount/${USER}_secure-cookie-key

#Let me know when container exits.
trap "echo Rstudio is closed" EXIT

#payload for this script.
#Singularity container built with `singularity pull --name singularity-rstudio.simg shub://nickjer/singularity-rstudio`
#source code at: https://github.com/nickjer/singularity-rstudio
singularity run --app rserver /lustre/groups/hpc/urban_lab/workspace/rstudio/singularity-rstudio.simg \
  --auth-none 0 \
  --www-port ${PORT} \
  --auth-pam-helper rstudio_auth \
  --secure-cookie-key-file ~/rstudio-mount/${USER}_secure-cookie-key