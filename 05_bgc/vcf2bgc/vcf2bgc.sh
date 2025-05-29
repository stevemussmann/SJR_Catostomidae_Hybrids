#!/bin/bash

# conda activate clinehelpr

./vcf2bgc.py -v populations.snps.vcf -m dx2003_bgc_parental_map.txt --p1 Clat --p2 Xtex --admixed Admix -o dx2003 -l -c 1.481

exit
