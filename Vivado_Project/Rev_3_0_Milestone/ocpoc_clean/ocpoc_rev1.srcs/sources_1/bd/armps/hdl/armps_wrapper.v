//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.2_sdx (lin64) Build 1972098 Wed Aug 23 11:34:38 MDT 2017
//Date        : Fri Dec  1 14:38:33 2017
//Host        : aerotennaKS running 64-bit unknown
//Command     : generate_target armps_wrapper.bd
//Design      : armps_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module armps_wrapper
   (CAN_PS_0_rx,
    CAN_PS_0_tx,
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
    UART_PL_0_baudoutn,
    UART_PL_0_ddis,
    UART_PL_0_dtrn,
    UART_PL_0_out1n,
    UART_PL_0_out2n,
    UART_PL_0_rtsn,
    UART_PL_0_rxd,
    UART_PL_0_rxrdyn,
    UART_PL_0_txd,
    UART_PL_0_txrdyn,
    UART_PL_1_baudoutn,
    UART_PL_1_ddis,
    UART_PL_1_dtrn,
    UART_PL_1_out1n,
    UART_PL_1_out2n,
    UART_PL_1_rtsn,
    UART_PL_1_rxd,
    UART_PL_1_rxrdyn,
    UART_PL_1_txd,
    UART_PL_1_txrdyn,
    UART_PL_2_baudoutn,
    UART_PL_2_ddis,
    UART_PL_2_dtrn,
    UART_PL_2_out1n,
    UART_PL_2_out2n,
    UART_PL_2_rtsn,
    UART_PL_2_rxd,
    UART_PL_2_rxrdyn,
    UART_PL_2_txd,
    UART_PL_2_txrdyn,
    UART_PL_3_baudoutn,
    UART_PL_3_ddis,
    UART_PL_3_dtrn,
    UART_PL_3_out1n,
    UART_PL_3_out2n,
    UART_PL_3_rtsn,
    UART_PL_3_rxd,
    UART_PL_3_rxrdyn,
    UART_PL_3_txd,
    UART_PL_3_txrdyn,
    UART_PL_4_baudoutn,
    UART_PL_4_ddis,
    UART_PL_4_dtrn,
    UART_PL_4_out1n,
    UART_PL_4_out2n,
    UART_PL_4_rtsn,
    UART_PL_4_rxd,
    UART_PL_4_rxrdyn,
    UART_PL_4_txd,
    UART_PL_4_txrdyn,
    UART_PL_5_baudoutn,
    UART_PL_5_ddis,
    UART_PL_5_dtrn,
    UART_PL_5_out1n,
    UART_PL_5_out2n,
    UART_PL_5_rtsn,
    UART_PL_5_rxd,
    UART_PL_5_rxrdyn,
    UART_PL_5_txd,
    UART_PL_5_txrdyn,
    UART_PL_6_baudoutn,
    UART_PL_6_ddis,
    UART_PL_6_dtrn,
    UART_PL_6_out1n,
    UART_PL_6_out2n,
    UART_PL_6_rtsn,
    UART_PL_6_rxd,
    UART_PL_6_rxrdyn,
    UART_PL_6_txd,
    UART_PL_6_txrdyn,
    UART_PL_7_baudoutn,
    UART_PL_7_ddis,
    UART_PL_7_dtrn,
    UART_PL_7_out1n,
    UART_PL_7_out2n,
    UART_PL_7_rtsn,
    UART_PL_7_rxd,
    UART_PL_7_rxrdyn,
    UART_PL_7_txd,
    UART_PL_7_txrdyn,
    UART_PS_0_rxd,
    UART_PS_0_txd,
    Vaux15_v_n,
    Vaux15_v_p,
    iic_pl_0_scl_io,
    iic_pl_0_sda_io,
    iic_pl_1_scl_io,
    iic_pl_1_sda_io,
    iic_pl_2_scl_io,
    iic_pl_2_sda_io,
    iic_pl_3_scl_io,
    iic_pl_3_sda_io,
    iic_ps_0_scl_io,
    iic_ps_0_sda_io,
    iic_ps_1_scl_io,
    iic_ps_1_sda_io,
    pulse_train_in,
    pwm_0,
    pwm_1,
    pwm_10,
    pwm_11,
    pwm_2,
    pwm_3,
    pwm_4,
    pwm_5,
    pwm_6,
    pwm_7,
    pwm_8,
    pwm_9,
    spi_ps_0_io0_io,
    spi_ps_0_io1_io,
    spi_ps_0_sck_io,
    spi_ps_0_ss1_o,
    spi_ps_0_ss2_o,
    spi_ps_0_ss_io,
    spi_ps_1_io0_io,
    spi_ps_1_io1_io,
    spi_ps_1_sck_io,
    spi_ps_1_ss1_o,
    spi_ps_1_ss2_o,
    spi_ps_1_ss_io);
  input CAN_PS_0_rx;
  output CAN_PS_0_tx;
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
  output UART_PL_0_baudoutn;
  output UART_PL_0_ddis;
  output UART_PL_0_dtrn;
  output UART_PL_0_out1n;
  output UART_PL_0_out2n;
  output UART_PL_0_rtsn;
  input UART_PL_0_rxd;
  output UART_PL_0_rxrdyn;
  output UART_PL_0_txd;
  output UART_PL_0_txrdyn;
  output UART_PL_1_baudoutn;
  output UART_PL_1_ddis;
  output UART_PL_1_dtrn;
  output UART_PL_1_out1n;
  output UART_PL_1_out2n;
  output UART_PL_1_rtsn;
  input UART_PL_1_rxd;
  output UART_PL_1_rxrdyn;
  output UART_PL_1_txd;
  output UART_PL_1_txrdyn;
  output UART_PL_2_baudoutn;
  output UART_PL_2_ddis;
  output UART_PL_2_dtrn;
  output UART_PL_2_out1n;
  output UART_PL_2_out2n;
  output UART_PL_2_rtsn;
  input UART_PL_2_rxd;
  output UART_PL_2_rxrdyn;
  output UART_PL_2_txd;
  output UART_PL_2_txrdyn;
  output UART_PL_3_baudoutn;
  output UART_PL_3_ddis;
  output UART_PL_3_dtrn;
  output UART_PL_3_out1n;
  output UART_PL_3_out2n;
  output UART_PL_3_rtsn;
  input UART_PL_3_rxd;
  output UART_PL_3_rxrdyn;
  output UART_PL_3_txd;
  output UART_PL_3_txrdyn;
  output UART_PL_4_baudoutn;
  output UART_PL_4_ddis;
  output UART_PL_4_dtrn;
  output UART_PL_4_out1n;
  output UART_PL_4_out2n;
  output UART_PL_4_rtsn;
  input UART_PL_4_rxd;
  output UART_PL_4_rxrdyn;
  output UART_PL_4_txd;
  output UART_PL_4_txrdyn;
  output UART_PL_5_baudoutn;
  output UART_PL_5_ddis;
  output UART_PL_5_dtrn;
  output UART_PL_5_out1n;
  output UART_PL_5_out2n;
  output UART_PL_5_rtsn;
  input UART_PL_5_rxd;
  output UART_PL_5_rxrdyn;
  output UART_PL_5_txd;
  output UART_PL_5_txrdyn;
  output UART_PL_6_baudoutn;
  output UART_PL_6_ddis;
  output UART_PL_6_dtrn;
  output UART_PL_6_out1n;
  output UART_PL_6_out2n;
  output UART_PL_6_rtsn;
  input UART_PL_6_rxd;
  output UART_PL_6_rxrdyn;
  output UART_PL_6_txd;
  output UART_PL_6_txrdyn;
  output UART_PL_7_baudoutn;
  output UART_PL_7_ddis;
  output UART_PL_7_dtrn;
  output UART_PL_7_out1n;
  output UART_PL_7_out2n;
  output UART_PL_7_rtsn;
  input UART_PL_7_rxd;
  output UART_PL_7_rxrdyn;
  output UART_PL_7_txd;
  output UART_PL_7_txrdyn;
  input UART_PS_0_rxd;
  output UART_PS_0_txd;
  input Vaux15_v_n;
  input Vaux15_v_p;
  inout iic_pl_0_scl_io;
  inout iic_pl_0_sda_io;
  inout iic_pl_1_scl_io;
  inout iic_pl_1_sda_io;
  inout iic_pl_2_scl_io;
  inout iic_pl_2_sda_io;
  inout iic_pl_3_scl_io;
  inout iic_pl_3_sda_io;
  inout iic_ps_0_scl_io;
  inout iic_ps_0_sda_io;
  inout iic_ps_1_scl_io;
  inout iic_ps_1_sda_io;
  input pulse_train_in;
  output pwm_0;
  output pwm_1;
  output pwm_10;
  output pwm_11;
  output pwm_2;
  output pwm_3;
  output pwm_4;
  output pwm_5;
  output pwm_6;
  output pwm_7;
  output pwm_8;
  output pwm_9;
  inout spi_ps_0_io0_io;
  inout spi_ps_0_io1_io;
  inout spi_ps_0_sck_io;
  output spi_ps_0_ss1_o;
  output spi_ps_0_ss2_o;
  inout spi_ps_0_ss_io;
  inout spi_ps_1_io0_io;
  inout spi_ps_1_io1_io;
  inout spi_ps_1_sck_io;
  output spi_ps_1_ss1_o;
  output spi_ps_1_ss2_o;
  inout spi_ps_1_ss_io;

  wire CAN_PS_0_rx;
  wire CAN_PS_0_tx;
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
  wire UART_PL_0_baudoutn;
  wire UART_PL_0_ddis;
  wire UART_PL_0_dtrn;
  wire UART_PL_0_out1n;
  wire UART_PL_0_out2n;
  wire UART_PL_0_rtsn;
  wire UART_PL_0_rxd;
  wire UART_PL_0_rxrdyn;
  wire UART_PL_0_txd;
  wire UART_PL_0_txrdyn;
  wire UART_PL_1_baudoutn;
  wire UART_PL_1_ddis;
  wire UART_PL_1_dtrn;
  wire UART_PL_1_out1n;
  wire UART_PL_1_out2n;
  wire UART_PL_1_rtsn;
  wire UART_PL_1_rxd;
  wire UART_PL_1_rxrdyn;
  wire UART_PL_1_txd;
  wire UART_PL_1_txrdyn;
  wire UART_PL_2_baudoutn;
  wire UART_PL_2_ddis;
  wire UART_PL_2_dtrn;
  wire UART_PL_2_out1n;
  wire UART_PL_2_out2n;
  wire UART_PL_2_rtsn;
  wire UART_PL_2_rxd;
  wire UART_PL_2_rxrdyn;
  wire UART_PL_2_txd;
  wire UART_PL_2_txrdyn;
  wire UART_PL_3_baudoutn;
  wire UART_PL_3_ddis;
  wire UART_PL_3_dtrn;
  wire UART_PL_3_out1n;
  wire UART_PL_3_out2n;
  wire UART_PL_3_rtsn;
  wire UART_PL_3_rxd;
  wire UART_PL_3_rxrdyn;
  wire UART_PL_3_txd;
  wire UART_PL_3_txrdyn;
  wire UART_PL_4_baudoutn;
  wire UART_PL_4_ddis;
  wire UART_PL_4_dtrn;
  wire UART_PL_4_out1n;
  wire UART_PL_4_out2n;
  wire UART_PL_4_rtsn;
  wire UART_PL_4_rxd;
  wire UART_PL_4_rxrdyn;
  wire UART_PL_4_txd;
  wire UART_PL_4_txrdyn;
  wire UART_PL_5_baudoutn;
  wire UART_PL_5_ddis;
  wire UART_PL_5_dtrn;
  wire UART_PL_5_out1n;
  wire UART_PL_5_out2n;
  wire UART_PL_5_rtsn;
  wire UART_PL_5_rxd;
  wire UART_PL_5_rxrdyn;
  wire UART_PL_5_txd;
  wire UART_PL_5_txrdyn;
  wire UART_PL_6_baudoutn;
  wire UART_PL_6_ddis;
  wire UART_PL_6_dtrn;
  wire UART_PL_6_out1n;
  wire UART_PL_6_out2n;
  wire UART_PL_6_rtsn;
  wire UART_PL_6_rxd;
  wire UART_PL_6_rxrdyn;
  wire UART_PL_6_txd;
  wire UART_PL_6_txrdyn;
  wire UART_PL_7_baudoutn;
  wire UART_PL_7_ddis;
  wire UART_PL_7_dtrn;
  wire UART_PL_7_out1n;
  wire UART_PL_7_out2n;
  wire UART_PL_7_rtsn;
  wire UART_PL_7_rxd;
  wire UART_PL_7_rxrdyn;
  wire UART_PL_7_txd;
  wire UART_PL_7_txrdyn;
  wire UART_PS_0_rxd;
  wire UART_PS_0_txd;
  wire Vaux15_v_n;
  wire Vaux15_v_p;
  wire iic_pl_0_scl_i;
  wire iic_pl_0_scl_io;
  wire iic_pl_0_scl_o;
  wire iic_pl_0_scl_t;
  wire iic_pl_0_sda_i;
  wire iic_pl_0_sda_io;
  wire iic_pl_0_sda_o;
  wire iic_pl_0_sda_t;
  wire iic_pl_1_scl_i;
  wire iic_pl_1_scl_io;
  wire iic_pl_1_scl_o;
  wire iic_pl_1_scl_t;
  wire iic_pl_1_sda_i;
  wire iic_pl_1_sda_io;
  wire iic_pl_1_sda_o;
  wire iic_pl_1_sda_t;
  wire iic_pl_2_scl_i;
  wire iic_pl_2_scl_io;
  wire iic_pl_2_scl_o;
  wire iic_pl_2_scl_t;
  wire iic_pl_2_sda_i;
  wire iic_pl_2_sda_io;
  wire iic_pl_2_sda_o;
  wire iic_pl_2_sda_t;
  wire iic_pl_3_scl_i;
  wire iic_pl_3_scl_io;
  wire iic_pl_3_scl_o;
  wire iic_pl_3_scl_t;
  wire iic_pl_3_sda_i;
  wire iic_pl_3_sda_io;
  wire iic_pl_3_sda_o;
  wire iic_pl_3_sda_t;
  wire iic_ps_0_scl_i;
  wire iic_ps_0_scl_io;
  wire iic_ps_0_scl_o;
  wire iic_ps_0_scl_t;
  wire iic_ps_0_sda_i;
  wire iic_ps_0_sda_io;
  wire iic_ps_0_sda_o;
  wire iic_ps_0_sda_t;
  wire iic_ps_1_scl_i;
  wire iic_ps_1_scl_io;
  wire iic_ps_1_scl_o;
  wire iic_ps_1_scl_t;
  wire iic_ps_1_sda_i;
  wire iic_ps_1_sda_io;
  wire iic_ps_1_sda_o;
  wire iic_ps_1_sda_t;
  wire pulse_train_in;
  wire pwm_0;
  wire pwm_1;
  wire pwm_10;
  wire pwm_11;
  wire pwm_2;
  wire pwm_3;
  wire pwm_4;
  wire pwm_5;
  wire pwm_6;
  wire pwm_7;
  wire pwm_8;
  wire pwm_9;
  wire spi_ps_0_io0_i;
  wire spi_ps_0_io0_io;
  wire spi_ps_0_io0_o;
  wire spi_ps_0_io0_t;
  wire spi_ps_0_io1_i;
  wire spi_ps_0_io1_io;
  wire spi_ps_0_io1_o;
  wire spi_ps_0_io1_t;
  wire spi_ps_0_sck_i;
  wire spi_ps_0_sck_io;
  wire spi_ps_0_sck_o;
  wire spi_ps_0_sck_t;
  wire spi_ps_0_ss1_o;
  wire spi_ps_0_ss2_o;
  wire spi_ps_0_ss_i;
  wire spi_ps_0_ss_io;
  wire spi_ps_0_ss_o;
  wire spi_ps_0_ss_t;
  wire spi_ps_1_io0_i;
  wire spi_ps_1_io0_io;
  wire spi_ps_1_io0_o;
  wire spi_ps_1_io0_t;
  wire spi_ps_1_io1_i;
  wire spi_ps_1_io1_io;
  wire spi_ps_1_io1_o;
  wire spi_ps_1_io1_t;
  wire spi_ps_1_sck_i;
  wire spi_ps_1_sck_io;
  wire spi_ps_1_sck_o;
  wire spi_ps_1_sck_t;
  wire spi_ps_1_ss1_o;
  wire spi_ps_1_ss2_o;
  wire spi_ps_1_ss_i;
  wire spi_ps_1_ss_io;
  wire spi_ps_1_ss_o;
  wire spi_ps_1_ss_t;

  armps armps_i
       (.CAN_PS_0_rx(CAN_PS_0_rx),
        .CAN_PS_0_tx(CAN_PS_0_tx),
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
        .IIC_PL_0_scl_i(iic_pl_0_scl_i),
        .IIC_PL_0_scl_o(iic_pl_0_scl_o),
        .IIC_PL_0_scl_t(iic_pl_0_scl_t),
        .IIC_PL_0_sda_i(iic_pl_0_sda_i),
        .IIC_PL_0_sda_o(iic_pl_0_sda_o),
        .IIC_PL_0_sda_t(iic_pl_0_sda_t),
        .IIC_PL_1_scl_i(iic_pl_1_scl_i),
        .IIC_PL_1_scl_o(iic_pl_1_scl_o),
        .IIC_PL_1_scl_t(iic_pl_1_scl_t),
        .IIC_PL_1_sda_i(iic_pl_1_sda_i),
        .IIC_PL_1_sda_o(iic_pl_1_sda_o),
        .IIC_PL_1_sda_t(iic_pl_1_sda_t),
        .IIC_PL_2_scl_i(iic_pl_2_scl_i),
        .IIC_PL_2_scl_o(iic_pl_2_scl_o),
        .IIC_PL_2_scl_t(iic_pl_2_scl_t),
        .IIC_PL_2_sda_i(iic_pl_2_sda_i),
        .IIC_PL_2_sda_o(iic_pl_2_sda_o),
        .IIC_PL_2_sda_t(iic_pl_2_sda_t),
        .IIC_PL_3_scl_i(iic_pl_3_scl_i),
        .IIC_PL_3_scl_o(iic_pl_3_scl_o),
        .IIC_PL_3_scl_t(iic_pl_3_scl_t),
        .IIC_PL_3_sda_i(iic_pl_3_sda_i),
        .IIC_PL_3_sda_o(iic_pl_3_sda_o),
        .IIC_PL_3_sda_t(iic_pl_3_sda_t),
        .IIC_PS_0_scl_i(iic_ps_0_scl_i),
        .IIC_PS_0_scl_o(iic_ps_0_scl_o),
        .IIC_PS_0_scl_t(iic_ps_0_scl_t),
        .IIC_PS_0_sda_i(iic_ps_0_sda_i),
        .IIC_PS_0_sda_o(iic_ps_0_sda_o),
        .IIC_PS_0_sda_t(iic_ps_0_sda_t),
        .IIC_PS_1_scl_i(iic_ps_1_scl_i),
        .IIC_PS_1_scl_o(iic_ps_1_scl_o),
        .IIC_PS_1_scl_t(iic_ps_1_scl_t),
        .IIC_PS_1_sda_i(iic_ps_1_sda_i),
        .IIC_PS_1_sda_o(iic_ps_1_sda_o),
        .IIC_PS_1_sda_t(iic_ps_1_sda_t),
        .SPI_PS_0_io0_i(spi_ps_0_io0_i),
        .SPI_PS_0_io0_o(spi_ps_0_io0_o),
        .SPI_PS_0_io0_t(spi_ps_0_io0_t),
        .SPI_PS_0_io1_i(spi_ps_0_io1_i),
        .SPI_PS_0_io1_o(spi_ps_0_io1_o),
        .SPI_PS_0_io1_t(spi_ps_0_io1_t),
        .SPI_PS_0_sck_i(spi_ps_0_sck_i),
        .SPI_PS_0_sck_o(spi_ps_0_sck_o),
        .SPI_PS_0_sck_t(spi_ps_0_sck_t),
        .SPI_PS_0_ss1_o(spi_ps_0_ss1_o),
        .SPI_PS_0_ss2_o(spi_ps_0_ss2_o),
        .SPI_PS_0_ss_i(spi_ps_0_ss_i),
        .SPI_PS_0_ss_o(spi_ps_0_ss_o),
        .SPI_PS_0_ss_t(spi_ps_0_ss_t),
        .SPI_PS_1_io0_i(spi_ps_1_io0_i),
        .SPI_PS_1_io0_o(spi_ps_1_io0_o),
        .SPI_PS_1_io0_t(spi_ps_1_io0_t),
        .SPI_PS_1_io1_i(spi_ps_1_io1_i),
        .SPI_PS_1_io1_o(spi_ps_1_io1_o),
        .SPI_PS_1_io1_t(spi_ps_1_io1_t),
        .SPI_PS_1_sck_i(spi_ps_1_sck_i),
        .SPI_PS_1_sck_o(spi_ps_1_sck_o),
        .SPI_PS_1_sck_t(spi_ps_1_sck_t),
        .SPI_PS_1_ss1_o(spi_ps_1_ss1_o),
        .SPI_PS_1_ss2_o(spi_ps_1_ss2_o),
        .SPI_PS_1_ss_i(spi_ps_1_ss_i),
        .SPI_PS_1_ss_o(spi_ps_1_ss_o),
        .SPI_PS_1_ss_t(spi_ps_1_ss_t),
        .UART_PL_0_baudoutn(UART_PL_0_baudoutn),
        .UART_PL_0_ddis(UART_PL_0_ddis),
        .UART_PL_0_dtrn(UART_PL_0_dtrn),
        .UART_PL_0_out1n(UART_PL_0_out1n),
        .UART_PL_0_out2n(UART_PL_0_out2n),
        .UART_PL_0_rtsn(UART_PL_0_rtsn),
        .UART_PL_0_rxd(UART_PL_0_rxd),
        .UART_PL_0_rxrdyn(UART_PL_0_rxrdyn),
        .UART_PL_0_txd(UART_PL_0_txd),
        .UART_PL_0_txrdyn(UART_PL_0_txrdyn),
        .UART_PL_1_baudoutn(UART_PL_1_baudoutn),
        .UART_PL_1_ddis(UART_PL_1_ddis),
        .UART_PL_1_dtrn(UART_PL_1_dtrn),
        .UART_PL_1_out1n(UART_PL_1_out1n),
        .UART_PL_1_out2n(UART_PL_1_out2n),
        .UART_PL_1_rtsn(UART_PL_1_rtsn),
        .UART_PL_1_rxd(UART_PL_1_rxd),
        .UART_PL_1_rxrdyn(UART_PL_1_rxrdyn),
        .UART_PL_1_txd(UART_PL_1_txd),
        .UART_PL_1_txrdyn(UART_PL_1_txrdyn),
        .UART_PL_2_baudoutn(UART_PL_2_baudoutn),
        .UART_PL_2_ddis(UART_PL_2_ddis),
        .UART_PL_2_dtrn(UART_PL_2_dtrn),
        .UART_PL_2_out1n(UART_PL_2_out1n),
        .UART_PL_2_out2n(UART_PL_2_out2n),
        .UART_PL_2_rtsn(UART_PL_2_rtsn),
        .UART_PL_2_rxd(UART_PL_2_rxd),
        .UART_PL_2_rxrdyn(UART_PL_2_rxrdyn),
        .UART_PL_2_txd(UART_PL_2_txd),
        .UART_PL_2_txrdyn(UART_PL_2_txrdyn),
        .UART_PL_3_baudoutn(UART_PL_3_baudoutn),
        .UART_PL_3_ddis(UART_PL_3_ddis),
        .UART_PL_3_dtrn(UART_PL_3_dtrn),
        .UART_PL_3_out1n(UART_PL_3_out1n),
        .UART_PL_3_out2n(UART_PL_3_out2n),
        .UART_PL_3_rtsn(UART_PL_3_rtsn),
        .UART_PL_3_rxd(UART_PL_3_rxd),
        .UART_PL_3_rxrdyn(UART_PL_3_rxrdyn),
        .UART_PL_3_txd(UART_PL_3_txd),
        .UART_PL_3_txrdyn(UART_PL_3_txrdyn),
        .UART_PL_4_baudoutn(UART_PL_4_baudoutn),
        .UART_PL_4_ddis(UART_PL_4_ddis),
        .UART_PL_4_dtrn(UART_PL_4_dtrn),
        .UART_PL_4_out1n(UART_PL_4_out1n),
        .UART_PL_4_out2n(UART_PL_4_out2n),
        .UART_PL_4_rtsn(UART_PL_4_rtsn),
        .UART_PL_4_rxd(UART_PL_4_rxd),
        .UART_PL_4_rxrdyn(UART_PL_4_rxrdyn),
        .UART_PL_4_txd(UART_PL_4_txd),
        .UART_PL_4_txrdyn(UART_PL_4_txrdyn),
        .UART_PL_5_baudoutn(UART_PL_5_baudoutn),
        .UART_PL_5_ddis(UART_PL_5_ddis),
        .UART_PL_5_dtrn(UART_PL_5_dtrn),
        .UART_PL_5_out1n(UART_PL_5_out1n),
        .UART_PL_5_out2n(UART_PL_5_out2n),
        .UART_PL_5_rtsn(UART_PL_5_rtsn),
        .UART_PL_5_rxd(UART_PL_5_rxd),
        .UART_PL_5_rxrdyn(UART_PL_5_rxrdyn),
        .UART_PL_5_txd(UART_PL_5_txd),
        .UART_PL_5_txrdyn(UART_PL_5_txrdyn),
        .UART_PL_6_baudoutn(UART_PL_6_baudoutn),
        .UART_PL_6_ddis(UART_PL_6_ddis),
        .UART_PL_6_dtrn(UART_PL_6_dtrn),
        .UART_PL_6_out1n(UART_PL_6_out1n),
        .UART_PL_6_out2n(UART_PL_6_out2n),
        .UART_PL_6_rtsn(UART_PL_6_rtsn),
        .UART_PL_6_rxd(UART_PL_6_rxd),
        .UART_PL_6_rxrdyn(UART_PL_6_rxrdyn),
        .UART_PL_6_txd(UART_PL_6_txd),
        .UART_PL_6_txrdyn(UART_PL_6_txrdyn),
        .UART_PL_7_baudoutn(UART_PL_7_baudoutn),
        .UART_PL_7_ddis(UART_PL_7_ddis),
        .UART_PL_7_dtrn(UART_PL_7_dtrn),
        .UART_PL_7_out1n(UART_PL_7_out1n),
        .UART_PL_7_out2n(UART_PL_7_out2n),
        .UART_PL_7_rtsn(UART_PL_7_rtsn),
        .UART_PL_7_rxd(UART_PL_7_rxd),
        .UART_PL_7_rxrdyn(UART_PL_7_rxrdyn),
        .UART_PL_7_txd(UART_PL_7_txd),
        .UART_PL_7_txrdyn(UART_PL_7_txrdyn),
        .UART_PS_0_rxd(UART_PS_0_rxd),
        .UART_PS_0_txd(UART_PS_0_txd),
        .Vaux15_v_n(Vaux15_v_n),
        .Vaux15_v_p(Vaux15_v_p),
        .pulse_train_in(pulse_train_in),
        .pwm_0(pwm_0),
        .pwm_1(pwm_1),
        .pwm_10(pwm_10),
        .pwm_11(pwm_11),
        .pwm_2(pwm_2),
        .pwm_3(pwm_3),
        .pwm_4(pwm_4),
        .pwm_5(pwm_5),
        .pwm_6(pwm_6),
        .pwm_7(pwm_7),
        .pwm_8(pwm_8),
        .pwm_9(pwm_9));
  IOBUF iic_pl_0_scl_iobuf
       (.I(iic_pl_0_scl_o),
        .IO(iic_pl_0_scl_io),
        .O(iic_pl_0_scl_i),
        .T(iic_pl_0_scl_t));
  IOBUF iic_pl_0_sda_iobuf
       (.I(iic_pl_0_sda_o),
        .IO(iic_pl_0_sda_io),
        .O(iic_pl_0_sda_i),
        .T(iic_pl_0_sda_t));
  IOBUF iic_pl_1_scl_iobuf
       (.I(iic_pl_1_scl_o),
        .IO(iic_pl_1_scl_io),
        .O(iic_pl_1_scl_i),
        .T(iic_pl_1_scl_t));
  IOBUF iic_pl_1_sda_iobuf
       (.I(iic_pl_1_sda_o),
        .IO(iic_pl_1_sda_io),
        .O(iic_pl_1_sda_i),
        .T(iic_pl_1_sda_t));
  IOBUF iic_pl_2_scl_iobuf
       (.I(iic_pl_2_scl_o),
        .IO(iic_pl_2_scl_io),
        .O(iic_pl_2_scl_i),
        .T(iic_pl_2_scl_t));
  IOBUF iic_pl_2_sda_iobuf
       (.I(iic_pl_2_sda_o),
        .IO(iic_pl_2_sda_io),
        .O(iic_pl_2_sda_i),
        .T(iic_pl_2_sda_t));
  IOBUF iic_pl_3_scl_iobuf
       (.I(iic_pl_3_scl_o),
        .IO(iic_pl_3_scl_io),
        .O(iic_pl_3_scl_i),
        .T(iic_pl_3_scl_t));
  IOBUF iic_pl_3_sda_iobuf
       (.I(iic_pl_3_sda_o),
        .IO(iic_pl_3_sda_io),
        .O(iic_pl_3_sda_i),
        .T(iic_pl_3_sda_t));
  IOBUF iic_ps_0_scl_iobuf
       (.I(iic_ps_0_scl_o),
        .IO(iic_ps_0_scl_io),
        .O(iic_ps_0_scl_i),
        .T(iic_ps_0_scl_t));
  IOBUF iic_ps_0_sda_iobuf
       (.I(iic_ps_0_sda_o),
        .IO(iic_ps_0_sda_io),
        .O(iic_ps_0_sda_i),
        .T(iic_ps_0_sda_t));
  IOBUF iic_ps_1_scl_iobuf
       (.I(iic_ps_1_scl_o),
        .IO(iic_ps_1_scl_io),
        .O(iic_ps_1_scl_i),
        .T(iic_ps_1_scl_t));
  IOBUF iic_ps_1_sda_iobuf
       (.I(iic_ps_1_sda_o),
        .IO(iic_ps_1_sda_io),
        .O(iic_ps_1_sda_i),
        .T(iic_ps_1_sda_t));
  IOBUF spi_ps_0_io0_iobuf
       (.I(spi_ps_0_io0_o),
        .IO(spi_ps_0_io0_io),
        .O(spi_ps_0_io0_i),
        .T(spi_ps_0_io0_t));
  IOBUF spi_ps_0_io1_iobuf
       (.I(spi_ps_0_io1_o),
        .IO(spi_ps_0_io1_io),
        .O(spi_ps_0_io1_i),
        .T(spi_ps_0_io1_t));
  IOBUF spi_ps_0_sck_iobuf
       (.I(spi_ps_0_sck_o),
        .IO(spi_ps_0_sck_io),
        .O(spi_ps_0_sck_i),
        .T(spi_ps_0_sck_t));
  IOBUF spi_ps_0_ss_iobuf
       (.I(spi_ps_0_ss_o),
        .IO(spi_ps_0_ss_io),
        .O(spi_ps_0_ss_i),
        .T(spi_ps_0_ss_t));
  IOBUF spi_ps_1_io0_iobuf
       (.I(spi_ps_1_io0_o),
        .IO(spi_ps_1_io0_io),
        .O(spi_ps_1_io0_i),
        .T(spi_ps_1_io0_t));
  IOBUF spi_ps_1_io1_iobuf
       (.I(spi_ps_1_io1_o),
        .IO(spi_ps_1_io1_io),
        .O(spi_ps_1_io1_i),
        .T(spi_ps_1_io1_t));
  IOBUF spi_ps_1_sck_iobuf
       (.I(spi_ps_1_sck_o),
        .IO(spi_ps_1_sck_io),
        .O(spi_ps_1_sck_i),
        .T(spi_ps_1_sck_t));
  IOBUF spi_ps_1_ss_iobuf
       (.I(spi_ps_1_ss_o),
        .IO(spi_ps_1_ss_io),
        .O(spi_ps_1_ss_i),
        .T(spi_ps_1_ss_t));
endmodule
