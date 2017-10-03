-------------------------------------------------------------------------------
-- xuart_tx_load_sm.vhd - entity/architecture pair
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
-- Filename:        xuart_tx_load_sm.vhd
-- Version:         v2.0
-- Description:     xuart transmitter load state machine
--
-- VHDL-Standard:   VHDL'93
--
-------------------------------------------------------------------------------
--
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
-- Entity section
-------------------------------------------------------------------------------
entity xuart_tx_load_sm is
  port (
    Rst       : in  std_logic;                    -- Rst input
    Sys_clk   : in  std_logic;                    -- Sys clock
    Thr       : in  std_logic_vector(7 downto 0); -- Trasmit holding reg
    Write_thr : in  std_logic;                    -- Thr write
    Load_tx   : in  std_logic;                    -- load Tx input  
    Tsr       : out std_logic_vector(7 downto 0); -- Transmit shift reg
    Thre      : out std_logic;                    -- Thr reg empty
    Tsre      : out std_logic                     -- Tsr reg empty
    );
end xuart_tx_load_sm;

-------------------------------------------------------------------------------
-- Architecture section
-------------------------------------------------------------------------------
architecture implementation of xuart_tx_load_sm is

-- Pragma Added to supress synth warnings
attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of implementation : architecture is "yes";

  -- state types are based on TSR_THR
  type   state_type is (EMPTY_EMPTY, EMPTY_FULL, FULL_EMPTY, FULL_FULL);
  signal current_state, next_state : state_type;

  signal thre_com : std_logic;
  signal tsre_com : std_logic;
  signal tsr_com  : std_logic_vector(7 downto 0);
  signal tsr_int  : std_logic_vector(7 downto 0);
  
begin

  Tsr <= tsr_int;

  -----------------------------------------------------------------------------
  -- PROCESS: TX_LOAD_SM_REG_PROCESS
  -- purpose: Transmit register load and next state logic
  -----------------------------------------------------------------------------
  TX_LOAD_SM_REG_PROCESS : process (Sys_clk) is
  begin  -- process TX_LOAD_SM_REG_PROCESS
    if Sys_clk'event and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                  -- synchronous reset (active high)
        current_state <= EMPTY_EMPTY;
        tsr_int       <= X"FF";
        Thre          <= '1';
        Tsre          <= '1';
      else
        current_state <= next_state;
        tsr_int       <= tsr_com;
        Thre          <= thre_com;
        Tsre          <= tsre_com;
      end if;
    end if;
  end process TX_LOAD_SM_REG_PROCESS;
  
  -----------------------------------------------------------------------------
  -- PROCESS: TX_LOAD_SM_COM_PROCESS
  -- purpose: uart16550 transmission register loading process
  -----------------------------------------------------------------------------
  TX_LOAD_SM_COM_PROCESS : process (current_state, Load_tx, Rst, Thr, tsr_int,
                                    Write_thr) is

  begin  -- process TX_LOAD_SM_COM_PROCESS

      next_state <= current_state;
      tsr_com    <= tsr_int;
      tsre_com   <= '1';
      thre_com   <= '1';

      case current_state is

        when EMPTY_EMPTY =>
          if Write_thr = '1' then
            next_state <= EMPTY_FULL;
            tsr_com    <= Thr;
            tsre_com   <= '1';
            thre_com   <= '0';
          else
            next_state <= EMPTY_EMPTY;
            tsr_com    <= tsr_int;
            tsre_com   <= '1';
            thre_com   <= '1';
          end if;

        when EMPTY_FULL =>
          next_state <= FULL_EMPTY;
          tsr_com    <= Thr;
          tsre_com   <= '0';
          thre_com   <= '1';

        when FULL_EMPTY =>
          if (Load_tx = '0' and Write_thr = '1') then
            next_state <= FULL_FULL;
            tsr_com    <= tsr_int;
            tsre_com   <= '0';
            thre_com   <= '0';
          elsif (Load_tx = '1' and Write_thr = '1') then
            next_state <= EMPTY_FULL;
            tsr_com    <= tsr_int;
            tsre_com   <= '1';
            thre_com   <= '0';
          elsif (Load_tx = '1' and Write_thr = '0') then
            next_state <= EMPTY_EMPTY;
            tsr_com    <= tsr_int;
            tsre_com   <= '1';
            thre_com   <= '1';
          else
            next_state <= FULL_EMPTY;
            tsr_com    <= tsr_int;
            tsre_com   <= '0';
            thre_com   <= '1';
          end if;

        when FULL_FULL =>
          tsr_com <= tsr_int;
          if (Load_tx = '1') then
            next_state <= EMPTY_FULL;
            tsre_com   <= '1';
            thre_com   <= '0';
          else
            next_state <= FULL_FULL;
            tsre_com   <= '0';
            thre_com   <= '0';
          end if;

        -- added coverage off to disable the coverage for default state
        -- as state machine will never enter in defualt state while doing
        -- verification. 
        -- coverage off
        when others =>
          next_state <= EMPTY_EMPTY;
          tsr_com    <= tsr_int;
          tsre_com   <= '1';
          thre_com   <= '1';
        -- coverage on 

      end case;
  end process TX_LOAD_SM_COM_PROCESS;

end implementation;
