#!/bin/bash

rm cp_files.txt
touch cp_files.txt

rm -r sub-*/ugr/run-0*_cue_*


for sub in `cat /data/projects/rf1-sra-ugr/code/newsubs.txt`; do

	logsave -a cp_files.txt 

cp sub-$sub/ugr_endowment/run-01_cue_nonsocial_pmod.txt sub-$sub/ugr/ 
cp sub-$sub/ugr_endowment/run-02_cue_nonsocial_pmod.txt sub-$sub/ugr/ 

cp sub-$sub/ugr_endowment/run-01_cue_social_pmod.txt sub-$sub/ugr/  
cp sub-$sub/ugr_endowment/run-02_cue_social_pmod.txt sub-$sub/ugr/ 

cp sub-$sub/ugr_endowment/run-01_cue_nonsocial.txt sub-$sub/ugr/ 
cp sub-$sub/ugr_endowment/run-02_cue_nonsocial.txt sub-$sub/ugr/ 

cp sub-$sub/ugr_endowment/run-01_cue_social.txt sub-$sub/ugr/  
cp sub-$sub/ugr_endowment/run-02_cue_social.txt sub-$sub/ugr/ 

	
done



