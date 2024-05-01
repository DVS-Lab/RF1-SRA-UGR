#!/bin/bash

#Add flag for activation/ppi {type} and model number

# Path to the subject list file
sublist="/ZPOOL/data/projects/rf1-sra-ugr/code/L3_n99.txt"

# Loop through each subject in the list
while IFS= read -r subject; do

    files=$(ls -1 "/ZPOOL/data/projects/rf1-sra-ugr/derivatives/fsl/sub-$subject/L2_task-ugr_model-2_type-act_sm-5.gfeat/cope2.feat/stats/cope1.nii.gz" 2>/dev/null)

    if [ -z "$files" ]; then
        files=$(ls -1 "/ZPOOL/data/projects/rf1-sra-ugr/derivatives/fsl/sub-$subject/L1_task-ugr_model-2_type-act_run-1_sm-5.feat/stats/cope2.nii.gz" 2>/dev/null)
    fi

    if [ -z "$files" ]; then
        files=$(ls -1 "/ZPOOL/data/projects/rf1-sra-ugr/derivatives/fsl/sub-$subject/L1_task-ugr_model-2_type-act_run-2_sm-5.feat/stats/cope2.nii.gz" 2>/dev/null)
    fi

    if [ -n "$files" ]; then
        echo "$files"
    fi
done < "$sublist"
