--------------------------------------------------------------------------------
-- xuart.vhd - entity/architecture pair
--------------------------------------------------------------------------------
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
-- Filename:        xuart.vhd
-- Version:         v2.0
-- Description:     This module instantiates the uart 16550 core , 
--                  and ipic_if.vhd modules
--                                        
-- VHDL-Standard:   VHDL'93
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
library lib_cdc_v1_0_2;

-------------------------------------------------------------------------------
-- axi_uart16550_v2_0_8 library is used for axi_uart16550_v2_0_8 
-- component declarations
-------------------------------------------------------------------------------
library axi_uart16550_v2_0_8;
use axi_uart16550_v2_0_8.uart16550;
use axi_uart16550_v2_0_8.ipic_if;


-------------------------------------------------------------------------------
-- Definition of Generics:
-- System generics
--    C_FAMILY              --  Xilinx FPGA Family
--    C_S_AXI_CLK_FREQ_HZ   --  System clock frequency driving UART lite
--                              peripheral in Hz
--                            
-- AXI generics               
--    C_S_AXI_BASEADDR      --  Base address of the core
--    C_S_AXI_HIGHADDR      --  Permits alias of address space
--                              by making greater than xFFF
--    C_S_AXI_ADDR_WIDTH    --  Width of AXI Address Bus (in bits)
--    C_S_AXI_DATA_WIDTH    --  Width of the AXI Data Bus (in bits)
--			    
-- UART 16550 generics         
--    C_IS_A_16550          --  Selection of UART for 16450 or 16550 mode
--    C_HAS_EXTERNAL_XIN    --  External XIN
--    C_HAS_EXTERNAL_RCLK   --  External RCLK
--    C_EXTERNAL_XIN_CLK_HZ --  External XIN clock frequency
-------------------------------------------------------------------------------
--
-- Definition of ports:
-- IPIC signals
--    Bus2IP_Clk          --  Bus to IP clock
--    Bus2IP_Reset        --  Bus to IP reset
--    Bus2IP_Addr         --  Bus to IP address
--    Bus2IP_RdCE         --  Bus to IP read chip enables
--    Bus2IP_WrCE         --  Bus to IP write chip enables
--    Bus2IP_Data         --  Bus to IP data
--    IP2Bus_Data         --  IP to bus data
--    IP2Bus_WrAck        --  IP to bus write acknowledge
--    IP2Bus_RdAck        --  IP to bus read acknowledge
--
-- UART16550 interface signals
--    BaudoutN            --  Transmitter Clock
--    CtsN                --  Clear To Send (active low)
--    DcdN                --  Data Carrier Detect (active low)
--    Ddis                --  Driver Disable
--    DsrN                --  Data Set Ready (active low)
--    DtrN                --  Data Terminal Ready (active low)
--    Out1N               --  User controlled output1
--    Out2N               --  User controlled output2
--    Rclk                --  Receiver 16x Clock
--    RiN                 --  Ring Indicator (active low)
--    RtsN                --  Request To Send (active low)
--    RxrdyN              --  DMA control signal
--    Sin                 --  Serial Data Input
--    Sout                --  Serial Data Output
--    Xin                 --  Baud Rate Generator reference clock
--    Xout                --  Inverted XIN
--    TxrdyN              --  DMA control signal
--    IP2INTC_Irpt        --  Interrupt signal
--    Freeze              --  Freezes UART for software debug (active high)
--    Intr                --  Uart interupt (not used)
-------------------------------------------------------------------------------
-- Entity section
-------------------------------------------------------------------------------

entity xuart is
  
  generic (
    C_FAMILY                : string;
    C_S_AXI_CLK_FREQ_HZ     : integer                 := 100_000_000;
    AXI_DATA_WIDTH          : integer  range 32 to 32 := 32;
    AXI_ADDR_WIDTH          : integer                 := 32; 
    C_IS_A_16550            : boolean;
    C_HAS_EXTERNAL_XIN      : boolean;
    C_HAS_EXTERNAL_RCLK     : boolean;
    C_EXTERNAL_XIN_CLK_HZ   : integer                 := 25_000_000
    ); 

   port (

    -- Controls to the IP/IPIF modules
    Bus2IP_Clk     : in  std_logic;
    Bus2IP_Reset   : in  std_logic;
    Bus2IP_Addr    : in  std_logic_vector(2 downto 0);
    Bus2IP_RdCE    : in  std_logic;
    Bus2IP_WrCE    : in  std_logic;
    Bus2IP_Data    : in  std_logic_vector((AXI_DATA_WIDTH-1) downto 0);
    IP2Bus_Data    : out std_logic_vector((AXI_DATA_WIDTH-1) downto 0);
    IP2Bus_WrAck   : out std_logic;
    IP2Bus_RdAck   : out std_logic;
    
    -- Uart Signals
    BaudoutN       : out std_logic;
    CtsN           : in  std_logic;
    DcdN           : in  std_logic;
    Ddis           : out std_logic;
    DsrN           : in  std_logic;
    DtrN           : out std_logic;
    Out1N          : out std_logic;
    Out2N          : out std_logic;
    Rclk           : in  std_logic;
    RiN            : in  std_logic;
    RtsN           : out std_logic;
    RxrdyN         : out std_logic;
    Sin            : in  std_logic;
    Sout           : out std_logic;
    IP2INTC_Irpt   : out std_logic;
    TxrdyN         : out std_logic;
    Xin            : in  std_logic;
    Xout           : out std_logic;
    Freeze         : in  std_logic;
    Intr           : out std_logic
    );

