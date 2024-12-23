#!/usr/bin/env bash

# This script will perform Level 1 statistics in FSL.
# Rather than having multiple scripts, we are merging three analyses
# into this one script:
#		1) activation
#		2) seed-based ppi
#		3) network-based ppi
# Note that activation analysis must be performed first.
# Seed-based PPI and Network PPI should follow activation analyses.

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"
rf1datadir=/ZPOOL/data/projects/rf1-sra-data #need to fix this upon release (no hard coding paths)

# study-specific inputs
TASK=ugr
sm=5
sub=$1
run=$2
ppi=0 # 0 for activation, otherwise seed region or network
model=2
maskname=$act

# sub ____ has a slightly different mask due to different dimensions (SAR limit exceeded)

#Mask1="NAcc-bin"
#Mask2="IFG_extracted"
#Mask3="Insula_extracted"

#if [ $1 -eq 1243 ] && [ $2 -eq 1 ] && [ $ppi = $Mask1 ] ; then
#name="ppi_seed-NAcc-bin"
#maskname="NAcc-1243-bin"
#echo "Mask for 1243 is $maskname"

#elif [ $1 -eq 1243 ] && [ $2 -eq 1 ] && [ $ppi = $Mask2 ] ; then
#name="ppi_seed-IFG_extracted"
#maskname="IFG-1243_extracted"
#echo "Mask for 1243 is $maskname"

#elif [ $1 -eq 1243 ] && [ $2 -eq 1 ] && [ $ppi = $Mask3 ] ; then
#name="ppi_seed-Insula_extracted"
#maskname="Insula-1243_extracted"
#echo "Mask for 1243 is $maskname"

# $else
# $maskname=$ppi
# $echo "Using mask $maskname"
# $fi


# set inputs and general outputs (should not need to chage across studies in Smith Lab)
MAINOUTPUT=${maindir}/derivatives/fsl/sub-${sub}
mkdir -p $MAINOUTPUT
DATA=${rf1datadir}/derivatives/fmriprep/sub-${sub}/func/sub-${sub}_task-${TASK}_run-${run}_part-mag_space-MNI152NLin6Asym_desc-preproc_bold.nii.gz
NVOLUMES=`fslnvols $DATA`
CONFOUNDEVS=${rf1datadir}/derivatives/fsl/confounds/sub-${sub}/sub-${sub}_task-${TASK}_run-${run}_part-mag_desc-fslConfounds.tsv
echo "Starting analysis for sub-${sub}, run-${run}, analysis type: ${ppi}"
if [ ! -e $CONFOUNDEVS ]; then
	echo "missing confounds: $CONFOUNDEVS "  
	exit # exiting to ensure nothing gets run without confounds
fi

EVDIR=${maindir}/derivatives/fsl/EVfiles/sub-${sub}/ugr/run-${run} # REMOVED zero padded

# empty EVs (specific to this study)
EV_MISSED_TRIAL=${EVDIR}_missed_trial.txt
if [ -e $EV_MISSED_TRIAL ]; then
	SHAPE_MISSED_TRIAL=3
else
	SHAPE_MISSED_TRIAL=10
fi
EV_COMPN=${EVDIR}_event_computer_neutral.txt
if [ -e $EV_COMPN ]; then
	SHAPE_COMPN=3
else
	SHAPE_COMPN=10
fi
EV_STRANGERN=${EVDIR}_event_stranger_neutral.txt
if [ -e $EV_STRANGERN ]; then
	SHAPE_STRANGERN=3
else
	SHAPE_STRANGERN=10
fi
EV_FRIENDN=${EVDIR}_event_friend_neutral.txt
if [ -e $EV_FRIENDN ]; then
	SHAPE_FRIENDN=3
else
	SHAPE_FRIENDN=10
fi

