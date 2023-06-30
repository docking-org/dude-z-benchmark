#!/bin/sh

if [ -n "$SOURCE_SCRIPT" ]; then
    source $SOURCE_SCRIPT
fi

cd $TARGET_DIR
eval "pydock3 dockopt - new --job_dir_path=dockopt_job_beam_search/"
cd dockopt_job_beam_search/
eval "pydock3 dockopt - run $SCHEDULER $PARAMS"