end xuart;

-------------------------------------------------------------------------------
-- Architecture section
-------------------------------------------------------------------------------
architecture imp of xuart is

-- Pragma Added to supress synth warnings
attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of imp : architecture is "yes";


  -----------------------------------------------------------------------------
    -- Signal and Type Declarations
  -----------------------------------------------------------------------------
  signal Rd               : std_logic;
  signal Wr               : std_logic;
  signal baudoutN_int     : std_logic;
  signal rclk_int         : std_logic;
  signal uart_intr        : std_logic;
  signal xin_int          : std_logic;
  signal bus2ip_cs_i      : std_logic;
  signal bus2ip_rdreq_i   : std_logic;
  signal bus2ip_wrreq_i   : std_logic;
 
  -----------------------------------------------------------------------------
    -- Begin Architecture
  -----------------------------------------------------------------------------
    
  begin
  
  -----------------------------------------------------------------------------
  -- Component Instantiations
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
    -- Entity UART instantiation
  -----------------------------------------------------------------------------
       
   UART16550_I_1 : entity axi_uart16550_v2_0_8.uart16550
    generic map (
      C_FAMILY              => C_FAMILY,
      C_S_AXI_CLK_FREQ_HZ   => C_S_AXI_CLK_FREQ_HZ,
      C_IS_A_16550          => C_IS_A_16550,
      C_HAS_EXTERNAL_XIN    => C_HAS_EXTERNAL_XIN,
      C_EXTERNAL_XIN_CLK_HZ => C_EXTERNAL_XIN_CLK_HZ)
    port map (
      Din          => Bus2IP_Data(7 downto 0),
      Dout         => IP2Bus_Data(7 downto 0),
      Sout         => Sout,
      BaudoutN     => BaudoutN,
      BaudoutN_int => baudoutN_int, 
      Intr         => uart_intr,
      Ddis         => Ddis,
      TxrdyN       => TxrdyN,
      RxrdyN       => RxrdyN,
      Xout         => Xout,
      RtsN         => RtsN,
      DtrN         => DtrN,
      Out1N        => Out1N,
      Out2N        => Out2N,
      Addr         => Bus2IP_Addr,
      Cs0          => bus2ip_cs_i,
      Cs1          => '1',
      Cs2N         => '0',
      AdsN         => '0',
      Sin          => Sin,
      Rclk         => rclk_int,
      Xin          => xin_int,
      Rd           => Rd,
      RdN          => '1',
      Wr           => Wr,
      WrN          => '1',
      Rst          => Bus2IP_Reset,
      CtsN         => CtsN,
      DcdN         => DcdN,
      DsrN         => DsrN,
      RiN          => RiN,
      Freeze       => Freeze,
      Sys_clk      => Bus2IP_Clk);


  -- IPIC signals
  IP2Bus_Data(AXI_DATA_WIDTH-1 downto 8) <= (others => '0');
  IP2INTC_Irpt  <= uart_intr;  
  Intr          <= uart_intr;



  -----------------------------------------------------------------------------
    -- Entity IPIC_IC instantiation
  -----------------------------------------------------------------------------
  
  IPIC_IF_I_1 : entity axi_uart16550_v2_0_8.ipic_if 
    port map
       (
       Bus2IP_Clk             => Bus2IP_Clk,
       Bus2IP_Reset           => Bus2IP_Reset,
       Bus2IP_RdCE            => Bus2IP_RdCE,
       Bus2IP_WrCE            => Bus2IP_WrCE,
       Bus2IP_RdReq           => bus2ip_rdreq_i,
       Bus2IP_WrReq           => bus2ip_wrreq_i,
       Wr                     => Wr,
       Rd                     => Rd,
                              
       -- IPIF signals        
       IP2Bus_WrAcknowledge   => IP2Bus_WrAck,
       IP2Bus_RdAcknowledge   => IP2Bus_RdAck
       );
  
  -----------------------------------------------------------------------------
  -- GENERATING_EXTERNAL_RCLK : Synchronize Rclk clock with system clock if 
  -- external receive clock is selected.
  -----------------------------------------------------------------------------
  GENERATING_EXTERNAL_RCLK : if C_HAS_EXTERNAL_RCLK = TRUE generate

    signal rclk_d1 : std_logic;
    signal rclk_d2 : std_logic;
    signal rclk_d3 : std_logic;

  begin
  
    ---------------------------------------------------------------------------
     -- purpose: detects rising edge of Rclk
     -- type   : sequential
     -- inputs : Bus2IP_Clk, Rclk
    ---------------------------------------------------------------------------
    RCLK_CDC : entity lib_cdc_v1_0_2.cdc_sync
    generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_VECTOR_WIDTH             => 32,
        C_MTBF_STAGES              => 4
    )
    port map (
        prmry_aclk                 => '0',
        prmry_resetn               => '0', 
        prmry_in                   => Rclk, 
        prmry_vect_in              => (others => '0'),
                                    
        scndry_aclk                => Bus2IP_Clk , 
        scndry_resetn              => '0',
        scndry_out                 => rclk_d2,
        scndry_vect_out            => open
    );

    RCLK_RISING_EDGE : process (Bus2IP_Clk) is
      begin  -- process RCLK_RISING_EDGE
        if Bus2IP_Clk'event and Bus2IP_Clk = '1' then  -- rising clock edge
          --rclk_d1 <= Rclk;
          rclk_d3 <= rclk_d2;
      end if;
    end process RCLK_RISING_EDGE;
    
    rclk_int <= rclk_d2 and (not rclk_d3) and (not Bus2IP_Reset);
  end generate GENERATING_EXTERNAL_RCLK;

  -----------------------------------------------------------------------------
  -- NOT_GENERATING_EXTERNAL_RCLK : If external receive clock is not available,
  -- use baudoutN_int as a receive clock
  -----------------------------------------------------------------------------
  NOT_GENERATING_EXTERNAL_RCLK : if C_HAS_EXTERNAL_RCLK /= TRUE generate
  begin
    rclk_int <= not baudoutN_int;
  end generate NOT_GENERATING_EXTERNAL_RCLK;

  -----------------------------------------------------------------------------
  -- GENERATING_EXTERNAL_XIN : Synchronize Xin clock with system clock if 
  -- external Xin clock is selected.
  -----------------------------------------------------------------------------
  GENERATING_EXTERNAL_XIN : if C_HAS_EXTERNAL_XIN = TRUE generate

    signal xin_d1 : std_logic;
    signal xin_d2 : std_logic;
    signal xin_d3 : std_logic;

  begin
  
    ---------------------------------------------------------------------------
    -- purpose: detects rising edge of xin
    -- Type   : sequential
    -- inputs : Bus2IP_Clk, xin
    -- outputs: xin_rising
    ---------------------------------------------------------------------------
    XIN_CDC : entity lib_cdc_v1_0_2.cdc_sync
    generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_VECTOR_WIDTH             => 32,
        C_MTBF_STAGES              => 4
    )
    port map (
        prmry_aclk                 => '0',
        prmry_resetn               => '0', 
        prmry_in                   => Xin, 
        prmry_vect_in              => (others => '0'),
                                    
        scndry_aclk                => Bus2IP_Clk , 
        scndry_resetn              => '0',
        scndry_out                 => xin_d2,
        scndry_vect_out            => open
    );

    XIN_RISING_EDGE: process (Bus2IP_Clk) is
    begin  -- process XIN_RISING_EDGE
      if Bus2IP_Clk'event and Bus2IP_Clk = '1' then  -- rising clock edge
         -- xin_d1 <= Xin;
          xin_d3 <= xin_d2;
      end if;
    end process XIN_RISING_EDGE;
    xin_int <= xin_d2 and (not xin_d3);  -- inverted to make baudoutN
  end generate GENERATING_EXTERNAL_XIN;

  -----------------------------------------------------------------------------
  -- NOT_GENERATING_EXTERNAL_XIN : If external xin clock is not available,
  -- drive xin_int with '1'. 
  -----------------------------------------------------------------------------
  NOT_GENERATING_EXTERNAL_XIN : if C_HAS_EXTERNAL_XIN /= TRUE generate
  begin
    xin_int <= '1';                      -- xin in always active
  end generate NOT_GENERATING_EXTERNAL_XIN;
  
  bus2ip_cs_i <= bus2ip_rdreq_i or bus2ip_wrreq_i;  

end imp;
