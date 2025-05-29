#!/bin/bash

for line in `./findFixed.pl`
do 
	q=`echo -ne "$line" | sed 's/.1_/.1\t/g'`
	#echo $q
	grep "$q" populations.snps.vcf | awk '{print $3}' | awk -F":" '{print $1}'
done

exit
