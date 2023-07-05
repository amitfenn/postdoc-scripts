#!/bin/bash
#  made for my localmachine
# This is for CZID only extracts taxID column and prints out reformatted lineage code.
file=$(mktemp)
taxpasta standardise -p kraken2 -o $file $1
for i in $(cut -f 1  $file | tail -n $(let a=$(cat $file | wc -l)-1; echo $a))
    do echo $i| /home/amitfenn/miniconda3/envs/taxkit/bin/taxonkit reformat -I 1 -F -f "{k};{p};{c};{o};{f};{g}";
    #-f, --format string                  output format, placeholders of rank are needed (default "{k};{p};{c};{o};{f};{g};{s}")
done

## current challenge, parsing this csv is not as straightforward. It requires that I am able to parse the csv for structures like:
#100.00  1       0       R       1       root
#100.00  1       0       R1      131567    cellular organisms
#100.00  1       0       D       2           Bacteria

## consider taxpasta for the task.
# taxpasta standardise -p kraken2 -o test.tsv barcode05_porechop-x-40-polishing-x-filtered_contigs.kreport.txt   ─╯

