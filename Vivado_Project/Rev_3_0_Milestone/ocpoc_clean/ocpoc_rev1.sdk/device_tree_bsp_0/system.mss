
 PARAMETER VERSION = 2.2.0


BEGIN OS
 PARAMETER OS_NAME = device_tree
 PARAMETER PROC_INSTANCE = ps7_cortexa9_0
 PARAMETER bootargs = console=ttyPS1,115200 root=/dev/mmcblk0p2 rw rootwait rootfstype=ext4 noinitrd
 PARAMETER console_device = ps7_uart_0
 PARAMETER main_memory = ps7_ddr_0
END


BEGIN PROCESSOR
 PARAMETER DRIVER_NAME = cpu_cortexa9
 PARAMETER HW_INSTANCE = ps7_cortexa9_0
END


BEGIN DRIVER
 PARAMETER DRIVER_NAME = axi_iic
 PARAMETER HW_INSTANCE = axi_iic_0
 PARAMETER clock-names = ref_clk
 PARAMETER clocks = clkc 15
 PARAMETER interrupt-parent = intc
 PARAMETER interrupts = 0 29 4
 PARAMETER reg = 0x41600000 0x10000
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = axi_iic
 PARAMETER HW_INSTANCE = axi_iic_1
 PARAMETER clock-names = ref_clk
 PARAMETER clocks = clkc 15
 PARAMETER interrupt-parent = intc
 PARAMETER interrupts = 0 30 4
 PARAMETER reg = 0x41610000 0x10000
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = axi_iic
 PARAMETER HW_INSTANCE = axi_iic_2
 PARAMETER clock-names = ref_clk
 PARAMETER clocks = clkc 15
 PARAMETER interrupt-parent = intc
 PARAMETER interrupts = 0 31 4
 PARAMETER reg = 0x41620000 0x10000
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = axi_iic
 PARAMETER HW_INSTANCE = axi_iic_3
 PARAMETER clock-names = ref_clk
 PARAMETER clocks = clkc 15
 PARAMETER interrupt-parent = intc
 PARAMETER interrupts = 0 32 4
 PARAMETER reg = 0x41630000 0x10000
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = uartns
 PARAMETER HW_INSTANCE = axi_uart16550_0
 PARAMETER clock-names = ref_clk
 PARAMETER clocks = clkc 0
 PARAMETER interrupt-parent = intc
 PARAMETER interrupts = 0 34 4
 PARAMETER port-number = 1
 PARAMETER reg = 0x43c10000 0x10000
 PARAMETER xlnx,external-xin-clk-hz = 25000000
 PARAMETER xlnx,external-xin-clk-hz-d = 25
 PARAMETER xlnx,has-external-rclk = 0
 PARAMETER xlnx,has-external-xin = 0
 PARAMETER xlnx,is-a-16550 = 1
 PARAMETER xlnx,s-axi-aclk-freq-hz-d = 100.0
 PARAMETER xlnx,use-modem-ports = 1
 PARAMETER xlnx,use-user-ports = 1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = uartns
 PARAMETER HW_INSTANCE = axi_uart16550_1
 PARAMETER clock-names = ref_clk
 PARAMETER clocks = clkc 0
 PARAMETER interrupt-parent = intc
 PARAMETER interrupts = 0 35 4
 PARAMETER port-number = 2
 PARAMETER reg = 0x43c20000 0x10000
 PARAMETER xlnx,external-xin-clk-hz = 25000000
 PARAMETER xlnx,external-xin-clk-hz-d = 25
 PARAMETER xlnx,has-external-rclk = 0
 PARAMETER xlnx,has-external-xin = 0
 PARAMETER xlnx,is-a-16550 = 1
 PARAMETER xlnx,s-axi-aclk-freq-hz-d = 100.0
 PARAMETER xlnx,use-modem-ports = 1
 PARAMETER xlnx,use-user-ports = 1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = uartns
 PARAMETER HW_INSTANCE = axi_uart16550_2
 PARAMETER clock-names = ref_clk
 PARAMETER clocks = clkc 0
 PARAMETER interrupt-parent = intc
 PARAMETER interrupts = 0 56 4
 PARAMETER port-number = 3
 PARAMETER reg = 0x43c30000 0x10000
 PARAMETER xlnx,external-xin-clk-hz = 25000000
 PARAMETER xlnx,external-xin-clk-hz-d = 25
 PARAMETER xlnx,has-external-rclk = 0
 PARAMETER xlnx,has-external-xin = 0
 PARAMETER xlnx,is-a-16550 = 1
 PARAMETER xlnx,s-axi-aclk-freq-hz-d = 100.0
 PARAMETER xlnx,use-modem-ports = 1
 PARAMETER xlnx,use-user-ports = 1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = uartns
 PARAMETER HW_INSTANCE = axi_uart16550_3
 PARAMETER clock-names = ref_clk
 PARAMETER clocks = clkc 0
 PARAMETER interrupt-parent = intc
 PARAMETER interrupts = 0 36 4
 PARAMETER port-number = 4
 PARAMETER reg = 0x43c40000 0x10000
 PARAMETER xlnx,external-xin-clk-hz = 25000000
 PARAMETER xlnx,external-xin-clk-hz-d = 25
 PARAMETER xlnx,has-external-rclk = 0
 PARAMETER xlnx,has-external-xin = 0
 PARAMETER xlnx,is-a-16550 = 1
 PARAMETER xlnx,s-axi-aclk-freq-hz-d = 100.0
 PARAMETER xlnx,use-modem-ports = 1
 PARAMETER xlnx,use-user-ports = 1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = uartns
 PARAMETER HW_INSTANCE = axi_uart16550_4
 PARAMETER clock-names = ref_clk
 PARAMETER clocks = clkc 0
 PARAMETER interrupt-parent = intc
 PARAMETER interrupts = 0 52 4
 PARAMETER port-number = 5
 PARAMETER reg = 0x43c60000 0x10000
 PARAMETER xlnx,external-xin-clk-hz = 25000000
 PARAMETER xlnx,external-xin-clk-hz-d = 25
 PARAMETER xlnx,has-external-rclk = 0
 PARAMETER xlnx,has-external-xin = 0
 PARAMETER xlnx,is-a-16550 = 1
 PARAMETER xlnx,s-axi-aclk-freq-hz-d = 100.0
 PARAMETER xlnx,use-modem-ports = 1
 PARAMETER xlnx,use-user-ports = 1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = uartns
 PARAMETER HW_INSTANCE = axi_uart16550_5
 PARAMETER clock-names = ref_clk
 PARAMETER clocks = clkc 0
 PARAMETER interrupt-parent = intc
 PARAMETER interrupts = 0 53 4
 PARAMETER port-number = 6
 PARAMETER reg = 0x43c70000 0x10000
 PARAMETER xlnx,external-xin-clk-hz = 25000000
 PARAMETER xlnx,external-xin-clk-hz-d = 25
 PARAMETER xlnx,has-external-rclk = 0
 PARAMETER xlnx,has-external-xin = 0
 PARAMETER xlnx,is-a-16550 = 1
 PARAMETER xlnx,s-axi-aclk-freq-hz-d = 100.0
 PARAMETER xlnx,use-modem-ports = 1
 PARAMETER xlnx,use-user-ports = 1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = uartns
 PARAMETER HW_INSTANCE = axi_uart16550_6
 PARAMETER clock-names = ref_clk
 PARAMETER clocks = clkc 0
 PARAMETER interrupt-parent = intc
 PARAMETER interrupts = 0 54 4
 PARAMETER port-number = 7
 PARAMETER reg = 0x43c80000 0x10000
 PARAMETER xlnx,external-xin-clk-hz = 25000000
 PARAMETER xlnx,external-xin-clk-hz-d = 25
 PARAMETER xlnx,has-external-rclk = 0
 PARAMETER xlnx,has-external-xin = 0
 PARAMETER xlnx,is-a-16550 = 1
 PARAMETER xlnx,s-axi-aclk-freq-hz-d = 100.0
 PARAMETER xlnx,use-modem-ports = 1
 PARAMETER xlnx,use-user-ports = 1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = uartns
 PARAMETER HW_INSTANCE = axi_uart16550_7
 PARAMETER clock-names = ref_clk
 PARAMETER clocks = clkc 0
 PARAMETER interrupt-parent = intc
 PARAMETER interrupts = 0 55 4
 PARAMETER port-number = 8
 PARAMETER reg = 0x43c90000 0x10000
 PARAMETER xlnx,external-xin-clk-hz = 25000000
 PARAMETER xlnx,external-xin-clk-hz-d = 25
 PARAMETER xlnx,has-external-rclk = 0
 PARAMETER xlnx,has-external-xin = 0
 PARAMETER xlnx,is-a-16550 = 1
 PARAMETER xlnx,s-axi-aclk-freq-hz-d = 100.0
 PARAMETER xlnx,use-modem-ports = 1
 PARAMETER xlnx,use-user-ports = 1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ps7_afi_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ps7_afi_1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ps7_afi_2
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ps7_afi_3
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = canps
 PARAMETER HW_INSTANCE = ps7_can_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ps7_coresight_comp_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = ddrps
 PARAMETER HW_INSTANCE = ps7_ddr_0
 PARAMETER reg = 0x0 0x20000000
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = ddrcps
 PARAMETER HW_INSTANCE = ps7_ddrc_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = devcfg
 PARAMETER HW_INSTANCE = ps7_dev_cfg_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = none
 PARAMETER HW_INSTANCE = ps7_dma_ns
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = dmaps
 PARAMETER HW_INSTANCE = ps7_dma_s
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = emacps
 PARAMETER HW_INSTANCE = ps7_ethernet_0
 PARAMETER phy-mode = rgmii-id
 PARAMETER xlnx,ptp-enet-clock = 111111115
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = globaltimerps
 PARAMETER HW_INSTANCE = ps7_globaltimer_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = gpiops
 PARAMETER HW_INSTANCE = ps7_gpio_0
 PARAMETER emio-gpio-width = 64
 PARAMETER gpio-mask-high = 0
 PARAMETER gpio-mask-low = 22016
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ps7_gpv_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = iicps
 PARAMETER HW_INSTANCE = ps7_i2c_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = iicps
 PARAMETER HW_INSTANCE = ps7_i2c_1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ps7_intc_dist_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ps7_iop_bus_config_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ps7_l2cachec_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = ocmcps
 PARAMETER HW_INSTANCE = ps7_ocmc_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = pl310ps
 PARAMETER HW_INSTANCE = ps7_pl310_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = pmups
 PARAMETER HW_INSTANCE = ps7_pmu_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = qspips
 PARAMETER HW_INSTANCE = ps7_qspi_0
 PARAMETER is-dual = 0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ps7_qspi_linear_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = ramps
 PARAMETER HW_INSTANCE = ps7_ram_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = none
 PARAMETER HW_INSTANCE = ps7_ram_1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ps7_scuc_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = scugic
 PARAMETER HW_INSTANCE = ps7_scugic_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = scutimer
 PARAMETER HW_INSTANCE = ps7_scutimer_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = scuwdt
 PARAMETER HW_INSTANCE = ps7_scuwdt_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = ps7_sd_0
 PARAMETER xlnx,has-cd = 0
 PARAMETER xlnx,has-power = 0
 PARAMETER xlnx,has-wp = 0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = slcrps
 PARAMETER HW_INSTANCE = ps7_slcr_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = spips
 PARAMETER HW_INSTANCE = ps7_spi_0
 PARAMETER num-cs = 3
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = spips
 PARAMETER HW_INSTANCE = ps7_spi_1
 PARAMETER num-cs = 3
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = ttcps
 PARAMETER HW_INSTANCE = ps7_ttc_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = ttcps
 PARAMETER HW_INSTANCE = ps7_ttc_1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = uartps
 PARAMETER HW_INSTANCE = ps7_uart_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = uartps
 PARAMETER HW_INSTANCE = ps7_uart_1
 PARAMETER port-number = 9
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = usbps
 PARAMETER HW_INSTANCE = ps7_usb_0
 PARAMETER phy_type = ulpi
 PARAMETER usb-reset = gpio0 46 0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = wdtps
 PARAMETER HW_INSTANCE = ps7_wdt_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = xadcps
 PARAMETER HW_INSTANCE = ps7_xadc_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = axi_xadc
 PARAMETER HW_INSTANCE = xadc_wiz_0
 PARAMETER clock-names = ref_clk
 PARAMETER clocks = clkc 0
 PARAMETER compatible = xlnx,axi-xadc-1.00.a
 PARAMETER interrupt-parent = intc
 PARAMETER interrupts = 0 33 4
 PARAMETER reg = 0x43c50000 0x10000
 PARAMETER xlnx,alarm-limit-r0 = 46573
 PARAMETER xlnx,alarm-limit-r1 = 22500
 PARAMETER xlnx,alarm-limit-r10 = 21845
 PARAMETER xlnx,alarm-limit-r11 = 20753
 PARAMETER xlnx,alarm-limit-r12 = 39321
 PARAMETER xlnx,alarm-limit-r13 = 37355
 PARAMETER xlnx,alarm-limit-r14 = 27306
 PARAMETER xlnx,alarm-limit-r15 = 26214
 PARAMETER xlnx,alarm-limit-r2 = 41287
 PARAMETER xlnx,alarm-limit-r3 = 51763
 PARAMETER xlnx,alarm-limit-r4 = 43322
 PARAMETER xlnx,alarm-limit-r5 = 21190
 PARAMETER xlnx,alarm-limit-r6 = 38229
 PARAMETER xlnx,alarm-limit-r7 = 44622
 PARAMETER xlnx,alarm-limit-r8 = 22937
 PARAMETER xlnx,alarm-limit-r9 = 20753
 PARAMETER xlnx,configuration-r0 = 0
 PARAMETER xlnx,configuration-r1 = 8448
 PARAMETER xlnx,configuration-r2 = 512
 PARAMETER xlnx,dclk-frequency = 50
 PARAMETER xlnx,external-mux = none
 PARAMETER xlnx,external-mux-channel = VP_VN
 PARAMETER xlnx,external-muxaddr-enable = 0
 PARAMETER xlnx,fifo-depth = 7
 PARAMETER xlnx,has-axi = 1
 PARAMETER xlnx,has-axi4stream = 0
 PARAMETER xlnx,has-busy = 1
 PARAMETER xlnx,has-channel = 1
 PARAMETER xlnx,has-convst = 0
 PARAMETER xlnx,has-convstclk = 0
 PARAMETER xlnx,has-dclk = 1
 PARAMETER xlnx,has-drp = 0
 PARAMETER xlnx,has-eoc = 1
 PARAMETER xlnx,has-eos = 1
 PARAMETER xlnx,has-external-mux = 0
 PARAMETER xlnx,has-jtagbusy = 0
 PARAMETER xlnx,has-jtaglocked = 0
 PARAMETER xlnx,has-jtagmodified = 0
 PARAMETER xlnx,has-ot-alarm = 1
 PARAMETER xlnx,has-reset = 0
 PARAMETER xlnx,has-temp-bus = 0
 PARAMETER xlnx,has-user-temp-alarm = 1
 PARAMETER xlnx,has-vbram-alarm = 0
 PARAMETER xlnx,has-vccaux-alarm = 1
 PARAMETER xlnx,has-vccddro-alarm = 1
 PARAMETER xlnx,has-vccint-alarm = 1
 PARAMETER xlnx,has-vccpaux-alarm = 1
 PARAMETER xlnx,has-vccpint-alarm = 1
 PARAMETER xlnx,has-vn = 1
 PARAMETER xlnx,has-vp = 1
 PARAMETER xlnx,include-intr = 1
 PARAMETER xlnx,sampling-rate = 961538.4615384615
 PARAMETER xlnx,sequence-r0 = 257
 PARAMETER xlnx,sequence-r1 = 32768
 PARAMETER xlnx,sequence-r2 = 256
 PARAMETER xlnx,sequence-r3 = 32768
 PARAMETER xlnx,sequence-r4 = 0
 PARAMETER xlnx,sequence-r5 = 0
 PARAMETER xlnx,sequence-r6 = 0
 PARAMETER xlnx,sequence-r7 = 32768
 PARAMETER xlnx,sim-file-name = design
 PARAMETER xlnx,sim-file-rel-path = ./
 PARAMETER xlnx,sim-file-sel = Default
 PARAMETER xlnx,vaux0 = 0
 PARAMETER xlnx,vaux1 = 0
 PARAMETER xlnx,vaux10 = 0
 PARAMETER xlnx,vaux11 = 0
 PARAMETER xlnx,vaux12 = 0
 PARAMETER xlnx,vaux13 = 0
 PARAMETER xlnx,vaux14 = 0
 PARAMETER xlnx,vaux15 = 1
 PARAMETER xlnx,vaux2 = 0
 PARAMETER xlnx,vaux3 = 0
 PARAMETER xlnx,vaux4 = 0
 PARAMETER xlnx,vaux5 = 0
 PARAMETER xlnx,vaux6 = 0
 PARAMETER xlnx,vaux7 = 0
 PARAMETER xlnx,vaux8 = 0
 PARAMETER xlnx,vaux9 = 0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = RC_Receiver_Input_0
 PARAMETER compatible = xlnx,RC-Receiver-Input-1.1
 PARAMETER reg = 0x43ca0000 0x10000
 PARAMETER xlnx,s00-axi-addr-width = 4
 PARAMETER xlnx,s00-axi-data-width = 32
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER HW_INSTANCE = AXI_OcPoC_PWM_Controller_0
 PARAMETER compatible = xlnx,AXI-OcPoC-PWM-Controller-1.0
 PARAMETER reg = 0x43c00000 0x10000
 PARAMETER xlnx,s00-axi-addr-width = 7
 PARAMETER xlnx,s00-axi-data-width = 32
END


