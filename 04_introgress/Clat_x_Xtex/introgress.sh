#!/bin/bash

SPEC1="Cdis"
SPEC2="Xtex"
PREFIX="${SPEC1}_x_${SPEC2}.filt2"
VCF="populations.snps.recode.vcf"
VCFRED="${SPEC1}_x_${SPEC2}.vcf"
SNPS="${PREFIX}.min4.phy"
MAP="${SPEC1}_x_${SPEC2}_map.txt"

BCFLIST="sampleList.txt"

F="${SPEC1}_pure"
S="${SPEC2}_pure"

# make string of non-hybrid sample groups
STR=`awk '{print $2}' $MAP | sort | uniq | grep -v _pure`
H=`for item in $STR; do echo -ne $item; echo -ne "+"; done;`

# pull sample names out of sample map
awk '{print $1}' $MAP > $BCFLIST

# pull relevant samples from vcf file
bcftools view -S $BCFLIST -o $VCFRED $VCF 

# convert to phylip
vcf2phylip.py -i $VCFRED --output-prefix $PREFIX

# find fixed SNPs
fixedSNP.pl -p $MAP -1 $F -2 $S -i $SNPS
phylip2introgress.pl -p $MAP -1 $F -2 $S -a ${H%+} -i out.phy
introgress.R | tee "${SPEC1}_x_${SPEC2}.log"
mv tri_plot.pdf "${SPEC1}_x_${SPEC2}.pdf"

exit
