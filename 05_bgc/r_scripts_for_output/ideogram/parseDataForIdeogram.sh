#!/bin/bash

dos2unix dx2003_mean.txt

./ideogramTypes_new.pl > coords_mean.txt
./ideogramTypes_all.pl > coords_mean_all.txt
./ideogramAlpha.pl > alpha_mean.txt
./ideogramBeta.pl > beta_mean.txt


exit
