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
THRESH="0.5"
STORAGE="/storage/username/dx_projects/dx2003"
SCRATCH="/scratch/$SLURM_JOB_ID"
PROGRAM="populations_bgc_${THRESH}"
MAP="dx2003_bgc_map.txt"
WL="bgc_whitelist.txt"
PROC=16

# copy files into place
mkdir -p $SCRATCH/$PROGRAM/populations
rsync -r $STORAGE/stacks/stacks $SCRATCH/$PROGRAM/.
rsync $SLURM_SUBMIT_DIR/$MAP $SCRATCH/$PROGRAM/.
rsync $SLURM_SUBMIT_DIR/$WL $SCRATCH/$PROGRAM/.

cd $SCRATCH/$PROGRAM

populations -P $SCRATCH/$PROGRAM/stacks/ -M $SCRATCH/$PROGRAM/$MAP -O $SCRATCH/$PROGRAM/populations \
	-t $PROC --min-populations 3 --min-samples-per-pop ${THRESH} --min-maf 0.05 --write-single-snp \
	--vcf -W $WL

rm -r $SCRATCH/$PROGRAM/stacks

mkdir -p $STORAGE/$PROGRAM

rsync -r $SCRATCH/$PROGRAM/ $STORAGE/$PROGRAM/.

exit
