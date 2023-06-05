#!/bin/sh

if [ -n "$SOURCE_SCRIPT" ]; then
    source $SOURCE_SCRIPT
fi

cd $TARGET_DIR
pydock3 dockopt - new
cd dockopt_job/
pydock3 dockopt - run $SCHEDULER $PARAMS

