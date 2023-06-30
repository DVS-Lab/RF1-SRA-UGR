#!/bin/bash

# define atlas
#atlas=/usr/share/fsl/data/atlases/HarvardOxford/HarvardOxford-cort-maxprob-thr50-2mm.nii.gz #change sub to cort for cortical vs. subcortical.


atlas=/usr/share/fsl/data/atlases/MarsTPJParcellation/TPJ_thr25_2mm.nii.gz

# use atlas in mask directory for TPJ.

# This codes generates a mask in the desired region. 1) Adjust the threshold values based on indices from the atlas variable queried from the path above. 2) Adjust output name. 
# fslmaths $atlas -thr value -uthr value -bin output_name.

# Reference "Making ROIs" Slab page on DVS page.

fslmaths $atlas -thr 2 -uthr 2 -bin aTPJ_25
#fslmaths $atlas -thr 29 -uthr 29 -bin anterior_cingulate_gyrus_50
#fslmaths $atlas -thr 18 -uthr 18 -bin superior_parietal_lobule_50
#fslmaths $atlas -thr 2 -uthr 2 -bin insular_cortex_50
#fslmaths left_accumbens -add right_accumbens seed-NAcc

