
# XM-Sim Command File
# TOOL:	xmsim(64)	24.09-s005
#

set tcl_prompt1 {puts -nonewline "xcelium> "}
set tcl_prompt2 {puts -nonewline "> "}
set vlog_format %h
set vhdl_format %v
set real_precision 6
set display_unit auto
set time_unit module
set heap_garbage_size -200
set heap_garbage_time 0
set assert_report_level note
set assert_stop_level never
set autoscope yes
set assert_1164_warnings yes
set pack_assert_off {}
set severity_pack_assert_off {note warning}
set assert_output_stop_level failed
set tcl_debug_level 0
set relax_path_name 1
set vhdl_vcdmap XX01ZX01X
set intovf_severity_level ERROR
set probe_screen_format 0
set rangecnst_severity_level ERROR
set textio_severity_level ERROR
set vital_timing_checks_on 1
set vlog_code_show_force 0
set assert_count_attempts 1
set tcl_all64 false
set tcl_runerror_exit false
set assert_report_incompletes 0
set show_force 1
set force_reset_by_reinvoke 0
set tcl_relaxed_literal 0
set probe_exclude_patterns {}
set probe_packed_limit 4k
set probe_unpacked_limit 16k
set assert_internal_msg no
set svseed 1234
set assert_reporting_mode 0
set vcd_compact_mode 0
set vhdl_forgen_loopindex_enum_pos 0
set xmreplay_dc_debug 0
set tcl_runcmd_interrupt next_command
set tcl_sigval_prefix {#}
alias . run
alias cp create_probes
alias create_local_wave_db database -open shmdb -into waves.shm -default
alias create_probes 
scope -set ifx_dig_top
# DUT probe
probe -create ifx_dig_top -depth all -tasks -functions -uvm -packed 4k -unpacked 16k -all -memories -variables -sc_processes -all -dynamic -database shmdb
probe -create $uvm:{uvm_test_top} -all -depth all -database shmdb

alias delete_probes probe -delete 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
alias dp delete_probes
alias indago verisium
alias quit exit
stop -create -name Randomize -randomize
database -open -shm -into waves.shm shmdb -default
probe -create -database shmdb ifx_dig_top -all -variables -memories -dynamic -sc_processes -depth all -tasks -functions -uvm
probe -create -database shmdb $uvm:{uvm_test_top} -all -depth all

simvision -input /home/student8/ifx_summer_school_2025/simulation/sv_sim/.simvision/709871_student8__autosave.tcl.svcf
