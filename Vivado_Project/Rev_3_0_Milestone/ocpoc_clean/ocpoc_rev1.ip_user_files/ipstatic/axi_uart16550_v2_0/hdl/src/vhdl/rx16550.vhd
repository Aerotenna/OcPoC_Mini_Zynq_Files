-------------------------------------------------------------------------------
-- rx16550.vhd - entity/architecture pair
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
-- Filename:        rx16550.vhd
-- Version:         v2.0
-- Description:     Implements the receiver portion of uart16550
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
use ieee.std_logic_unsigned."-";

-------------------------------------------------------------------------------
-- Entity section
-------------------------------------------------------------------------------
entity rx16550 is
  port (
    Sys_clk            : in  std_logic;  -- sysclk
    Rclk               : in  std_logic;  -- receive clock
    Rst                : in  std_logic;  -- reset
    Lcr                : in  std_logic_vector (7 downto 0);  
                                         -- line control register
    Rbr                : out std_logic_vector (7 downto 0);  
                                         -- receiver holding register
    Fcr_0              : in  std_logic;  -- FIFO enable indication bit from FCR
    Sin                : in  std_logic;  -- serial data out
    Parity_error       : out std_logic;  -- parity error flag
    Framing_error      : out std_logic;  -- framing error flag
    Break_interrupt    : out std_logic;  -- break interrupt flag
    Data_ready         : out std_logic;  -- data ready flag
    Rx_fifo_data_in    : out std_logic_vector (10 downto 0);  
                                         -- receiver fifo data input
    Character_received : out std_logic;  -- flags character has been received
    Have_bi_in_fifo_n  : out std_logic   -- break interrupt is in fifo
    );

end rx16550;

-------------------------------------------------------------------------------
-- Architecture section
-------------------------------------------------------------------------------
architecture implementation of rx16550 is

-- Pragma Added to supress synth warnings
attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of implementation : architecture is "yes";

-------------------------- Constant Declarations  -----------------------------
--------------------------- Signal Declarations  ------------------------------
  
  type STATE_TYPE is (IDLE, START_BIT, DATA_BIT1, DATA_BIT2, DATA_BIT3, 
                      DATA_BIT4, DATA_BIT5, DATA_BIT6, DATA_BIT7, DATA_BIT8,
                      PARITY_BIT, STOP_BIT1, STOP_BIT2, FRAME_ERROR);

-------------------------------------------------------------------------------
-- Signal Declarations
-------------------------------------------------------------------------------
  signal receive_state       : STATE_TYPE;  -- states for receive state machine
  signal next_state          : STATE_TYPE;  -- states for receive state machine
  signal rsr                 : std_logic_vector (7 downto 0);  -- receive shift
                                                               -- register
  signal rbr_d               : std_logic_vector (7 downto 0);  -- internal copy
                                                               -- of Rbr
  signal rx_parity_com       : std_logic;  -- rx_parity signal
  signal parity_error_d      : std_logic;  -- internal version of  
                                           -- Parity_error output
  signal parity_error_i      : std_logic;  -- internal version of 
                                           --Parity_error output
  signal parity_error_latch  : std_logic;  -- internal version of 
                                           -- Parity_error output
  signal clkdiv              : std_logic_vector (3 downto 0); -- clock counter
  signal clk1x               : std_logic;  -- serial data clock
  signal clk1x_d             : std_logic;  -- serial data clock delsyed 1
                                           -- Sys_clk cycle
  signal clk2x               : std_logic;  -- 2x clock for creating 1/2 
                                           --stop bit
  signal sin_d1              : std_logic;  -- serial data in delayed by 1
  signal sin_d2              : std_logic;  -- serial data in delayed by 2
  signal sin_d3              : std_logic;  -- serial data in delayed by 3
  signal sin_d4              : std_logic;  -- serial data in delayed by 4
  signal sin_d5              : std_logic;  -- serial data in delayed by 5
  signal sin_d6              : std_logic;  -- serial data in delayed by 6
  signal sin_d7              : std_logic;  -- serial data in delayed by 7
  signal sin_d8              : std_logic;  -- serial data in delayed by 8
  signal sin_d9              : std_logic;  -- serial data in delayed by 9
  signal sin_d10             : std_logic;  -- serial data in delayed by 10
  signal parity_enable       : std_logic;  -- Lcr(3) PE (parity enabled 
                                           -- when '1')
  signal even_parity         : std_logic;  -- Lcr(4) EPS (even parity 
                                           -- selected )
  signal numbits             : std_logic_vector (1 downto 0);  
                                           -- Lcr(1) & Lcr(0)
  signal got_start_bit_d     : std_logic;  -- found start bit register
  signal got_start_bit_com   : std_logic;  -- found start bit logic
  signal resynch_clkdiv      : std_logic;
  signal resynch_clkdiv_d    : std_logic;
  signal num_stop_bits       : std_logic;  -- number of stop bits
  signal half_stop_bit       : std_logic;  -- flags half a stop bit
  signal clk_div_en          : std_logic;  -- enables sample clock
  signal framing_error_com   : std_logic;  -- framing error logic
  signal framing_error_d     : std_logic;  -- internal version of 
                                           -- Framing_error
  signal framing_error_i     : std_logic;  -- internal version of 
                                           -- Framing_error
                                           -- output
  signal framing_error_flag  : std_logic;  -- framing error logic
  signal break_interrupt_com : std_logic;  -- inverse of break interrupt 
                                           -- (for local accumulation of bits)
  signal break_interrupt_error_d   : std_logic;  -- break interrupt accumulator
  signal break_interrupt_i         : std_logic;  -- break interrupt accumulator
  signal break_interrupt_flag      : std_logic;  -- break interrupt accumulator
  signal character_received_com    : std_logic;
  signal character_received_d      : std_logic;
  signal character_received_flag   : std_logic;
  signal character_received_rclk   : std_logic;
  signal load_rbr_d                : std_logic;
  signal load_rbr_com              : std_logic;
  signal have_bi_in_fifo_n_i       : std_logic;
  signal resynch_clkdiv_startbit   : std_logic;
  signal resynch_clkdiv_startbit_d : std_logic;
  signal clk_div_rst               : std_logic;
  signal stick_parity              : std_logic;
  signal resynch_clkdiv_frame      : std_logic;
  signal resynch_clkdiv_frame_d    : std_logic;
  signal clock_1x_early            : std_logic;

