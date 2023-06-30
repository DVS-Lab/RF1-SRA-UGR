#!/bin/bash

File="output.txt"
Lines=$(cat $File)
for Line in $Lines
do

echo "$Line"
done
