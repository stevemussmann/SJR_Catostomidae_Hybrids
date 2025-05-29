#!/bin/bash
#SBATCH --job-name=xtex_fastp
#SBATCH --partition condo
#SBATCH --qos condo
#SBATCH --constraint='labgroup&256gb'
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --exclusive
#SBATCH --time=240:00:00
#SBATCH -e %j.err
#SBATCH -o %j.out

module purge
source ~/miniconda3/etc/profile.d/conda.sh
conda activate fastp0234

STORAGE="/storage/username/dx_projects/dx2003"
RAW="$STORAGE/stacks/samples"
SCRATCH="/scratch/$SLURM_JOB_ID"
PROGRAM="fastp"

DIR="$SCRATCH/$PROGRAM/input"
LOG="$SCRATCH/$PROGRAM/logs"
mkdir -p $DIR
mkdir -p $LOG

rsync $RAW/*.fq.gz $DIR/.

cd $SCRATCH/$PROGRAM

for file in $DIR/*.fq.gz
do
	fn="$(basename -- $file)"
	fastp -i $file -o $SCRATCH/$PROGRAM/$fn --disable_quality_filtering --trim_poly_g \
		--trim_front1 8 --max_len1 120 --length_required 120 \
		--adapter_sequence=GATCGGAAGAGCGGTTCAGCAGGAATGCCGAGACCGATCTCGTATGCCGTCTTCTGCTTG \
		--adapter_sequence_r2=AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT
	cp fastp.html $LOG/${fn%.fq.gz}.html
	cp fastp.json $LOG/${fn%.fq.gz}.json
done

rm -r $DIR

mkdir -p $STORAGE/$PROGRAM
rsync -r $SCRATCH/$PROGRAM/ $STORAGE/$PROGRAM/.

exit
