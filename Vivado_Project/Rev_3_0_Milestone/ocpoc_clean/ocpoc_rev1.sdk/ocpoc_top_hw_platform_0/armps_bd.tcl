
################################################################
# This is a generated script based on design: armps
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source armps_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z010clg400-1

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name armps

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set CAN_PS_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:can_rtl:1.0 CAN_PS_0 ]
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set IIC_PL_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_PL_0 ]
  set IIC_PL_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_PL_1 ]
  set IIC_PL_2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_PL_2 ]
  set IIC_PL_3 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_PL_3 ]
  set IIC_PS_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_PS_0 ]
  set IIC_PS_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_PS_1 ]
  set SPI_PS_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:spi_rtl:1.0 SPI_PS_0 ]
  set SPI_PS_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:spi_rtl:1.0 SPI_PS_1 ]
  set UART_PL_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART_PL_0 ]
  set UART_PL_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART_PL_1 ]
  set UART_PL_2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART_PL_2 ]
  set UART_PL_3 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART_PL_3 ]
  set UART_PL_4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART_PL_4 ]
  set UART_PL_5 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART_PL_5 ]
  set UART_PL_6 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART_PL_6 ]
  set UART_PL_7 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART_PL_7 ]
  set UART_PS_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART_PS_0 ]
  set Vaux15 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux15 ]

  # Create ports
  set pulse_train_in [ create_bd_port -dir I pulse_train_in ]
  set pwm_0 [ create_bd_port -dir O pwm_0 ]
  set pwm_1 [ create_bd_port -dir O pwm_1 ]
  set pwm_2 [ create_bd_port -dir O pwm_2 ]
  set pwm_3 [ create_bd_port -dir O pwm_3 ]
  set pwm_4 [ create_bd_port -dir O pwm_4 ]
  set pwm_5 [ create_bd_port -dir O pwm_5 ]
  set pwm_6 [ create_bd_port -dir O pwm_6 ]
  set pwm_7 [ create_bd_port -dir O pwm_7 ]
  set pwm_8 [ create_bd_port -dir O pwm_8 ]

  # Create instance: AXI_OcPoC_PWM_Controller_0, and set properties
  set AXI_OcPoC_PWM_Controller_0 [ create_bd_cell -type ip -vlnv Aerotenna:user:AXI_OcPoC_PWM_Controller:1.0 AXI_OcPoC_PWM_Controller_0 ]

  # Create instance: RC_Receiver_Input_0, and set properties
  set RC_Receiver_Input_0 [ create_bd_cell -type ip -vlnv Aerotenna:user:RC_Receiver_Input:1.0 RC_Receiver_Input_0 ]

  # Create instance: axi_iic_0, and set properties
  set axi_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_0 ]
  set_property -dict [ list \
CONFIG.C_SCL_INERTIAL_DELAY {30} \
CONFIG.C_SDA_INERTIAL_DELAY {5} \
CONFIG.IIC_FREQ_KHZ {100} \
 ] $axi_iic_0

  # Create instance: axi_iic_1, and set properties
  set axi_iic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_1 ]
  set_property -dict [ list \
CONFIG.C_SCL_INERTIAL_DELAY {30} \
CONFIG.C_SDA_INERTIAL_DELAY {5} \
CONFIG.IIC_FREQ_KHZ {100} \
 ] $axi_iic_1

  # Create instance: axi_iic_2, and set properties
  set axi_iic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_2 ]
  set_property -dict [ list \
CONFIG.C_SCL_INERTIAL_DELAY {30} \
CONFIG.C_SDA_INERTIAL_DELAY {5} \
CONFIG.IIC_FREQ_KHZ {100} \
 ] $axi_iic_2

  # Create instance: axi_iic_3, and set properties
  set axi_iic_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_3 ]
  set_property -dict [ list \
CONFIG.C_SCL_INERTIAL_DELAY {30} \
CONFIG.C_SDA_INERTIAL_DELAY {5} \
CONFIG.IIC_FREQ_KHZ {100} \
 ] $axi_iic_3

  # Create instance: axi_uart16550_0, and set properties
  set axi_uart16550_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_0 ]

  # Create instance: axi_uart16550_1, and set properties
  set axi_uart16550_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_1 ]

  # Create instance: axi_uart16550_2, and set properties
  set axi_uart16550_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_2 ]

  # Create instance: axi_uart16550_3, and set properties
  set axi_uart16550_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_3 ]

  # Create instance: axi_uart16550_4, and set properties
  set axi_uart16550_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_4 ]

  # Create instance: axi_uart16550_5, and set properties
  set axi_uart16550_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_5 ]

  # Create instance: axi_uart16550_6, and set properties
  set axi_uart16550_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_6 ]

  # Create instance: axi_uart16550_7, and set properties
  set axi_uart16550_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_7 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_ENET_RESET_ENABLE {0} \
