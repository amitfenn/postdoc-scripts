#!/bin/bash
#  made for my localmachine
# This is for CZID only extracts name column and prints out reformatted lineage code.

for i in $(cut -d ',' -f 4  $1 | tail -n $(let a=$(cat $1 | wc -l)-1; echo $a))
    do echo $i | taxonkit name2taxid | cut -f 2| taxonkit reformat -I 1 -F -f "{k};{p};{c};{o};{f};{g}";
    #-f, --format string                  output format, placeholders of rank are needed (default "{k};{p};{c};{o};{f};{g};{s}")
done

## current challenge, parsing this csv is not as straightforward. It requires that I am able to parse the csv for structures like  ,"[ , ]".
## consider python script for the task.
#tax_id,tax_level,genus_tax_id,name,common_name,category,is_phage,nt_bpm,nt_base_count,nt_count,nt_contigs,nt_contig_b,nt_percent_identity,nt_alignment_length,nt_e_value,nr_bpm,nr_base_count,nr_count,nr_contigs,nr_contig_b,nr_percent_identity,nr_alignment_length,nr_e_value,species_tax_ids,known_pathogen
#2803845,2,2803845,Usitatibacter,"",bacteria,false,18.8855,8595,2,,,85.4495,234.5,10^-91.4786,,,,,,,,,"[2732487, 2732067]",0
#2732487,1,2803845,Usitatibacter palustris,"",bacteria,false,5.25585,2392,1,,,81.026,390.0,10^-152.545,,,,,,,,,,0
#2732067,1,2803845,Usitatibacter rugosus,"",bacteria,false,13.6296,6203,1,,,89.873,79.0,10^-30.4117,,,,,,,,,,0
#2801844,2,2801844,Arachnia,"",bacteria,false,22.7812,10368,2,,,84.405,2404.0,10^-191.838,,,,,,,,,[1750],0
#1750,1,2801844,Pseudopropionibacterium propionicum,"",bacteria,false,22.7812,10368,2,,,84.405,2404.0,10^-191.838,,,,,,,,,,0


# head 1flye_shotgun_fahad_10-consensus_consensus_report_CZID.csv |tail -n 9 | cut -d',' -f4 | taxonkit name2taxid | cut -f 2| taxonkit reformat -F -I 1
