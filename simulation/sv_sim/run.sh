#!/bin/bash

str=$(pwd)
rem="/simulation/sv_sim"
export proj_root=${str%$rem}
echo $proj_root

clear

echo "Removing xcelium temp files"
rm -rf cov_work xcelium.d .simvision .shadow *.log *.key waves.shm *~

echo "Launching XCELIUM with test $1 seed $2"
echo

/opt/cadence/installs/XCELIUM2409/tools/xcelium/bin/xrun +UVM_TESTNAME=$1 -seed $2 -gui -f run.args &