CONFIG.PCW_EN_CLK1_PORT {1} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} \
CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_I2C_RESET_ENABLE {0} \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_TTC1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {534} \
CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J128M16 HA-15E} \
CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_USB0_RESET_ENABLE {1} \
CONFIG.PCW_USB0_RESET_IO {MIO 46} \
CONFIG.PCW_USB_RESET_ENABLE {1} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
CONFIG.PCW_WDT_PERIPHERAL_ENABLE {1} \
 ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {15} \
 ] $processing_system7_0_axi_periph

  # Create instance: rst_processing_system7_0_50M, and set properties
  set rst_processing_system7_0_50M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_50M ]

  # Create instance: rst_processing_system7_0_50M_1, and set properties
  set rst_processing_system7_0_50M_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_50M_1 ]

  # Create instance: xadc_wiz_0, and set properties
  set xadc_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xadc_wiz:3.2 xadc_wiz_0 ]
  set_property -dict [ list \
CONFIG.ACQUISITION_TIME_VAUXP15_VAUXN15 {true} \
CONFIG.ACQUISITION_TIME_VP_VN {false} \
CONFIG.ADC_CONVERSION_RATE {962} \
CONFIG.AVERAGE_ENABLE_TEMPERATURE {true} \
CONFIG.AVERAGE_ENABLE_VAUXP15_VAUXN15 {true} \
CONFIG.AVERAGE_ENABLE_VP_VN {false} \
CONFIG.CHANNEL_ENABLE_CALIBRATION {true} \
CONFIG.CHANNEL_ENABLE_TEMPERATURE {true} \
CONFIG.CHANNEL_ENABLE_VAUXP15_VAUXN15 {true} \
CONFIG.CHANNEL_ENABLE_VP_VN {false} \
CONFIG.DCLK_FREQUENCY {50} \
CONFIG.EXTERNAL_MUX_CHANNEL {VP_VN} \
CONFIG.SEQUENCER_MODE {Continuous} \
CONFIG.SINGLE_CHANNEL_SELECTION {TEMPERATURE} \
CONFIG.XADC_STARUP_SELECTION {channel_sequencer} \
 ] $xadc_wiz_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {13} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Vaux15_1 [get_bd_intf_ports Vaux15] [get_bd_intf_pins xadc_wiz_0/Vaux15]
  connect_bd_intf_net -intf_net axi_iic_0_IIC [get_bd_intf_ports IIC_PL_0] [get_bd_intf_pins axi_iic_0/IIC]
  connect_bd_intf_net -intf_net axi_iic_1_IIC [get_bd_intf_ports IIC_PL_1] [get_bd_intf_pins axi_iic_1/IIC]
  connect_bd_intf_net -intf_net axi_iic_2_IIC [get_bd_intf_ports IIC_PL_2] [get_bd_intf_pins axi_iic_2/IIC]
  connect_bd_intf_net -intf_net axi_iic_3_IIC [get_bd_intf_ports IIC_PL_3] [get_bd_intf_pins axi_iic_3/IIC]
  connect_bd_intf_net -intf_net axi_uart16550_0_UART [get_bd_intf_ports UART_PL_0] [get_bd_intf_pins axi_uart16550_0/UART]
  connect_bd_intf_net -intf_net axi_uart16550_1_UART [get_bd_intf_ports UART_PL_1] [get_bd_intf_pins axi_uart16550_1/UART]
  connect_bd_intf_net -intf_net axi_uart16550_2_UART [get_bd_intf_ports UART_PL_2] [get_bd_intf_pins axi_uart16550_2/UART]
  connect_bd_intf_net -intf_net axi_uart16550_3_UART [get_bd_intf_ports UART_PL_3] [get_bd_intf_pins axi_uart16550_3/UART]
  connect_bd_intf_net -intf_net axi_uart16550_4_UART [get_bd_intf_ports UART_PL_4] [get_bd_intf_pins axi_uart16550_4/UART]
  connect_bd_intf_net -intf_net axi_uart16550_5_UART [get_bd_intf_ports UART_PL_5] [get_bd_intf_pins axi_uart16550_5/UART]
  connect_bd_intf_net -intf_net axi_uart16550_6_UART [get_bd_intf_ports UART_PL_6] [get_bd_intf_pins axi_uart16550_6/UART]
  connect_bd_intf_net -intf_net axi_uart16550_7_UART [get_bd_intf_ports UART_PL_7] [get_bd_intf_pins axi_uart16550_7/UART]
  connect_bd_intf_net -intf_net processing_system7_0_CAN_0 [get_bd_intf_ports CAN_PS_0] [get_bd_intf_pins processing_system7_0/CAN_0]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_IIC_0 [get_bd_intf_ports IIC_PS_0] [get_bd_intf_pins processing_system7_0/IIC_0]
  connect_bd_intf_net -intf_net processing_system7_0_IIC_1 [get_bd_intf_ports IIC_PS_1] [get_bd_intf_pins processing_system7_0/IIC_1]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_SPI_0 [get_bd_intf_ports SPI_PS_0] [get_bd_intf_pins processing_system7_0/SPI_0]
  connect_bd_intf_net -intf_net processing_system7_0_SPI_1 [get_bd_intf_ports SPI_PS_1] [get_bd_intf_pins processing_system7_0/SPI_1]
  connect_bd_intf_net -intf_net processing_system7_0_UART_0 [get_bd_intf_ports UART_PS_0] [get_bd_intf_pins processing_system7_0/UART_0]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins AXI_OcPoC_PWM_Controller_0/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins axi_uart16550_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M02_AXI [get_bd_intf_pins axi_uart16550_5/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M03_AXI [get_bd_intf_pins axi_uart16550_1/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M04_AXI [get_bd_intf_pins axi_uart16550_2/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M05_AXI [get_bd_intf_pins axi_uart16550_3/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M06_AXI [get_bd_intf_pins axi_iic_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M07_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M07_AXI] [get_bd_intf_pins xadc_wiz_0/s_axi_lite]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M08_AXI [get_bd_intf_pins axi_uart16550_4/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M08_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M09_AXI [get_bd_intf_pins axi_uart16550_6/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M09_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M10_AXI [get_bd_intf_pins axi_uart16550_7/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M10_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M11_AXI [get_bd_intf_pins axi_iic_1/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M11_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M12_AXI [get_bd_intf_pins axi_iic_2/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M12_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M13_AXI [get_bd_intf_pins axi_iic_3/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M13_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M14_AXI [get_bd_intf_pins RC_Receiver_Input_0/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M14_AXI]

  # Create port connections
  connect_bd_net -net AXI_OcPoC_PWM_Controller_0_pwm0 [get_bd_ports pwm_0] [get_bd_pins AXI_OcPoC_PWM_Controller_0/pwm0]
  connect_bd_net -net AXI_OcPoC_PWM_Controller_0_pwm1 [get_bd_ports pwm_1] [get_bd_pins AXI_OcPoC_PWM_Controller_0/pwm1]
  connect_bd_net -net AXI_OcPoC_PWM_Controller_0_pwm2 [get_bd_ports pwm_2] [get_bd_pins AXI_OcPoC_PWM_Controller_0/pwm2]
  connect_bd_net -net AXI_OcPoC_PWM_Controller_0_pwm3 [get_bd_ports pwm_3] [get_bd_pins AXI_OcPoC_PWM_Controller_0/pwm3]
  connect_bd_net -net AXI_OcPoC_PWM_Controller_0_pwm4 [get_bd_ports pwm_4] [get_bd_pins AXI_OcPoC_PWM_Controller_0/pwm4]
  connect_bd_net -net AXI_OcPoC_PWM_Controller_0_pwm5 [get_bd_ports pwm_5] [get_bd_pins AXI_OcPoC_PWM_Controller_0/pwm5]
  connect_bd_net -net AXI_OcPoC_PWM_Controller_0_pwm6 [get_bd_ports pwm_6] [get_bd_pins AXI_OcPoC_PWM_Controller_0/pwm6]
  connect_bd_net -net AXI_OcPoC_PWM_Controller_0_pwm7 [get_bd_ports pwm_7] [get_bd_pins AXI_OcPoC_PWM_Controller_0/pwm7]
  connect_bd_net -net AXI_OcPoC_PWM_Controller_0_pwm8 [get_bd_ports pwm_8] [get_bd_pins AXI_OcPoC_PWM_Controller_0/pwm8]
  connect_bd_net -net Net [get_bd_pins axi_uart16550_0/ctsn] [get_bd_pins axi_uart16550_0/freeze] [get_bd_pins axi_uart16550_0/rin] [get_bd_pins axi_uart16550_1/ctsn] [get_bd_pins axi_uart16550_1/rin] [get_bd_pins axi_uart16550_2/ctsn] [get_bd_pins axi_uart16550_2/rin] [get_bd_pins axi_uart16550_3/ctsn] [get_bd_pins axi_uart16550_3/rin] [get_bd_pins axi_uart16550_4/ctsn] [get_bd_pins axi_uart16550_4/rin] [get_bd_pins axi_uart16550_5/ctsn] [get_bd_pins axi_uart16550_5/rin] [get_bd_pins axi_uart16550_6/ctsn] [get_bd_pins axi_uart16550_6/rin] [get_bd_pins axi_uart16550_7/ctsn] [get_bd_pins axi_uart16550_7/rin] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net Net1 [get_bd_pins axi_uart16550_0/dcdn] [get_bd_pins axi_uart16550_0/dsrn] [get_bd_pins axi_uart16550_1/dcdn] [get_bd_pins axi_uart16550_1/dsrn] [get_bd_pins axi_uart16550_2/dcdn] [get_bd_pins axi_uart16550_2/dsrn] [get_bd_pins axi_uart16550_3/dcdn] [get_bd_pins axi_uart16550_3/dsrn] [get_bd_pins axi_uart16550_4/dcdn] [get_bd_pins axi_uart16550_4/dsrn] [get_bd_pins axi_uart16550_5/dcdn] [get_bd_pins axi_uart16550_5/dsrn] [get_bd_pins axi_uart16550_6/dcdn] [get_bd_pins axi_uart16550_6/dsrn] [get_bd_pins axi_uart16550_7/dcdn] [get_bd_pins axi_uart16550_7/dsrn] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net axi_iic_0_iic2intc_irpt [get_bd_pins axi_iic_0/iic2intc_irpt] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_iic_1_iic2intc_irpt [get_bd_pins axi_iic_1/iic2intc_irpt] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net axi_iic_2_iic2intc_irpt [get_bd_pins axi_iic_2/iic2intc_irpt] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net axi_iic_3_iic2intc_irpt [get_bd_pins axi_iic_3/iic2intc_irpt] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net axi_uart16550_0_ip2intc_irpt [get_bd_pins axi_uart16550_0/ip2intc_irpt] [get_bd_pins xlconcat_0/In5]
  connect_bd_net -net axi_uart16550_1_ip2intc_irpt [get_bd_pins axi_uart16550_1/ip2intc_irpt] [get_bd_pins xlconcat_0/In6]
  connect_bd_net -net axi_uart16550_2_ip2intc_irpt [get_bd_pins axi_uart16550_2/ip2intc_irpt] [get_bd_pins xlconcat_0/In12]
  connect_bd_net -net axi_uart16550_3_ip2intc_irpt [get_bd_pins axi_uart16550_3/ip2intc_irpt] [get_bd_pins xlconcat_0/In7]
  connect_bd_net -net axi_uart16550_4_ip2intc_irpt [get_bd_pins axi_uart16550_4/ip2intc_irpt] [get_bd_pins xlconcat_0/In8]
  connect_bd_net -net axi_uart16550_5_ip2intc_irpt [get_bd_pins axi_uart16550_5/ip2intc_irpt] [get_bd_pins xlconcat_0/In9]
  connect_bd_net -net axi_uart16550_6_ip2intc_irpt [get_bd_pins axi_uart16550_6/ip2intc_irpt] [get_bd_pins xlconcat_0/In10]
  connect_bd_net -net axi_uart16550_7_ip2intc_irpt [get_bd_pins axi_uart16550_7/ip2intc_irpt] [get_bd_pins xlconcat_0/In11]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_iic_0/s_axi_aclk] [get_bd_pins axi_iic_1/s_axi_aclk] [get_bd_pins axi_iic_2/s_axi_aclk] [get_bd_pins axi_iic_3/s_axi_aclk] [get_bd_pins axi_uart16550_0/s_axi_aclk] [get_bd_pins axi_uart16550_1/s_axi_aclk] [get_bd_pins axi_uart16550_2/s_axi_aclk] [get_bd_pins axi_uart16550_3/s_axi_aclk] [get_bd_pins axi_uart16550_4/s_axi_aclk] [get_bd_pins axi_uart16550_5/s_axi_aclk] [get_bd_pins axi_uart16550_6/s_axi_aclk] [get_bd_pins axi_uart16550_7/s_axi_aclk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/M02_ACLK] [get_bd_pins processing_system7_0_axi_periph/M03_ACLK] [get_bd_pins processing_system7_0_axi_periph/M04_ACLK] [get_bd_pins processing_system7_0_axi_periph/M05_ACLK] [get_bd_pins processing_system7_0_axi_periph/M06_ACLK] [get_bd_pins processing_system7_0_axi_periph/M07_ACLK] [get_bd_pins processing_system7_0_axi_periph/M08_ACLK] [get_bd_pins processing_system7_0_axi_periph/M09_ACLK] [get_bd_pins processing_system7_0_axi_periph/M10_ACLK] [get_bd_pins processing_system7_0_axi_periph/M11_ACLK] [get_bd_pins processing_system7_0_axi_periph/M12_ACLK] [get_bd_pins processing_system7_0_axi_periph/M13_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins rst_processing_system7_0_50M/slowest_sync_clk] [get_bd_pins xadc_wiz_0/s_axi_aclk]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins AXI_OcPoC_PWM_Controller_0/s00_axi_aclk] [get_bd_pins RC_Receiver_Input_0/s00_axi_aclk] [get_bd_pins processing_system7_0/FCLK_CLK1] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M14_ACLK] [get_bd_pins rst_processing_system7_0_50M_1/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_50M/ext_reset_in] [get_bd_pins rst_processing_system7_0_50M_1/ext_reset_in]
  connect_bd_net -net pulse_train_in_1 [get_bd_ports pulse_train_in] [get_bd_pins RC_Receiver_Input_0/pulse_train_in]
  connect_bd_net -net rst_processing_system7_0_50M_1_peripheral_aresetn [get_bd_pins AXI_OcPoC_PWM_Controller_0/s00_axi_aresetn] [get_bd_pins RC_Receiver_Input_0/s00_axi_aresetn] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M14_ARESETN] [get_bd_pins rst_processing_system7_0_50M_1/peripheral_aresetn]
  connect_bd_net -net rst_processing_system7_0_50M_interconnect_aresetn [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins rst_processing_system7_0_50M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_50M_peripheral_aresetn [get_bd_pins axi_iic_0/s_axi_aresetn] [get_bd_pins axi_iic_1/s_axi_aresetn] [get_bd_pins axi_iic_2/s_axi_aresetn] [get_bd_pins axi_iic_3/s_axi_aresetn] [get_bd_pins axi_uart16550_0/s_axi_aresetn] [get_bd_pins axi_uart16550_1/s_axi_aresetn] [get_bd_pins axi_uart16550_2/s_axi_aresetn] [get_bd_pins axi_uart16550_3/s_axi_aresetn] [get_bd_pins axi_uart16550_4/s_axi_aresetn] [get_bd_pins axi_uart16550_5/s_axi_aresetn] [get_bd_pins axi_uart16550_6/s_axi_aresetn] [get_bd_pins axi_uart16550_7/s_axi_aresetn] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M02_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M03_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M04_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M05_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M06_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M07_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M08_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M09_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M10_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M11_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M12_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M13_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_processing_system7_0_50M/peripheral_aresetn] [get_bd_pins xadc_wiz_0/s_axi_aresetn]
  connect_bd_net -net xadc_wiz_0_ip2intc_irpt [get_bd_pins xadc_wiz_0/ip2intc_irpt] [get_bd_pins xlconcat_0/In4]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins xlconcat_0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x10000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs AXI_OcPoC_PWM_Controller_0/S00_AXI/S00_AXI_reg] SEG_AXI_OcPoC_PWM_Controller_0_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43CA0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs RC_Receiver_Input_0/S00_AXI/S00_AXI_reg] SEG_RC_Receiver_Input_0_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x41600000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_iic_0/S_AXI/Reg] SEG_axi_iic_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x41610000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_iic_1/S_AXI/Reg] SEG_axi_iic_1_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x41620000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_iic_2/S_AXI/Reg] SEG_axi_iic_2_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x41630000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_iic_3/S_AXI/Reg] SEG_axi_iic_3_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_uart16550_0/S_AXI/Reg] SEG_axi_uart16550_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C20000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_uart16550_1/S_AXI/Reg] SEG_axi_uart16550_1_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C30000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_uart16550_2/S_AXI/Reg] SEG_axi_uart16550_2_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C40000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_uart16550_3/S_AXI/Reg] SEG_axi_uart16550_3_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C60000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_uart16550_4/S_AXI/Reg] SEG_axi_uart16550_4_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C70000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_uart16550_5/S_AXI/Reg] SEG_axi_uart16550_5_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C80000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_uart16550_6/S_AXI/Reg] SEG_axi_uart16550_6_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C90000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_uart16550_7/S_AXI/Reg] SEG_axi_uart16550_7_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C50000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs xadc_wiz_0/s_axi_lite/Reg] SEG_xadc_wiz_0_Reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port pwm_4 -pg 1 -y 660 -defaultsOSRD
