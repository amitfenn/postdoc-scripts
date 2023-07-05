#!/bin/bash
set -euo pipefail

if [[ $(head $1  -n1 | cut -d ',' -f1) = filename ]]
 then 
    #WIMP
    for i in $(cut -d ',' -f 6  $1 | tail -n $(let a=$(cat $1 | wc -l)-1; echo $a))
        do echo $i| /home/amitfenn/miniconda3/envs/taxkit/bin/taxonkit reformat -I 1 -F -f "{k};{p};{c};{o};{f};{g}";
    #-f, --format string                  output format, placeholders of rank are needed (default "{k};{p};{c};{o};{f};{g};{s}")
    done
 elif [[ $(head $1  -n1 | cut -d ',' -f1) = tax_id ]]
 then 
    #CZID
    for i in $(cut -d ',' -f 4  $1 | tail -n $(let a=$(cat $1 | wc -l)-1; echo $a))
        do echo $i | taxonkit name2taxid | cut -f 2| taxonkit reformat -I 1 -F -f "{k};{p};{c};{o};{f};{g}";
    #-f, --format string                  output format, placeholders of rank are needed (default "{k};{p};{c};{o};{f};{g};{s}")
    done
 else
    #kraken
    file=$(mktemp)
    taxpasta standardise -p kraken2 -o $file  --output-format TSV $1
    for i in $(cut -f 1  $file | tail -n $(let a=$(cat $file | wc -l)-1; echo $a))
        do echo $i| /home/amitfenn/miniconda3/envs/taxkit/bin/taxonkit reformat -I 1 -F -f "{k};{p};{c};{o};{f};{g}";
        #-f, --format string                  output format, placeholders of rank are needed (default "{k};{p};{c};{o};{f};{g};{s}")
        done
fi

