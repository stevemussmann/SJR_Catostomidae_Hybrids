#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate clinehelpr

RUN="run2"
SETTINGS="bgc_settings2.txt"

mkdir -p $RUN

run_bgc.sh -s $SETTINGS

exit
