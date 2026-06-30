#!/bin/bash

## script for pulling two species from master vcf file

SPEC1="Cdis"
SPEC2="Clat"
PREFIX="${SPEC1}_x_${SPEC2}.filt2"
VCF="populations.snps.recode.vcf" # file produced by admixpipe pipeline
VCFRED="${SPEC1}_x_${SPEC2}.vcf"
MAP="${SPEC1}_x_${SPEC2}_map.txt"

BCFLIST="sampleList.txt"

# pull sample names out of sample map
awk '{print $1}' $MAP > $BCFLIST

# pull relevant samples from vcf file
bcftools view -S $BCFLIST -o $VCFRED $VCF 

exit
