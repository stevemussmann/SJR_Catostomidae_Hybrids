Dependencies:
* vcftools
* clineHelpR: https://github.com/stevemussmann/ClineHelpR

Order of operations:
* run the `selectLoci.sh` script.
* run the `vcf2bgc.sh` script. This script was rerun with the following values of the `-c` option to test different recombination rates in BGC:
    * lower = 0.558
    * mean = 1.481
    * upper = 2.404

Notes:
* The `kept_sites.txt` file in this directory contains the actual list of loci we used for analysis in our study (a product of the `selectLoci.sh` script).