#!/bin/sh

source /nfs/soft/ian/env.sh

sleep 5
cd $TARGET_DIR/dockopt_job
pydock3 dockopt - run slurm --retrodock_job_max_reattempts=5

