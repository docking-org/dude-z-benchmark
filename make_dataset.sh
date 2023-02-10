#!/usr/bin/env/bash

wget --no-check-certificate https://dudez.docking.org/DOCKING_GRIDS_AND_POSES.tgz
tar -xzf DOCKING_GRIDS_AND_POSES.tgz

for f in DOCKING_GRIDS_AND_POSES/*/INDOCK
do
  sed -i -e 's/DOCK 3.7 parameter/DOCK 3.8 parameter/g' $f
  sed -i -e 's/match_goal                    5000/match_goal                    1000/g' $f
done

wget -nH -x --no-parent -r -l1 -A \*.tgz http://dudez.docking.org/property_matched/
rm -rf property_matched/*_1/
cd property_matched/
for f in *.tgz
do
  tar -xzf $f
done


