#!/bin/bash

MAP="dx2003_map.txt"
SNP="populations.snps.vcf"

admixturePipeline.py -m $MAP -v $SNP -k 3 -K 5 -n 20 -t 25000

submitClumpak.py -p populations.snps -M

distructRerun.py -a ./ -d clumpakOutput/ -k 3 -K 5 -w 0.7 -s

cd clumpakOutput/best_results

distruct -d drawparams.3

ps2pdf K3.ps

exit
