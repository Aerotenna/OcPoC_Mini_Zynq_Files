-------------------------------------------------------------------------------
-- ipic_if.vhd - entity/architecture pair
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
-- Filename:        ipic_if.vhd
-- Version:         v1.01.a
-- Description:     This module has the logic for generation ofacknowledgemet
--                  signals for read and write transactions to UART and also
--                  incorporates the logic for generation of 3-bit address 
--                  for UART registers alongwith single pulse read and write
--                  signals for UART.

-- VHDL-Standard:   VHDL'93
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
-- Definition of Generics:

-- Definition of ports:
--   IPIC 
--     Bus2IP_Clk           -- Bus to IP clock 
--     Bus2IP_Reset         -- Bus to IP reset   
--     Bus2IP_RdCE          -- Bus to IP read chip enables
--     Bus2IP_WrCE          -- Bus to IP write chip enables
--     Bus2IP_RdReq         -- Bus to IP read request
--     Bus2IP_WrReq         -- Bus to IP write request
--     IP2Bus_WrAcknowledge -- IP to Bus write acknowledge
--     IP2Bus_RdAcknowledge -- IP to Bus read acknowledge
      
--  UART core Interface signals
--     Rd                   -- UART Read
--     Wr                   -- UART Write        
        
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Entity section
-------------------------------------------------------------------------------
entity ipic_if is
  port (
     -- IPIC Signals
        Bus2IP_Clk           : in std_logic;
        Bus2IP_Reset         : in std_logic;
        Bus2IP_RdCE          : in std_logic;
        Bus2IP_WrCE          : in std_logic;
        Bus2IP_RdReq         : out std_logic;
        Bus2IP_WrReq         : out std_logic;
                             
     -- UART Signals         
        Wr                   : out std_logic;
        Rd                   : out std_logic;
                             
     -- IPIF signals         
        IP2Bus_WrAcknowledge : out std_logic;
        IP2Bus_RdAcknowledge : out std_logic
      );
end ipic_if;

-------------------------------------------------------------------------------
-- Architecture section
-------------------------------------------------------------------------------

architecture imp of ipic_if is
-- Pragma Added to supress synth warnings
attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of imp : architecture is "yes";
-------------------------------------------------------------------------------
-- Function Declarations
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Signal Declarations
-------------------------------------------------------------------------------

  signal bus2ip_rdreq_i   : std_logic;
  signal bus2ip_wrreq_i   : std_logic;
  
  signal ip2bus_wrack     : std_logic;
  signal ip2bus_rdack     : std_logic;
  signal ip2bus_wrack_d1  : std_logic;
  signal ip2bus_rdack_d1  : std_logic;
  signal bus2ip_rdreq_d1  : std_logic;
  signal bus2ip_rdreq_d2  : std_logic;
  signal bus2ip_rdreq_d3  : std_logic;
  signal bus2ip_rdreq_d4  : std_logic;
      
  signal wrReq_d1         : std_logic;
  signal wrReq_d2         : std_logic;
  signal wrReq_d3         : std_logic;

begin 
    
  -----------------------------------------------------------------------------
  -- bus2ip_rdreq_i generated if any one of the Bus2IP_RdCE is asserted 
  -----------------------------------------------------------------------------
  bus2ip_rdreq_i  <= Bus2IP_RdCE;
  
  -----------------------------------------------------------------------------
  -- bus2ip_wrreq_i generated if any one of the Bus2IP_WrCE is asserted 
  -----------------------------------------------------------------------------
  bus2ip_wrreq_i  <= Bus2IP_WrCE;                         
  
  Bus2IP_RdReq    <= bus2ip_rdreq_i;
  Bus2IP_WrReq    <= bus2ip_wrreq_i;
 
  ---------------------------------------------------------------------------
  -- PROCESS: RDREQ_D
  -- purpose: register bus2ip_rdreq
  ---------------------------------------------------------------------------
  RDREQ_D : process (Bus2IP_Clk) is
    begin  
      if Bus2IP_Clk'EVENT and Bus2IP_Clk = '1' then  -- rising clock edge
        if Bus2IP_Reset = '1' then                  
          bus2ip_rdreq_d1 <= '0';
        else
          bus2ip_rdreq_d1 <= bus2ip_rdreq_i;
        end if;
      end if;
  end process RDREQ_D;
   
  ---------------------------------------------------------------------------
  -- PROCESS: RX_ERR_IN_FIFO_CNT_PROC
  -- purpose: Write Ack & read Acks back to IPIF are registered
  ---------------------------------------------------------------------------
  ACKN: process(Bus2IP_Clk)
  begin
    if(Bus2IP_Clk'event and Bus2IP_Clk = '1') then
      if Bus2IP_Reset = '1' then
        ip2bus_wrack_d1       <= '0';
        ip2bus_rdack_d1       <= '0';
        IP2Bus_WrAcknowledge  <= '0';
        IP2Bus_RdAcknowledge  <= '0';
      else                    
        ip2bus_wrack_d1       <= ip2bus_wrack;
        ip2bus_rdack_d1       <= ip2bus_rdack;
        IP2Bus_WrAcknowledge  <= ip2bus_wrack_d1;
        IP2Bus_RdAcknowledge  <= ip2bus_rdack_d1;
      end if;
    end if;
  end process ACKN; 
  
   
 ------------------------------------------------------------------------------
  -- The logic in XUART_WRITE process for the generation of acknowledge and 
  -- write signal for write operations initiated in UART 16550 registers 
 ------------------------------------------------------------------------------ 
  XUART_WRITE : process (Bus2IP_Clk) is
    begin  -- process XUART_WRITE
     if Bus2IP_Clk'EVENT and Bus2IP_Clk = '1' then  -- rising clock edge
       if Bus2IP_Reset = '1' then                  
         wrReq_d1   <= '0';
         wrReq_d2   <= '0';
         wrReq_d3   <= '0';
       else         
         wrReq_d1   <= bus2ip_wrreq_i;
         wrReq_d2   <= wrReq_d1;
         wrReq_d3   <= wrReq_d2;
       end if;
     end if;
  end process XUART_WRITE;
      
  ip2bus_wrack  <= wrReq_d2 and (not wrReq_d3);
  Wr            <= bus2ip_wrreq_i and (not wrReq_d1);
   
   
 ------------------------------------------------------------------------------
  -- The logic in XUART_READ process for the generation of acknowledge and read
  -- signal for read operations initiated in UART 16550 registers 
 ------------------------------------------------------------------------------  
  XUART_READ : process (Bus2IP_Clk) is
  begin  -- process XUART_READ
    if Bus2IP_Clk'EVENT and Bus2IP_Clk = '1' then  -- rising clock edge
      if Bus2IP_Reset = '1' then                  
        bus2ip_rdreq_d2 <= '0';
        bus2ip_rdreq_d3 <= '0';
        bus2ip_rdreq_d4 <= '0';
      else
        bus2ip_rdreq_d2 <= bus2ip_rdreq_d1;
        bus2ip_rdreq_d3 <= bus2ip_rdreq_d2;
        bus2ip_rdreq_d4 <= bus2ip_rdreq_d3;
      end if;
    end if;
  end process XUART_READ;
  
  -- Read ack generation
  ip2bus_rdack <= bus2ip_rdreq_d3 and (not bus2ip_rdreq_d4);
  Rd           <= bus2ip_rdreq_d1 and (not bus2ip_rdreq_d2);  
  
end imp;
