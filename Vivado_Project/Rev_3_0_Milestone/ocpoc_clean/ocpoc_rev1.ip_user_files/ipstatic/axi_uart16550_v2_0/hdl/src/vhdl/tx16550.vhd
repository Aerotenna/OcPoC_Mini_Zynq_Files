-------------------------------------------------------------------------------
-- tx16550.vhd - entity/architecture pair
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
-- Filename:        tx16550.vhd
-- Version:         v2.0
-- Description:     Implements the transmitter section of uart16550
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
use ieee.std_logic_unsigned."+";

-------------------------------------------------------------------------------
-- Entity section
-------------------------------------------------------------------------------
entity tx16550 is
  port (
    Sys_clk          : in  std_logic;   -- Sys clock
    Rst              : in  std_logic;   -- sys reset
    BaudoutN         : in  std_logic;   -- baudout
    Lcr              : in  std_logic_vector (7 downto 0);  
                                        -- line control register
    Thr              : in  std_logic_vector (7 downto 0);  
                                        -- transmitter holding register
    Tx_empty         : out std_logic;   -- transmit shift register empty signal
    Start_tx         : in  std_logic;   -- transmit holding register empty flag
    Sout             : out std_logic;   -- serial data out
    Tsr_loaded       : out std_logic;   -- Thr loaded into tsr
    Tx_fifo_rd_en    : out std_logic;   -- read enable for transmit fifo
    Fcr_0            : in  std_logic;   -- tx fifo enabled
    Tx_fifo_data_out : in  std_logic_vector (7 downto 0)
                                        -- tx fifo data output
    );
end tx16550;

-------------------------------------------------------------------------------
-- Architecture section
-------------------------------------------------------------------------------
architecture implementation of tx16550 is

-- Pragma Added to supress synth warnings
attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of implementation : architecture is "yes";
------------------------------ Signal Declarations  ---------------------------
  type STATE_TYPE is (IDLE, START_BIT, DATA_BIT1, DATA_BIT2, DATA_BIT3, 
                      DATA_BIT4, DATA_BIT5, DATA_BIT6, DATA_BIT7, DATA_BIT8, 
                      PARITY_BIT, STOP_BIT1, STOP_BIT2);

  signal transmit_state     : STATE_TYPE;  -- states for transmit state machine
  signal next_state         : STATE_TYPE;  -- states for transmit state machine
  signal tsr                : std_logic_vector (7 downto 0);  
                                          -- transmit shift register 
  signal tsr_com            : std_logic_vector (7 downto 0);  
                                          -- transmit shift register input
  signal tx_parity          : std_logic;  -- tx_parity signal
  signal clkdiv             : std_logic_vector (3 downto 0);  -- clock counter
  signal clk1x              : std_logic;  -- serial data clock
  signal clk2x              : std_logic;  -- 2x clock for creating 1/2 stop bit
  signal sout_com           : std_logic;  -- serial data out 
  signal transmitting_n     : std_logic;  -- transmit shift reg empty signal
  signal transmitting_n_com : std_logic;  -- transmit shift reg empty signal
  signal parity_enable      : std_logic;  -- Lcr(3) PE(parity enabled when '1')
  signal even_parity        : std_logic;  -- Lcr(4) EPS (even parity selected
                                          -- when '1')
  signal stick_parity       : std_logic;  -- Lcr(5) enables stick parity.
  signal tx_parity_com      : std_logic;  -- tx_parity logic
  signal set_break          : std_logic;  -- Lcr(6) BC (if set Sout is 
                                          --             forced to '0')
  signal numbits            : std_logic_vector (1 downto 0); -- Lcr(1) & Lcr(0)
  signal num_stop_bits      : std_logic;  -- number of stop bits
  signal half_stop_bit      : std_logic;  -- flags half a stop bit
  signal tsr_loaded_com     : std_logic;  -- Tsr_loaded logic 
  signal tx_fifo_rd_en_com  : std_logic;  -- transmit fifo read enable logic   

