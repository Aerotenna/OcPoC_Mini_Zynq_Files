#PPM
set_property PACKAGE_PIN R17 [get_ports pulse_train_in]
set_property IOSTANDARD LVCMOS33 [get_ports pulse_train_in]

#Telemetry UART ttyPS1
set_property PACKAGE_PIN L16 [get_ports UART_PS_0_rxd]   
set_property PACKAGE_PIN L17 [get_ports UART_PS_0_txd]
set_property IOSTANDARD LVCMOS33 [get_ports UART_PS_0_rxd]
set_property IOSTANDARD LVCMOS33 [get_ports UART_PS_0_txd]

##zynq-pl-i2c
# J15
##COMPASS # G18 # F16
set_property PACKAGE_PIN G18 [get_ports IIC_PL_0_scl_io]   
set_property PACKAGE_PIN F16 [get_ports IIC_PL_0_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports IIC_PL_0_scl_io]   
set_property IOSTANDARD LVCMOS33 [get_ports IIC_PL_0_sda_io]
# ttyS4
#set_property PACKAGE_PIN F16 [get_ports UART_PL_4_rxd]   
#set_property PACKAGE_PIN G18 [get_ports UART_PL_4_txd]
#set_property IOSTANDARD LVCMOS33 [get_ports UART_PL_4_rxd]
#set_property IOSTANDARD LVCMOS33 [get_ports UART_PL_4_txd]
   

#zynq ps led i2c
set_property PACKAGE_PIN E19 [get_ports IIC_PS_1_scl_io]   
set_property PACKAGE_PIN F19 [get_ports IIC_PS_1_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports IIC_PS_1_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports IIC_PS_1_sda_io]

# zynq-ps-spi
set_property PACKAGE_PIN L19 [get_ports SPI_PS_0_io0_io]
set_property PACKAGE_PIN L20 [get_ports SPI_PS_0_io1_io]
set_property PACKAGE_PIN L15 [get_ports SPI_PS_0_sck_io]
#MPU9250    (CS0)
set_property PACKAGE_PIN D19 [get_ports SPI_PS_0_ss_io]       
#MS5611     (CS1)
set_property PACKAGE_PIN A20 [get_ports SPI_PS_0_ss1_o]     
#MPU9250    (CS2)
set_property PACKAGE_PIN H17 [get_ports SPI_PS_0_ss2_o]
set_property IOSTANDARD LVCMOS33 [get_ports SPI_PS_0_io0_io]
set_property IOSTANDARD LVCMOS33 [get_ports SPI_PS_0_io1_io]
set_property IOSTANDARD LVCMOS33 [get_ports SPI_PS_0_sck_io]
set_property IOSTANDARD LVCMOS33 [get_ports SPI_PS_0_ss_io]
set_property IOSTANDARD LVCMOS33 [get_ports SPI_PS_0_ss1_o]
set_property IOSTANDARD LVCMOS33 [get_ports SPI_PS_0_ss2_o]

# J14 SPI BUS J18
set_property PACKAGE_PIN D18 [get_ports SPI_PS_1_io0_io]; #MOSI Delay 50.67ps
set_property PACKAGE_PIN E18 [get_ports SPI_PS_1_io1_io]; #MISO 57.1ps
set_property PACKAGE_PIN E17 [get_ports SPI_PS_1_sck_io]; #CLOCK 50.97ps
set_property PACKAGE_PIN F17 [get_ports SPI_PS_1_ss_io];  #CS   52ps    
set_property IOSTANDARD LVCMOS33 [get_ports SPI_PS_1_io0_io]
set_property IOSTANDARD LVCMOS33 [get_ports SPI_PS_1_io1_io]
set_property IOSTANDARD LVCMOS33 [get_ports SPI_PS_1_sck_io]
set_property IOSTANDARD LVCMOS33 [get_ports SPI_PS_1_ss_io]


#CAN BUS
set_property PACKAGE_PIN H18 [get_ports CAN_PS_0_rx]
set_property PACKAGE_PIN C20 [get_ports CAN_PS_0_tx]
#set_property PACKAGE_PIN C20 [get_ports CAN_PS_0_rx]
#set_property PACKAGE_PIN H18 [get_ports CAN_PS_0_tx]
set_property IOSTANDARD LVCMOS33 [get_ports CAN_PS_0_rx]
set_property IOSTANDARD LVCMOS33 [get_ports CAN_PS_0_tx]


#zumq-pl-vio
#sbus ttyS2
set_property PACKAGE_PIN V15 [get_ports sbus_in]
set_property IOSTANDARD LVCMOS33 [get_ports sbus_in]

#GPS UART / USHARP / Ulanding J13 ttyS5
set_property PACKAGE_PIN G17 [get_ports UART_PL_2_txd]   
set_property PACKAGE_PIN H16 [get_ports UART_PL_2_rxd]
set_property IOSTANDARD LVCMOS33 [get_ports UART_PL_2_txd]
set_property IOSTANDARD LVCMOS33 [get_ports UART_PL_2_rxd]

#ULANDING J9 ttyS6
set_property PACKAGE_PIN M15 [get_ports UART_PL_3_txd]   
set_property PACKAGE_PIN M14 [get_ports UART_PL_3_rxd]
set_property IOSTANDARD LVCMOS33 [get_ports UART_PL_3_txd]
set_property IOSTANDARD LVCMOS33 [get_ports UART_PL_3_rxd]

#FLOW (Pin 13&14)
set_property PACKAGE_PIN Y14 [get_ports IIC_PS_0_scl_io]  
set_property PACKAGE_PIN W15 [get_ports IIC_PS_0_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports IIC_PS_0_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports IIC_PS_0_sda_io]
set_property PULLUP true [get_ports IIC_PS_0_scl_io]
set_property PULLUP true [get_ports IIC_PS_0_sda_io]

