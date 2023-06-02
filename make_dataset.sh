#!/usr/bin/env/bash

if [[ ! -f "DOCKING_GRIDS_AND_POSES.tgz" ]]; then
	wget --no-check-certificate https://dudez.docking.org/DOCKING_GRIDS_AND_POSES.tgz
fi

if [[ ! -d "DOCKING_GRIDS_AND_POSES" ]]; then
	tar -xzf DOCKING_GRIDS_AND_POSES.tgz
	for f in DOCKING_GRIDS_AND_POSES/*/INDOCK
	do
		sed -i -e 's/DOCK 3.7 parameter/DOCK 3.8 parameter/g' $f
		sed -i -e 's/match_goal                    5000/match_goal                    1000/g' $f
	done
fi

if [[ ! -d "property_matched" ]]; then
	wget --no-check-certificate -nH -x --no-parent -r -l1 -A \*.tgz http://dudez.docking.org/property_matched/
	rm -rf property_matched/*/
	cd property_matched/
	for f in *.tgz
	do
		tar -xzf $f
		TARGET_PATH=${f%.tgz}
		cd $TARGET_PATH
                cd ligands/
		tar -czf positives.tgz *
                cd ../decoys/
		tar -czf negatives.tgz *
		cd ..
		TARGET_NAME=${TARGET_PATH%_new_DUDE_1}
		mv ligands/positives.tgz ../../DOCKING_GRIDS_AND_POSES/$TARGET_NAME/
                mv decoys/negatives.tgz ../../DOCKING_GRIDS_AND_POSES/$TARGET_NAME/
                cd ..
	done
	cd ..
fi

