#!/bin/bash
#SBATCH --job-name=xtex_populations
#SBATCH --partition condo
#SBATCH --qos condo
#SBATCH --constraint='labgroup&256gb'
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --exclusive
#SBATCH --time=12:00:00
#SBATCH -e %j.err
#SBATCH -o %j.out

module purge
source ~/miniconda3/etc/profile.d/conda.sh
conda activate stacks264

STORAGE="/storage/username/dx_projects/dx2003"
SCRATCH="/scratch/$SLURM_JOB_ID"
PROGRAM="populations"
MAP="dx2003_map.txt"
PROC=16

# copy files into place
mkdir -p $SCRATCH/$PROGRAM/populations
rsync -r $STORAGE/stacks/stacks $SCRATCH/$PROGRAM/.
rsync $SLURM_SUBMIT_DIR/$MAP $SCRATCH/$PROGRAM/.

cd $SCRATCH/$PROGRAM

#populations -P $SCRATCH/$PROGRAM/stacks/ -M $SCRATCH/$PROGRAM/$MAP -O $SCRATCH/$PROGRAM/populations \
#	-t $PROC --min-populations 12 --min-samples-per-pop 0.5 --min-maf 0.01 --write-single-snp \
#	--vcf --genepop --structure --plink --phylip-var

populations -P $SCRATCH/$PROGRAM/stacks/ -M $SCRATCH/$PROGRAM/$MAP -O $SCRATCH/$PROGRAM/populations \
	-t $PROC --min-samples-overall 0.5 --min-maf 0.01 --write-single-snp \
	--vcf --genepop --structure --plink --phylip-var

rm -r $SCRATCH/$PROGRAM/stacks

mkdir -p $STORAGE/$PROGRAM

rsync -r $SCRATCH/$PROGRAM/ $STORAGE/$PROGRAM/.

exit
