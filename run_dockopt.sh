#!/bin/sh

source /nfs/soft/ian/env.sh

sleep 2
cd $TARGET_DIR
pydock3 dockopt - new
cd dockopt_job/
pydock3 dockopt - run $SCHEDULER --extra_submission_cmd_params_str="--mem=4G"

