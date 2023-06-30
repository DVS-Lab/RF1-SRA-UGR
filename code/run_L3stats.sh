#!/bin/bash

# This run_* script is a wrapper for L3stats.sh, so it will loop over several
# copes and models. Note that Contrast N for PPI is always PHYS in these models.


# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"


# Change the type of analysis in the " " marks.

for analysis in "act"; do # "ppi_seed-IFG_extracted" act ppi_seed-NAcc-bin nppi-dmn nppi-ecn ppi_seed-IFG_extracted
	

# Define the contrast value and the name you would like in the output. 

analysistype=${analysis}
		for copeinfo in "7 social_pmod" "8 nonsocial_pmod" "9 cue_social_nonsocial_h" "10 cue_social_nonsocial_l" "11 choice_social_nonsocial" "12 choice_social_nonsocial_pmod" "13 cue_social_nonsocial" "14 cue_h_l"; do # "17 PHYS" "18 l_eye" "19 r_eye" "20 l_r_eye"; do
			

# split copeinfo variable
		set -- $copeinfo
		copenum=$1
		copename=$2

		NCORES=12
		SCRIPTNAME=${maindir}/code/L3stats.sh
		while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
			sleep 1s
		done
		bash $SCRIPTNAME $copenum $copename $analysistype &

	done
done
