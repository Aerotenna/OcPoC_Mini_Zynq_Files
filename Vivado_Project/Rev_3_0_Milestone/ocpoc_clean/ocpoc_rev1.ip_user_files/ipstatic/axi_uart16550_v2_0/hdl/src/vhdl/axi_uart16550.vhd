-------------------------------------------------------------------------------
-- axi_uart16550.vhd - entity/architecture pair
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
-- Filename:        axi_uart16550.vhd
-- Version:         v2.0
-- Description:     This is the top level module for axi 16550 uart core.
--                  This module has interfaces to AXI Lite IPIF,
--                  Serial port and Modem and incorporates the logic for 
--                  UART 16550 core functionality and interfacing logic 
--                  for AXI.
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
-- axi_uart16550_v2_0_8 library is used for axi_uart16550_v2_0_8 
-- component declarations
-------------------------------------------------------------------------------
library axi_uart16550_v2_0_8;
    use axi_uart16550_v2_0_8.xuart;

-------------------------------------------------------------------------------
-- axi_lite_ipif_v2_0 library is used for AXI Lite IPIF 
-- component declarations
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- proc common package of the proc common library is used for different 
-- function declarations
-------------------------------------------------------------------------------
library axi_lite_ipif_v3_0_3;
-- SLV64_ARRAY_TYPE refered from ipif_pkg
use axi_lite_ipif_v3_0_3.ipif_pkg.SLV64_ARRAY_TYPE;
-- INTEGER_ARRAY_TYPE refered from ipif_pkg
use axi_lite_ipif_v3_0_3.ipif_pkg.INTEGER_ARRAY_TYPE;
    use axi_lite_ipif_v3_0_3.axi_lite_ipif;

-------------------------------------------------------------------------------
-- Definition of Generics :
-------------------------------------------------------------------------------
-- System generics
--    C_FAMILY              --  Xilinx FPGA Family
--    C_S_AXI_ACLK_FREQ_HZ  --  System clock frequency driving UART lite
--                              peripheral in Hz
--                          
-- AXI generics             
--    C_S_AXI_ADDR_WIDTH    --  Width of AXI Address Bus (in bits)
--    C_S_AXI_DATA_WIDTH    --  Width of the AXI Data Bus (in bits)
--
-- UART 16550 generics       
--    C_IS_A_16550          --  Selection of UART for 16450 or 16550 mode
--    C_HAS_EXTERNAL_XIN    --  External XIN
--    C_HAS_EXTERNAL_RCLK   --  External RCLK
--    C_EXTERNAL_XIN_CLK_HZ --  External XIN clock frequency
-------------------------------------------------------------------------------
-- Definition of Ports :
-------------------------------------------------------------------------------
-- System signals
--    s_axi_aclk          --  AXI Clock
--    s_axi_aresetn       --  AXI Reset
--    ip2intc_irpt        --  Device interrupt output to microprocessor 
--                            interrupt input or system interrupt controller.
--    freeze              --  Freezes UART for software debug (active high)
--                            
-- AXI signals                
--    s_axi_awaddr        --  AXI Write address
--    s_axi_awvalid       --  Write address valid
--    s_axi_awready       --  Write address ready
--    s_axi_wdata         --  Write data
--    s_axi_wstrb         --  Write strobes
--    s_axi_wvalid        --  Write valid
--    s_axi_wready        --  Write ready
--    s_axi_bresp         --  Write response
--    s_axi_bvalid        --  Write response valid
--    s_axi_bready        --  Response ready
--    s_axi_araddr        --  Read address
--    s_axi_arvalid       --  Read address valid
--    s_axi_arready       --  Read address ready
--    s_axi_rdata         --  Read data
--    s_axi_rresp         --  Read response
--    s_axi_rvalid        --  Read valid
--    s_axi_rready        --  Read ready
--
-- UART16550 interface signals
--    baudoutn            --  Transmitter Clock
--    rclk                --  Receiver 16x Clock
--    sin                 --  Serial Data Input
--    sout                --  Serial Data Output
--    xin                 --  Baud Rate Generator reference clock
--    xout                --  Inverted XIN
--    ctsn                --  Clear To Send (active low)
--    dcdn                --  Data Carrier Detect (active low)
--    dsrn                --  Data Set Ready (active low)
--    dtrn                --  Data Terminal Ready (active low)
--    rin                 --  Ring Indicator (active low)
--    rtsn                --  Request To Send (active low)
--    ddis                --  Driver Disable
--    out1n               --  User controlled output1
--    out2n               --  User controlled output2
--    rxrdyn              --  DMA control signal
--    txrdyn              --  DMA control signal
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Entity section
-------------------------------------------------------------------------------

