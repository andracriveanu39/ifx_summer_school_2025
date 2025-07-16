#!/bin/bash

str=$(pwd)
rem="/simulation/rtl_sim"
export proj_root=${str%$rem}
echo $proj_root

echo "Removing xcelium temp files"
rm -rf cov_work xcelium.d .simvision .shadow *.log *.key waves.shm *~

xrun -top $1 -gui -f run.args
