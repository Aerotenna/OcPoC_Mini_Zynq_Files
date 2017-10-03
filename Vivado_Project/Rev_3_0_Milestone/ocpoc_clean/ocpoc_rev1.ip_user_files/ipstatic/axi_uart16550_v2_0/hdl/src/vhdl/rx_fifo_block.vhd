-------------------------------------------------------------------------------
-- rx_fifo_block.vhd - entity/architecture pair
-------------------------------------------------------------------------------
--  ***************************************************************************
--  ** DISCLAIMER OF LIABILITY                                               **
--  **                                                                       **
--  **  This file contains proprietary and confidential information of       **
--  **  Xilinx, Inc. ("Xilinx"), that is distributed under a license         **
--  **  from Xilinx, and may be used, copied and/or disclosed only           **
--  **  pursuant to the terms of a valid license agreement with Xilinx.      **
--  **                                                                       **
--  **  XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION                **
--  **  ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER           **
--  **  EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT                  **
--  **  LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,            **
--  **  MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx        **
--  **  does not warrant that functions included in the Materials will       **
--  **  meet the requirements of Licensee, or that the operation of the      **
--  **  Materials will be uninterrupted or error-free, or that defects       **
--  **  in the Materials will be corrected. Furthermore, Xilinx does         **
--  **  not warrant or make any representations regarding use, or the        **
--  **  results of the use, of the Materials in terms of correctness,        **
--  **  accuracy, reliability or otherwise.                                  **
--  **                                                                       **
--  **  Xilinx products are not designed or intended to be fail-safe,        **
--  **  or for use in any application requiring fail-safe performance,       **
--  **  such as life-support or safety devices or systems, Class III         **
--  **  medical devices, nuclear facilities, applications related to         **
--  **  the deployment of airbags, or any other applications that could      **
--  **  lead to death, personal injury or severe property or                 **
--  **  environmental damage (individually and collectively, "critical       **
--  **  applications"). Customer assumes the sole risk and liability         **
--  **  of any use of Xilinx products in critical applications,              **
--  **  subject only to applicable laws and regulations governing            **
--  **  limitations on product liability.                                    **
--  **                                                                       **
--  **  Copyright 2010 Xilinx, Inc.                                          **
--  **  All rights reserved.                                                 **
--  **                                                                       **
--  **  This disclaimer and copyright notice must be retained as part        **
--  **  of this file at all times.                                           **
--  ***************************************************************************
-------------------------------------------------------------------------------
-- Filename:        rx_fifo_block.vhd
-- Version:         v2.0
-- Description:     Contains UART rx FIFO and FIFO control circuitry
--
-- VHDL-Standard:   VHDL'93
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x" 
--      reset signals:                          "rst", "rst_n" 
--      generics:                               "C_*" 
--      user defined types:                     "*_TYPE" 
--      state machine next state:               "*_ns" 
--      state machine current state:            "*_cs" 
--      combinatorial signals:                  "*_cmb" 
--      pipelined or register delay signals:    "*_d#" 
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce" 
--      internal version of output port         "*_i"
--      device pins:                            "*_pin" 
--      ports:                                  - Names begin with Uppercase 
--      processes:                              "*_PROCESS" 
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------
-- axi_uart16550_v2_0_8 library is used for axi_uart16550_v2_0_8 
-- component declarations
-------------------------------------------------------------------------------
library axi_uart16550_v2_0_8;

-------------------------------------------------------------------------------
-- proc common package of the proc common library is used for different 
-- function declarations
-------------------------------------------------------------------------------
library lib_srl_fifo_v1_0_2;
use lib_srl_fifo_v1_0_2.srl_fifo_rbu_f;

-------------------------------------------------------------------------------
-- Entity section
-------------------------------------------------------------------------------
entity rx_fifo_block is
  generic (
    C_FAMILY         : string := "virtex7");               -- XILINX FPGA family
  port (
    Sys_clk          : in  std_logic;                      -- System Clk
    Rclk             : in  std_logic;                      -- Receiver clock
    Rst              : in  std_logic;                      -- Rst                  
    Rx_fifo_data_in  : in  std_logic_vector(10 downto 0 ); -- Rx fifo data in
    Rx_fifo_wr_en    : in  std_logic;                      -- Rx fifo write en
    Rx_fifo_rd_en    : in  std_logic;                      -- Rx fifo read en
    Rx_fifo_rst      : in  std_logic;                      -- Rx fifo rst
    Fcr              : in  std_logic_vector(7 downto 0 );  -- Fifo Control reg
    Rx_fifo_data_out : out std_logic_vector(10 downto 0 ); -- Rx fifo data out
    Rx_fifo_empty    : out std_logic;                      -- Rx fifo empty
    Rx_fifo_timeout  : out std_logic;                      -- Rx fifo timeout 
    Rx_fifo_trigger  : out std_logic;                      -- Rx fifo trigger
    Rx_fifo_full     : out std_logic;                      -- Rx fifo full
    Rx_error_in_fifo : out std_logic                       -- Rx error in fifo
    );


end rx_fifo_block;


-------------------------------------------------------------------------------
-- Architecture section
-------------------------------------------------------------------------------
architecture implementation of rx_fifo_block is

-- Pragma Added to supress synth warnings
attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of implementation : architecture is "yes";
  
-------------------------------------------------------------------------------
-- Signal Declarations
-------------------------------------------------------------------------------
  signal rx_fifo_empty_i   : std_logic;
  signal rx_fifo_full_i    : std_logic;
  signal rx_fifo_count     : std_logic_vector(5 downto 0);
  signal rx_fifo_rd_en_i   : std_logic;
  signal rx_fifo_wr_en_i   : std_logic;
  
begin

  Rx_fifo_empty   <= rx_fifo_empty_i;
  Rx_fifo_full    <= rx_fifo_full_i;
  rx_fifo_rd_en_i <= Rx_fifo_rd_en and (not rx_fifo_empty_i);
  rx_fifo_wr_en_i <= Rx_fifo_wr_en and (not rx_fifo_full_i);

  -----------------------------------------------------------------------------
  -- Instantiating rx_fifo_control module
  -----------------------------------------------------------------------------
  rx_fifo_control_1 : entity axi_uart16550_v2_0_8.rx_fifo_control
  generic map (
      C_FAMILY         =>  C_FAMILY )
    port map (
      Fcr              => Fcr,
      Rx_fifo_empty    => rx_fifo_empty_i,
      rx_fifo_count    => rx_fifo_count,
      Rx_fifo_rd_en    => rx_fifo_rd_en_i,
      Rx_fifo_wr_en    => rx_fifo_wr_en_i,
      Rx_fifo_data_in  => Rx_fifo_data_in,
      Rx_fifo_trigger  => Rx_fifo_trigger,
      Rx_fifo_timeout  => Rx_fifo_timeout,
      Rx_error_in_fifo => Rx_error_in_fifo,
      Rclk             => Rclk,
      Rst              => Rst,
      Rx_fifo_rst      => Rx_fifo_rst,
      Sys_clk          => Sys_clk);
      
  -----------------------------------------------------------------------------
  -- Instantiating srl_fifo from proc_common
  -----------------------------------------------------------------------------
  srl_fifo_rbu_f_i1 : entity lib_srl_fifo_v1_0_2.srl_fifo_rbu_f
    generic map (
      C_DWIDTH => 11,
      C_DEPTH  => 64,
      C_FAMILY => C_FAMILY 
                )
    port map (
      Clk           => Sys_clk,            -- [in]
      Reset         => Rx_fifo_rst,        -- [in]
      FIFO_Write    => rx_fifo_wr_en_i,    -- [in]
      Data_In       => Rx_fifo_data_in,    -- [in]
      FIFO_Read     => rx_fifo_rd_en_i,    -- [in]
      Data_Out      => Rx_fifo_data_out,   -- [out]
      FIFO_Full     => rx_fifo_full_i,     -- [out]
      FIFO_Empty    => rx_fifo_empty_i,    -- [out]
      Addr          => rx_fifo_count,      -- [out]
      Num_To_Reread => "000000",               -- [in]
      Underflow     => open,               -- [out]
      Overflow      => open);              -- [out]
  -------------------------------------------       
 
end implementation;
