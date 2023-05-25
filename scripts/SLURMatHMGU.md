# Welcome to Helmholtz Munich, One Health Genomics, 
## the group of Dr. Lara Urban.

At Helholtz Munich, we use High Performing Compute(HPC) clusters that are operated by SLURM.
[ Here is the SLURM Documentation. ](https://slurm.schedmd.com/archive/slurm-22.05.6/quickstart.html)

Here is an example header for a typical SLURM batch script. To run this script, you would execute your `script.sh` like so: `sbatch script.sh`

```
#!/bin/bash
#unless you are running a parallelized task and know what you're doing, ntasks remain 1, modify the next lines to your task.
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=8G
#SBATCH --signal=USR2
#SBATCH --job-name=<job.name>

#make sure you have the folder ~/logs/slurm/ for the next lines.
#SBATCH -o /home/haicu/<user.name>/logs/slurm/%x.%j.%a.out 
#SBATCH -e /home/haicu/<user.name>/logs/slurm/%x.%j.%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<user.name>@helmholtz-muenchen.de

#This is where you allocate some of cluster specific parameters.
#SBATCH --partition=cpu_p
#SBATCH --qos=cpu
```

Some other examples of cluster specific paramets include the following:
```
#SBATCH --partition=interactive_cpu_p
#SBATCH --qos=interactive_cpu
```
```
#SBATCH --partition=interactive_gpu_p
#SBATCH --qos=interactive_gpu
```
You get the idea..



Here is how you find the state of the nodes and the names of the partitions we have.
```
$sinfo
PARTITION         AVAIL  TIMELIMIT  NODES  STATE NODELIST
interactive_cpu_p    up   12:00:00      2    mix cpusrv[51-52]
interactive_cpu_p    up   12:00:00      3   idle cpusrv[53-55]
interactive_gpu_p    up   12:00:00      4    mix gpusrv[22-25]
cpu_p                up 3-00:00:00      2 drain* supercpu[01-02]
cpu_p                up 3-00:00:00      9    mix cpusrv[39-42,44-47,50]
cpu_p                up 3-00:00:00      3  alloc cpusrv[43,48-49]
gpu_p                up 2-00:00:00      2  down* gpusrv[50-51]
gpu_p                up 2-00:00:00     23    mix gpusrv[26-35,38-49,52]
normal_q             up 5-00:00:00      3 drain* cpusrv[62-64]
normal_q             up 5-00:00:00      6    mix cpusrv[57-61,65]
normal_q             up 5-00:00:00      1  alloc cpusrv56
cemp_gpu_p           up 5-00:00:00      1   idle supergpu06
```

The `--qos` argument determins what kind of Quality of Service(QOS) you get.
```
$sacctmgr show qos format="Name,MaxWall,MaxTRESPerUser%30,MaxJob,Priority,Fairshare,MaxCPUs,MaxJobs"
      Name     MaxWall                      MaxTRESPU MaxJobs   Priority     Share  MaxCPUs MaxJobs 
---------- ----------- ------------------------------ ------- ---------- --------- -------- ------- 
    normal                                                500          0         0              500 
      comi                                                200          0         0              200 
  longjobs 15-00:00:00                                    200          0         0              200 
       bcf                                                200          0         0              200 
       icb  3-00:00:00                                    200          0         0              200 
       gpu  2-00:00:00                                     20          0         0       28      20 
interacti+    12:00:00                                      2          0         0       28       2 
interacti+                                                  2          0         0                2 
       cpu  3-00:00:00                                    200          0         0              200 
  priority  3-00:00:00                                               100         0                  
 cpu_short    06:00:00                                     20        100         0               20 
cpu_normal  5-00:00:00                                    200          0         0              200 
  cpu_long 15-00:00:00                                      2          0         0                2 
 gpu_short    06:00:00     cpu=10,gres/gpu=1,mem=100G       5        100         0                5 
  gpu_long  5-00:00:00                                      2          0         0       28       2 
  cemp_gpu                                                             0         0                  
gpu_reser+                                                             0         0                  
cpu_reser+                                                             0         0                  
gpu_normal                                                             0         0                  
gpu_prior+                                                             0         0                  
cpu_prior+                                                             0         0                  
interacti+                                                             0         0                  
interacti+                                                             0         0                  
```

To learn more about which partitions you specifically have access to, run the following.
```
$sacctmgr show assoc format=user,account,qos,Fairshare   |grep $USER
 amit.fenn      haicu cpu,gpu,icb,interac+         1 
```
See? some of just don't have access to the priority QOS, like me. But that is okay, who needs priority when you have 23 GPU nodes or 14 CPU nodes, probably just the PIs.

In any case, if you want the motherload of details, to map your slurm jobs. Here is the command for it.
```
 scontrol show partitions
PartitionName=interactive_cpu_p
   AllowGroups=ALL AllowAccounts=ALL AllowQos=interactive_cpu,interactive_cpu_short
   AllocNodes=ALL Default=NO QoS=N/A
   DefaultTime=NONE DisableRootJobs=NO ExclusiveUser=NO GraceTime=0 Hidden=NO
   MaxNodes=UNLIMITED MaxTime=12:00:00 MinNodes=0 LLN=NO MaxCPUsPerNode=UNLIMITED
   Nodes=cpusrv[51-55]
   PriorityJobFactor=1 PriorityTier=1 RootOnly=NO ReqResv=NO OverSubscribe=NO
   OverTimeLimit=NONE PreemptMode=GANG,SUSPEND
   State=UP TotalCPUs=480 TotalNodes=5 SelectTypeParameters=NONE
   JobDefaults=(null)
   DefMemPerCPU=100 MaxMemPerNode=UNLIMITED
   TRES=cpu=440,mem=3815885M,node=5,billing=440

PartitionName=interactive_gpu_p
   AllowGroups=ALL AllowAccounts=ALL AllowQos=interactive_gpu,interactive_gpu_short
   AllocNodes=ALL Default=NO QoS=N/A
   DefaultTime=NONE DisableRootJobs=NO ExclusiveUser=NO GraceTime=0 Hidden=NO
   MaxNodes=UNLIMITED MaxTime=12:00:00 MinNodes=0 LLN=NO MaxCPUsPerNode=UNLIMITED
   Nodes=gpusrv[22-25]
   PriorityJobFactor=1 PriorityTier=1 RootOnly=NO ReqResv=NO OverSubscribe=NO
   OverTimeLimit=NONE PreemptMode=GANG,SUSPEND
   State=UP TotalCPUs=256 TotalNodes=4 SelectTypeParameters=NONE
   JobDefaults=DefCpuPerGPU=3,DefMemPerGPU=16384
   DefMemPerCPU=2048 MaxMemPerCPU=2730
   TRES=cpu=216,mem=1504448M,node=4,billing=216,gres/gpu=8

PartitionName=cpu_p
   AllowGroups=ALL AllowAccounts=ALL AllowQos=cpu_short,cpu_normal,cpu_long,cpu_priority,cpu_reservation,cpu,icb,normal,priority,longjobs
   AllocNodes=ALL Default=NO QoS=N/A
   DefaultTime=NONE DisableRootJobs=NO ExclusiveUser=NO GraceTime=0 Hidden=NO
   MaxNodes=UNLIMITED MaxTime=3-00:00:00 MinNodes=0 LLN=NO MaxCPUsPerNode=UNLIMITED
   Nodes=cpusrv[39-50],supercpu[01-02]
   PriorityJobFactor=1 PriorityTier=1 RootOnly=NO ReqResv=NO OverSubscribe=NO
   OverTimeLimit=NONE PreemptMode=GANG,SUSPEND
   State=UP TotalCPUs=1664 TotalNodes=14 SelectTypeParameters=NONE
   JobDefaults=(null)
   DefMemPerCPU=100 MaxMemPerNode=UNLIMITED
   TRES=cpu=1546,mem=13143942M,node=14,billing=1546

PartitionName=gpu_p
   AllowGroups=ALL AllowAccounts=ALL AllowQos=gpu_short,gpu_normal,gpu_long,gpu_priority,gpu_reservation,gpu
   AllocNodes=ALL Default=NO QoS=N/A
   DefaultTime=NONE DisableRootJobs=NO ExclusiveUser=NO GraceTime=0 Hidden=NO
   MaxNodes=UNLIMITED MaxTime=2-00:00:00 MinNodes=0 LLN=NO MaxCPUsPerNode=UNLIMITED
   Nodes=gpusrv[26-35,38-52]
   PriorityJobFactor=1 PriorityTier=1 RootOnly=NO ReqResv=NO OverSubscribe=NO
   OverTimeLimit=NONE PreemptMode=GANG,SUSPEND
   State=UP TotalCPUs=3200 TotalNodes=25 SelectTypeParameters=NONE
   JobDefaults=DefCpuPerGPU=3,DefMemPerGPU=12500
   DefMemPerCPU=2048 MaxMemPerNode=UNLIMITED
   TRES=cpu=3000,mem=19081150M,node=25,billing=3000,gres/gpu=54

PartitionName=normal_q
   AllowGroups=ALL AllowAccounts=ALL AllowQos=cpu_short,cpu_normal,cpu_long,cpu_priority,cpu_reservation,cpu,icb,normal,priority,longjobs
   AllocNodes=ALL Default=NO QoS=N/A
   DefaultTime=02:00:00 DisableRootJobs=NO ExclusiveUser=NO GraceTime=0 Hidden=NO
   MaxNodes=UNLIMITED MaxTime=5-00:00:00 MinNodes=0 LLN=NO MaxCPUsPerNode=UNLIMITED
   Nodes=cpusrv[56-65]
   PriorityJobFactor=1 PriorityTier=1 RootOnly=NO ReqResv=NO OverSubscribe=NO
   OverTimeLimit=NONE PreemptMode=GANG,SUSPEND
   State=UP TotalCPUs=928 TotalNodes=10 SelectTypeParameters=NONE
   JobDefaults=(null)
   DefMemPerCPU=100 MaxMemPerNode=UNLIMITED
   TRES=cpu=846,mem=7889825M,node=10,billing=846

PartitionName=cemp_gpu_p
   AllowGroups=ALL AllowAccounts=ALL AllowQos=cemp_gpu
   AllocNodes=ALL Default=NO QoS=N/A
   DefaultTime=NONE DisableRootJobs=NO ExclusiveUser=NO GraceTime=0 Hidden=NO
   MaxNodes=UNLIMITED MaxTime=5-00:00:00 MinNodes=0 LLN=NO MaxCPUsPerNode=UNLIMITED
   Nodes=supergpu06
   PriorityJobFactor=1 PriorityTier=1 RootOnly=NO ReqResv=NO OverSubscribe=NO
   OverTimeLimit=NONE PreemptMode=GANG,SUSPEND
   State=UP TotalCPUs=240 TotalNodes=1 SelectTypeParameters=NONE
   JobDefaults=DefMemPerGPU=20480
   DefMemPerCPU=100 MaxMemPerNode=UNLIMITED
   TRES=cpu=220,mem=1988645M,node=1,billing=220,gres/gpu=2
   ```