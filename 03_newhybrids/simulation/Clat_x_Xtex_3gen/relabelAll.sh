#!/bin/bash

MAP="Clat_x_Xtex.newhybridsmap.txt"
GEN="ThreeGensGtypFreq.txt"

for file in run*/aa-PofZ.txt
do
	echo $file
	dir=$(dirname "$file")
	./relabelPofZ.pl -m $MAP -n $GEN -p $file -o "${dir}/aa-PofZ.relabeled.txt"
done

./compareNewhybrids.pl

paste class.txt prob.txt | awk '{$6=""; print}' > allResults.txt

exit
