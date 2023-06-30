#!/bin/sh

if [ -n "$SOURCE_SCRIPT" ]; then
    source $SOURCE_SCRIPT
fi

cd $TARGET_DIR
sed -i -e 's/DOCK 3.8 parameter/DOCK 3.7 parameter/g' INDOCK
eval "pydock3 retrodock - new --job_dir_path=retrodock_job_dudez_published_dockfiles"
cd retrodock_job_dudez_published_dockfiles/
eval "pydock3 retrodock - run $SCHEDULER $PARAMS"