entity axi_uart16550 is

  generic (

--  -- System Parameter
    C_FAMILY              : string                        := "virtex7";
    C_S_AXI_ACLK_FREQ_HZ  : integer                       := 100_000_000;
--  -- AXI Parameters
    C_S_AXI_ADDR_WIDTH    : integer                       := 13;
    C_S_AXI_DATA_WIDTH    : integer range 32 to 128       := 32;
--  -- UARTLite Parameters
    C_IS_A_16550          : integer range 0 to 1          := 1;
    C_HAS_EXTERNAL_XIN    : integer range 0 to 1          := 0;
    C_HAS_EXTERNAL_RCLK   : integer range 0 to 1          := 0;
    C_EXTERNAL_XIN_CLK_HZ : integer                       := 25_000_000
   );
 
  port (
    -- System signals
    s_axi_aclk       : in  std_logic;
    s_axi_aresetn    : in  std_logic;
    ip2intc_irpt     : out std_logic;
    freeze           : in  std_logic;

-- AXI signals
    s_axi_awaddr     : in  std_logic_vector(12 downto 0);
    s_axi_awvalid    : in  std_logic;
    s_axi_awready    : out std_logic;
    s_axi_wdata      : in  std_logic_vector(31 downto 0);
    s_axi_wstrb      : in  std_logic_vector(3 downto 0);
    s_axi_wvalid     : in  std_logic;
    s_axi_wready     : out std_logic;
    s_axi_bresp      : out std_logic_vector(1 downto 0);
    s_axi_bvalid     : out std_logic;
    s_axi_bready     : in  std_logic;
    s_axi_araddr     : in  std_logic_vector(12 downto 0);
    s_axi_arvalid    : in  std_logic;
    s_axi_arready    : out std_logic;
    s_axi_rdata      : out std_logic_vector(31 downto 0);
    s_axi_rresp      : out std_logic_vector(1 downto 0);
    s_axi_rvalid     : out std_logic;
    s_axi_rready     : in  std_logic;

    -- UART16550 Interface Signals
    baudoutn         : out std_logic;
    ctsn             : in  std_logic;
    dcdn             : in  std_logic;
    ddis             : out std_logic;
    dsrn             : in  std_logic;
    dtrn             : out std_logic;
    out1n            : out std_logic;
    out2n            : out std_logic;
    rclk             : in  std_logic := '0';
    rin              : in  std_logic;
    rtsn             : out std_logic;
    rxrdyn           : out std_logic;
    sin              : in  std_logic;
    sout             : out std_logic;
    txrdyn           : out std_logic;
    xin              : in  std_logic := '0';
    xout             : out std_logic
);

  
  --fan-out attributes for XST
  attribute MAX_FANOUT                  : string;             
  attribute MAX_FANOUT of s_axi_aclk    : signal   is "10000";  
  attribute MAX_FANOUT of s_axi_aresetn : signal   is "10000";
  
  attribute SIGIS                       : string;             
  attribute SIGIS of rclk               : signal   is "CLK";  
  attribute SIGIS of xin                : signal   is "CLK";
  attribute SIGIS of ip2intc_irpt       : signal   is "INTERRUPT";

