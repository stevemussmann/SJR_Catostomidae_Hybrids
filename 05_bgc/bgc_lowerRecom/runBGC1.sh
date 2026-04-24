#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate clinehelpr

RUN="run1"
SETTINGS="bgc_settings1.txt"

mkdir -p $RUN

run_bgc.sh -s $SETTINGS

exit
