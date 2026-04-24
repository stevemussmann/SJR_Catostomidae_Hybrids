#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate clinehelpr

VCF="final.recode.vcf"
#MAP="dx2003_bgc_parental_map.txt"
MAP="dx2003_bgc_map.txt"

./vcf2bgc.py -v $VCF -m $MAP --p1 Clat --p2 Xtex --admixed Admix -o dx2003 -l -c 1.481

exit