# if network (ecn or dmn), do nppi; otherwise, do activation or seed-based ppi
if [ "$ppi" == "ecn" -o  "$ppi" == "dmn" ]; then

	# check for output and skip existing
	OUTPUT=${MAINOUTPUT}/L1_task-${TASK}_model-${model}_type-nppi-${ppi}_run-${run}_sm-${sm}
	if [ -e ${OUTPUT}.feat/cluster_mask_zstat1.nii.gz ]; then
		exit
	else
		echo "running: $OUTPUT " 
		rm -rf ${OUTPUT}.feat
	fi

	# network extraction. need to ensure you have run Level 1 activation
	MASK=${MAINOUTPUT}/L1_task-${TASK}_model-${model}_type-act_run-${run}_sm-${sm}.feat/mask
	if [ ! -e ${MASK}.nii.gz ]; then
		echo "cannot run nPPI because you're missing $MASK"
		exit
	fi
	for net in `seq 0 9`; do
		NET=${maindir}/masks/nan_rPNAS_2mm_net000${net}.nii.gz
		TSFILE=${MAINOUTPUT}/ts_task-${TASK}_net000${net}_nppi-${ppi}_run-${run}.txt
		fsl_glm -i $DATA -d $NET -o $TSFILE --demean -m $MASK
		eval INPUT${net}=$TSFILE
	done

	# set names for network ppi (we generally only care about ECN and DMN)
	DMN=$INPUT3
	ECN=$INPUT7
	if [ "$ppi" == "dmn" ]; then
		MAINNET=$DMN
		OTHERNET=$ECN
	else
		MAINNET=$ECN
		OTHERNET=$DMN
	fi

	# create template and run analyses
	ITEMPLATE=${maindir}/templates/L1_task-${TASK}_model-${model}_type-nppi.fsf
	OTEMPLATE=${MAINOUTPUT}/L1_task-${TASK}_model-${model}_seed-${ppi}_run-${run}.fsf
	sed -e 's@OUTPUT@'$OUTPUT'@g' \
	-e 's@DATA@'$DATA'@g' \
	-e 's@EVDIR@'$EVDIR'@g' \
	-e 's@EV_MISSED_TRIAL@'$EV_MISSED_TRIAL'@g' \
	-e 's@SHAPE_MISSED_TRIAL@'$SHAPE_MISSED_TRIAL'@g' \
	-e 's@EV_FRIENDN@'$EV_FRIENDN'@g' \
	-e 's@SHAPE_FRIENDN@'$SHAPE_FRIENDN'@g' \
	-e 's@EV_COMPN@'$EV_COMPN'@g' \
	-e 's@SHAPE_COMPN@'$SHAPE_COMPN'@g' \
	-e 's@EV_STRANGERN@'$EV_STRANGERN'@g' \
	-e 's@SHAPE_STRANGERN@'$SHAPE_STRANGERN'@g' \
	-e 's@CONFOUNDEVS@'$CONFOUNDEVS'@g' \
	-e 's@MAINNET@'$MAINNET'@g' \
	-e 's@OTHERNET@'$OTHERNET'@g' \
	-e 's@INPUT0@'$INPUT0'@g' \
	-e 's@INPUT1@'$INPUT1'@g' \
	-e 's@INPUT2@'$INPUT2'@g' \
	-e 's@INPUT4@'$INPUT4'@g' \
	-e 's@INPUT5@'$INPUT5'@g' \
	-e 's@INPUT6@'$INPUT6'@g' \
	-e 's@INPUT8@'$INPUT8'@g' \
	-e 's@INPUT9@'$INPUT9'@g' \
	-e 's@NVOLUMES@'$NVOLUMES'@g' \
	<$ITEMPLATE> $OTEMPLATE
	feat $OTEMPLATE

