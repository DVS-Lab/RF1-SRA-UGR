#!/bin/bash

# This script will perform Level 3 statistics in FSL.
# Rather than having multiple scripts, we are merging three analyses
# into this one script:
#		1) two groups (older vs. younger)
#		2) two groups (older vs. younger), with covariates
#		3) single group average
#
# This script can also run randomise (permutation-based stats) on existing output.
# By default, randomise will not be be run if FEAT analyses do not exist. In addition,
# randomise will only be run on copes above a specified number (see copenum_thresh_randomise variable).
# If you have no intention of running randomise, you set copenum_thresh_randomise=20 (> max of 19 copes)
# and you could uncomment out the rm lines that remove the filtered_func_data file (save disk space).

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"

# study-specific inputs and general output folder

copenum=$1
copenum_thresh_randomise=16 # actual contrasts start here. no need to do randomise main effects (e.g., reward > nothing/fixation/baseline)
copename=$2
REPLACEME=$3 # this defines the parts of the path that differ across analyses
type=${REPLACEME} # For output template

# Variables that change per analysis. Check carefully! 
covariate=COMPOSITE #_noINT
N=54
template=L3_task-ugdg_COMPOSITE_n54_flame1.fsf # L3_task-ugdg_COMPOSITE_noINT_n54_flame1.fsf

# Set once and then forget.
model=1
task=ugdg
modeltype=flame1
templatedir="/data/projects/istart-ugdg/templates"
MAINOUTPUT=${maindir}/derivatives/fsl/COPE/L3_model-${model}_task-${task}_type-${type}-n${N}-cov-${covariate}-${modeltype}


mkdir -p $MAINOUTPUT


### --- One group ------------------------------
# set outputs and check for existing
cnum_pad=`zeropad ${copenum} 2`
OUTPUT=${MAINOUTPUT}/L3_model-${model}_task-${task}_n${N}-cov-${covariate}-cope-${copenum}-${copename}-${modeltype}

#if [ -e ${OUTPUT}.gfeat/cope1.feat/cluster_mask_zstat1.nii.gz ]; then
#
#	# run randomise if output doesn't exist and the contrasts (copes) are valid
#	cd ${OUTPUT}.gfeat/cope1.feat
#	if [ ! -e randomise_tfce_corrp_tstat2.nii.gz ] && [ $copenum -ge $copenum_thresh_randomise ]; then
#		randomise -i filtered_func_data.nii.gz -o randomise -d design.mat -t design.con -m mask.nii.gz -T -c 2.6 -n 10000
#	fi

#else # try to run feat and clean up previous effort with partial output

	echo "re-doing: ${OUTPUT}" >> re-runL3.log
	rm -rf ${OUTPUT}.gfeat

	# create template and run FEAT analyses
	ITEMPLATE=${templatedir}/${template}
	OTEMPLATE=${MAINOUTPUT}/L3_task-${task}_model-${model}_type-${type}_cope-${copenum}_${covariate}_n${N}_${modeltype}.fsf
	sed -e 's@OUTPUT@'$OUTPUT'@g' \
	-e 's@COPENUM@'$copenum'@g' \
	-e 's@REPLACEME@'$REPLACEME'@g' \
	-e 's@BASEDIR@'$maindir'@g' \
	<$ITEMPLATE> $OTEMPLATE
	feat $OTEMPLATE

# delete unused files
rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/res4d.nii.gz
rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/corrections.nii.gz
rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/threshac1.nii.gz
#rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/filtered_func_data.nii.gz
rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/var_filtered_func_data.nii.gz
