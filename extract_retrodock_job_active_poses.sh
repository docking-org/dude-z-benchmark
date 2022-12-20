#!/usr/bin/env bash

DUDE_Z_DIR_PATH=${1:-"DOCKING_GRIDS_AND_POSES/"}
RETRODOCK_JOB_DIR_NAME=${2:-"retrodock_job"}

DUDE_Z_DIR_PATH=$(realpath $DUDE_Z_DIR_PATH)

cd $DUDE_Z_DIR_PATH

for d in */
do
 cd $DUDE_Z_DIR_PATH/$d/$RETRODOCK_JOB_DIR_NAME/output/1/
 mv test.mol2.gz.0 test.mol2.gz
 gunzip test.mol2.gz
done

