## Step 1
Run populations module of Stacks to get loci that are present among individuals used as reference data
* Samples are in `dx2003_bgc_parental_map.txt`
* Command for populations is in `populations.bgc.parental_map.slurm`. [See Stacks folder for populations command and whitelist file](https://github.com/stevemussmann/SJR_Catostomidae_Hybrids/tree/main/01_stacks).

## Step 2
Run `vcf2bgc.py` to convert file to do initial conversion to format for bgc
* Command is in the `vcf2bgc.sh` script

## Step 3
Find loci that represent fixed differences between Clat and Xtex
* run the `locids.sh` script.
* this script runs the findFixed.pl script on the resulting bgc input files to find loci that represent fixed differences between Clat and Xtex in your reference data.
* This file sums the two columns associated with each locus in the p0in.txt and p1in.txt files. These columns correspond to the number of times each allele of each locus was sequenced for each individual.
* The output will be a list of Stacks locus identifiers. Capture this in a text file:
* `./locids.sh > whitelist.txt`

## Step 4
* Run stacks populations module again to get whitelisted loci in all samples for bgc input. [See Stacks folder for populations command and whitelist file](https://github.com/stevemussmann/SJR_Catostomidae_Hybrids/tree/main/01_stacks).
* Rerun the `vcf2bgc.sh` script to produce the final input for bgc. 


<hr>

## NOTES
* The `vcf2bgc.py` script included here is a modified version of the original script packaged with the [ClineHelpR](https://github.com/btmartin721/ClineHelpR) R package. It includes a `-c` / `--cm` option to allow the user to specify the frequency of genetic recombination in cM/Mb. This information is used by the linkage model in bgc. Previously the script expressed distance between loci as a proportion of the length of the chromosome on which the loci were found. 
