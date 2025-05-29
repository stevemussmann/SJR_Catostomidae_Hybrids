#!/bin/bash
#SBATCH --job-name=xtex_procrad
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
conda activate stacks264

STORAGE="/storage/username/dx_projects/dx2003"
RAW="$STORAGE/raw"
BAR="$STORAGE/barcodes"
SCRATCH="/scratch/$SLURM_JOB_ID"
PROGRAM="stacks"

DIR="${SCRATCH}/${PROGRAM}"

mkdir -p $DIR/raw
mkdir -p $DIR/barcodes
mkdir -p $DIR/samples
mkdir -p $DIR/logs

rsync $RAW/*.fastq.gz $DIR/raw
rsync $BAR/*.txt $DIR/barcodes

cd $DIR

rm $DIR/raw/*_R2_*.fastq.gz
gunzip -v $DIR/raw/*.fastq.gz

process_radtags -f $DIR/raw/idx1_S1_R1_001.fastq -b $DIR/barcodes/idx1.txt -o $DIR/samples \
	-i fastq -y fastq -r --disable-rad-check
cp $DIR/samples/process_radtags.raw.log $DIR/logs/process_radtags.idx1.log

process_radtags -f $DIR/raw/idx2_S2_R1_001.fastq -b $DIR/barcodes/idx2.txt -o $DIR/samples \
	-i fastq -y fastq -r --disable-rad-check
cp $DIR/samples/process_radtags.raw.log $DIR/logs/process_radtags.idx2.log

process_radtags -f $DIR/raw/idx3_S3_R1_001.fastq -b $DIR/barcodes/idx3.txt -o $DIR/samples \
	-i fastq -y fastq -r --disable-rad-check
cp $DIR/samples/process_radtags.raw.log $DIR/logs/process_radtags.idx3.log

process_radtags -f $DIR/raw/idx4_S4_R1_001.fastq -b $DIR/barcodes/idx4.txt -o $DIR/samples \
	-i fastq -y fastq -r --disable-rad-check
cp $DIR/samples/process_radtags.raw.log $DIR/logs/process_radtags.idx4.log

process_radtags -f $DIR/raw/idx5_S5_R1_001.fastq -b $DIR/barcodes/idx5.txt -o $DIR/samples \
	-i fastq -y fastq -r --disable-rad-check
cp $DIR/samples/process_radtags.raw.log $DIR/logs/process_radtags.idx5.log

process_radtags -f $DIR/raw/idx6_S6_R1_001.fastq -b $DIR/barcodes/idx6.txt -o $DIR/samples \
	-i fastq -y fastq -r --disable-rad-check
cp $DIR/samples/process_radtags.raw.log $DIR/logs/process_radtags.idx6.log

process_radtags -f $DIR/raw/dx1701_Xtex20_pooled_ACAGTG_S4_R1_001.fastq \
	-b $DIR/barcodes/XtexW20SJR_idx5_ACAGTG.txt -o $DIR/samples -i fastq -y fastq -r \
	--disable-rad-check
cp $DIR/samples/process_radtags.raw.log $DIR/logs/process_radtags.idx1.log

process_radtags -f $DIR/raw/dx1701_Xtex20_pooled_TGACCA_S3_R1_001.fastq \
	-b $DIR/barcodes/XtexW20SJR_idx4_TGACCA.txt -o $DIR/samples -i fastq -y fastq -r \
	--disable-rad-check
cp $DIR/samples/process_radtags.raw.log $DIR/logs/process_radtags.XtexW20SJR_idx4.log

process_radtags -f $DIR/raw/dx1701_Xtex20_pooled_TTAGGC_S2_R1_001.fastq \
	-b $DIR/barcodes/XtexW20SJR_idx3_TTAGGC.txt -o $DIR/samples -i fastq -y fastq -r \
	--disable-rad-check
cp $DIR/samples/process_radtags.raw.log $DIR/logs/process_radtags.XtexW20SJR_idx3.log

process_radtags -f $DIR/raw/dx1701_Xtex20_pooled_ATCACG_S1_R1_001.fastq \
	-b $DIR/barcodes/XtexW20SJR_idx1_ATCACG.txt -o $DIR/samples -i fastq -y fastq -r \
	--disable-rad-check
cp $DIR/samples/process_radtags.raw.log $DIR/logs/process_radtags.XtexW20SJR_idx1.log

process_radtags -f $DIR/raw/dx1701_Pluc20_Csp20_pooled_ACAGTG_S4_R1_001.fastq \
	-b $DIR/barcodes/CspW20_idx5_ACAGTG.txt -o $DIR/samples -i fastq -y fastq -r \
	--disable-rad-check
cp $DIR/samples/process_radtags.raw.log $DIR/logs/process_radtags.CspW20_idx5.log

## MSB juvenile samples demultiplexing
process_radtags -f $DIR/raw/msb_juv_pt1+2_idx1-ATCACG_S1_R1_001.fastq \
	-b $DIR/barcodes/msb_juv_pt1+2_idx1_ATCACG.txt \
	-o $DIR/samples -i fastq -y fastq -r \
	--disable-rad-check
cp $DIR/samples/process_radtags.raw.log $DIR/logs/process_radtags.msb_juv_pt1+2_idx1.log

process_radtags -f $DIR/raw/msb_juv_pt1+2_idx2-CGATGT_S2_R1_001.fastq \
	-b $DIR/barcodes/msb_juv_pt1+2_idx2_CGATGT.txt \
	-o $DIR/samples -i fastq -y fastq -r \
	--disable-rad-check
cp $DIR/samples/process_radtags.raw.log $DIR/logs/process_radtags.msb_juv_pt1+2_idx2.log

process_radtags -f $DIR/raw/msb_juv_pt1+2_idx3-TTAGGC_S3_R1_001.fastq \
	-b $DIR/barcodes/msb_juv_pt1+2_idx3_TTAGGC.txt \
	-o $DIR/samples -i fastq -y fastq -r \
	--disable-rad-check
cp $DIR/samples/process_radtags.raw.log $DIR/logs/process_radtags.msb_juv_pt1+2_idx3.log

process_radtags -f $DIR/raw/msb_juv_pt1+2_idx5-ACAGTG_S4_R1_001.fastq \
	-b $DIR/barcodes/msb_juv_pt1+2_idx5_ACAGTG.txt \
	-o $DIR/samples -i fastq -y fastq -r \
	--disable-rad-check
cp $DIR/samples/process_radtags.raw.log $DIR/logs/process_radtags.msb_juv_pt1+2_idx5.log

process_radtags -f $DIR/raw/dx2003_L1_S1_L001_R1_001.fastq -b $DIR/barcodes/dx2003_pt03_l01_ATCACG.txt -o $DIR/samples -i fastq -y fastq -r --disable-rad-check
cp $DIR/samples/process_radtags.raw.log $DIR/logs/process_radtags.dx2003_l1_idx1.log

process_radtags -f $DIR/raw/dx2003_L2_S2_L001_R1_001.fastq -b $DIR/barcodes/dx2003_pt03_l02_CGATGT.txt -o $DIR/samples -i fastq -y fastq -r --disable-rad-check
cp $DIR/samples/process_radtags.raw.log $DIR/logs/process_radtags.dx2003_l2_idx2.log

process_radtags -f $DIR/raw/dx2003_L3_S3_L001_R1_001.fastq -b $DIR/barcodes/dx2003_pt04_l03_TTAGGC.txt -o $DIR/samples -i fastq -y fastq -r --disable-rad-check
cp $DIR/samples/process_radtags.raw.log $DIR/logs/process_radtags.dx2003_l3_idx3.log

process_radtags -f $DIR/raw/dx2003_L4_S4_L001_R1_001.fastq -b $DIR/barcodes/dx2003_pt04_l04_TGACCA.txt -o $DIR/samples -i fastq -y fastq -r --disable-rad-check
cp $DIR/samples/process_radtags.raw.log $DIR/logs/process_radtags.dx2003_l4_idx4.log

process_radtags -f $DIR/raw/dx2003_L5_S5_L001_R1_001.fastq -b $DIR/barcodes/dx2003_pt05_l05_ACAGTG.txt -o $DIR/samples -i fastq -y fastq -r --disable-rad-check
cp $DIR/samples/process_radtags.raw.log $DIR/logs/process_radtags.dx2003_l5_idx5.log

process_radtags -f $DIR/raw/dx2003_L6_S6_L001_R1_001.fastq -b $DIR/barcodes/dx2003_pt05_l06_GCCAAT.txt -o $DIR/samples -i fastq -y fastq -r --disable-rad-check
cp $DIR/samples/process_radtags.raw.log $DIR/logs/process_radtags.dx2003_l6_idx6.log

process_radtags -f $DIR/raw/dx2003_L7_S7_L001_R1_001.fastq -b $DIR/barcodes/dx2003_pt06_l07_CAGATC.txt -o $DIR/samples -i fastq -y fastq -r --disable-rad-check
cp $DIR/samples/process_radtags.raw.log $DIR/logs/process_radtags.dx2003_l7_idx7.log

process_radtags -f $DIR/raw/dx2003_L8_S8_L001_R1_001.fastq -b $DIR/barcodes/dx2003_pt06_l08_ACTTGA.txt -o $DIR/samples -i fastq -y fastq -r --disable-rad-check
cp $DIR/samples/process_radtags.raw.log $DIR/logs/process_radtags.dx2003_l8_idx8.log

process_radtags -f $DIR/raw/dx2003_L9_S9_L001_R1_001.fastq -b $DIR/barcodes/dx2003_pt07_l09_GATCAG.txt -o $DIR/samples -i fastq -y fastq -r --disable-rad-check
cp $DIR/samples/process_radtags.raw.log $DIR/logs/process_radtags.dx2003_l9_idx9.log

process_radtags -f $DIR/raw/dx2003_L10_S10_L001_R1_001.fastq -b $DIR/barcodes/dx2003_pt07_l10_TAGCTT.txt -o $DIR/samples -i fastq -y fastq -r --disable-rad-check
cp $DIR/samples/process_radtags.raw.log $DIR/logs/process_radtags.dx2003_l10_idx10.log

rm $DIR/raw/*.fastq
gzip $DIR/samples/*.fq

mkdir -p $STORAGE/$PROGRAM
rsync -r $SCRATCH/$PROGRAM/ $STORAGE/$PROGRAM/.

exit
