

datadir=/data/projects/istart-data

scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

lefteye_mask='/data/projects/istart-ugdg/masks/eyeball_left.nii.gz'
righteye_mask='/data/projects/istart-ugdg/masks/eyeball_right.nii.gz'

for sub in `cat ${scriptdir}/newsubs.txt`; do
    for run in 1 2; do

	DATA=${datadir}/derivatives/fmriprep/sub-${sub}/func/sub-${sub}_task-ugdg_run-${run}_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz

	lefteye_out=/data/projects/istart-ugdg/derivatives/fsl/EVfiles/sub-${sub}/ugdg_GLM2_d/run-0${run}_LeftEye_eig.txt
	righteye_out=/data/projects/istart-ugdg/derivatives/fsl/EVfiles/sub-${sub}/ugdg_GLM2_d/run-0${run}_RightEye_eig.txt
        

	fslmeants -i $DATA -o ${lefteye_out} -m ${lefteye_mask} --eig
	fslmeants -i $DATA -o ${righteye_out} -m ${righteye_mask}  --eig
    done
done

