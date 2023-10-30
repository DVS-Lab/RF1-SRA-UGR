#!/bin/bash

# This run_* script is a wrapper for L3stats.sh, so it will loop over several
# copes and models. Note that Contrast N for PPI is always PHYS in these models.


# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"


# Change the type of analysis in the " " marks.

for analysis in "ppi_seed-NAcc-bin"; do # "ppi_seed-IFG_extracted" act ppi_seed-NAcc-bin nppi-dmn nppi-ecn ppi_seed-IFG_extracted
	

# Define the contrast value and the name you would like in the output. 

analysistype=${analysis}
		for copeinfo in "7 cue_social_nonsocial" "8 cue_social_h_l" "9 cue_nonsocial_h_l" "10 cue_h_l" "11 choice_social_nonsocial" "12 phys"; do # "17 PHYS" 
		
		#"7 cue_social_nonsocial" "8 cue_social_h_l" "9 cue_nonsocial_h_l" "10 cue_h_l" "11 choice_social_nonsocial"
		#"7 choice_social_pmod" "8 choice_nonsocial_pmod" "9 cue_social_nonsocial" "10 cue_h_l" "11 cue_social_h_l" "12 cue_nonsocial_h_l" "13 choice_social_nonsocial" "14 choice_social_nonsocial_pmod" "15 phys"

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
