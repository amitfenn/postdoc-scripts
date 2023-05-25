#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=8G
#SBATCH --signal=USR2
#SBATCH --partition=interactive_cpu_p
#SBATCH --job-name=RStudio-FENN
#SBATCH -o /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.out
#SBATCH -e /home/haicu/amit.fenn/logs/slurm/%x.%j.%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=amit.fenn@helmholtz-muenchen.de
#SBATCH --qos=interactive_cpu
#SBATCH --contraint="Lustre_File_System"

source /home/haicu/amit.fenn/.bashrc
set -euo pipefail
trap 'catch $? $LINENO' ERR
catch() {
  echo "Error $1 occurred on $2"
}

echo "Starting rstudio..."
workdir="/home/haicu/amit.fenn/rstudio-mount"

#mkdir -p -m 700 ${workdir}/run ${workdir}/tmp ${workdir}/var/lib/rstudio-server
cat > ${workdir}/database.conf <<END
provider=sqlite
directory=/var/lib/rstudio-server
END

# Set OMP_NUM_THREADS to prevent OpenBLAS (and any other OpenMP-enhanced
# libraries used by R) from spawning more threads than the number of processors
# allocated to the job.
#
# Set R_LIBS_USER to a path specific to rocker/rstudio to avoid conflicts with
# personal libraries from any R installation in the host environment

cat > ${workdir}/rsession.sh <<END
#!/bin/sh
export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}
export R_LIBS_USER="/home/haicu/amit.fenn/rstudio-mount/rocker-rstudio/4.2"
exec /usr/lib/rstudio-server/bin/rsession "\${@}"
END

chmod +x ${workdir}/rsession.sh

# Do not suspend idle sessions.
# Alternative to setting session-timeout-minutes=0 in /etc/rstudio/rsession.conf
# https://github.com/rstudio/rstudio/blob/v1.4.1106/src/cpp/server/ServerSessionManager.cpp#L126
export APPTAINERENV_RSTUDIO_SESSION_TIMEOUT=0

export APPTAINERENV_USER=$(id -un)
export APPTAINERENV_PASSWORD=$(openssl rand -base64 15)
# get unused socket per https://unix.stackexchange.com/a/132524
# tiny race condition between the python & singularity commands
readonly PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
cat 1>&2 <<END
1. SSH tunnel from your workstation using the following command:

   ssh -N -L 8787:${HOSTNAME}:${PORT} ${APPTAINERENV_USER}@${HOSTNAME}

   and point your web browser to http://localhost:8787

2. log in to RStudio Server using the following credentials:

   user: ${APPTAINERENV_USER}
   password: ${APPTAINERENV_PASSWORD}

When done using RStudio Server, terminate the job by:

1. Exit the RStudio Session ("power" button in the top right corner of the RStudio window)
2. Issue the following command on the login node:

      scancel -f ${SLURM_JOB_ID}
END

trap 'echo "===rstudio exited ===="' EXIT

singularity exec \
      --bind ${workdir}/run:/run,${workdir}/tmp:/tmp,${workdir}/database.conf:/etc/rstudio/database.conf,${workdir}/rsession.sh:/etc/rstudio/rsession.sh:ro,${workdir}/var/lib/rstudio-server:/var/lib/rstudio-server \
      /home/haicu/amit.fenn/container-images/rstudio_4.2.sif /usr/lib/rstudio-server/bin/rserver --www-port ${PORT} \
       --auth-none=0 \
       --auth-pam-helper-path=pam-helper \
       --auth-stay-signed-in-days=30 \
       --auth-timeout-minutes=0 \
       --rsession-path=/etc/rstudio/rsession.sh

printf 'rserver exited' 1>&2
