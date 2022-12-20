#!/bin/sh

source /wynton/home/irwin/isknight/dude-z-benchmark/env.sh

sleep 2
cd $TARGET_DIR
pydock3 retrodock - new
cd retrodock_job/
pydock3 retrodock - run $SCHEDULER

