#!/bin/bash

INFILE="output_genepop.gen"
OUTFILE="Clat_x_Xtex.simulated.3gen.newhybrids"

if [ ! -f "${INFILE}.bak"  ]
then
	cp $INFILE "${INFILE}.bak"
else
	cp "${INFILE}.bak" $INFILE
fi

HEADER=`head -1 $INFILE`

sed -i "s/$HEADER/Title:\"\"/g" $INFILE
sed -i 's/-/_/g' $INFILE
sed -i 's/pop/Pop/g' $INFILE
sed -i 's/, / ,  /g' $INFILE

./genepop2newhybrids.pl -m Clat_x_Xtex.map.txt -o $OUTFILE -g $INFILE -z Clat_pure -Z Xtex_pure > "${OUTFILE}.sampleOrder.txt"

sed -i 's/ ,  / /g' $OUTFILE
sed -i 's/NumLoci\t1/NumLoci\t200/g' $OUTFILE

exit
