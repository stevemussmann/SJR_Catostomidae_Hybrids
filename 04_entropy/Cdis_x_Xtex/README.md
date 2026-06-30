# Bluehead Sucker x Razorback Sucker entropy

Requirements:
1. conda environment with `entropy` and `bcftools` installed. Also requires the `inputdataformat.R` script packaged with `entropy` to be placed in the folder where the `entropy.sh` script is executed.

1. Run `twospecies.sh` which uses the `Cdis_x_Xtex_map.txt` file to pull only these two species from the filtered VCF file produced during running admixpipe

2. run `entropy.sh` to run the remainder of the filtering and execute `entropy`. 
