This milestone supports the 2.1 - 2.3 OcPoC Boards

This milestone has the following features:

*       Adds USB
*       Adds Triplex Ports for UART and I2C
*       Adds I2C Inertial Delays to FPGA I2C buses for stability
*       Increases the PL Clock for High speed UART
*       Removes the GPS from the Internal SPI-Bus
*       Adds Secondary IMU to the SPI-Bus
*	Removes I2C from J15
*	Adds UART to J15 (ttyS4)
*	Activates CANBUS on J18
*	Adds 4 more PWM channels on the PWM port
*	Adds Triplex GPS
*	Adds SPI 


The folder is structured as follows:

* boot.Bin
* devicetree.dtb
* zynq_interface - the schematic for the zynq 2.3 board
* ip_repo
** pwm_chan8_1.0 - the IP for the 8 channel PWM controller
** RC_Receiver_Input - the IP for PPM input
*ocpoc_clean

In ocpoc_clean there are lots files related to the project, of note ocpoc_rev1.sdk contains a spare devicetree in device_tree_0, and fsbl in the fsbl/debug/fsbl.elf folders
There is a spare boot.bin as well, as well as u-boot.elf and fsbl.elf () 