begin


  -----------------------------------------------------------------------------
  -- PROCESS: TX_EMPTY_PROC
  -- purpose: Tx_empty generation logic
  -----------------------------------------------------------------------------
  TX_EMPTY_PROC : process (Sys_clk) is
  begin  -- process TX_EMPTY_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                      -- synchronous reset (active high)
        Tx_empty <= '1';
      else
        Tx_empty <= transmitting_n and clk1x;
      end if;
    end if;
  end process TX_EMPTY_PROC;

  num_stop_bits <= Lcr(2);
  half_stop_bit <= '1' when (num_stop_bits = '1' and
                             numbits = "00" and
                             transmit_state = STOP_BIT2) else '0';
  parity_enable <= Lcr(3);
  even_parity   <= Lcr(4);
  stick_parity  <= (Lcr(5) and (not Lcr(4))) or ((not Lcr(5) and tx_parity));
  set_break     <= Lcr(6);
  numbits       <= Lcr(1) & Lcr(0);

  -----------------------------------------------------------------------------
  -- PROCESS: CLOCK_DIV_PROCESS
  -- purpose: clk_div counter 
  -----------------------------------------------------------------------------
  CLOCK_DIV_PROCESS : process (Sys_clk) is
  begin  -- process CLOCK_DIV_PROCESS
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                  -- synchronous reset (active high)
        clkdiv <= "0000";
      elsif (clk2x = '1' and half_stop_bit = '1') then
        clkdiv <= clkdiv + "1000";
      elsif BaudoutN = '0' then
        clkdiv <= clkdiv + "0001";
      end if;
    end if;
  end process CLOCK_DIV_PROCESS;

  -----------------------------------------------------------------------------
  -- PROCESS: CLK_1X_PROCESS
  -- purpose: clock_1x generation
  -----------------------------------------------------------------------------
  CLK_1X_PROCESS : process (Sys_clk) is
  begin  -- process CLK_1X_PROCESS
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                  -- synchronous reset (active high)
        clk1x <= '0';
      elsif (clkdiv = "0111" and BaudoutN = '0') then
        clk1x <= '1';
      else
        clk1x <= '0';
      end if;
    end if;
  end process CLK_1X_PROCESS;

  -----------------------------------------------------------------------------
  -- PROCESS: CLK_2X_PROCESS
  -- purpose: clk2x generation
  -----------------------------------------------------------------------------
  CLK_2X_PROCESS : process (Sys_clk) is
  begin  -- process CLK_2X_PROCESS
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                  -- synchronous reset (active high)
        clk2x <= '0';
      elsif (clkdiv = "1111" and BaudoutN = '0') then
        clk2x <= '1';
      else
        clk2x <= '0';
      end if;
    end if;
  end process CLK_2X_PROCESS;

 tx_fifo_rd_en_com <= '1' when (clk1x='1' and transmit_state=START_BIT) else 
                      '0';

  -----------------------------------------------------------------------------
  -- PROCESS: TX_FIFO_RD_EN_PROC
  -- purpose: transmit fifo read enable logic
  -----------------------------------------------------------------------------
  TX_FIFO_RD_EN_PROC : process (Sys_clk) is
  begin  -- process TX_FIFO_RD_EN_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                      -- synchronous reset (active high)
        Tx_fifo_rd_en <= '0';
      else
        Tx_fifo_rd_en <= tx_fifo_rd_en_com;
      end if;
    end if;
  end process TX_FIFO_RD_EN_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: TRANSMIT_SM_REG_PROC
  -- purpose: Sout register logic and next state generation logic
  -----------------------------------------------------------------------------
  TRANSMIT_SM_REG_PROC : process (Sys_clk) is
  begin  -- process TRANSMIT_SM_REG_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                  -- synchronous reset (active high)
        Sout           <= '1';
        transmitting_n <= '1';
        tsr            <= (others => '1');
        Tsr_loaded     <= '0';
        tx_parity      <= '0';
        transmit_state <= IDLE;
      elsif clk1x = '1' or (clk2x = '1' and half_stop_bit = '1') then
        Sout           <= sout_com and (not set_break);
        tsr            <= tsr_com;
        Tsr_loaded     <= tsr_loaded_com;
        tx_parity      <= tx_parity_com;
        transmit_state <= next_state;
      else
        Tsr_loaded <= '0';
      end if;
      transmitting_n <= transmitting_n_com;
    end if;
  end process TRANSMIT_SM_REG_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: TRANSMIT_SM_COM
  -- purpose: Transmit state machine
  -----------------------------------------------------------------------------
  TRANSMIT_SM_COM : process (even_parity, Fcr_0, Rst, num_stop_bits, numbits,
                             parity_enable, Start_tx, stick_parity, Thr,
                             transmit_state, tsr, Tx_fifo_data_out, tx_parity)
  begin
    
      next_state         <= transmit_state;
      tsr_loaded_com     <= '0';
      transmitting_n_com <= '1';
      tx_parity_com      <= '0';
      sout_com           <= '1';
      tsr_com            <= (others => '1');

      case transmit_state is
        when IDLE =>
          tsr_loaded_com     <= '0';
          transmitting_n_com <= '1';
          if Start_tx = '0' then
            next_state <= START_BIT;
          else
            next_state <= IDLE;
          end if;

        when START_BIT =>
          sout_com           <= '0';         -- generates low start bit
          tsr_loaded_com     <= '1';
          transmitting_n_com <= '0';
          if Fcr_0 = '1' then
            tsr_com <= Tx_fifo_data_out;
          else
            tsr_com <= Thr;                  -- load data
          end if;
          tx_parity_com <= not even_parity;  -- initialize parity counter
          next_state    <= DATA_BIT1;

        when DATA_BIT1 =>
          tsr_com            <= '1' & tsr(7 downto 1);
          sout_com           <= tsr(0);
          tsr_loaded_com     <= '0';
          transmitting_n_com <= '0';
          tx_parity_com      <= tx_parity xor tsr(0);
          next_state         <= DATA_BIT2;

        when DATA_BIT2 =>
          tsr_com            <= '1' & tsr(7 downto 1);
          sout_com           <= tsr(0);
          tsr_loaded_com     <= '0';
          transmitting_n_com <= '0';
          tx_parity_com      <= tx_parity xor tsr(0);
          next_state         <= DATA_BIT3;

        when DATA_BIT3 =>
          tsr_com            <= '1' & tsr(7 downto 1);
          sout_com           <= tsr(0);
          tsr_loaded_com     <= '0';
          transmitting_n_com <= '0';
          tx_parity_com      <= tx_parity xor tsr(0);
          next_state         <= DATA_BIT4;

        when DATA_BIT4 =>
          tsr_com            <= '1' & tsr(7 downto 1);
          sout_com           <= tsr(0);
          tsr_loaded_com     <= '0';
          transmitting_n_com <= '0';
          tx_parity_com      <= tx_parity xor tsr(0);
          next_state         <= DATA_BIT5;

        when DATA_BIT5 =>
          tsr_com            <= '1' & tsr(7 downto 1);
          sout_com           <= tsr(0);
          tsr_loaded_com     <= '0';
          transmitting_n_com <= '0';
          tx_parity_com      <= tx_parity xor tsr(0);
          if numbits /= "00" then
            next_state <= DATA_BIT6;
          elsif parity_enable = '1' then
            next_state <= PARITY_BIT;
          else
            next_state <= STOP_BIT1;
          end if;

        when DATA_BIT6 =>
          tsr_com            <= '1' & tsr(7 downto 1);
          sout_com           <= tsr(0);
          tsr_loaded_com     <= '0';
          transmitting_n_com <= '0';
          tx_parity_com      <= tx_parity xor tsr(0);
          if numbits /= "01" then
            next_state <= DATA_BIT7;
          elsif parity_enable = '1' then
            next_state <= PARITY_BIT;
          else
            next_state <= STOP_BIT1;
          end if;

        when DATA_BIT7 =>
          tsr_com            <= '1' & tsr(7 downto 1);
          sout_com           <= tsr(0);
          tsr_loaded_com     <= '0';
          transmitting_n_com <= '0';
          tx_parity_com      <= tx_parity xor tsr(0);
          if numbits /= "10" then
            next_state <= DATA_BIT8;
          elsif parity_enable = '1' then
            next_state <= PARITY_BIT;
          else
            next_state <= STOP_BIT1;
          end if;

        when DATA_BIT8 =>
          tsr_com            <= '1' & tsr(7 downto 1);
          sout_com           <= tsr(0);
          tsr_loaded_com     <= '0';
          transmitting_n_com <= '0';
          tx_parity_com      <= tx_parity xor tsr(0);
          if parity_enable = '1' then
            next_state <= PARITY_BIT;
          else
            next_state <= STOP_BIT1;
          end if;

        when PARITY_BIT =>
          tsr_loaded_com     <= '0';
          transmitting_n_com <= '0';
          sout_com           <= stick_parity;
          next_state         <= STOP_BIT1;

        when STOP_BIT1 =>
          tsr_loaded_com <= '0';
          sout_com       <= '1';
          if num_stop_bits = '1' then
            next_state <= STOP_BIT2;
          else
            if Start_tx = '0' then
              transmitting_n_com <= '0';
              next_state         <= START_BIT;
            else
              transmitting_n_com <= '1';
              next_state         <= IDLE;
            end if;
          end if;

        when STOP_BIT2 =>
          tsr_loaded_com <= '0';
          sout_com       <= '1';
          if Start_tx = '0' then
            transmitting_n_com <= '0';
            next_state         <= START_BIT;
          else
            transmitting_n_com <= '1';
            next_state         <= IDLE;
          end if;

        -- added coverage off to disable the coverage for default state
        -- as state machine will never enter in defualt state while doing
        -- verification. 
        -- coverage off
        when others =>
          next_state <= IDLE;
        -- coverage on 

      end case;

  end process;

end implementation;


