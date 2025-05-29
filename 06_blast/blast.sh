#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate blast

DB="sequence.fasta"
FASTA="dx2003_coi.fa"

makeblastdb -in $DB -dbtype nucl

blastn -query $FASTA -db $DB -out dx2003_blastn_results.txt -outfmt 6 \
	-evalue 0.0001 -num_threads 8 -max_target_seqs 1

./addSpecies.pl -m genbank_species_map.txt -f dx2003_blastn_results.txt

awk '{print $1"\t"$13}' blast.species.out.txt > results.txt

exit
