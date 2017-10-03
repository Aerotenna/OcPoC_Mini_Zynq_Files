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


start_step init_design
set ACTIVE_STEP init_design
set rc [catch {
  create_msg_db init_design.pb
  create_project -in_memory -part xc7z010clg400-1
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir /home/hding/Projects/flight-control/trunk/OcPoC_Zynq_Mini/Rev_3_0_Milestone/ocpoc_clean/ocpoc_rev1.cache/wt [current_project]
  set_property parent.project_path /home/hding/Projects/flight-control/trunk/OcPoC_Zynq_Mini/Rev_3_0_Milestone/ocpoc_clean/ocpoc_rev1.xpr [current_project]
  set_property ip_repo_paths {
  /home/hding/Projects/flight-control/trunk/OcPoC_Zynq_Mini/Rev_3_0_Milestone/ip_repo/RC_Receiver_Input_1.0_en
  /home/hding/Projects/flight-control/trunk/OcPoC_Zynq_Mini/Rev_3_0_Milestone/ip_repo/AXI_OcPoC_en
} [current_project]
  set_property ip_cache_permissions disable [current_project]
  set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
  add_files -quiet /home/hding/Projects/flight-control/trunk/OcPoC_Zynq_Mini/Rev_3_0_Milestone/ocpoc_clean/ocpoc_rev1.runs/synth_1/ocpoc_top.dcp
  set_msg_config -source 4 -id {BD 41-1661} -suppress
  set_param project.isImplRun true
  add_files /home/hding/Projects/flight-control/trunk/OcPoC_Zynq_Mini/Rev_3_0_Milestone/ocpoc_clean/ocpoc_rev1.srcs/sources_1/bd/armps/armps.bd
  set_property is_locked true [get_files /home/hding/Projects/flight-control/trunk/OcPoC_Zynq_Mini/Rev_3_0_Milestone/ocpoc_clean/ocpoc_rev1.srcs/sources_1/bd/armps/armps.bd]
  set_param project.isImplRun false
  read_xdc /home/hding/Projects/flight-control/trunk/OcPoC_Zynq_Mini/Rev_3_0_Milestone/ocpoc_clean/ocpoc_rev1.srcs/constrs_1/new/ocpoc_rev1.xdc
  set_param project.isImplRun true
  link_design -top ocpoc_top -part xc7z010clg400-1
  set_param project.isImplRun false
  write_hwdef -force -file ocpoc_top.hwdef
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
  unset ACTIVE_STEP 
}

start_step opt_design
set ACTIVE_STEP opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force ocpoc_top_opt.dcp
  catch { report_drc -file ocpoc_top_drc_opted.rpt }
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
  unset ACTIVE_STEP 
}

start_step place_design
set ACTIVE_STEP place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force ocpoc_top_placed.dcp
  catch { report_io -file ocpoc_top_io_placed.rpt }
  catch { report_utilization -file ocpoc_top_utilization_placed.rpt -pb ocpoc_top_utilization_placed.pb }
  catch { report_control_sets -verbose -file ocpoc_top_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
  unset ACTIVE_STEP 
}

start_step route_design
set ACTIVE_STEP route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force ocpoc_top_routed.dcp
  catch { report_drc -file ocpoc_top_drc_routed.rpt -pb ocpoc_top_drc_routed.pb -rpx ocpoc_top_drc_routed.rpx }
  catch { report_methodology -file ocpoc_top_methodology_drc_routed.rpt -rpx ocpoc_top_methodology_drc_routed.rpx }
  catch { report_power -file ocpoc_top_power_routed.rpt -pb ocpoc_top_power_summary_routed.pb -rpx ocpoc_top_power_routed.rpx }
  catch { report_route_status -file ocpoc_top_route_status.rpt -pb ocpoc_top_route_status.pb }
  catch { report_clock_utilization -file ocpoc_top_clock_utilization_routed.rpt }
  catch { report_timing_summary -warn_on_violation -max_paths 10 -file ocpoc_top_timing_summary_routed.rpt -rpx ocpoc_top_timing_summary_routed.rpx }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  write_checkpoint -force ocpoc_top_routed_error.dcp
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
  unset ACTIVE_STEP 
}

start_step write_bitstream
set ACTIVE_STEP write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
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

