#!/bin/bash
set -e

source ~/miniconda3/etc/profile.d/conda.sh
conda activate entropy

# specify input file
IN="Cdis_x_Clat.vcf"
OUT="${IN%.vcf}.pl.vcf"
MPGL="${OUT%.vcf}.mpgl"

# check if mpgl conversion R script is present; exit if not
if [ ! -f "inputdataformat.R" ]
then
	echo "inputdataformat.R script is not present"
	exit 1
fi

# make output location for entropy and log files
if [ ! -d "outfiles" ]
then
	mkdir outfiles
fi

if [ ! -d "logfiles" ]
then
	mkdir logfiles
fi

# remove loci with >20% missing data and write to temporary file
echo "Running bcftools..."
echo ""
bcftools filter -i 'F_MISSING<0.2' $IN -Oz -o tmp.vcf

# convert genotype likelihoods to phred-scaled likelihoods
bcftools +tag2tag tmp.vcf -- --GL-to-PL > $OUT
rm tmp.vcf # cleanup intermediate file

## get number of individuals in vcf and write ploidy file
COUNT=$((`grep "^#CHROM" $OUT | awk '{print NF}'`-9)) # count individuals

# test if ploidy file exists and remove if it does
if [ -f ploidy_inds.txt ]
then
	rm ploidy_inds.txt
fi

# add ploidy record for each individual to ploidy_inds.txt
for i in `seq $COUNT`
do 
	echo "2" >> ploidy_inds.txt
done

# convert data to mpgl format
echo "Converting to mpgl format..."
echo ""
./inputdataformat.R $OUT > logfiles/mpglConversion.log 2>&1

# make list of names from mpgl file - used later for plotting in R
if [ -f ${MPGL%.mpgl}.names.txt ]
then
	rm ${MPGL%.mpgl}.names.txt
fi

for line in `head -2 $MPGL | tail -1`
do 
	echo $line >> ${MPGL%.mpgl}.names.txt
done

## run entropy
# remove commands file if already exists
COMS="entropyCommands.txt"
if [ -f $COMS ]
then
	rm $COMS
fi

# prepare 3 chains and write to commpands file
for i in `seq 3`
do
	# switch to '-l 100000 -b 80000 -t 10' for full run
	echo "entropy -i $MPGL -Q 1 -m 1 -n 2 -k 2 -q qk2inds.txt -l 100000 -b 80000 -t 10 -r $RANDOM -o outfiles/mcmcoutchain${i}.hdf5 > logfiles/mcmcoutchain${i}.log 2>&1" >> $COMS
done

# run in parallel
echo "Running entropy..."
echo ""
cat $COMS | parallel

# run estpost
estpost.entropy -p gprob -s 0 outfiles/mcmcoutchain1.hdf5 outfiles/mcmcoutchain2.hdf5 outfiles/mcmcoutchain3.hdf5 -o ${MPGL%.pl.mpgl}.genoest.txt
estpost.entropy -p q -s 0 outfiles/mcmcoutchain1.hdf5 outfiles/mcmcoutchain2.hdf5 outfiles/mcmcoutchain3.hdf5 -o ${MPGL%.pl.mpgl}.admixest.txt
estpost.entropy -p Q -s 0 outfiles/mcmcoutchain1.hdf5 outfiles/mcmcoutchain2.hdf5 outfiles/mcmcoutchain3.hdf5 -o ${MPGL%.pl.mpgl}.Q12.txt

exit