begin


  stick_parity  <= Lcr(5);
  parity_enable <= Lcr(3);
  even_parity   <= Lcr(4);
  num_stop_bits <= Lcr(2);

  half_stop_bit <= '1' when (num_stop_bits = '1' and numbits = "00" and 
                             receive_state = STOP_BIT1) else '0';
  numbits       <= Lcr(1) & Lcr(0);

  Have_bi_in_fifo_n <= have_bi_in_fifo_n_i;
-------------------------------------------------------------------------------
-- Rclk processes
-------------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- PROCESS: SIN_DELAY_PROC
  -- purpose: register and delay Sin input
  -----------------------------------------------------------------------------
  SIN_DELAY_PROC : process (Sys_clk) is
  begin  -- process SIN_DELAY_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                      -- synchronous reset (active high)
        sin_d1  <= '0';
        sin_d2  <= '0';
        sin_d3  <= '0';
        sin_d4  <= '0';
        sin_d5  <= '0';
        sin_d6  <= '0';
        sin_d7  <= '0';
        sin_d8  <= '0';
        sin_d9  <= '0';
        sin_d10 <= '0';
      elsif Rclk = '1' then
        sin_d1  <= Sin;
        sin_d2  <= sin_d1;
        sin_d3  <= sin_d2;
        sin_d4  <= sin_d3;
        sin_d5  <= sin_d4;
        sin_d6  <= sin_d5;
        sin_d7  <= sin_d6;
        sin_d8  <= sin_d7;
        sin_d9  <= sin_d8;
        sin_d10 <= sin_d9;
      end if;
    end if;
  end process SIN_DELAY_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: GOT_START_BIT_PROC
  -- purpose: register got_start_bit_d
  -----------------------------------------------------------------------------
  GOT_START_BIT_PROC : process (Sys_clk) is
  begin  -- process GOT_START_BIT_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                      -- synchronous reset (active high)
        got_start_bit_d  <= '0';
      elsif Rclk = '1' then
        got_start_bit_d  <= got_start_bit_com;
      end if;
    end if;
  end process GOT_START_BIT_PROC;

  -- detect the start of the frame and re-sync the clock_div logic to sample
  -- the data at the centre of the Sin input
  resynch_clkdiv <= '1' when ((got_start_bit_d = '1' and 
                               framing_error_d = '0' and
                               sin_d5 = '0' and sin_d6 = '1' and 
                               clock_1x_early = '0' and
                               ((num_stop_bits = '0' and 
                                 receive_state = STOP_BIT1) or
                                receive_state = STOP_BIT2)) and Rclk = '1')else 
                    '0';

  -- Generated clkdiv resynch signal when the receive state is in START_BIT 
  -- delayed start_bit is detected. 
  -- Modified for CR:441089 
  resynch_clkdiv_startbit <= '1' when (got_start_bit_d = '1' and 
                                       sin_d9 = '0' and sin_d10 = '1' and 
                                 receive_state = START_BIT and Rclk = '1') else
                             '0';


  -- Generated clkdiv resynch signal in case of framming error to synchronize 
  -- with sin. 
  resynch_clkdiv_frame <= '1' when ((got_start_bit_d = '1' and 
                                     framing_error_d = '1' and
                                     sin_d9 = '0' and sin_d10 = '1' and 
                                     ((num_stop_bits = '0' and 
                                       receive_state = FRAME_ERROR) or
                                      receive_state = STOP_BIT2)) 
                                      and Rclk = '1') else 
                          '0';
  
  -----------------------------------------------------------------------------
  -- PROCESS: RESYNCH_CLKDIV_PROC
  -- purpose: register resynch_clkdiv_d and resynch_clkdiv_startbit_d
  -----------------------------------------------------------------------------
  RESYNCH_CLKDIV_PROC : process (Sys_clk) is
  begin  -- process RESYNCH_CLKDIV_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                      -- synchronous reset (active high)
        resynch_clkdiv_d <= '0';
        resynch_clkdiv_startbit_d <= '0';
      else
        resynch_clkdiv_d <= resynch_clkdiv;
        resynch_clkdiv_startbit_d <= resynch_clkdiv_startbit;
        resynch_clkdiv_frame_d <= resynch_clkdiv_frame;    
      end if;
    end if;
  end process RESYNCH_CLKDIV_PROC;
  
  -- generate clock_div reset
  clk_div_rst <= '1' when ((receive_state = IDLE and clk1x_d = '1') or
                           have_bi_in_fifo_n_i = '0') else 
                 '0';          

  -----------------------------------------------------------------------------
  -- PROCESS: CLOCK_DIV_EN_PROC
  -- purpose: register resynch_clkdiv_d and resynch_clkdiv_startbit_d
  -----------------------------------------------------------------------------
  CLOCK_DIV_EN_PROC : process (Sys_clk) is
  begin  -- process CLOCK_DIV_EN_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' or clk_div_rst = '1' then -- synchronous reset 
        clk_div_en <= '0';                   -- (active high)  
      elsif Rclk = '1' then
        if (got_start_bit_d = '0' and sin_d1 = '0' and sin_d2 = '1') then
          clk_div_en <= '1';
        end if;
      end if;
    end if;
  end process CLOCK_DIV_EN_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: CLOCK_DIV_PROCESS
  -- purpose: clk_div counter to synchronize with the Sin input
  -----------------------------------------------------------------------------
  CLOCK_DIV_PROCESS : process (Sys_clk) is
  begin  -- process CLOCK_DIV_PROCESS
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' or clk_div_en = '0' then  -- synchronous reset (active high)
        clkdiv <= "0000";
      elsif (resynch_clkdiv = '1' or resynch_clkdiv_startbit = '1') then
        clkdiv <= "0000"; 
      elsif (clk2x = '1' and half_stop_bit = '1') then
        clkdiv <= "0111";
      elsif resynch_clkdiv_d = '1' then
        clkdiv <= "0100";       
      elsif resynch_clkdiv_startbit_d = '1' or resynch_clkdiv_frame_d = '1' then
        clkdiv <= "1000";
      elsif Rclk = '1' and clk_div_en = '1' then
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
      if Rst = '1' then                      -- synchronous reset (active high)
        clk1x <= '0';
      elsif (Rclk = '1' and clkdiv = "0111" and 
             resynch_clkdiv = '0' and resynch_clkdiv_startbit = '0') then
        clk1x <= '1';
      else
        clk1x <= '0';
      end if;
    end if;
  end process CLK_1X_PROCESS;


  -----------------------------------------------------------------------------
  -- PROCESS: CLK_1X_EARLY_PROCESS
  -- purpose: clock_1x_early generation
  -----------------------------------------------------------------------------
  CLK_1X_EARLY_PROCESS : process (Sys_clk) is
  begin  -- process CLK_1X_PROCESS
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                      -- synchronous reset (active high)
        clock_1x_early <= '0';
      elsif (Rclk = '1' and clkdiv = "0110" ) then
        clock_1x_early <= '1';
      else
        clock_1x_early <= '0';
      end if;
    end if;
  end process CLK_1X_EARLY_PROCESS;

  -----------------------------------------------------------------------------
  -- PROCESS: CLK_1X_DELAY_PROC
  -- purpose: delay clk1x
  -----------------------------------------------------------------------------
  CLK_1X_DELAY_PROC : process (Sys_clk) is
  begin  -- process CLK_1X_DELAY_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then
        clk1x_d <= '0';
      else
        clk1x_d <= clk1x;
      end if;
    end if;
  end process CLK_1X_DELAY_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: CLK_2X_PROCESS
  -- purpose: clk2x generation
  -----------------------------------------------------------------------------
  CLK_2X_PROCESS : process (Sys_clk) is
  begin  -- process CLK_2X_PROCESS
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                      -- synchronous reset (active high)
        clk2x <= '0';
      elsif (Rclk = '1' and clkdiv = "1111") then
        clk2x <= '1';
      else
        clk2x <= '0';
      end if;
    end if;
  end process CLK_2X_PROCESS;

  -----------------------------------------------------------------------------
  -- PROCESS: CHAR_RECEIVED_PROC
  -- purpose: generate character receive clock
  -----------------------------------------------------------------------------
  CHAR_RECEIVED_PROC : process (Sys_clk) is
  begin  -- process CHAR_RECEIVED_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                      -- synchronous reset (active high)
        character_received_rclk <= '0';
      elsif Rclk = '1' then
        character_received_rclk <= character_received_d;
      end if;
    end if;
  end process CHAR_RECEIVED_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: FRAMING_ERROR_PROC
  -- purpose: framing error flag generation
  -----------------------------------------------------------------------------
  FRAMING_ERROR_PROC : process (Sys_clk) is
  begin  -- process DATA_RDY_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then               -- rising clock edge
      if Rst = '1' or character_received_rclk = '1' then  -- synchronous reset 
        framing_error_flag <= '0';                        -- (active high)
      elsif Rclk = '1' and framing_error_d = '1' then
        framing_error_flag <= '1';
      end if;
    end if;
  end process FRAMING_ERROR_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: BREAK_INTERRUPT_ERROR_PROC
  -- purpose: break interrupt error flag generation
  -----------------------------------------------------------------------------
  BREAK_INTERRUPT_ERROR_PROC : process (Sys_clk) is
  begin  -- process DATA_RDY_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then               -- rising clock edge
      if Rst = '1' or character_received_rclk = '1' then  -- synchronous reset
        break_interrupt_flag <= '0';                      --  (active high)
      elsif Rclk = '1' and break_interrupt_error_d = '1' then
        break_interrupt_flag <= '1';
      end if;
    end if;
  end process BREAK_INTERRUPT_ERROR_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: CHARACTER_RECEIVED_PROC
  -- purpose: character received flag generation
  -----------------------------------------------------------------------------
  CHARACTER_RECEIVED_PROC : process (Sys_clk) is
  begin  -- process DATA_RDY_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then               -- rising clock edge
      if Rst = '1' or character_received_rclk = '1' then  -- synchronous reset
        character_received_flag <= '0';                   --  (active high)
      else
        character_received_flag <= Rclk and character_received_d;
      end if;
    end if;
  end process CHARACTER_RECEIVED_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: CONDITION_CODE_PROC
  -- purpose: Pass condition flags on
  -----------------------------------------------------------------------------
  CONDITION_CODE_PROC : process (Sys_clk) is
  begin  -- process CONDITION_CODE_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                      -- synchronous reset (active high)
        Rbr                <= (others => '0');
        parity_error_i     <= '0';
        framing_error_i    <= '0';
        Data_ready         <= '0';
        break_interrupt_i  <= '0';
        Character_received <= '0';
      else
        Rbr                <= rbr_d;
        parity_error_i     <= parity_error_latch and character_received_flag 
                                                 and parity_enable;
        framing_error_i    <= framing_error_flag and character_received_flag;
        break_interrupt_i  <= (not break_interrupt_flag) and 
                              character_received_flag;
        Character_received <= character_received_flag;
        Data_ready         <= character_received_flag;
      end if;
    end if;
  end process CONDITION_CODE_PROC;

  -- rx_fifo_data input generation
  Rx_fifo_data_in(7 downto 0) <= rbr_d(7 downto 0);
  Rx_fifo_data_in(8)          <= break_interrupt_i;
  Rx_fifo_data_in(9)          <= framing_error_i;
  Rx_fifo_data_in(10)         <= parity_error_i;
  
  -- generate error
  Parity_error                <= parity_error_i;                                 
  Framing_error               <= framing_error_i;
  Break_interrupt             <= break_interrupt_i;

  -----------------------------------------------------------------------------
  -- PROCESS: HAVE_BI_IN_FIFO_PROC
  -- purpose: generate receive fifo rst
  -----------------------------------------------------------------------------
  HAVE_BI_IN_FIFO_PROC : process (Sys_clk) is
  begin  -- process HAVE_BI_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' or sin_d2 = '1' then      -- synchronous reset (active high)
        have_bi_in_fifo_n_i <= '1';
      elsif (Fcr_0 = '0' and break_interrupt_flag = '0' and 
                             character_received_flag = '1') then
        have_bi_in_fifo_n_i <= '0';
      elsif (Fcr_0 = '1' and break_interrupt_flag = '0' and 
                                                  break_interrupt_i = '1') then
             have_bi_in_fifo_n_i <= '0';
      end if;
    end if;
  end process HAVE_BI_IN_FIFO_PROC;

