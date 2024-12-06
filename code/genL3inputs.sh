#!/bin/bash

# This script lists cope filenames to be pasted in as L3 data
# Jimmy Wyngaarden, Sept 2023


# Ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
basedir="$(dirname "$scriptdir")"
sm=5

# Set cope & model nums
cope=2
modelnum=1

for task in ugr; do
	for ppi in "act"; do
		for sub in `cat ${basedir}/code/sublist_all.txt`; do
				L2file="/ZPOOL/data/projects/rf1-sra-ugr/derivatives/fsl/sub-${sub}/L2_task-ugr_model-2_type-act_sm-5.gfeat/cope2.feat/stats/cope1.nii.gz"
				L1run1file="/ZPOOL/data/projects/rf1-sra-ugr/derivatives/fsl/sub-${sub}/L1_task-ugr_model-2_type-act_run-1_sm-5.feat/stats/cope2.nii.gz"
				L1run2file="/ZPOOL/data/projects/rf1-sra-ugr/derivatives/fsl/sub-${sub}/L1_task-ugr_model-2_type-act_run-2_sm-5.feat/stats/cope2.nii.gz"
				#L2file="/ZPOOL/data/projects/rf1-sra-ugr/derivatives/fsl/sub-${sub}/L2_task-${ugr}_model-${modelnum}_type-${ppi}_sm-${sm}.gfeat/cope${cope}.feat/stats/cope1.nii.gz"
				#L2file="/ZPOOL/data/projects/rf1-sra-ugr/derivatives/fsl/sub-${sub}/L2_task-${task}_model-${modelnum}_type-${ppi}_sm-${sm}.gfeat/cope${cnum}.feat/stats/cope1.nii.gz"
				#L1run1file="/ZPOOL/data/projects/rf1-sra-ugr/derivatives/fsl/sub-${sub}/L1_task-${task}_model-${modelnum}_type-${ppi}_run-1_sm-${sm}.feat/stats/cope${cnum}.nii.gz"
				#L1run2file="/ZPOOL/data/projects/rf1-sra-ugr/derivatives/fsl/sub-${sub}/L1_task-${task}_model-${modelnum}_type-${ppi}_run-2_sm-${sm}.feat/stats/cope${cnum}.nii.gz"
				if [ -f $L2file ]; then
					echo $L2file
				elif [ -f $L1run1file ]; then
					echo $L1run1file
				elif [ -f $L1run2file ]; then
					echo $L1run2file
				else
					echo "No valid individual lvl runs for sub-${sub}"
				fi
	  	done
	done
done
