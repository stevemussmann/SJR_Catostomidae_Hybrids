## Inputs
* `outliers.txt` = output from clineHelpR
* `rbs.chrom.map.txt` = map file used to convert GenBank accessions to the chromosome numbers used for display in plots
* `rbs.karyotype` = karyotype file used by RIdeogram package

## Scripts
* `ideogramTypes.pl` produces the coords.txt file used to display points (circles, triangles, boxes) on the ideogram. 
```
ideogramTypes.pl > coords.txt
```
* `ideogramAlpha.pl` extracts the alpha values for all outlier loci for depiction on the ideogram. 
```
ideogramAlpha.pl > alpha.txt
```
* `ideogramBeta.pl` extracts the beta values for all outlier loci for depiction on the ideogram. 
```
ideogramBeta.pl > beta.txt
```
* `ideogram.R` is used for visualizing outputs on an ideogram
