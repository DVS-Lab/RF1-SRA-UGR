#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
basedir="$(dirname "$scriptdir")"
nruns=2
task=ugr # edit if necessary


	for sub in `cat ${scriptdir}/newsubs.txt`; do 
	  for run in `seq $nruns`; do
	  
	  	wc -l sub-*/ugr/*dec_accept_pmod.txt
	  
	   
		wc -l sub-*/ugr/run-0*_dec_accept_pmod.txt >> accept_pmod.csv       
		wc -l sub-*/ugr/run-0*_dec_nonsocial_accept_pmod.txt >> nonsocial_accept_pmod.csv
		wc -l sub-*/ugr/run-0*_dec_nonsocial_choice_pmod.txt >> nonsocial_choice_pmod.csv
		wc -l sub-*/ugr/run-0*_dec_nonsocial_reject_pmod.txt  >> nonsocial_reject_pmod.csv
		wc -l sub-*/ugr/run-0*_dec_reject_pmod.txt >> reject_pmod.csv
		wc -l sub-*/ugr/run-0*_dec_social_accept_pmod.txt >> social_accept_pmod.csv  
		wc -l sub-*/ugr/run-0*_dec_social_reject_pmod.txt >> social_reject_pmod.csv
	  	bash $SCRIPTNAME $sub $run $ppi 
		
	  done
	done

