#!/bin/bash
#  made for my localmachine
# This is for WIMP only extracts taxID column and prints out reformatted lineage code.

for i in $(cut -d ',' -f 6  $1 | tail -n $(let a=$(cat $1 | wc -l)-1; echo $a))
    do echo $i| /home/amitfenn/miniconda3/envs/taxkit/bin/taxonkit reformat -I 1 -F -f "{k};{p};{c};{o};{f};{g}";
    #-f, --format string                  output format, placeholders of rank are needed (default "{k};{p};{c};{o};{f};{g};{s}")
done