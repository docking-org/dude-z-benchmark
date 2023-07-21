#!/usr/bin/env/bash

if [[ ! -f "DOCKING_GRIDS_AND_POSES.tgz" ]]; then
	wget --no-check-certificate https://dudez.docking.org/DOCKING_GRIDS_AND_POSES.tgz
fi

if [[ ! -d "DOCKING_GRIDS_AND_POSES" ]]; then
	mkdir DOCKING_GRIDS_AND_POSES
	cd DOCKING_GRIDS_AND_POSES/
	tar -xzf ../DOCKING_GRIDS_AND_POSES.tgz
#	for f in DOCKING_GRIDS_AND_POSES/*/INDOCK
#	do
#		sed -i -e 's/DOCK 3.7 parameter/DOCK 3.8 parameter/g' $f
#		sed -i -e 's/match_goal                    5000/match_goal                    1000/g' $f
#	done
	cd ..
fi

#
if command -v realpath >/dev/null 2>&1; then
	export DUDEZ_PATH=$(realpath DOCKING_GRIDS_AND_POSES/)
else
	if command -v readlink >/dev/null 2>&1; then
		export DUDEZ_PATH=$(readlink -f DOCKING_GRIDS_AND_POSES/)
	else
		echo "Error: `realpath` and `readlink` commands are unrecognized on this system. Exiting."
		exit 1
	fi
fi

#
if [[ ! -d "property_matched" ]]; then
	wget --no-check-certificate -nH -x --no-parent -r -l1 -A \*.tgz http://dudez.docking.org/property_matched/
	rm -rf property_matched/*/
fi

#
cd property_matched/
for f in *.tgz
do
	TARGET_NAME=${f%.tgz}
	if [ ! -f "$TARGET_NAME/ligands.tgz" ] || [ ! -f "$TARGET_NAME/decoys.tgz" ]; then
		mkdir -p $TARGET_NAME
		cd $TARGET_NAME
		rm -rf *
		tar -xzf ../$f
		cd ..
	fi
	if [ ! -f "$DUDEZ_PATH/$TARGET_NAME/positives.tgz" ] || [ ! -f "$DUDEZ_PATH/$TARGET_NAME/negatives.tgz" ]; then
		cp $TARGET_NAME/ligands.tgz $DUDEZ_PATH/$TARGET_NAME/positives.tgz
                cp $TARGET_NAME/decoys.tgz $DUDEZ_PATH/$TARGET_NAME/negatives.tgz
	fi
done
cd ..

