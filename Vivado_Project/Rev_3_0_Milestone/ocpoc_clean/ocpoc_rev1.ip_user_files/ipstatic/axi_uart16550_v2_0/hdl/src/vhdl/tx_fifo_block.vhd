-------------------------------------------------------------------------------
-- tx_fifo_block.vhd - entity/architecture pair
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
-- Filename:        tx_fifo_block.vhd
-- Version:         v2.0
-- Description:     Contains the uart transmitter fifo
--
-- VHDL-Standard:   VHDL'93
--
-------------------------------------------------------------------------------
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
-- proc common package of the proc common library is used for different 
-- function declarations
-------------------------------------------------------------------------------
library lib_srl_fifo_v1_0_2;
use lib_srl_fifo_v1_0_2.srl_fifo_rbu_f;

-------------------------------------------------------------------------------
-- Entity section
-------------------------------------------------------------------------------
entity tx_fifo_block is
  generic (
    C_FAMILY         : string := "virtex7");              -- XILINX FPGA family
  port (
    Tx_fifo_data_in  : in  std_logic_VECTOR(7 downto 0 ); -- Tx fifo data in
    Tx_fifo_wr_en    : in  std_logic;                     -- Tx fifo write en  
    Tx_fifo_data_out : out std_logic_VECTOR(7 downto 0 ); -- Tx fifo data out
    Tx_fifo_clk      : in  std_logic;                     -- Tx fifo clk
    Tx_fifo_rd_en    : in  std_logic;                     -- Tx fifo read en  
    Tx_fifo_rst      : in  std_logic;                     -- Tx fifo Rst   
    Tx_fifo_empty    : out std_logic;                     -- Tx fifo empty  
    Tx_fifo_full     : out std_logic                      -- Tx fifo full   
    );

end tx_fifo_block;


-------------------------------------------------------------------------------
-- Architecture section
-------------------------------------------------------------------------------
architecture implementation of tx_fifo_block is
-- Pragma Added to supress synth warnings
attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of implementation : architecture is "yes";
 
  signal tx_fifo_empty_i : std_logic;
  signal tx_fifo_full_i  : std_logic;
  signal tx_fifo_rd_en_i : std_logic;
  signal tx_fifo_wr_en_i : std_logic;

begin
  Tx_fifo_empty   <= tx_fifo_empty_i;
  Tx_fifo_full    <= tx_fifo_full_i;
  tx_fifo_rd_en_i <= Tx_fifo_rd_en and (not tx_fifo_empty_i);
  tx_fifo_wr_en_i <= Tx_fifo_wr_en and (not tx_fifo_full_i);
 
   srl_fifo_rbu_f_i1 : entity lib_srl_fifo_v1_0_2.srl_fifo_rbu_f
     generic map (
       C_DWIDTH => 8,
       C_DEPTH  => 64,
       C_FAMILY => C_FAMILY
                 )
     port map (
       Clk           => Tx_fifo_clk,       -- [in]
       Reset         => Tx_fifo_rst,       -- [in]
       FIFO_Write    => tx_fifo_wr_en_i,   -- [in]
       Data_In       => Tx_fifo_data_in,   -- [in]
       FIFO_Read     => tx_fifo_rd_en_i,   -- [in]
       Data_Out      => Tx_fifo_data_out,  -- [out]
       FIFO_Full     => tx_fifo_full_i,    -- [out]
       FIFO_Empty    => tx_fifo_empty_i,   -- [out]
       Addr          => open,              -- [out]
       Num_To_Reread => "000000",              -- [in]
       Underflow     => open,              -- [out]
       Overflow      => open);             -- [out]
  -------------------------------------------    
end implementation;
