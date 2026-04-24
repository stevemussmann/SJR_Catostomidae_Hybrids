#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate clinehelpr

RUN="run5"
SETTINGS="bgc_settings5.txt"

mkdir -p $RUN

run_bgc.sh -s $SETTINGS

exit
