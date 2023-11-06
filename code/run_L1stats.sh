#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
basedir="$(dirname "$scriptdir")"
nruns=2
task=ugr # edit if necessary

for ppi in "ecn"; do # putting 0 first will indicate "activation" Put in "NAcc-bin" and "ecn" for PPI 

	for sub in `cat ${scriptdir}/newsubs.txt`; do 
	  for run in `seq $nruns`; do

			# some exceptionsc
			#if [ $sub -eq 1243 ] && [ $run -eq 1 ] && [ $ppi -eq "NAcc-bin" ]; # Different dimensions 
			#        #mask='NAcc-bin-1243'
			#	echo "separate mask ${mask} for sub-${sub} for task-${task}"
			#	continue
			#fi
		
			#if [ $sub -eq 1243 ] && [ $run == 1 ] && [ $ppi == "NAcc-bin" ]; then # bad data
		#		ppi="NAcc-1243-bin"
		#		#echo "Using different mask for -${sub} for task-${task} for run ${run}."
		#		#continue
		#	fi

	  	# Manages the number of jobs and cores
	  	SCRIPTNAME=${basedir}/code/L1stats.sh
	  	NCORES=15
	  	while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
	    		sleep 5s
	  	done
	  	bash $SCRIPTNAME $sub $run $ppi &
			sleep 1s
	  done
	done
done
