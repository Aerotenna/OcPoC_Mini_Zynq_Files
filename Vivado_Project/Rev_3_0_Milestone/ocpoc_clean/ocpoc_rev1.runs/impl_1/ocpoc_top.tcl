proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config  -ruleid {1}  -id {Project 1-19}  -string {{CRITICAL WARNING: [Project 1-19] Could not find the file '/home/ashirley/flight-control/trunk/OcPoC_Zynq_Mini/Rev_3_0_Milestone/ocpoc_clean/ocpoc_rev1.srcs/sources_1/bd/armps/ip/armps_axi_uart16550_0_0/armps_axi_uart16550_0_0.upgrade_log'.}}  -suppress 
set_msg_config  -ruleid {2}  -id {Project 1-19}  -string {{CRITICAL WARNING: [Project 1-19] Could not find the file '/home/ashirley/flight-control/trunk/OcPoC_Zynq_Mini/Rev_3_0_Milestone/ocpoc_clean/ocpoc_rev1.srcs/sources_1/bd/armps/ip/armps_axi_uart16550_0_1/armps_axi_uart16550_0_1.upgrade_log'.}}  -suppress 
set_msg_config  -ruleid {3}  -id {Project 1-19}  -suppress 

start_step write_bitstream
set ACTIVE_STEP write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  open_checkpoint ocpoc_top_routed.dcp
  set_property webtalk.parent_dir /home/ashirley/flight-control/trunk/OcPoC_Zynq_Mini/Rev_3_0_Milestone/ocpoc_clean/ocpoc_rev1.cache/wt [current_project]
  set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
  catch { write_mem_info -force ocpoc_top.mmi }
  write_bitstream -force ocpoc_top.bit 
  catch { write_sysdef -hwdef ocpoc_top.hwdef -bitfile ocpoc_top.bit -meminfo ocpoc_top.mmi -file ocpoc_top.sysdef }
  catch {write_debug_probes -no_partial_ltxfile -quiet -force debug_nets}
  catch {file copy -force debug_nets.ltx ocpoc_top.ltx}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
  unset ACTIVE_STEP 
}

