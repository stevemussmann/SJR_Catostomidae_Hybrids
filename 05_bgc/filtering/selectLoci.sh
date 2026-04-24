#!/bin/bash
set -e

source ~/miniconda3/etc/profile.d/conda.sh
conda activate wgs
 
MAP="Clat_x_Xtex_map.txt"
VCF="populations.snps.vcf"
pop1="clat.txt"
pop2="xtex.txt"
out="clat_vs_xtex"
 
# grab reference individuals
grep Clat_pure $MAP | awk '{print $1}' > $pop1
grep Xtex_pure $MAP | awk '{print $1}' > $pop2

# run vcftools
vcftools --vcf $VCF --weir-fst-pop $pop1 --weir-fst-pop $pop2 --minDP 4 --thin 25000 --out $out

# get pairwise fst > 0.7 and drop individuals with -nan values
awk '$3 > 0.5 {print $0}' $out.weir.fst | grep -v "nan$" > list
awk '$3 > 0.5 {print $0}' $out.weir.fst | grep -v "nan$" | awk '{print $1"\t"$2}' > coordinates.txt

# filter for depth and overall missing data
vcftools --vcf $VCF --positions coordinates.txt --recode --recode-INFO-all --minDP 6 --thin 25000 --max-missing 0.2 --out filtered_snps

# get coordiantes from filtered file, and skip loci that did not map to chromosome-length scaffolds
grep -v "^#" filtered_snps.recode.vcf | grep -v "^NW" | shuf -n 2500 | awk '{print $1"\t"$2}' > kept_sites.txt

# get final vcf file
vcftools --vcf $VCF --positions kept_sites.txt --recode --recode-INFO-all --out final

exit
