#!/usr/bin/env bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"

TASK=sharedreward
TYPE=act
outputdir=${maindir}/derivatives/fsl/zimages
mkdir -p $outputdir


for sub in 104 105 106 107 108 109 110 111 112 113 115 116 117 118 120 121 122 124 125 126 127 128 129 130 131 132 133 134 135 136 137 140 141 142 143 144 145 147 149 150 151 152 153 154 155 156 157 158 159; do

	if [ $sub -eq 111 ] || [ $sub -eq 118 ] || [ $sub -eq 120 ] || [ $sub -eq 129 ] || [ $sub -eq 135 ] || [ $sub -eq 138 ] || [ $sub -eq 145 ] || [ $sub -eq 149 ] || [ $sub -eq 152 ]; then # bad data
		echo "skipping sub-${sub} for task-${task}"
		continue
	fi


	# copy to a common folder
	for COPENUM in 1 2 3 4 5 6; do

		run1_img=${maindir}/derivatives/fsl/sub-${sub}/L1_task-sharedreward_model-02_type-act_run-01_sm-6.feat/stats/zstat${COPENUM}.nii.gz
		run2_img=${maindir}/derivatives/fsl/sub-${sub}/L1_task-sharedreward_model-02_type-act_run-02_sm-6.feat/stats/zstat${COPENUM}.nii.gz
		cp $run1_img $outputdir/sub-${sub}_task-sharedreward_model-02_type-act_run-01_sm-6_cope-${COPENUM}_L1.nii.gz
		cp $run2_img $outputdir/sub-${sub}_task-sharedreward_model-02_type-act_run-02_sm-6_cope-${COPENUM}_L1.nii.gz

		L2_img=${maindir}/derivatives/fsl/sub-${sub}/L2_task-sharedreward_model-02_type-act_sm-6.gfeat/cope${COPENUM}.feat/stats/zstat1.nii.gz
		cp $L2_img $outputdir/sub-${sub}_task-sharedreward_model-02_type-act_sm-6_cope-${COPENUM}_L2.nii.gz

	done

done

for COPENUM in 1 2 3 4 5 6; do

	# merge for each cope
	fslmerge -t $outputdir/compiled_task-sharedreward_model-02_type-act_run-01_sm-6_cope-${COPENUM}_L1.nii.gz $outputdir/sub-*_task-sharedreward_model-02_type-act_run-01_sm-6_cope-${COPENUM}_L1.nii.gz
	fslmerge -t $outputdir/compiled_task-sharedreward_model-02_type-act_run-02_sm-6_cope-${COPENUM}_L1.nii.gz $outputdir/sub-*_task-sharedreward_model-02_type-act_run-02_sm-6_cope-${COPENUM}_L1.nii.gz
	fslmerge -t $outputdir/compiled_task-sharedreward_model-02_type-act_sm-6_cope-${COPENUM}_L2.nii.gz $outputdir/sub-*_task-sharedreward_model-02_type-act_sm-6_cope-${COPENUM}_L2.nii.gz

	# copy to g-drive
	rclone copy $outputdir/compiled_task-sharedreward_model-02_type-act_run-01_sm-6_cope-${COPENUM}_L1.nii.gz dvs-temple:projects/SharedReward
	rclone copy $outputdir/compiled_task-sharedreward_model-02_type-act_run-02_sm-6_cope-${COPENUM}_L1.nii.gz dvs-temple:projects/SharedReward
	rclone copy $outputdir/compiled_task-sharedreward_model-02_type-act_sm-6_cope-${COPENUM}_L2.nii.gz dvs-temple:projects/SharedReward

done
