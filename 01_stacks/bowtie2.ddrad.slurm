#!/bin/bash
#SBATCH --job-name=xtex_bowtie2_ddrad
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
conda activate bowtie245

PROC=16

STORAGE="/storage/username/dx_projects/dx2003"
SCRATCH="/scratch/$SLURM_JOB_ID"
PROGRAM="bowtie2"

FASTA="GCF_025860055.1_RBS_HiC_50CHRs_genomic.fna"
DB="xtex"

GENOME="/storage/username/genomes/Xyrauchen_texanus/GCF_025860055.1_RBS_HiC_50CHRs/$FASTA.gz"
RAW="$STORAGE/process_radtags_2"

mkdir -p $SCRATCH/$PROGRAM

rsync $RAW/*.fq.gz $SCRATCH/$PROGRAM/.
rsync $GENOME $SCRATCH/$PROGRAM/.

cd $SCRATCH/$PROGRAM

gunzip "$FASTA.gz"

#index the genome
bowtie2-build --threads $PROC $FASTA $DB

#align reads
for file in *.fq.gz
do
	read1=$file

	sam="$(basename -- $read1)"
	sam=${sam%.fq.gz}.sam

	bowtie2 -p $PROC -x $DB --very-sensitive -U $read1 -S $sam

	conda deactivate
	conda activate samtools1151

	rm $read1
	
	samtools view -bS $sam > ${sam%.sam}_unsorted.bam
	rm $sam

	samtools sort -@ $PROC -o ${sam%.sam}.bam ${sam%.sam}_unsorted.bam
	rm ${sam%.sam}_unsorted.bam

	conda deactivate
	conda activate bowtie245
done

rm $SCRATCH/$PROGRAM/$FASTA

mkdir -p $STORAGE/$PROGRAM
rsync -r $SCRATCH/$PROGRAM/ $STORAGE/$PROGRAM/.

exit

