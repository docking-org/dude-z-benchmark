#!/usr/bin/env/bash

if [[ ! -f "DOCKING_GRIDS_AND_POSES.tgz" ]]; then
	wget --no-check-certificate https://dudez.docking.org/DOCKING_GRIDS_AND_POSES.tgz
fi

echo a
if [[ ! -d "DOCKING_GRIDS_AND_POSES" ]]; then
	tar -xzf DOCKING_GRIDS_AND_POSES.tgz
	for f in DOCKING_GRIDS_AND_POSES/*/INDOCK
	do
		sed -i -e 's/DOCK 3.7 parameter/DOCK 3.8 parameter/g' $f
		sed -i -e 's/match_goal                    5000/match_goal                    1000/g' $f
	done
fi

export DUDEZ_PATH=$(realpath DOCKING_GRIDS_AND_POSES/)

echo b
if [[ ! -d "property_matched" ]]; then
	wget --no-check-certificate -nH -x --no-parent -r -l1 -A \*.tgz http://dudez.docking.org/property_matched/
	rm -rf property_matched/*/
fi

cd property_matched/
for f in *.tgz
do
	TARGET_NAME=${f%.tgz}
	echo c
	if [ ! -d "$TARGET_NAME" ]; then
		tar -xzf $f
	fi
	echo d
	if [ ! -f "$DUDEZ_PATH/$TARGET_NAME/positives.tgz" ] || [ ! -f "$DUDEZ_PATH/$TARGET_NAME/negatives.tgz" ]; then
		cd $TARGET_NAME/ligands/
		echo e
		tar -czf positives.tgz *.db2*
                echo f
		cd ../decoys/
		tar -czf negatives.tgz *.db2*
		cd ..
		mv ligands/positives.tgz $DUDEZ_PATH/$TARGET_NAME/positives.tgz
                mv decoys/negatives.tgz $DUDEZ_PATH/$TARGET_NAME/negatives.tgz
                cd ..
	fi
done
cd ..

