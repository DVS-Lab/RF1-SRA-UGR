
#!/bin/bash

for s in 

wc -l sub-*/ugr/run-0*_dec_accept_pmod.txt >> accept_pmod.csv       
wc -l sub-*/ugr/run-0*_dec_accept.txt >> accept.csv
wc -l sub-*/ugr/run-0*_dec_choice_pmod.txt >> choice_pmod.csv
wc -l sub-*/ugr/run-0*_dec_choice.txt >> choice.csv
wc -l sub-*/ugr/run-0*_dec_nonsocial_accept_pmod.txt >> nonsocial_accept_pmod.csv
wc -l sub-*/ugr/run-0*_dec_nonsocial_accept.txt >> nonsocial_accept.csv
wc -l sub-*/ugr/run-0*_dec_nonsocial_choice_pmod.txt >> nonsocial_choice_pmod.csv
wc -l sub-*/ugr/run-0*_dec_nonsocial_choice.txt >> nonsocial_choice.csv
wc -l sub-*/ugr/run-0*_dec_nonsocial_high_pmod.txt >> nonsocial_high_pmod.csv
wc -l sub-*/ugr/run-0*_dec_nonsocial_high.txt >> nonsocial_high.csv 
wc -l sub-*/ugr/run-0*_dec_nonsocial_low_pmod.txt  >> nonsocial_low_pmod.csv

wc -l sub-*/ugr/run-0*_dec_nonsocial_reject_pmod.txt  >> nonsocial_reject_pmod.csv
wc -l sub-*/ugr/run-0*_dec_nonsocial_reject.txt >> nonsocial_reject.csv
wc -l sub-*/ugr/run-0*_dec_reject_pmod.txt >> reject_pmod.csv
wc -l sub-*/ugr/run-0*_dec_reject.txt >> reject.csv
wc -l sub-*/ugr/run-0*_dec_social_accept_pmod.txt >> social_accept_pmod.csv  
wc -l sub-*/ugr/run-0*_dec_social_accept.txt >> social_accept.csv
wc -l sub-*/ugr/run-0*_dec_social_choice_pmod.txt >> social_choice_pmod.csv
wc -l sub-*/ugr/run-0*_dec_social_choice.txt >> social_choice.csv
wc -l sub-*/ugr/run-0*_dec_social_high_pmod.txt >> social_high_pmod.csv
wc -l sub-*/ugr/run-0*_dec_social_high.txt >> social_high.csv
wc -l sub-*/ugr/run-0*_dec_social_low_pmod.txt >> social_low_pmod.csv
wc -l sub-*/ugr/run-0*_dec_social_low.txt >> social_low.csv
wc -l sub-*/ugr/run-0*_dec_social_reject_low_pmod.txt >> social_reject_low_pmod.csv
wc -l sub-*/ugr/run-0*_dec_social_reject_pmod.txt >> social_reject_pmod.csv
wc -l sub-*/ugr/run-0*_dec_social_reject.txt >> social_reject.csv
wc -l sub-*/ugr/run-0*_dec_nonsocial_low.txt >> nonsocial_low.csv

wc -l sub-*/ugr/run-0*_dec_social_accept_high.txt >> social_accept_high.csv
wc -l sub-*/ugr/run-0*_dec_social_accept_low.txt >> social_accept_low.csv
wc -l sub-*/ugr/run-0*_dec_nonsocial_accept_high.txt >> nonsocial_accept_high.csv
wc -l sub-*/ugr/run-0*_dec_nonsocial_accept_low.txt >> nonsocial_accept_low.csv

wc -l sub-*/ugr/run-0*_dec_social_reject_high.txt >> social_reject_high.csv
wc -l sub-*/ugr/run-0*_dec_social_reject_low.txt >> social_reject_low.csv
wc -l sub-*/ugr/run-0*_dec_nonsocial_reject_high.txt >> nonsocial_reject_high.csv
wc -l sub-*/ugr/run-0*_dec_nonsocial_reject_low.txt >> nonsocial_reject_low.csv

wc -l sub-*/ugr/run-0*_cue_social_low.txt >> cue_nonsocial_low.csv
wc -l sub-*/ugr/run-0*_cue_social_high.txt >> cue_nonsocial_high.csv
wc -l sub-*/ugr/run-0*_cue_social_low.txt >> cue_social_low.csv
wc -l sub-*/ugr/run-0*_cue_social_high.txt >> cue_social_high.csv
wc -l sub-*/ugr/run-0*_cue_nonsocial.txt >> cue_nonsocial.csv
wc -l sub-*/ugr/run-0*_cue_social.txt >> cue_social.csv



