#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate clinehelpr

RUN="run6"
SETTINGS="bgc_settings6.txt"

mkdir -p $RUN

run_bgc.sh -s $SETTINGS

exit
