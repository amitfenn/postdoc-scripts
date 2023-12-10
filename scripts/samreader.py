#!/usr/bin/python3
#-*- coding : utf-8 -*-


#__authors__ = ("Ambre PETIT", "Laure NANNINI")
#__contact__ = ("ambre.petit@etu.umontpellier.fr","laure.nannini@etu.umontpellier.fr")
#__version__ = "1.0"
#__date__ = "12/5/2022"
#__licence__ ="This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation,\n either version 3 of the License, or (at your option) any later version. \nThis program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; \nwithout even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.\n You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>."


    ### OPTION LIST:
        ##-h or --help : help information
        ##-i or --input: input file (.sam)
        ##-o or --output: output name files (.txt)

    #Synopsis:
        ##SamReader.py -h or --help # Launch the help.
        ##SamReader.py -i or --input <file> # Launch SamReader to analyze a samtools file (.sam) and print the result in the terminal
        ##SamReader.py -i or --input <file> -o or --output <name> # Launch SamReader to analyze a samtools file (.sam) and print the result in the file called <name>
  


############### IMPORT MODULES ###############

import sys 
import re
import os
import pathlib


############### FUNCTIONS TO :

### 1/ Check the file


file_name = input("File's name : ")
emplacement = input("Indicate file's location : ")


# Verification of the file's extension, must be a .sam file
if pathlib.Path(file_name).suffix != ".sam" :
  print("Error, please enter a .sam file")
  exit()

# Verification that the file is really a file
if os.path.isdir(file_name) == 1 :
  print("Error, not a file")
  exit()

# Verification that the file is not empty
if os.path.getsize(emplacement+'/'+file_name) == 0: 
  print("Error, file is empty")
  exit()


### 2/ Read the file 
file = open(emplacement+'/'+file_name, 'r')

## Collect key
line=file.readline()



### 3/ Store into a dictionary 

dict={}
lines = file.readlines()[2:]   # Read file from line 2 to avoid the header
for line in lines :   # Read each line one by one
  key=line.split("\t")   # Creation of a list split with the tab separator
  if key[0] in dict.keys() :  # Test if the key already exist
    dict[key[0]].append(key[1:]) # If key already exist, create and add value
  else :
    dict[key[0]]=[key[1:]] # If key not already exist add value




### 4/ Close the file 
file.close()



### 5/ Analyse 

## Analyze the number of starting data

print("Total of starting reads is : ", len(dict)*2) # Count the number of lines in dictionary, multiplied by 2 because reads are paired in dictionary (We would have liked to check it)



## Analyse the mapping quality

# Ask user for threshold value : 
answer1=input("The threshold value is 20, would you change it ?\nIf yes enter y / If no enter n : ")

if answer1 in ["y","Y"] :
    quality=int(input(" Please enter your new value for mapping quality : "))
else : 
  if answer1 in ["n","N"] : 
    quality=20
  else : 
    print("Your answer is neither yes or no, so the mapping quality value stays at 20 ")
    quality=20

print("The value of the mapping quality is :", quality)


# Counting reads with mapping quality greater than the value
readMq = 0  # Counter initialization

for key in dict.keys():
  if int(dict[key][0][3]) >= quality:   # Comparison of the value of the mapping quality in dictionary with the desired value
    readMq += 1   # If condition are met, add 1 to the counter

print("Total of reads with the mapping quality greater than ", quality," is ",readMq*2)  # Return the number in the counter, multiplied by 2 because reads are paired in dictionary




## Analyse the CIGAR = regular expression that summarise each read alignment
# Counting reads which are matched 

readAligment = 0  # Counter initialization

for key in dict.keys() :
  sequence=len(dict[key][0][8])  # Counting nucleotides in sequence in each read
  if ((dict[key][0][4]) == (str(sequence)+"M")):  # Comparison of the value of the CIGAR with the sequence's number 
     readAligment += 1   # If CIGAR correspond to number of sequence + M, add 1 to the counter

print("Total of reads correctly aligned is :",readAligment*2) # Return the number in the counter, multiplied by 2 because reads are paired in dictionary




## Analyse un/mapped reads

readMapped = 0  # Counter initialization
f4 = 4   # FLAG number = 4 

dict_mappes = {}   # Create a new dictionary only for mapped reads
for key,value in dict.items():  # Browse dictionary based on keys and values
  for v in value : 
    if int(v[0]) & f4 == f4 :    # Binary calculation to see if value contains 4 (FLAG corresponding to unmapped reads)
      readMapped += 1   # If FLAG's read contains 4, add 1 to the counter
    else : 
      dict_mappes[key] = value   # If read is mapped, add value to the dictionary 

print("Total of mapped reads is ", len(dict)*2 - readMapped, " so the number of unmapped reads is : ", readMapped)

answer2=input("Do you want to see the resume of mapped reads ? \nIf yes enter y / If no enter n : ")
if answer2 in ["y","Y"]: 
  print(key, dict_mappes)
elif answer2 in ["n","N"] :
  pass




## Analyse reads "proper mapped" = paired reads and mapped in proper pair with a sequence's size < 150 bp
# Paired reads = FLAG 1
# Proper pair = FLAG 2

readProperM = 0
f1 = 1
f2 = 2

dict_proper_mapped = {}   # Create a new dictionary only for proper mapped reads
for key,value in dict.items():
  for v in value :
    if int(v[0]) & f1 == f1:     # Binary calculation to see if value contains 1 (FLAG corresponding to paired reads)
      if int(v[0]) & f2 == f2:   # Binary calculation to see if value contains 2 (FLAG corresponding to proper pair)
        sequence=len(dict[key][0][8])   # Counting the sequence's size
        if sequence < 150 :       # Verify if sequence's size is under 150
          readProperM += 1            # If reads have all the conditions, add 1 to the counter
          dict_proper_mapped[key] = value    # If read proper mapped, add value to the dictionary 
print("Total of proper mapped reads is ", readProperM)

answer3=input("Do you want to see the resume of proper mapped reads ? \nIf yes enter y / If no enter n : ")
if answer3 in ["y","Y"]: 
  print(key, dict_proper_mapped)
elif answer3 in ["n","N"] :
  pass




## Save the summary of all values

answer4=input("Do you want to save all values in a .txt file ? \nIf yes enter y / If no enter n : ")
if answer4 in ["y","Y"]: 
	ResultFile = open('Results.txt', 'w')  # Create a new file named Results.txt in writting mode
	ResultFile.write("Total of starting reads is : " + str(len(dict)*2) + "\nThe value of the mapping quality is : "+ str(quality)+ "\nTotal of reads with the mapping quality greater than "+ str(quality)+" is : "+ str(readMq*2)+ "\nTotal of reads correctly aligned is : "+str(readAligment*2)+"\nTotal of mapped reads is : "+ str(len(dict)*2 - readMapped)+ " so the number of unmapped reads is : "+ str(readMapped)+ "\nTotal of proper mapped reads is : "+ str(readProperM)) # Writte into the file our results
	ResultFile.close()  # Close the file 
elif answer4 in ["n","N"] :
	pass