preplace port DDR -pg 1 -y 80 -defaultsOSRD
preplace port pwm_5 -pg 1 -y 680 -defaultsOSRD
preplace port UART_PL_0 -pg 1 -y 1040 -defaultsOSRD
preplace port pwm_6 -pg 1 -y 700 -defaultsOSRD
preplace port UART_PL_1 -pg 1 -y 1220 -defaultsOSRD
preplace port pwm_7 -pg 1 -y 720 -defaultsOSRD
preplace port IIC_PL_0 -pg 1 -y 1910 -defaultsOSRD
preplace port UART_PL_2 -pg 1 -y 1400 -defaultsOSRD
preplace port pwm_8 -pg 1 -y 740 -defaultsOSRD
preplace port IIC_PL_1 -pg 1 -y 1950 -defaultsOSRD
preplace port UART_PL_3 -pg 1 -y 1580 -defaultsOSRD
preplace port UART_PS_0 -pg 1 -y 120 -defaultsOSRD
preplace port SPI_PS_0 -pg 1 -y 180 -defaultsOSRD
preplace port IIC_PL_2 -pg 1 -y 2150 -defaultsOSRD
preplace port UART_PL_4 -pg 1 -y 1760 -defaultsOSRD
preplace port SPI_PS_1 -pg 1 -y 200 -defaultsOSRD
preplace port IIC_PL_3 -pg 1 -y 2170 -defaultsOSRD
preplace port UART_PL_5 -pg 1 -y 2000 -defaultsOSRD
preplace port pulse_train_in -pg 1 -y 600 -defaultsOSRD
preplace port UART_PL_6 -pg 1 -y 2220 -defaultsOSRD
preplace port UART_PL_7 -pg 1 -y 2420 -defaultsOSRD
preplace port CAN_PS_0 -pg 1 -y 220 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 100 -defaultsOSRD
preplace port pwm_0 -pg 1 -y 580 -defaultsOSRD
preplace port pwm_1 -pg 1 -y 600 -defaultsOSRD
preplace port pwm_2 -pg 1 -y 620 -defaultsOSRD
preplace port Vaux15 -pg 1 -y 2720 -defaultsOSRD
preplace port IIC_PS_0 -pg 1 -y 140 -defaultsOSRD
preplace port pwm_3 -pg 1 -y 640 -defaultsOSRD
preplace port IIC_PS_1 -pg 1 -y 160 -defaultsOSRD
preplace inst axi_uart16550_3 -pg 1 -lvl 4 -y 1630 -defaultsOSRD
preplace inst axi_uart16550_4 -pg 1 -lvl 4 -y 1810 -defaultsOSRD
preplace inst axi_iic_0 -pg 1 -lvl 3 -y 1930 -defaultsOSRD
preplace inst axi_uart16550_5 -pg 1 -lvl 4 -y 2050 -defaultsOSRD
preplace inst AXI_OcPoC_PWM_Controller_0 -pg 1 -lvl 4 -y 680 -defaultsOSRD
preplace inst xlconstant_0 -pg 1 -lvl 3 -y 2390 -defaultsOSRD
preplace inst axi_iic_1 -pg 1 -lvl 3 -y 2050 -defaultsOSRD
preplace inst axi_uart16550_6 -pg 1 -lvl 4 -y 2270 -defaultsOSRD
preplace inst xlconstant_1 -pg 1 -lvl 3 -y 2520 -defaultsOSRD
preplace inst axi_iic_2 -pg 1 -lvl 3 -y 2170 -defaultsOSRD
preplace inst xadc_wiz_0 -pg 1 -lvl 4 -y 2720 -defaultsOSRD
preplace inst axi_uart16550_7 -pg 1 -lvl 4 -y 2470 -defaultsOSRD
preplace inst axi_iic_3 -pg 1 -lvl 3 -y 2290 -defaultsOSRD
preplace inst xlconcat_0 -pg 1 -lvl 3 -y 620 -defaultsOSRD
preplace inst rst_processing_system7_0_50M -pg 1 -lvl 2 -y 1050 -defaultsOSRD
preplace inst rst_processing_system7_0_50M_1 -pg 1 -lvl 2 -y 1300 -defaultsOSRD
preplace inst axi_uart16550_0 -pg 1 -lvl 4 -y 1090 -defaultsOSRD
preplace inst axi_uart16550_1 -pg 1 -lvl 4 -y 1270 -defaultsOSRD
preplace inst RC_Receiver_Input_0 -pg 1 -lvl 2 -y 1990 -defaultsOSRD
preplace inst axi_uart16550_2 -pg 1 -lvl 4 -y 1450 -defaultsOSRD
preplace inst processing_system7_0_axi_periph -pg 1 -lvl 3 -y 1420 -defaultsOSRD
preplace inst processing_system7_0 -pg 1 -lvl 4 -y 250 -defaultsOSRD
preplace netloc processing_system7_0_axi_periph_M08_AXI 1 3 1 1040
preplace netloc processing_system7_0_FIXED_IO 1 4 1 NJ
preplace netloc AXI_OcPoC_PWM_Controller_0_pwm0 1 4 1 1750
preplace netloc processing_system7_0_CAN_0 1 4 1 NJ
preplace netloc AXI_OcPoC_PWM_Controller_0_pwm1 1 4 1 1740
preplace netloc AXI_OcPoC_PWM_Controller_0_pwm2 1 4 1 1730
preplace netloc axi_uart16550_7_UART 1 4 1 NJ
preplace netloc axi_uart16550_2_UART 1 4 1 NJ
preplace netloc axi_iic_0_IIC 1 3 2 NJ 1910 NJ
preplace netloc AXI_OcPoC_PWM_Controller_0_pwm3 1 4 1 1720
preplace netloc axi_uart16550_2_ip2intc_irpt 1 2 3 660 900 NJ 900 1600
preplace netloc AXI_OcPoC_PWM_Controller_0_pwm4 1 4 1 1710
preplace netloc AXI_OcPoC_PWM_Controller_0_pwm5 1 4 1 1700
preplace netloc xlconcat_0_dout 1 3 1 1120
preplace netloc axi_uart16550_1_UART 1 4 1 NJ
preplace netloc AXI_OcPoC_PWM_Controller_0_pwm6 1 4 1 1690
preplace netloc AXI_OcPoC_PWM_Controller_0_pwm7 1 4 1 1680
preplace netloc processing_system7_0_axi_periph_M06_AXI 1 2 2 650 1020 1040
preplace netloc AXI_OcPoC_PWM_Controller_0_pwm8 1 4 1 1670
preplace netloc processing_system7_0_DDR 1 4 1 NJ
preplace netloc axi_uart16550_5_ip2intc_irpt 1 2 3 640 1840 NJ 1930 1590
preplace netloc Vaux15_1 1 0 4 NJ 2720 NJ 2720 NJ 2720 NJ
preplace netloc processing_system7_0_axi_periph_M05_AXI 1 3 1 1200
preplace netloc axi_uart16550_3_UART 1 4 1 NJ
preplace netloc rst_processing_system7_0_50M_interconnect_aresetn 1 2 1 570
preplace netloc axi_uart16550_1_ip2intc_irpt 1 2 3 620 -20 NJ -20 1640
preplace netloc processing_system7_0_FCLK_RESET0_N 1 1 4 160 940 NJ 940 NJ 940 1590
preplace netloc axi_iic_0_iic2intc_irpt 1 2 2 650 430 1070
preplace netloc axi_iic_3_IIC 1 3 2 NJ 2170 NJ
preplace netloc processing_system7_0_axi_periph_M10_AXI 1 3 1 1090
preplace netloc processing_system7_0_axi_periph_M02_AXI 1 3 1 1190
preplace netloc processing_system7_0_axi_periph_M03_AXI 1 3 1 1170
preplace netloc processing_system7_0_axi_periph_M07_AXI 1 3 1 1120
preplace netloc axi_uart16550_3_ip2intc_irpt 1 2 3 630 -10 NJ -10 1660
preplace netloc axi_iic_1_iic2intc_irpt 1 2 2 660 440 1060
preplace netloc axi_iic_3_iic2intc_irpt 1 2 2 640 410 1080
preplace netloc processing_system7_0_axi_periph_M09_AXI 1 3 1 1110
preplace netloc processing_system7_0_axi_periph_M11_AXI 1 2 2 660 1850 1020
preplace netloc processing_system7_0_axi_periph_M13_AXI 1 2 2 670 2440 1030
preplace netloc pulse_train_in_1 1 0 2 NJ 600 150
preplace netloc axi_uart16550_6_UART 1 4 1 NJ
preplace netloc processing_system7_0_IIC_0 1 4 1 NJ
preplace netloc processing_system7_0_axi_periph_M01_AXI 1 3 1 1150
preplace netloc processing_system7_0_IIC_1 1 4 1 NJ
preplace netloc processing_system7_0_axi_periph_M12_AXI 1 2 2 670 1860 1010
preplace netloc axi_uart16550_4_ip2intc_irpt 1 2 3 630 1830 NJ 1920 1590
preplace netloc Net 1 3 2 1180 990 1630
preplace netloc axi_uart16550_0_ip2intc_irpt 1 2 3 610 -40 NJ -40 1650
preplace netloc processing_system7_0_SPI_0 1 4 1 NJ
preplace netloc Net1 1 3 2 NJ 2370 1620
preplace netloc processing_system7_0_FCLK_CLK0 1 1 4 170 960 560 960 1160 0 1620
preplace netloc processing_system7_0_SPI_1 1 4 1 NJ
preplace netloc processing_system7_0_FCLK_CLK1 1 1 4 170 1390 590 890 1180 890 1600
preplace netloc axi_uart16550_5_UART 1 4 1 NJ
preplace netloc axi_uart16550_0_UART 1 4 1 NJ
preplace netloc processing_system7_0_axi_periph_M00_AXI 1 3 1 1120
preplace netloc axi_uart16550_4_UART 1 4 1 NJ
preplace netloc rst_processing_system7_0_50M_peripheral_aresetn 1 2 2 580 1010 1140
preplace netloc xadc_wiz_0_ip2intc_irpt 1 2 3 600 2910 NJ 2910 1590
preplace netloc axi_uart16550_7_ip2intc_irpt 1 2 3 620 2900 NJ 2900 1600
preplace netloc processing_system7_0_UART_0 1 4 1 NJ
preplace netloc rst_processing_system7_0_50M_1_peripheral_aresetn 1 1 3 180 1760 550 790 NJ
preplace netloc processing_system7_0_axi_periph_M14_AXI 1 1 3 190 1820 NJ 1820 1000
preplace netloc processing_system7_0_M_AXI_GP0 1 2 3 670 880 NJ 880 1610
preplace netloc axi_iic_2_IIC 1 3 2 NJ 2150 NJ
preplace netloc axi_iic_1_IIC 1 3 2 NJ 1950 NJ
preplace netloc processing_system7_0_axi_periph_M04_AXI 1 3 1 1210
preplace netloc axi_iic_2_iic2intc_irpt 1 2 2 670 450 1050
preplace netloc axi_uart16550_6_ip2intc_irpt 1 2 3 610 2890 NJ 2890 1610
levelinfo -pg 1 0 130 390 850 1400 2050 -top -90 -bot 2920
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


