## Step 1
Run populations module of Stacks to get loci that are present among individuals used as reference data
* Samples are in dx2003_bgc_parental_map.txt
* Command for populations is in populations.bgc.parental_map.slurm

## Step 2
Run vcf2bgc.py to convert file to do initial conversion to format for bgc
* Command is in the vcf2bgc.sh script

## Step 3
Find loci that represent fixed differences between Clat and Xtex
* run the locids.sh script.
* this script runs the findFixed.pl script on the resulting bgc input files to find loci that represent fixed differences between Clat and Xtex in your reference data.
* This file sums the two columns associated with each locus in the p0in.txt and p1in.txt files. These columns correspond to the number of times each allele of each locus was sequenced for each individual.
* The output will be a list of Stacks locus identifiers. Capture this in a text file:
* ./locids.sh > whitelist.txt

Step 4
* Run stacks populations module again to get whitelisted loci in all samples for bgc input.
