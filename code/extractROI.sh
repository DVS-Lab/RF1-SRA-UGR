#!/usr/bin/env bash

# This code extracts ROI from L3 results.

#!/usr/bin/env bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"


# Specify all the L3 models:

# COPE Nums:

# 1.  Cue Dict
# 2.  Cue UGP
# 3.  Cue UG-R
# 4.  Choice DG-P
# 5.  Choice UG-P
# 6.  Choice UG-R 
# 7.  Cue Dict pmod
# 8.  Cue UGP pmod
# 9.  Cue UGR pmod
# 10. SKIP (DG cue > UGP cue)
# 11. SKIP (DGP pmod cue > UGP)
# 12. SKIP (DGP choice > UGP) 
# 13. Choice DG-P pmod
# 14. Choice UG-P pmod
# 15. Choice UG-R pmod
# 16. SKIP (DG-P choice pmod > UGP)

#L3_model-13_task-ugdg_type-act-n46-cov-SUBSTANCE-flame1
#L3_model-13_task-ugdg_type-act-n45-cov-ATTITUDES-flame1
#L3_model-13_task-ugdg_type-act-n50-cov-REWARD-flame1
#L3_model-13_task-ugdg_type-act-n51-cov-FULL-flame1
#L3_model-13_task-ugdg_type-nppi-ecn-n45-cov-ATTITUDES-flame1
#L3_model-13_task-ugdg_type-nppi-ecn-n46-cov-SUBSTANCE-flame1
#L3_model-13_task-ugdg_type-nppi-n50-cov-REWARD-flame1
#L3_model-13_task-ugdg_type-nppi-n51-cov-FULL-flame1 
#L3_model-13_task-ugdg_type-ppi_seed-NAcc-n50-cov-REWARD-flame1
#L3_model-13_task-ugdg_type-ppi_seed-NAcc-n51-cov-FULL-flame1
#L3_model-13_task-ugdg_type-ppi_seed-NAcc-n45-cov-ATTITUDES-flame1 
#L3_model-13_task-ugdg_type-ppi_seed-NAcc-n46-cov-SUBSTANCE-flame1

# base paths

# Inputs
L3_model_dir=L3_task-ugdg_model-1_COMPOSITE_noINT_n54_flame1.fsf #L3_task-ugdg_COMPOSITE_n54_flame1.fsf
TYPE=act #act #w #nppi-ecn ppi_seed-NAcc-bin
N=54
cov=COMPOSITE_noINT #_noINT

# Outputs

model=GLM3

# Set path info

L3_model=L3_model-1_task-ugdg_n${N}-cov-${cov}
TASK=ugdg
INPUT=/data/projects/istart-ugdg/derivatives/fsl/COPE/${L3_model_dir}/${L3_model}
#INPUT=/data/projects/istart-ugdg/derivatives/fsl/COPE/L3_model-19_task-ugdg_type-act-n54-cov-COMPOSITE-flame1/L3_model-19_task-ugdg_n54-cov-COMPOSITE # hard code for filtered func as it changes for each type of analsis.
outputdir=${maindir}/derivatives/imaging_plots

mkdir -p $outputdir

# activation: ROI name and other path information
for ROI in 'pinsula_extracted' 'seed-insula-bin' 'pTPJ_extracted' 'seed-NAcc-thr' 'seed-vmPFC-5mm-thr' 'seed-ACC-50-thr' 'seed-SPL-thr'  'seed-mPFC-thr' 'seed-dlPFC-thr' 'seed-pTPJ-bin' 'seed-insula-thr'  'seed-insula-thr' 'seed-PCC_abb_extracted' 'seed-PCC_int_extracted' 'IFG_extracted' 'Insula_extracted' 'Angular_extracted' 'AI_extracted'; do 
#'seed-NAcc-thr' 'seed-vmPFC-5mm-thr' 'seed-ACC-50-thr' 'seed-SPL-thr'  'seed-mPFC-thr' 'seed-dlPFC-thr' 'seed-pTPJ-bin' 'seed-insula-thr'  'seed-insula-thr' 'seed-PCC_abb_extracted' 'seed-PCC_int_extracted' 'IFG_extracted' 'Insula_extracted' 'lputamen-bin' mask_act-no-int_cope-15_ugrpmod_zstat-14' 'mask_act-no-int_cope-9_ugppmod_zstat-4' 'mask_ppi-no-int_cope-14_ugpchoicepmod_zstat5' 'mask_act-no-int_cope-7_dgpcuepmod_zstat-10' 'mask_ppi-no-int_cope-11_dgppmod_zstat-10'  'mask_ppi-no-int_cope-7_dgpendowpmod_zstat-5'; do  #'seed-NAcc-thr' 'seed-vmPFC-5mm-thr' 'seed-ACC-50-thr' 'seed-SPL-thr' 'seed-insula-thr'  'seed-mPFC-thr' 'seed-dlPFC-thr' 'seed-pTPJ-thr' #'seed-dlPFC-UGR-bin'; do #
	MASK=${maindir}/masks/${ROI}.nii.gz #masks_jbw3/
	for COPENUM in 1 2 3 4 5 6 7 8 9 10 11 12; do # act use 7 8 9 10 11 12 for normal extractions
		cnum_padded=`zeropad ${COPENUM} 2`
		#DATA=`ls -1 ${INPUT}-cope-${COPENUM}-*.gfeat/cope1.feat/filtered_func_data.nii.gz` # use normally
                DATA=/data/projects/istart-ugdg/derivatives/fsl/covariates/zstats_${TYPE}_${cov}/zstats_${TYPE}_cope_${COPENUM}.nii.gz # z scored for parametric analyses.
		fslmeants -i $DATA -o ${outputdir}/${ROI}_type-${TYPE}_cov-${cov}_model-${model}_cope-${cnum_padded}.txt -m ${MASK}
		
	done
done

