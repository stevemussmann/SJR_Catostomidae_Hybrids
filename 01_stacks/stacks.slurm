#!/bin/bash
#SBATCH --job-name=xtex_stacks
#SBATCH --partition condo
#SBATCH --constraint='labgroup&256gb'
#SBATCH --qos condo
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --exclusive
#SBATCH --time=48:00:00
#SBATCH -e %j.err
#SBATCH -o %j.out

module purge
source ~/miniconda3/etc/profile.d/conda.sh
conda activate stacks264

ulimit -n 4096

STORAGE="/storage/username/dx_projects/dx2003"
SCRATCH="/scratch/$SLURM_JOB_ID"
PROGRAM="stacks"
MAP="dx2003_map.txt"
PROC=40

# copy files into place
mkdir -p $SCRATCH/$PROGRAM/aligned
mkdir -p $SCRATCH/$PROGRAM/stacks
mkdir -p $SCRATCH/$PROGRAM/populations
rsync $STORAGE/bowtie2/*.bam $SCRATCH/$PROGRAM/aligned/.
rsync $SLURM_SUBMIT_DIR/$MAP $SCRATCH/$PROGRAM/.

cd $SCRATCH/$PROGRAM

# run stacks
gstacks -I $SCRATCH/$PROGRAM/aligned/ -M $SCRATCH/$PROGRAM/$MAP -O $SCRATCH/$PROGRAM/stacks/ -t $PROC

rm $SCRATCH/$PROGRAM/aligned/*.bam

mkdir -p $STORAGE/$PROGRAM

rsync -r $SCRATCH/$PROGRAM/ $STORAGE/$PROGRAM/.

exit
