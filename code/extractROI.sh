#!/usr/bin/env bash

# This code extracts ROI from L3 results.

#!/usr/bin/env bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"

# base paths

# Inputs
L3_model_dir=L3_model-2_task-ugr_type-nppi-ecn-n52-cov-EIwINT2-flame1 #L3_task-ugdg_COMPOSITE_n54_flame1.fsf
TYPE=nppi-ecn #act #w #nppi-ecn ppi_seed-NAcc-bin
N=52
cov=EIwINT2 #_noINT
# Outputs

model=ugr

# Set path info

L3_model=L3_model-2_task-ugr_n${N}-cov-${cov}
TASK=ugr
INPUT=/ZPOOL/data/projects/rf1-sra-ugr/derivatives/fsl/COPE/${L3_model_dir}/${L3_model}
#INPUT=/data/projects/istart-ugdg/derivatives/fsl/COPE/L3_model-19_task-ugdg_type-act-n54-cov-COMPOSITE-flame1/L3_model-19_task-ugdg_n54-cov-COMPOSITE # hard code for filtered func as it changes for each type of analsis.
outputdir=${maindir}/derivatives/imaging_plots

mkdir -p $outputdir

# activation: ROI name and other path information
for ROI in 'dACC-thr537' 'AI-thr10' 'seed-dlPFC-bin'; do 
#'seed-NAcc-thr' 'seed-vmPFC-5mm-thr' 'seed-ACC-50-thr' 'seed-SPL-thr'  'seed-mPFC-thr' 'seed-dlPFC-thr' 'seed-pTPJ-bin' 'seed-insula-thr'  'seed-insula-thr' 'seed-PCC_abb_extracted' 'seed-PCC_int_extracted' 'IFG_extracted' 'Insula_extracted' 'lputamen-bin' mask_act-no-int_cope-15_ugrpmod_zstat-14' 'mask_act-no-int_cope-9_ugppmod_zstat-4' 'mask_ppi-no-int_cope-14_ugpchoicepmod_zstat5' 'mask_act-no-int_cope-7_dgpcuepmod_zstat-10' 'mask_ppi-no-int_cope-11_dgppmod_zstat-10'  'mask_ppi-no-int_cope-7_dgpendowpmod_zstat-5'; do  #'seed-NAcc-thr' 'seed-vmPFC-5mm-thr' 'seed-ACC-50-thr' 'seed-SPL-thr' 'seed-insula-thr'  'seed-mPFC-thr' 'seed-dlPFC-thr' 'seed-pTPJ-thr' #'seed-dlPFC-UGR-bin'; do #
	MASK=${maindir}/masks/${ROI}.nii.gz #masks_jbw3/
	for COPENUM in 5 6 7 8 9 10 11 12 13 14; do # act use 7 8 9 10 11 12 for normal extractions
		cnum_padded=`zeropad ${COPENUM} 2`
		DATA=`ls -1 ${INPUT}-cope-${COPENUM}-*.gfeat/cope1.feat/filtered_func_data.nii.gz` # use normally
                #DATA=/data/projects/istart-ugdg/derivatives/fsl/covariates/zstats_${TYPE}_${cov}/zstats_${TYPE}_cope_${COPENUM}.nii.gz # z scored for parametric analyses.
		fslmeants -i $DATA -o ${outputdir}/${ROI}_type-${TYPE}_cov-${cov}_model-${model}_cope-${cnum_padded}.txt -m ${MASK}
		
	done
done

