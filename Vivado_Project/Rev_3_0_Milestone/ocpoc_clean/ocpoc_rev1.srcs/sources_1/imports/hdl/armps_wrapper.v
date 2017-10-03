//Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2015.4 (win64) Build 1412921 Wed Nov 18 09:43:45 MST 2015
//Date        : Tue May 02 10:17:35 2017
//Host        : PC-201609051626 running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target armps_wrapper.bd
//Design      : armps_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module armps_wrapper
   (CAN_0_rx,
    CAN_0_tx,
    DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    UART_0_rxd,
    UART_0_txd,
    UART_1_baudoutn,
    UART_1_ctsn,
    UART_1_dcdn,
    UART_1_ddis,
    UART_1_dsrn,
    UART_1_dtrn,
    UART_1_out1n,
    UART_1_out2n,
    UART_1_ri,
    UART_1_rtsn,
    UART_1_rxd,
    UART_1_rxrdyn,
    UART_1_txd,
    UART_1_txrdyn,
    UART_2_baudoutn,
    UART_2_ctsn,
    UART_2_dcdn,
    UART_2_ddis,
    UART_2_dsrn,
    UART_2_dtrn,
    UART_2_out1n,
    UART_2_out2n,
    UART_2_ri,
    UART_2_rtsn,
    UART_2_rxd,
    UART_2_rxrdyn,
    UART_2_txd,
    UART_2_txrdyn,
    UART_baudoutn,
    UART_ctsn,
    UART_dcdn,
    UART_ddis,
    UART_dsrn,
    UART_dtrn,
    UART_out1n,
    UART_out2n,
    UART_ri,
    UART_rtsn,
    UART_rxd,
    UART_rxrdyn,
    UART_txd,
    UART_txrdyn,
    Vaux15_v_n,
    Vaux15_v_p,
    freeze,
    iic_0_scl_io,
    iic_0_sda_io,
    iic_1_scl_io,
    iic_1_sda_io,
    iic_2_scl_io,
    iic_2_sda_io,
    iic_3_scl_io,
    iic_3_sda_io,
    iic_rtl_scl_io,
    iic_rtl_sda_io,
    iic_scl_io,
    iic_sda_io,
    pulse_train_in,
    pwm_0,
    pwm_1,
    pwm_2,
    pwm_3,
    pwm_4,
    pwm_5,
    pwm_6,
    pwm_7,
    spi_0_io0_io,
    spi_0_io1_io,
    spi_0_sck_io,
    spi_0_ss1_o,
    spi_0_ss2_o,
    spi_0_ss_io,
    spi_1_io0_io,
    spi_1_io1_io,
    spi_1_sck_io,
    spi_1_ss1_o,
    spi_1_ss2_o,
    spi_1_ss_io,
    uart_rtl0_baudoutn,
    uart_rtl0_ctsn,
    uart_rtl0_dcdn,
    uart_rtl0_ddis,
    uart_rtl0_dsrn,
    uart_rtl0_dtrn,
    uart_rtl0_out1n,
    uart_rtl0_out2n,
    uart_rtl0_ri,
    uart_rtl0_rtsn,
    uart_rtl0_rxd,
    uart_rtl0_rxrdyn,
    uart_rtl0_txd,
    uart_rtl0_txrdyn,
    uart_rtl1_baudoutn,
    uart_rtl1_ctsn,
    uart_rtl1_dcdn,
    uart_rtl1_ddis,
    uart_rtl1_dsrn,
    uart_rtl1_dtrn,
    uart_rtl1_out1n,
    uart_rtl1_out2n,
    uart_rtl1_ri,
    uart_rtl1_rtsn,
    uart_rtl1_rxd,
    uart_rtl1_rxrdyn,
    uart_rtl1_txd,
    uart_rtl1_txrdyn,
    uart_rtl2_baudoutn,
    uart_rtl2_ctsn,
    uart_rtl2_dcdn,
    uart_rtl2_ddis,
    uart_rtl2_dsrn,
    uart_rtl2_dtrn,
    uart_rtl2_out1n,
    uart_rtl2_out2n,
    uart_rtl2_ri,
    uart_rtl2_rtsn,
    uart_rtl2_rxd,
    uart_rtl2_rxrdyn,
    uart_rtl2_txd,
    uart_rtl2_txrdyn,
    uart_rtl3_baudoutn,
    uart_rtl3_ctsn,
    uart_rtl3_dcdn,
    uart_rtl3_ddis,
    uart_rtl3_dsrn,
    uart_rtl3_dtrn,
    uart_rtl3_out1n,
    uart_rtl3_out2n,
    uart_rtl3_ri,
    uart_rtl3_rtsn,
    uart_rtl3_rxd,
    uart_rtl3_rxrdyn,
    uart_rtl3_txd,
    uart_rtl3_txrdyn,
    uart_rtl4_baudoutn,
    uart_rtl4_ctsn,
    uart_rtl4_dcdn,
    uart_rtl4_ddis,
    uart_rtl4_dsrn,
    uart_rtl4_dtrn,
    uart_rtl4_out1n,
    uart_rtl4_out2n,
    uart_rtl4_ri,
    uart_rtl4_rtsn,
    uart_rtl4_rxd,
    uart_rtl4_rxrdyn,
    uart_rtl4_txd,
    uart_rtl4_txrdyn);
  input CAN_0_rx;
  output CAN_0_tx;
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  input UART_0_rxd;
  output UART_0_txd;
  output UART_1_baudoutn;
  input UART_1_ctsn;
  input UART_1_dcdn;
  output UART_1_ddis;
  input UART_1_dsrn;
  output UART_1_dtrn;
  output UART_1_out1n;
  output UART_1_out2n;
  input UART_1_ri;
  output UART_1_rtsn;
  input UART_1_rxd;
  output UART_1_rxrdyn;
  output UART_1_txd;
  output UART_1_txrdyn;
  output UART_2_baudoutn;
  input UART_2_ctsn;
  input UART_2_dcdn;
  output UART_2_ddis;
  input UART_2_dsrn;
  output UART_2_dtrn;
  output UART_2_out1n;
  output UART_2_out2n;
  input UART_2_ri;
  output UART_2_rtsn;
  input UART_2_rxd;
  output UART_2_rxrdyn;
  output UART_2_txd;
  output UART_2_txrdyn;
  output UART_baudoutn;
  input UART_ctsn;
  input UART_dcdn;
  output UART_ddis;
  input UART_dsrn;
  output UART_dtrn;
  output UART_out1n;
  output UART_out2n;
  input UART_ri;
  output UART_rtsn;
  input UART_rxd;
  output UART_rxrdyn;
  output UART_txd;
  output UART_txrdyn;
  input Vaux15_v_n;
  input Vaux15_v_p;
  input freeze;
  inout iic_0_scl_io;
  inout iic_0_sda_io;
  inout iic_1_scl_io;
  inout iic_1_sda_io;
  inout iic_2_scl_io;
  inout iic_2_sda_io;
  inout iic_3_scl_io;
  inout iic_3_sda_io;
  inout iic_rtl_scl_io;
  inout iic_rtl_sda_io;
  inout iic_scl_io;
  inout iic_sda_io;
  input pulse_train_in;
  output pwm_0;
  output pwm_1;
  output pwm_2;
  output pwm_3;
  output pwm_4;
  output pwm_5;
  output pwm_6;
  output pwm_7;
  inout spi_0_io0_io;
  inout spi_0_io1_io;
  inout spi_0_sck_io;
  output spi_0_ss1_o;
  output spi_0_ss2_o;
  inout spi_0_ss_io;
  inout spi_1_io0_io;
  inout spi_1_io1_io;
  inout spi_1_sck_io;
  output spi_1_ss1_o;
  output spi_1_ss2_o;
  inout spi_1_ss_io;
  output uart_rtl0_baudoutn;
  input uart_rtl0_ctsn;
  input uart_rtl0_dcdn;
  output uart_rtl0_ddis;
  input uart_rtl0_dsrn;
  output uart_rtl0_dtrn;
  output uart_rtl0_out1n;
  output uart_rtl0_out2n;
  input uart_rtl0_ri;
  output uart_rtl0_rtsn;
  input uart_rtl0_rxd;
  output uart_rtl0_rxrdyn;
  output uart_rtl0_txd;
  output uart_rtl0_txrdyn;
  output uart_rtl1_baudoutn;
  input uart_rtl1_ctsn;
  input uart_rtl1_dcdn;
  output uart_rtl1_ddis;
  input uart_rtl1_dsrn;
  output uart_rtl1_dtrn;
  output uart_rtl1_out1n;
  output uart_rtl1_out2n;
  input uart_rtl1_ri;
  output uart_rtl1_rtsn;
  input uart_rtl1_rxd;
  output uart_rtl1_rxrdyn;
  output uart_rtl1_txd;
  output uart_rtl1_txrdyn;
  output uart_rtl2_baudoutn;
  input uart_rtl2_ctsn;
  input uart_rtl2_dcdn;
  output uart_rtl2_ddis;
  input uart_rtl2_dsrn;
  output uart_rtl2_dtrn;
  output uart_rtl2_out1n;
  output uart_rtl2_out2n;
  input uart_rtl2_ri;
  output uart_rtl2_rtsn;
  input uart_rtl2_rxd;
  output uart_rtl2_rxrdyn;
  output uart_rtl2_txd;
  output uart_rtl2_txrdyn;
  output uart_rtl3_baudoutn;
  input uart_rtl3_ctsn;
  input uart_rtl3_dcdn;
  output uart_rtl3_ddis;
  input uart_rtl3_dsrn;
  output uart_rtl3_dtrn;
  output uart_rtl3_out1n;
  output uart_rtl3_out2n;
  input uart_rtl3_ri;
  output uart_rtl3_rtsn;
  input uart_rtl3_rxd;
  output uart_rtl3_rxrdyn;
  output uart_rtl3_txd;
  output uart_rtl3_txrdyn;
  output uart_rtl4_baudoutn;
  input uart_rtl4_ctsn;
  input uart_rtl4_dcdn;
  output uart_rtl4_ddis;
  input uart_rtl4_dsrn;
  output uart_rtl4_dtrn;
  output uart_rtl4_out1n;
  output uart_rtl4_out2n;
  input uart_rtl4_ri;
  output uart_rtl4_rtsn;
  input uart_rtl4_rxd;
  output uart_rtl4_rxrdyn;
  output uart_rtl4_txd;
  output uart_rtl4_txrdyn;

  wire CAN_0_rx;
  wire CAN_0_tx;
  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire UART_0_rxd;
  wire UART_0_txd;
  wire UART_1_baudoutn;
  wire UART_1_ctsn;
  wire UART_1_dcdn;
  wire UART_1_ddis;
  wire UART_1_dsrn;
  wire UART_1_dtrn;
  wire UART_1_out1n;
  wire UART_1_out2n;
  wire UART_1_ri;
  wire UART_1_rtsn;
  wire UART_1_rxd;
  wire UART_1_rxrdyn;
  wire UART_1_txd;
  wire UART_1_txrdyn;
  wire UART_2_baudoutn;
  wire UART_2_ctsn;
  wire UART_2_dcdn;
  wire UART_2_ddis;
  wire UART_2_dsrn;
  wire UART_2_dtrn;
  wire UART_2_out1n;
  wire UART_2_out2n;
  wire UART_2_ri;
  wire UART_2_rtsn;
  wire UART_2_rxd;
  wire UART_2_rxrdyn;
  wire UART_2_txd;
  wire UART_2_txrdyn;
  wire UART_baudoutn;
  wire UART_ctsn;
  wire UART_dcdn;
  wire UART_ddis;
  wire UART_dsrn;
  wire UART_dtrn;
  wire UART_out1n;
  wire UART_out2n;
  wire UART_ri;
  wire UART_rtsn;
  wire UART_rxd;
  wire UART_rxrdyn;
  wire UART_txd;
  wire UART_txrdyn;
  wire Vaux15_v_n;
  wire Vaux15_v_p;
  wire freeze;
  wire iic_0_scl_i;
  wire iic_0_scl_io;
  wire iic_0_scl_o;
  wire iic_0_scl_t;
  wire iic_0_sda_i;
  wire iic_0_sda_io;
  wire iic_0_sda_o;
  wire iic_0_sda_t;
  wire iic_1_scl_i;
  wire iic_1_scl_io;
  wire iic_1_scl_o;
  wire iic_1_scl_t;
  wire iic_1_sda_i;
  wire iic_1_sda_io;
  wire iic_1_sda_o;
  wire iic_1_sda_t;
  wire iic_2_scl_i;
  wire iic_2_scl_io;
  wire iic_2_scl_o;
  wire iic_2_scl_t;
  wire iic_2_sda_i;
  wire iic_2_sda_io;
  wire iic_2_sda_o;
  wire iic_2_sda_t;
  wire iic_3_scl_i;
  wire iic_3_scl_io;
  wire iic_3_scl_o;
  wire iic_3_scl_t;
  wire iic_3_sda_i;
  wire iic_3_sda_io;
  wire iic_3_sda_o;
  wire iic_3_sda_t;
  wire iic_rtl_scl_i;
  wire iic_rtl_scl_io;
  wire iic_rtl_scl_o;
  wire iic_rtl_scl_t;
  wire iic_rtl_sda_i;
  wire iic_rtl_sda_io;
  wire iic_rtl_sda_o;
  wire iic_rtl_sda_t;
  wire iic_scl_i;
  wire iic_scl_io;
  wire iic_scl_o;
  wire iic_scl_t;
  wire iic_sda_i;
  wire iic_sda_io;
  wire iic_sda_o;
  wire iic_sda_t;
  wire pulse_train_in;
  wire pwm_0;
  wire pwm_1;
  wire pwm_2;
  wire pwm_3;
  wire pwm_4;
  wire pwm_5;
  wire pwm_6;
  wire pwm_7;
  wire spi_0_io0_i;
  wire spi_0_io0_io;
  wire spi_0_io0_o;
  wire spi_0_io0_t;
  wire spi_0_io1_i;
  wire spi_0_io1_io;
  wire spi_0_io1_o;
  wire spi_0_io1_t;
  wire spi_0_sck_i;
  wire spi_0_sck_io;
  wire spi_0_sck_o;
  wire spi_0_sck_t;
  wire spi_0_ss1_o;
  wire spi_0_ss2_o;
  wire spi_0_ss_i;
  wire spi_0_ss_io;
  wire spi_0_ss_o;
  wire spi_0_ss_t;
  wire spi_1_io0_i;
  wire spi_1_io0_io;
  wire spi_1_io0_o;
  wire spi_1_io0_t;
  wire spi_1_io1_i;
  wire spi_1_io1_io;
  wire spi_1_io1_o;
  wire spi_1_io1_t;
  wire spi_1_sck_i;
  wire spi_1_sck_io;
  wire spi_1_sck_o;
  wire spi_1_sck_t;
  wire spi_1_ss1_o;
  wire spi_1_ss2_o;
  wire spi_1_ss_i;
  wire spi_1_ss_io;
  wire spi_1_ss_o;
  wire spi_1_ss_t;
  wire uart_rtl0_baudoutn;
  wire uart_rtl0_ctsn;
  wire uart_rtl0_dcdn;
  wire uart_rtl0_ddis;
  wire uart_rtl0_dsrn;
  wire uart_rtl0_dtrn;
  wire uart_rtl0_out1n;
  wire uart_rtl0_out2n;
  wire uart_rtl0_ri;
  wire uart_rtl0_rtsn;
  wire uart_rtl0_rxd;
  wire uart_rtl0_rxrdyn;
  wire uart_rtl0_txd;
  wire uart_rtl0_txrdyn;
  wire uart_rtl1_baudoutn;
  wire uart_rtl1_ctsn;
  wire uart_rtl1_dcdn;
  wire uart_rtl1_ddis;
  wire uart_rtl1_dsrn;
  wire uart_rtl1_dtrn;
  wire uart_rtl1_out1n;
  wire uart_rtl1_out2n;
  wire uart_rtl1_ri;
  wire uart_rtl1_rtsn;
  wire uart_rtl1_rxd;
  wire uart_rtl1_rxrdyn;
  wire uart_rtl1_txd;
  wire uart_rtl1_txrdyn;
  wire uart_rtl2_baudoutn;
  wire uart_rtl2_ctsn;
  wire uart_rtl2_dcdn;
  wire uart_rtl2_ddis;
  wire uart_rtl2_dsrn;
  wire uart_rtl2_dtrn;
  wire uart_rtl2_out1n;
  wire uart_rtl2_out2n;
  wire uart_rtl2_ri;
  wire uart_rtl2_rtsn;
  wire uart_rtl2_rxd;
  wire uart_rtl2_rxrdyn;
  wire uart_rtl2_txd;
  wire uart_rtl2_txrdyn;
  wire uart_rtl3_baudoutn;
  wire uart_rtl3_ctsn;
  wire uart_rtl3_dcdn;
  wire uart_rtl3_ddis;
  wire uart_rtl3_dsrn;
  wire uart_rtl3_dtrn;
  wire uart_rtl3_out1n;
  wire uart_rtl3_out2n;
  wire uart_rtl3_ri;
  wire uart_rtl3_rtsn;
  wire uart_rtl3_rxd;
  wire uart_rtl3_rxrdyn;
  wire uart_rtl3_txd;
  wire uart_rtl3_txrdyn;
  wire uart_rtl4_baudoutn;
  wire uart_rtl4_ctsn;
  wire uart_rtl4_dcdn;
  wire uart_rtl4_ddis;
  wire uart_rtl4_dsrn;
  wire uart_rtl4_dtrn;
  wire uart_rtl4_out1n;
  wire uart_rtl4_out2n;
  wire uart_rtl4_ri;
  wire uart_rtl4_rtsn;
  wire uart_rtl4_rxd;
  wire uart_rtl4_rxrdyn;
  wire uart_rtl4_txd;
  wire uart_rtl4_txrdyn;

  armps armps_i
       (.CAN_0_rx(CAN_0_rx),
        .CAN_0_tx(CAN_0_tx),
        .DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .IIC_0_scl_i(iic_0_scl_i),
        .IIC_0_scl_o(iic_0_scl_o),
        .IIC_0_scl_t(iic_0_scl_t),
        .IIC_0_sda_i(iic_0_sda_i),
        .IIC_0_sda_o(iic_0_sda_o),
        .IIC_0_sda_t(iic_0_sda_t),
        .IIC_1_scl_i(iic_1_scl_i),
        .IIC_1_scl_o(iic_1_scl_o),
        .IIC_1_scl_t(iic_1_scl_t),
        .IIC_1_sda_i(iic_1_sda_i),
        .IIC_1_sda_o(iic_1_sda_o),
        .IIC_1_sda_t(iic_1_sda_t),
        .IIC_2_scl_i(iic_2_scl_i),
        .IIC_2_scl_o(iic_2_scl_o),
        .IIC_2_scl_t(iic_2_scl_t),
        .IIC_2_sda_i(iic_2_sda_i),
        .IIC_2_sda_o(iic_2_sda_o),
        .IIC_2_sda_t(iic_2_sda_t),
        .IIC_3_scl_i(iic_3_scl_i),
        .IIC_3_scl_o(iic_3_scl_o),
        .IIC_3_scl_t(iic_3_scl_t),
        .IIC_3_sda_i(iic_3_sda_i),
        .IIC_3_sda_o(iic_3_sda_o),
        .IIC_3_sda_t(iic_3_sda_t),
        .IIC_scl_i(iic_scl_i),
        .IIC_scl_o(iic_scl_o),
        .IIC_scl_t(iic_scl_t),
        .IIC_sda_i(iic_sda_i),
        .IIC_sda_o(iic_sda_o),
        .IIC_sda_t(iic_sda_t),
        .SPI_0_io0_i(spi_0_io0_i),
        .SPI_0_io0_o(spi_0_io0_o),
        .SPI_0_io0_t(spi_0_io0_t),
        .SPI_0_io1_i(spi_0_io1_i),
        .SPI_0_io1_o(spi_0_io1_o),
        .SPI_0_io1_t(spi_0_io1_t),
        .SPI_0_sck_i(spi_0_sck_i),
        .SPI_0_sck_o(spi_0_sck_o),
        .SPI_0_sck_t(spi_0_sck_t),
        .SPI_0_ss1_o(spi_0_ss1_o),
        .SPI_0_ss2_o(spi_0_ss2_o),
        .SPI_0_ss_i(spi_0_ss_i),
        .SPI_0_ss_o(spi_0_ss_o),
        .SPI_0_ss_t(spi_0_ss_t),
        .SPI_1_io0_i(spi_1_io0_i),
        .SPI_1_io0_o(spi_1_io0_o),
        .SPI_1_io0_t(spi_1_io0_t),
        .SPI_1_io1_i(spi_1_io1_i),
        .SPI_1_io1_o(spi_1_io1_o),
        .SPI_1_io1_t(spi_1_io1_t),
        .SPI_1_sck_i(spi_1_sck_i),
        .SPI_1_sck_o(spi_1_sck_o),
        .SPI_1_sck_t(spi_1_sck_t),
        .SPI_1_ss1_o(spi_1_ss1_o),
        .SPI_1_ss2_o(spi_1_ss2_o),
        .SPI_1_ss_i(spi_1_ss_i),
        .SPI_1_ss_o(spi_1_ss_o),
        .SPI_1_ss_t(spi_1_ss_t),
        .UART_0_rxd(UART_0_rxd),
        .UART_0_txd(UART_0_txd),
        .UART_1_baudoutn(UART_1_baudoutn),
        .UART_1_ctsn(UART_1_ctsn),
        .UART_1_dcdn(UART_1_dcdn),
        .UART_1_ddis(UART_1_ddis),
        .UART_1_dsrn(UART_1_dsrn),
        .UART_1_dtrn(UART_1_dtrn),
        .UART_1_out1n(UART_1_out1n),
        .UART_1_out2n(UART_1_out2n),
        .UART_1_ri(UART_1_ri),
        .UART_1_rtsn(UART_1_rtsn),
        .UART_1_rxd(UART_1_rxd),
        .UART_1_rxrdyn(UART_1_rxrdyn),
        .UART_1_txd(UART_1_txd),
        .UART_1_txrdyn(UART_1_txrdyn),
        .UART_2_baudoutn(UART_2_baudoutn),
        .UART_2_ctsn(UART_2_ctsn),
        .UART_2_dcdn(UART_2_dcdn),
        .UART_2_ddis(UART_2_ddis),
        .UART_2_dsrn(UART_2_dsrn),
        .UART_2_dtrn(UART_2_dtrn),
        .UART_2_out1n(UART_2_out1n),
        .UART_2_out2n(UART_2_out2n),
        .UART_2_ri(UART_2_ri),
        .UART_2_rtsn(UART_2_rtsn),
        .UART_2_rxd(UART_2_rxd),
        .UART_2_rxrdyn(UART_2_rxrdyn),
        .UART_2_txd(UART_2_txd),
        .UART_2_txrdyn(UART_2_txrdyn),
        .UART_baudoutn(UART_baudoutn),
        .UART_ctsn(UART_ctsn),
        .UART_dcdn(UART_dcdn),
        .UART_ddis(UART_ddis),
        .UART_dsrn(UART_dsrn),
        .UART_dtrn(UART_dtrn),
        .UART_out1n(UART_out1n),
        .UART_out2n(UART_out2n),
        .UART_ri(UART_ri),
        .UART_rtsn(UART_rtsn),
        .UART_rxd(UART_rxd),
        .UART_rxrdyn(UART_rxrdyn),
        .UART_txd(UART_txd),
        .UART_txrdyn(UART_txrdyn),
        .Vaux15_v_n(Vaux15_v_n),
        .Vaux15_v_p(Vaux15_v_p),
        .freeze(freeze),
        .iic_rtl_scl_i(iic_rtl_scl_i),
        .iic_rtl_scl_o(iic_rtl_scl_o),
        .iic_rtl_scl_t(iic_rtl_scl_t),
        .iic_rtl_sda_i(iic_rtl_sda_i),
        .iic_rtl_sda_o(iic_rtl_sda_o),
        .iic_rtl_sda_t(iic_rtl_sda_t),
        .pulse_train_in(pulse_train_in),
        .pwm_0(pwm_0),
        .pwm_1(pwm_1),
        .pwm_2(pwm_2),
        .pwm_3(pwm_3),
        .pwm_4(pwm_4),
        .pwm_5(pwm_5),
        .pwm_6(pwm_6),
        .pwm_7(pwm_7),
        .uart_rtl0_baudoutn(uart_rtl0_baudoutn),
        .uart_rtl0_ctsn(uart_rtl0_ctsn),
        .uart_rtl0_dcdn(uart_rtl0_dcdn),
        .uart_rtl0_ddis(uart_rtl0_ddis),
        .uart_rtl0_dsrn(uart_rtl0_dsrn),
        .uart_rtl0_dtrn(uart_rtl0_dtrn),
        .uart_rtl0_out1n(uart_rtl0_out1n),
        .uart_rtl0_out2n(uart_rtl0_out2n),
        .uart_rtl0_ri(uart_rtl0_ri),
        .uart_rtl0_rtsn(uart_rtl0_rtsn),
        .uart_rtl0_rxd(uart_rtl0_rxd),
        .uart_rtl0_rxrdyn(uart_rtl0_rxrdyn),
        .uart_rtl0_txd(uart_rtl0_txd),
        .uart_rtl0_txrdyn(uart_rtl0_txrdyn),
        .uart_rtl1_baudoutn(uart_rtl1_baudoutn),
        .uart_rtl1_ctsn(uart_rtl1_ctsn),
        .uart_rtl1_dcdn(uart_rtl1_dcdn),
        .uart_rtl1_ddis(uart_rtl1_ddis),
        .uart_rtl1_dsrn(uart_rtl1_dsrn),
        .uart_rtl1_dtrn(uart_rtl1_dtrn),
        .uart_rtl1_out1n(uart_rtl1_out1n),
        .uart_rtl1_out2n(uart_rtl1_out2n),
        .uart_rtl1_ri(uart_rtl1_ri),
        .uart_rtl1_rtsn(uart_rtl1_rtsn),
        .uart_rtl1_rxd(uart_rtl1_rxd),
        .uart_rtl1_rxrdyn(uart_rtl1_rxrdyn),
        .uart_rtl1_txd(uart_rtl1_txd),
        .uart_rtl1_txrdyn(uart_rtl1_txrdyn),
        .uart_rtl2_baudoutn(uart_rtl2_baudoutn),
        .uart_rtl2_ctsn(uart_rtl2_ctsn),
        .uart_rtl2_dcdn(uart_rtl2_dcdn),
        .uart_rtl2_ddis(uart_rtl2_ddis),
        .uart_rtl2_dsrn(uart_rtl2_dsrn),
        .uart_rtl2_dtrn(uart_rtl2_dtrn),
        .uart_rtl2_out1n(uart_rtl2_out1n),
        .uart_rtl2_out2n(uart_rtl2_out2n),
        .uart_rtl2_ri(uart_rtl2_ri),
        .uart_rtl2_rtsn(uart_rtl2_rtsn),
        .uart_rtl2_rxd(uart_rtl2_rxd),
        .uart_rtl2_rxrdyn(uart_rtl2_rxrdyn),
        .uart_rtl2_txd(uart_rtl2_txd),
        .uart_rtl2_txrdyn(uart_rtl2_txrdyn),
        .uart_rtl3_baudoutn(uart_rtl3_baudoutn),
        .uart_rtl3_ctsn(uart_rtl3_ctsn),
        .uart_rtl3_dcdn(uart_rtl3_dcdn),
        .uart_rtl3_ddis(uart_rtl3_ddis),
        .uart_rtl3_dsrn(uart_rtl3_dsrn),
        .uart_rtl3_dtrn(uart_rtl3_dtrn),
        .uart_rtl3_out1n(uart_rtl3_out1n),
        .uart_rtl3_out2n(uart_rtl3_out2n),
        .uart_rtl3_ri(uart_rtl3_ri),
        .uart_rtl3_rtsn(uart_rtl3_rtsn),
        .uart_rtl3_rxd(uart_rtl3_rxd),
        .uart_rtl3_rxrdyn(uart_rtl3_rxrdyn),
        .uart_rtl3_txd(uart_rtl3_txd),
        .uart_rtl3_txrdyn(uart_rtl3_txrdyn),
        .uart_rtl4_baudoutn(uart_rtl4_baudoutn),
        .uart_rtl4_ctsn(uart_rtl4_ctsn),
        .uart_rtl4_dcdn(uart_rtl4_dcdn),
        .uart_rtl4_ddis(uart_rtl4_ddis),
        .uart_rtl4_dsrn(uart_rtl4_dsrn),
        .uart_rtl4_dtrn(uart_rtl4_dtrn),
        .uart_rtl4_out1n(uart_rtl4_out1n),
        .uart_rtl4_out2n(uart_rtl4_out2n),
        .uart_rtl4_ri(uart_rtl4_ri),
        .uart_rtl4_rtsn(uart_rtl4_rtsn),
        .uart_rtl4_rxd(uart_rtl4_rxd),
        .uart_rtl4_rxrdyn(uart_rtl4_rxrdyn),
        .uart_rtl4_txd(uart_rtl4_txd),
        .uart_rtl4_txrdyn(uart_rtl4_txrdyn));
  IOBUF iic_0_scl_iobuf
       (.I(iic_0_scl_o),
        .IO(iic_0_scl_io),
        .O(iic_0_scl_i),
        .T(iic_0_scl_t));
  IOBUF iic_0_sda_iobuf
       (.I(iic_0_sda_o),
        .IO(iic_0_sda_io),
        .O(iic_0_sda_i),
        .T(iic_0_sda_t));
  IOBUF iic_1_scl_iobuf
       (.I(iic_1_scl_o),
        .IO(iic_1_scl_io),
        .O(iic_1_scl_i),
        .T(iic_1_scl_t));
  IOBUF iic_1_sda_iobuf
       (.I(iic_1_sda_o),
        .IO(iic_1_sda_io),
        .O(iic_1_sda_i),
        .T(iic_1_sda_t));
  IOBUF iic_2_scl_iobuf
       (.I(iic_2_scl_o),
        .IO(iic_2_scl_io),
        .O(iic_2_scl_i),
        .T(iic_2_scl_t));
  IOBUF iic_2_sda_iobuf
       (.I(iic_2_sda_o),
        .IO(iic_2_sda_io),
        .O(iic_2_sda_i),
        .T(iic_2_sda_t));
  IOBUF iic_3_scl_iobuf
       (.I(iic_3_scl_o),
        .IO(iic_3_scl_io),
        .O(iic_3_scl_i),
        .T(iic_3_scl_t));
  IOBUF iic_3_sda_iobuf
       (.I(iic_3_sda_o),
        .IO(iic_3_sda_io),
        .O(iic_3_sda_i),
        .T(iic_3_sda_t));
  IOBUF iic_rtl_scl_iobuf
       (.I(iic_rtl_scl_o),
        .IO(iic_rtl_scl_io),
        .O(iic_rtl_scl_i),
        .T(iic_rtl_scl_t));
  IOBUF iic_rtl_sda_iobuf
       (.I(iic_rtl_sda_o),
        .IO(iic_rtl_sda_io),
        .O(iic_rtl_sda_i),
        .T(iic_rtl_sda_t));
  IOBUF iic_scl_iobuf
       (.I(iic_scl_o),
        .IO(iic_scl_io),
        .O(iic_scl_i),
        .T(iic_scl_t));
  IOBUF iic_sda_iobuf
       (.I(iic_sda_o),
        .IO(iic_sda_io),
        .O(iic_sda_i),
        .T(iic_sda_t));
  IOBUF spi_0_io0_iobuf
       (.I(spi_0_io0_o),
        .IO(spi_0_io0_io),
        .O(spi_0_io0_i),
        .T(spi_0_io0_t));
  IOBUF spi_0_io1_iobuf
       (.I(spi_0_io1_o),
        .IO(spi_0_io1_io),
        .O(spi_0_io1_i),
        .T(spi_0_io1_t));
  IOBUF spi_0_sck_iobuf
       (.I(spi_0_sck_o),
        .IO(spi_0_sck_io),
        .O(spi_0_sck_i),
        .T(spi_0_sck_t));
  IOBUF spi_0_ss_iobuf
       (.I(spi_0_ss_o),
        .IO(spi_0_ss_io),
        .O(spi_0_ss_i),
        .T(spi_0_ss_t));
  IOBUF spi_1_io0_iobuf
       (.I(spi_1_io0_o),
        .IO(spi_1_io0_io),
        .O(spi_1_io0_i),
        .T(spi_1_io0_t));
  IOBUF spi_1_io1_iobuf
       (.I(spi_1_io1_o),
        .IO(spi_1_io1_io),
        .O(spi_1_io1_i),
        .T(spi_1_io1_t));
  IOBUF spi_1_sck_iobuf
       (.I(spi_1_sck_o),
        .IO(spi_1_sck_io),
        .O(spi_1_sck_i),
        .T(spi_1_sck_t));
  IOBUF spi_1_ss_iobuf
       (.I(spi_1_ss_o),
        .IO(spi_1_ss_io),
        .O(spi_1_ss_i),
        .T(spi_1_ss_t));
endmodule