else # otherwise, do activation and seed-based ppi

	# set output based in whether it is activation or ppi
	if [ "$ppi" == "0" ]; then
		TYPE=act
		OUTPUT=${MAINOUTPUT}/L1_task-${TASK}_model-${model}_type-${TYPE}_run-${run}_sm-${sm}
		name=act
	else
		TYPE=ppi
		OUTPUT=${MAINOUTPUT}/L1_task-${TASK}_model-${model}_type-${TYPE}_seed-${ppi}_run-${run}_sm-${sm}
		type=seed-${ppi}
	fi

	# check for output and skip existing
	if [ -e ${OUTPUT}.feat/cluster_mask_zstat1.nii.gz ]; then
		exit
	else
		echo "running: $OUTPUT " 
		rm -rf ${OUTPUT}.feat
	fi

	# create template and run analyses
	ITEMPLATE=${maindir}/templates/L1_task-${TASK}_model-${model}_type-${TYPE}.fsf
	OTEMPLATE=${MAINOUTPUT}/L1_sub-${sub}_task-${TASK}_model-${model}_seed-${ppi}_run-${run}.fsf
	if [ "$ppi" == "0" ]; then
		sed -e 's@OUTPUT@'$OUTPUT'@g' \
		-e 's@DATA@'$DATA'@g' \
		-e 's@EVDIR@'$EVDIR'@g' \
		-e 's@EV_MISSED_TRIAL@'$EV_MISSED_TRIAL'@g' \
		-e 's@SHAPE_MISSED_TRIAL@'$SHAPE_MISSED_TRIAL'@g' \
		-e 's@EV_FRIENDN@'$EV_FRIENDN'@g' \
		-e 's@SHAPE_FRIENDN@'$SHAPE_FRIENDN'@g' \
		-e 's@EV_COMPN@'$EV_COMPN'@g' \
		-e 's@SHAPE_COMPN@'$SHAPE_COMPN'@g' \
		-e 's@EV_STRANGERN@'$EV_STRANGERN'@g' \
		-e 's@SHAPE_STRANGERN@'$SHAPE_STRANGERN'@g' \
		-e 's@SMOOTH@'$sm'@g' \
		-e 's@CONFOUNDEVS@'$CONFOUNDEVS'@g' \
		-e 's@NVOLUMES@'$NVOLUMES'@g' \
		<$ITEMPLATE> $OTEMPLATE
	else
		PHYS=${maindir}/derivatives/fsl/sub-${sub}/sub-${sub}_task-${TASK}_run-${run}_${ppi}.txt
		MASK=${maindir}/masks/seed-${maskname}.nii.gz
		fslmeants -i $DATA -o $PHYS -m $MASK
		sed -e 's@OUTPUT@'$OUTPUT'@g' \
		-e 's@DATA@'$DATA'@g' \
		-e 's@EVDIR@'$EVDIR'@g' \
		-e 's@EV_MISSED_TRIAL@'$EV_MISSED_TRIAL'@g' \
		-e 's@SHAPE_MISSED_TRIAL@'$SHAPE_MISSED_TRIAL'@g' \
		-e 's@EV_FRIENDN@'$EV_FRIENDN'@g' \
		-e 's@SHAPE_FRIENDN@'$SHAPE_FRIENDN'@g' \
		-e 's@EV_COMPN@'$EV_COMPN'@g' \
		-e 's@SHAPE_COMPN@'$SHAPE_COMPN'@g' \
		-e 's@EV_STRANGERN@'$EV_STRANGERN'@g' \
		-e 's@SHAPE_STRANGERN@'$SHAPE_STRANGERN'@g' \
		-e 's@PHYS@'$PHYS'@g' \
		-e 's@SMOOTH@'$sm'@g' \
		-e 's@CONFOUNDEVS@'$CONFOUNDEVS'@g' \
		-e 's@NVOLUMES@'$NVOLUMES'@g' \
		<$ITEMPLATE> $OTEMPLATE
	fi
	feat $OTEMPLATE
fi

# fix registration as per NeuroStars post:
# https://neurostars.org/t/performing-full-glm-analysis-with-fsl-on-the-bold-images-preprocessed-by-fmriprep-without-re-registering-the-data-to-the-mni-space/784/3
#mkdir -p ${OUTPUT}.feat/reg
#ln -s $FSLDIR/etc/flirtsch/ident.mat ${OUTPUT}.feat/reg/example_func2standard.mat
#ln -s $FSLDIR/etc/flirtsch/ident.mat ${OUTPUT}.feat/reg/standard2example_func.mat
#ln -s ${OUTPUT}.feat/mean_func.nii.gz ${OUTPUT}.feat/reg/standard.nii.gz



## fix registration as per NeuroStars post:
# https://neurostars.org/t/performing-full-glm-analysis-with-fsl-on-the-bold-images-preprocessed-by-fmriprep-without-re-registering-the-data-to-the-mni-space/784/3
mkdir -p ${OUTPUT}.feat/reg
ln -s $FSLDIR/etc/flirtsch/ident.mat ${OUTPUT}.feat/reg/example_func2standard.mat
ln -s $FSLDIR/etc/flirtsch/ident.mat ${OUTPUT}.feat/reg/standard2example_func.mat

# reslice correctly for the one weird case
#if [ $sub -eq 1243 ] && [ $run -eq 1 ]; then
#     cp ${maindir}/derivatives/fsl/sub-1004/L1_task-${TASK}_model-${model}_type-${name}_run-1_sm-${sm}.feat/mean_func.nii.gz ${OUTPUT}.feat/reg/standard.nii.gz
#
#else
     ln -s ${OUTPUT}.feat/mean_func.nii.gz ${OUTPUT}.feat/reg/standard.nii.gz
#fi


# delete unused files
rm -rf ${OUTPUT}.feat/stats/res4d.nii.gz
rm -rf ${OUTPUT}.feat/stats/corrections.nii.gz
rm -rf ${OUTPUT}.feat/stats/threshac1.nii.gz
rm -rf ${OUTPUT}.feat/filtered_func_data.nii.gz
