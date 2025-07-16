# command to create a database into the current simulation folder
alias create_local_wave_db "database -open shmdb -into waves.shm -default"

# command to create probes on the DUT and the environment
alias create_probes "
scope -set ifx_dig_top
# DUT probe
probe -create ifx_dig_top -depth all -tasks -functions -uvm -packed 4k -unpacked 16k -all -memories -variables -sc_processes -all -dynamic -database shmdb
probe -create $uvm:{uvm_test_top} -all -depth all -database shmdb
"

# command to delete all probes
alias delete_probes "probe -delete 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20"
set assert_stop_level never

alias cp "create_probes"
alias dp "delete_probes"

run 10

create_local_wave_db
cp