-------------------------------------------------------------------------------
-- 16x clock processes
-------------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- PROCESS: LOAD_RBR_COND_PROC
  -- purpose: generate receive buffer load 
  -----------------------------------------------------------------------------
  LOAD_RBR_COND_PROC : process (Sys_clk) is
  begin  -- process LOAD_RBR_COND_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then        -- rising clock edge
      if Rst = '1' or resynch_clkdiv_d = '1' then  -- synchronous reset 
        load_rbr_d <= '0';                               -- (active high)
      elsif clk2x = '1' then
        load_rbr_d <= load_rbr_com;
      end if;
    end if;
  end process LOAD_RBR_COND_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: RBR_PROCESS
  -- purpose: load Rbr with receive data
  -----------------------------------------------------------------------------
  RBR_PROCESS : process (Sys_clk) is
  begin  -- process RBR_PROCESS
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                      -- synchronous reset (active high)
        rbr_d <= (others => '0');
      elsif clk1x = '1' and load_rbr_d = '1' then
        case numbits is
          when "11" =>                  -- 8 bits
            rbr_d(7 downto 0) <= rsr(7 downto 0);
          when "10" =>                  -- 7 bits
            rbr_d(7 downto 0) <= '0' & rsr(7 downto 1);
          when "01" =>                  -- 6 bits
            rbr_d(7 downto 0) <= "00" & rsr(7 downto 2);
          when "00" =>                  -- 5 bits
            rbr_d(7 downto 0) <= "000" & rsr(7 downto 3);
          -- coverage off
          when others =>                -- default to 8
            rbr_d(7 downto 0) <= rsr(7 downto 0);
          -- coverage on
        end case;
      end if;
    end if;
  end process RBR_PROCESS;

  -----------------------------------------------------------------------------
  -- PROCESS: PARITY_LATCH_PROC
  -- purpose: latch parity error
  -----------------------------------------------------------------------------
  PARITY_LATCH_PROC : process (Sys_clk) is
  begin  -- process PARITY_LATCH_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then               -- rising clock edge
      if Rst = '1' or character_received_rclk = '1' then  -- synchronous reset 
        parity_error_latch <= '0';                        -- (active high)
      elsif clk2x = '1' and load_rbr_d = '1' then
        parity_error_latch <= parity_error_d;
      end if;
    end if;
  end process PARITY_LATCH_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: SHIFT_RSR_PROC
  -- purpose: shift register to capture serial Sin input
  -----------------------------------------------------------------------------
  SHIFT_RSR_PROC : process (Sys_clk) is
  begin  -- process SHIFT_RSR_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                      -- synchronous reset (active high)
        rsr <= (others => '0');
      elsif clk1x_d = '1' then
        rsr(7)          <= sin_d2;
        rsr(6 downto 0) <= rsr(7 downto 1);
      end if;
    end if;
  end process SHIFT_RSR_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: RECEIVE_SM_REG_PROC
  -- purpose: register error flag and next state generation logic
  -----------------------------------------------------------------------------
  RECEIVE_SM_REG_PROC : process (Sys_clk) is
  begin  -- process RECEIVE_SM_REG_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then           -- rising clock edge
      if Rst = '1' or have_bi_in_fifo_n_i = '0' then  -- synchronous reset 
        parity_error_d          <= '0';               -- (active high)
        break_interrupt_error_d <= '0';
        framing_error_d         <= '0';
        character_received_d    <= '0';
        receive_state           <= IDLE;
      elsif clk1x = '1' then
        parity_error_d          <= rx_parity_com;
        break_interrupt_error_d <= break_interrupt_com;
        framing_error_d         <= framing_error_com;
        character_received_d    <= character_received_com;
        receive_state           <= next_state;
      end if;
    end if;
  end process RECEIVE_SM_REG_PROC;

  -----------------------------------------------------------------------------
  -- PROCESS: RECEIVE_SM_COM_PROC
  -- purpose: Receive state machine
  -----------------------------------------------------------------------------
  RECEIVE_SM_COM_PROC : process (break_interrupt_error_d, even_parity, Rst,    
                                 num_stop_bits, numbits, parity_enable,stick_parity,
                                 parity_error_d, receive_state, sin_d2) is
  begin  -- process RECEIVE_SM_COM_PROC
      rx_parity_com          <= '0';
      break_interrupt_com    <= '0';
      framing_error_com      <= '0';
      character_received_com <= '0';
      load_rbr_com           <= '0';
      got_start_bit_com      <= '0';
      next_state             <= receive_state;

      case receive_state is
        when IDLE =>
          rx_parity_com          <= not even_parity;
          break_interrupt_com    <= '0';
          framing_error_com      <= '0';
          character_received_com <= '0';
          load_rbr_com           <= '0';
          got_start_bit_com      <= '0';
          if sin_d2 = '0' then
            next_state <= START_BIT;
          else
            next_state <= IDLE;
          end if;

        when START_BIT =>
          rx_parity_com          <= parity_error_d xor sin_d2;
          break_interrupt_com    <= break_interrupt_error_d or sin_d2;
          framing_error_com      <= '0';
          character_received_com <= '0';
          load_rbr_com           <= '0';
          got_start_bit_com      <= '1';
          next_state             <= DATA_BIT1;

        when DATA_BIT1 =>
          rx_parity_com          <= parity_error_d xor sin_d2;
          break_interrupt_com    <= break_interrupt_error_d or sin_d2;
          framing_error_com      <= '0';
          character_received_com <= '0';
          load_rbr_com           <= '0';
          got_start_bit_com      <= '1';
          next_state             <= DATA_BIT2;

        when DATA_BIT2 =>
          rx_parity_com          <= parity_error_d xor sin_d2;
          break_interrupt_com    <= break_interrupt_error_d or sin_d2;
          framing_error_com      <= '0';
          character_received_com <= '0';
          load_rbr_com           <= '0';
          got_start_bit_com      <= '1';
          next_state             <= DATA_BIT3;

        when DATA_BIT3 =>
          rx_parity_com          <= parity_error_d xor sin_d2;
          break_interrupt_com    <= break_interrupt_error_d or sin_d2;
          framing_error_com      <= '0';
          character_received_com <= '0';
          load_rbr_com           <= '0';
          got_start_bit_com      <= '1';
          next_state             <= DATA_BIT4;

        when DATA_BIT4 =>
          rx_parity_com          <= parity_error_d xor sin_d2;
          break_interrupt_com    <= break_interrupt_error_d or sin_d2;
          framing_error_com      <= '0';
          character_received_com <= '0';
          load_rbr_com           <= '0';
          got_start_bit_com      <= '1';
          next_state             <= DATA_BIT5;

        when DATA_BIT5 =>
          character_received_com <= '0';
          got_start_bit_com      <= '1';

          -- When stic parity is enabled, Parity bit is checked as not of 
          -- Even Parity Select
          if stick_parity = '1' and numbits = "00"then 
            rx_parity_com        <= even_parity xnor sin_d2;
          else 
            rx_parity_com        <= parity_error_d xor sin_d2;
          end if;
          

          if numbits /= "00" then
            break_interrupt_com  <= break_interrupt_error_d or sin_d2;
            framing_error_com    <= '0';
            load_rbr_com         <= '0';
            next_state           <= DATA_BIT6;
          elsif parity_enable = '1' then
            break_interrupt_com  <= break_interrupt_error_d or sin_d2;
            framing_error_com    <= '0';
            load_rbr_com         <= '1';
            next_state           <= PARITY_BIT;
          elsif num_stop_bits = '0' and sin_d2 = '0' then
            break_interrupt_com  <= '0';
            framing_error_com    <= '1';
            load_rbr_com         <= '1';
            next_state           <= FRAME_ERROR; -- In case of frame error, 
                                               -- sample start bit twice
          elsif num_stop_bits = '1' and sin_d2 = '0' then
            break_interrupt_com    <= break_interrupt_error_d or sin_d2;
            framing_error_com      <= '1';
            load_rbr_com           <= '1';
            next_state             <= STOP_BIT1; -- In case of frame error, 
                                                 -- sample start bit twice
          else
            break_interrupt_com  <= break_interrupt_error_d or sin_d2;
            framing_error_com    <= '0';
            load_rbr_com         <= '1';
            next_state           <= STOP_BIT1;
          end if;
          
        when DATA_BIT6 =>
          character_received_com <= '0';
          got_start_bit_com      <= '1';
          
          -- When stic parity is enabled, Parity bit is checked as not of 
          -- Even Parity Select
          if stick_parity = '1' and numbits = "01"then 
            rx_parity_com        <= even_parity xnor sin_d2;
          else 
            rx_parity_com        <= parity_error_d xor sin_d2;
          end if;

          if numbits /= "01" then
            break_interrupt_com  <= break_interrupt_error_d or sin_d2;
            framing_error_com    <= '0';
            load_rbr_com         <= '0';
            next_state           <= DATA_BIT7;
          elsif parity_enable = '1' then
            break_interrupt_com  <= break_interrupt_error_d or sin_d2;
            framing_error_com    <= '0';
            load_rbr_com         <= '1';
            next_state           <= PARITY_BIT;
          elsif num_stop_bits = '0' and sin_d2 = '0' then
            break_interrupt_com  <= '0';
            framing_error_com    <= '1';
            load_rbr_com         <= '1';
            next_state           <= FRAME_ERROR; -- In case of frame error, 
                                                 -- sample start bit twice
          elsif num_stop_bits = '1' and sin_d2 = '0' then
            break_interrupt_com    <= break_interrupt_error_d or sin_d2;
            framing_error_com      <= '1';
            load_rbr_com           <= '1';
            next_state             <= STOP_BIT1; -- In case of frame error, 
                                                 -- sample start bit twice
          else
            break_interrupt_com  <= break_interrupt_error_d or sin_d2;
            framing_error_com    <= '0';
            load_rbr_com         <= '1';
            next_state           <= STOP_BIT1;
          end if;

        when DATA_BIT7 =>
          character_received_com <= '0';
          got_start_bit_com      <= '1';
          
          -- When stic parity is enabled, Parity bit is checked as not of 
          -- Even Parity Select
          if stick_parity = '1' and numbits = "10"then 
            rx_parity_com        <= even_parity xnor sin_d2;
          else 
            rx_parity_com        <= parity_error_d xor sin_d2;
          end if;
          
          if numbits /= "10" then
            break_interrupt_com  <= break_interrupt_error_d or sin_d2;
            framing_error_com    <= '0';
            load_rbr_com         <= '0';
            next_state           <= DATA_BIT8;
          elsif parity_enable = '1' then
            break_interrupt_com  <= break_interrupt_error_d or sin_d2;
            framing_error_com    <= '0';
            load_rbr_com         <= '1';
            next_state           <= PARITY_BIT;
          elsif num_stop_bits = '0' and sin_d2 = '0' then
            break_interrupt_com  <= '0';
            framing_error_com    <= '1';
            load_rbr_com         <= '1';
            next_state           <= FRAME_ERROR; -- In case of frame error, 
                                               -- sample start bit twice
          elsif num_stop_bits = '1' and sin_d2 = '0' then
            break_interrupt_com    <= break_interrupt_error_d or sin_d2;
            framing_error_com      <= '1';
            load_rbr_com           <= '1';
            next_state             <= STOP_BIT1; -- In case of frame error, 
                                                 -- sample start bit twice
          else
            break_interrupt_com  <= break_interrupt_error_d or sin_d2;
            framing_error_com    <= '0';
            load_rbr_com         <= '1';
            next_state           <= STOP_BIT1;
          end if;

        when DATA_BIT8 =>
          load_rbr_com           <= '1';
          got_start_bit_com      <= '1';
          
          -- When stic parity is enabled, Parity bit is checked as not of 
          -- Even Parity Select
          if stick_parity = '1' then 
            rx_parity_com        <= even_parity xnor sin_d2;
          else 
            rx_parity_com        <= parity_error_d xor sin_d2;
          end if;
          
          if parity_enable = '1' then
            break_interrupt_com    <= break_interrupt_error_d or sin_d2;
            framing_error_com      <= '0';
            character_received_com <= '0';
            next_state             <= PARITY_BIT;
          elsif num_stop_bits = '0' and sin_d2 = '0' then
            break_interrupt_com    <= break_interrupt_error_d or sin_d2;
            framing_error_com      <= '1';
            character_received_com <= '0';
            next_state             <= FRAME_ERROR; -- In case of frame error, 
                                                 -- sample start bit twice
          elsif num_stop_bits = '1' and sin_d2 = '0' then
            break_interrupt_com    <= break_interrupt_error_d or sin_d2;
            framing_error_com      <= '1';
            character_received_com <= '0';
            next_state             <= STOP_BIT1; -- In case of frame error, 
                                                 -- sample start bit twice
          else
            break_interrupt_com    <= break_interrupt_error_d or sin_d2;
            framing_error_com      <= '0';
            character_received_com <= '0';
            next_state             <= STOP_BIT1;
          end if;

        when PARITY_BIT =>
          rx_parity_com       <= not even_parity;
          load_rbr_com        <= '0';
          got_start_bit_com   <= '1';
          
          if num_stop_bits = '0' and sin_d2 = '0' then
            break_interrupt_com    <= '0';
            framing_error_com      <= '1';
            character_received_com <= '0';
            next_state             <= FRAME_ERROR; -- In case of frame error, 
                                                 -- sample start bit twice
          elsif num_stop_bits = '1' and sin_d2 = '0' then
            break_interrupt_com    <= break_interrupt_error_d or sin_d2;
            framing_error_com      <= '1';
            character_received_com <= '0';
            next_state             <= STOP_BIT1; -- In case of frame error, 
                                                   -- sample start bit twice
          else
            break_interrupt_com    <= break_interrupt_error_d or sin_d2;
            framing_error_com      <= '0';
            character_received_com <= '0';
            next_state             <= STOP_BIT1;
          end if;

        when STOP_BIT1 =>
          rx_parity_com <= not even_parity;
          load_rbr_com  <= '0';

          if num_stop_bits = '1' then
              break_interrupt_com    <= break_interrupt_error_d or sin_d2;
              framing_error_com      <= '0';
              character_received_com <= '0';
              got_start_bit_com      <= '1';
              next_state             <= STOP_BIT2;
          else
            if sin_d2 = '0' then
              break_interrupt_com    <= '0';
              framing_error_com      <= '0';
              character_received_com <= '1';
              got_start_bit_com      <= '1';
              next_state             <= START_BIT;
            else
              break_interrupt_com    <= '0';
              framing_error_com      <= '0';
              character_received_com <= '1';
              got_start_bit_com      <= '0';
              next_state             <= IDLE;
            end if;
          end if;

        when STOP_BIT2 =>
          rx_parity_com          <= not even_parity;
          break_interrupt_com    <= '0';
          framing_error_com      <= '0';
          load_rbr_com           <= '0';
          character_received_com <= '1';

          if sin_d2 = '0' then
            got_start_bit_com    <= '1';
            next_state           <= START_BIT;
          else
            got_start_bit_com    <= '0';
            next_state           <= IDLE;
          end if;
          
        when FRAME_ERROR =>
          rx_parity_com          <= not even_parity;
          break_interrupt_com    <= '0';
          framing_error_com      <= '0';
          load_rbr_com           <= '0';
          character_received_com <= '1';

          if sin_d2 = '0' then
            got_start_bit_com    <= '1';
            next_state           <= START_BIT;
          else
            got_start_bit_com    <= '0';
            next_state           <= IDLE;
          end if;
        

        -- coverage off
        when others =>
          rx_parity_com          <= '0';
          break_interrupt_com    <= '0';
          framing_error_com      <= '0';
          load_rbr_com           <= '0';
          character_received_com <= '0';
          got_start_bit_com      <= '0';
          next_state             <= IDLE;
        -- coverage on
      end case;

  end process RECEIVE_SM_COM_PROC;

end implementation;
