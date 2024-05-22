#!/usr/bin/env bash


DUDEZ_PATH="DOCKING_GRIDS_AND_POSES"


run () {
	echo "a"
	echo $1
}

if [ -z $1 ]; then 
	RUN_ALL=true
else
	RUN_ALL=false
fi

if [ $RUN_ALL = true ]; then
	for d in $DUDEZ_PATH/*;
	do
		run $d
	done
else
	run $1
fi