#zumq-pl-servo_ch
#PWM
set_property PACKAGE_PIN V18 [get_ports pwm_0]   
set_property PACKAGE_PIN T19 [get_ports pwm_1]
set_property PACKAGE_PIN P15 [get_ports pwm_2]
set_property PACKAGE_PIN U18 [get_ports pwm_3]
set_property PACKAGE_PIN P16 [get_ports pwm_4]   
set_property PACKAGE_PIN Y19 [get_ports pwm_5]
set_property PACKAGE_PIN W20 [get_ports pwm_6]
set_property PACKAGE_PIN W19 [get_ports pwm_7]
set_property IOSTANDARD LVCMOS33 [get_ports pwm_0]
set_property IOSTANDARD LVCMOS33 [get_ports pwm_1]
set_property IOSTANDARD LVCMOS33 [get_ports pwm_2]
set_property IOSTANDARD LVCMOS33 [get_ports pwm_3]
set_property IOSTANDARD LVCMOS33 [get_ports pwm_4]
set_property IOSTANDARD LVCMOS33 [get_ports pwm_5]
set_property IOSTANDARD LVCMOS33 [get_ports pwm_6]
set_property IOSTANDARD LVCMOS33 [get_ports pwm_7]

set_property PACKAGE_PIN Y17 [get_ports pwm_8]   
set_property PACKAGE_PIN Y16 [get_ports pwm_9]
set_property PACKAGE_PIN Y18 [get_ports pwm_10]
set_property PACKAGE_PIN W14 [get_ports pwm_11]
set_property IOSTANDARD LVCMOS33 [get_ports pwm_8]
set_property IOSTANDARD LVCMOS33 [get_ports pwm_9]
set_property IOSTANDARD LVCMOS33 [get_ports pwm_10]
set_property IOSTANDARD LVCMOS33 [get_ports pwm_11]

set_property PACKAGE_PIN J16 [get_ports Vaux15_v_n]
set_property PACKAGE_PIN K16 [get_ports Vaux15_v_p]
set_property IOSTANDARD LVCMOS33 [get_ports Vaux15_v_n]
set_property IOSTANDARD LVCMOS33 [get_ports Vaux15_v_p]

# J6 USHARP ttyS0
set_property PACKAGE_PIN K18 [get_ports UART_PL_1_txd]   
set_property PACKAGE_PIN J18 [get_ports UART_PL_1_rxd]
set_property IOSTANDARD LVCMOS33 [get_ports UART_PL_1_txd]
set_property IOSTANDARD LVCMOS33 [get_ports UART_PL_1_rxd]


# add I2C and UART
#J10 ttyS3
 set_property PACKAGE_PIN N17 [get_ports IIC_PL_1_scl_io]
 set_property PACKAGE_PIN P18 [get_ports IIC_PL_1_sda_io]
 set_property PACKAGE_PIN R18 [get_ports UART_PL_7_rxd]
 set_property PACKAGE_PIN T17 [get_ports UART_PL_7_txd]
 #J12 ttyS7
 set_property PACKAGE_PIN P19 [get_ports IIC_PL_2_scl_io]
 set_property PACKAGE_PIN T20 [get_ports IIC_PL_2_sda_io]
 set_property PACKAGE_PIN P20 [get_ports UART_PL_5_rxd]
 set_property PACKAGE_PIN R19 [get_ports UART_PL_5_txd]
 #J7 ttyS1
 set_property PACKAGE_PIN V20 [get_ports IIC_PL_3_scl_io]
 set_property PACKAGE_PIN U20 [get_ports IIC_PL_3_sda_io]
 set_property PACKAGE_PIN U19 [get_ports UART_PL_6_rxd]
 set_property PACKAGE_PIN W16 [get_ports UART_PL_6_txd]
 
 set_property IOSTANDARD LVCMOS33 [get_ports IIC_PL_1_scl_io]
 set_property IOSTANDARD LVCMOS33 [get_ports IIC_PL_1_sda_io]
 set_property IOSTANDARD LVCMOS33 [get_ports UART_PL_5_rxd]
 set_property IOSTANDARD LVCMOS33 [get_ports UART_PL_5_txd]
 set_property IOSTANDARD LVCMOS33 [get_ports IIC_PL_2_scl_io]
 set_property IOSTANDARD LVCMOS33 [get_ports IIC_PL_2_sda_io]
 set_property IOSTANDARD LVCMOS33 [get_ports UART_PL_6_rxd]
 set_property IOSTANDARD LVCMOS33 [get_ports UART_PL_6_txd] 
 set_property IOSTANDARD LVCMOS33 [get_ports IIC_PL_3_scl_io]
 set_property IOSTANDARD LVCMOS33 [get_ports IIC_PL_3_sda_io]
 set_property IOSTANDARD LVCMOS33 [get_ports UART_PL_7_rxd]
 set_property IOSTANDARD LVCMOS33 [get_ports UART_PL_7_txd] 
 set_property PULLUP true [get_ports IIC_PL_1_scl_io]
 set_property PULLUP true [get_ports IIC_PL_1_sda_io]
 set_property PULLUP true [get_ports IIC_PL_2_scl_io]
 set_property PULLUP true [get_ports IIC_PL_2_sda_io]
 set_property PULLUP true [get_ports IIC_PL_3_scl_io]
 set_property PULLUP true [get_ports IIC_PL_3_sda_io]

# Example: set_property IOSTANDARD LVDS_25 [get_ports [list data_p* data_n*]]

