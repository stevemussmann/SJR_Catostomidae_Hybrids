#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate clinehelpr

RUN="run4"
SETTINGS="bgc_settings4.txt"

mkdir -p $RUN

run_bgc.sh -s $SETTINGS

exit
