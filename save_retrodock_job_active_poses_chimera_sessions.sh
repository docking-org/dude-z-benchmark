#!/usr/bin/env bash

DUDE_Z_PATH=${1:-"DOCKING_GRIDS_AND_POSES/"}
RETRODOCK_JOB_DIR_NAME=${2:-"retrodock_job"}
CHIMERA_EXEC=${3:-'/Applications/Chimera.app/Contents/MacOS/chimera'}
REC_PDB=${4:-'rec.crg.pdb'}
XTAL_LIG_PDB=${5:-'xtal-lig.pdb'}
ACTIVES_MOL2_PATH_IN_RETRODOCK_JOB=${6:-"output/1/test.mol2"}
ACTIVES_POSES_CHIMERA_SESSION_PATH_IN_RETRODOCK_JOB_DIR=${7:-"active_poses.py"}
CHIMERA_SAVE_SESSION_COM_FILE_PATH=${8:-"save_active_poses_chimera_session.com"}

DUDE_Z_PATH=$(realpath $DUDE_Z_PATH)
CHIMERA_SAVE_SESSION_COM_FILE_PATH=$(realpath $CHIMERA_SAVE_SESSION_COM_FILE_PATH)

cd $DUDE_Z_PATH

for d in */
do
    cd $DUDE_Z_PATH/$d/$RETRODOCK_JOB_DIR_NAME
    cp $CHIMERA_SAVE_SESSION_COM_FILE_PATH $(basename $CHIMERA_SAVE_SESSION_COM_FILE_PATH)
    $CHIMERA_EXEC --nogui $DUDE_Z_PATH/$d/$XTAL_LIG_PDB $DUDE_Z_PATH/$d/$REC_PDB $(basename $CHIMERA_SAVE_SESSION_COM_FILE_PATH)
done
