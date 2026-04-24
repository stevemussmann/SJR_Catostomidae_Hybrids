## Dependencies
* dos2unix program (makes sure outputs from R have unix line breaks); alternatively run `sed -i 's/\r//g' $FILE` on any text files output from R

## Inputs
* `rbs.chrom.map.txt` = map file used to convert GenBank accessions to the chromosome numbers used for display in plots
* `rbs.karyotype` = karyotype file used by RIdeogram package

## Scripts
* run `parseDataForIdeogram.sh` for the output of each BGC run. This will execute the following scripts:
    * `ideogramTypes_new.pl` produces the coords.txt file used to display points (circles, triangles, boxes) on the ideogram. 
    * `ideogramTypes_all.pl` like `ideogramTypes_new.pl` except it also outputs neutral loci
    * `ideogramAlpha.pl` extracts the alpha values for all outlier loci for depiction on the ideogram. 
    * `ideogramBeta.pl` extracts the beta values for all outlier loci for depiction on the ideogram. 

* Code in each of the ideogram R files is used for visualizing outputs on an ideogram:
    * `ideogram_lowerCI.R`
    * `ideogram_mean.R`
    * `ideogram_upperCI.R`