end entity axi_uart16550;

-------------------------------------------------------------------------------
-- Architecture section
-------------------------------------------------------------------------------
architecture rtl of axi_uart16550 is
-- Pragma Added to supress synth warnings
attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of rtl : architecture is "yes";

 

  -----------------------------------------------------------------------------
    -- Constant Declarations
  -----------------------------------------------------------------------------
  constant  ZEROES                : std_logic_vector := X"00000000";

 
  constant UART_REG_BASEADDR  : std_logic_vector  := X"00000000" or X"00001000";
  constant UART_REG_HIGHADDR  : std_logic_vector  := X"00000000" or X"0000101F";
 
  constant ARD_ADDR_RANGE_ARRAY : SLV64_ARRAY_TYPE  :=
        (
         ZEROES & UART_REG_BASEADDR, -- Uart Reg Base Address
         ZEROES & UART_REG_HIGHADDR  -- Uart Reg High Address
        );

  constant ARD_NUM_CE_ARRAY     : INTEGER_ARRAY_TYPE :=
          (
           0 => 1   
          );

  constant AXI_MIN_SIZE       : std_logic_vector(31 downto 0) := X"0000001F";
  constant USE_WSTRB          : integer := 1;
  constant DPHASE_TIMEOUT     : integer := 0;

  -----------------------------------------------------------------------------
    -- Signal and Type Declarations
  -----------------------------------------------------------------------------
  signal bus2ip_clk_i     : std_logic;
  signal bus2ip_data_i    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal bus2ip_addr_i    : std_logic_vector(12 downto 0);
  signal bus2ip_reset_i   : std_logic;
  signal ip2bus_data_i    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal bus2ip_rdce_i    : std_logic_vector(0 downto 0);
  signal bus2ip_wrce_i    : std_logic_vector(0 downto 0);
  signal ip2bus_wrack_i   : std_logic;
  signal ip2bus_rdack_i   : std_logic;
  signal bus2ip_reset_int      : std_logic;
  signal bus2ip_reset_int_core : std_logic;

 
  -----------------------------------------------------------------------------
    -- Begin Architecture
  -----------------------------------------------------------------------------
    
  begin
  

  -----------------------------------------------------------------------------
  -- Component Instantiations
  -----------------------------------------------------------------------------

    --------------------------------------------------------------------------
    -- Instantiate AXI lite IPIF
    --------------------------------------------------------------------------
    AXI_LITE_IPIF_I : entity axi_lite_ipif_v3_0_3.axi_lite_ipif
      generic map
       (
        C_S_AXI_ADDR_WIDTH        => 13,
        C_S_AXI_DATA_WIDTH        => C_S_AXI_DATA_WIDTH,
        C_S_AXI_MIN_SIZE          => AXI_MIN_SIZE,
        C_USE_WSTRB               => USE_WSTRB,
        C_DPHASE_TIMEOUT          => DPHASE_TIMEOUT,
        C_ARD_ADDR_RANGE_ARRAY    => ARD_ADDR_RANGE_ARRAY,
        C_ARD_NUM_CE_ARRAY        => ARD_NUM_CE_ARRAY,
        C_FAMILY                  => C_FAMILY
       )
     port map
       (
        S_AXI_ACLK       => s_axi_aclk,
        S_AXI_ARESETN    => s_axi_aresetn,
        S_AXI_AWADDR     => s_axi_awaddr,
        S_AXI_AWVALID    => s_axi_awvalid,
        S_AXI_AWREADY    => s_axi_awready,
        S_AXI_WDATA      => s_axi_wdata,
        S_AXI_WSTRB      => s_axi_wstrb,
        S_AXI_WVALID     => s_axi_wvalid,
        S_AXI_WREADY     => s_axi_wready,
        S_AXI_BRESP      => s_axi_bresp,
        S_AXI_BVALID     => s_axi_bvalid,
        S_AXI_BREADY     => s_axi_bready,
        S_AXI_ARADDR     => s_axi_araddr,
        S_AXI_ARVALID    => s_axi_arvalid,
        S_AXI_ARREADY    => s_axi_arready,
        S_AXI_RDATA      => s_axi_rdata,
        S_AXI_RRESP      => s_axi_rresp,
        S_AXI_RVALID     => s_axi_rvalid,
        S_AXI_RREADY     => s_axi_rready,
     
     -- IP Interconnect (IPIC) port signals 
        Bus2IP_Clk       => bus2ip_clk_i,
        Bus2IP_Resetn    => bus2ip_reset_int,
        Bus2IP_Addr      => bus2ip_addr_i,
        Bus2IP_Data      => bus2ip_data_i,
        Bus2IP_RNW       => open,
        Bus2IP_BE        => open,
        Bus2IP_CS        => open,
        Bus2IP_RdCE      => bus2ip_rdce_i,
        Bus2IP_WrCE      => bus2ip_wrce_i,
        IP2Bus_Data      => ip2bus_data_i,
        IP2Bus_WrAck     => ip2bus_wrack_i,
        IP2Bus_RdAck     => ip2bus_rdack_i,
        IP2Bus_Error     => '0'
       );


      ----------------------
      --REG_RESET_FROM_IPIF: convert active low to active hig reset to rest of 
      --                     the core.
      ----------------------    
      REG_RESET_FROM_IPIF: process (s_axi_aclk) is
      begin
           if(s_axi_aclk'event and s_axi_aclk = '1') then
           bus2ip_reset_int_core <= not(bus2ip_reset_int);
           end if;
      end process REG_RESET_FROM_IPIF;

    --------------------------------------------------------------------------
    -- Instantiate UART16550
    --------------------------------------------------------------------------

    XUART_I_1 : entity axi_uart16550_v2_0_8.xuart
    generic map (
      C_IS_A_16550          => C_IS_A_16550 /= 0,         -- default TRUE
      C_HAS_EXTERNAL_XIN    => C_HAS_EXTERNAL_XIN /= 0,   -- default TRUE
      C_HAS_EXTERNAL_RCLK   => C_HAS_EXTERNAL_RCLK /= 0,  -- default TRUE
      C_EXTERNAL_XIN_CLK_HZ => C_EXTERNAL_XIN_CLK_HZ,
      C_FAMILY              => C_FAMILY,
      C_S_AXI_CLK_FREQ_HZ   => C_S_AXI_ACLK_FREQ_HZ,
      AXI_ADDR_WIDTH        => 13,
      AXI_DATA_WIDTH        => C_S_AXI_DATA_WIDTH
      )
    port map (
      Bus2IP_Clk     => bus2ip_clk_i,
      Bus2IP_Reset   => bus2ip_reset_int_core,
      Bus2IP_Addr    => bus2ip_addr_i(4 downto 2),
      Bus2IP_Data    => bus2ip_data_i,
      Bus2IP_RdCE    => bus2ip_rdce_i(0),
      Bus2IP_WrCE    => bus2ip_wrce_i(0),
      IP2Bus_Data    => ip2bus_data_i,
      IP2Bus_WrAck   => ip2bus_wrack_i,
      IP2Bus_RdAck   => ip2bus_rdack_i,

      BaudoutN       => baudoutn,
      CtsN           => ctsn,
      DcdN           => dcdn,
      Ddis           => ddis,
      DsrN           => dsrn,
      DtrN           => dtrn,
      Out1N          => out1n,
      Out2N          => out2n,
      Rclk           => rclk,
      RiN            => rin,
      RtsN           => rtsn,
      RxrdyN         => rxrdyn,
      Sin            => sin,
      Sout           => sout,
      IP2INTC_Irpt   => ip2intc_irpt,
      TxrdyN         => txrdyn,
      Xin            => xin,
      Xout           => xout,
      Intr           => open,
      Freeze         => freeze
     );

      
end architecture rtl;
