-------------------------------------------------------------------------------
-- uart16550.vhd - entity/architecture pair
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
-- Filename:        uart16550.vhd
-- Version:         v2.0
-- Description:     16550 compatable UART 
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned."+";
use ieee.std_logic_unsigned."-";
use ieee.std_logic_unsigned.all;

-------------------------------------------------------------------------------
-- axi_uart16550_v2_0_8 library is used for axi_uart16550_v2_0_8 
-- component declarations
-------------------------------------------------------------------------------
library axi_uart16550_v2_0_8;
use axi_uart16550_v2_0_8.xuart_tx_load_sm;
use axi_uart16550_v2_0_8.rx16550;
use axi_uart16550_v2_0_8.tx16550;
use axi_uart16550_v2_0_8.tx_fifo_block;
use axi_uart16550_v2_0_8.rx_fifo_block;

-------------------------------------------------------------------------------
-- proc common package of the proc common library is used for different 
-- function declarations
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Vcomponents from unisim library is used for FIFO instatiation
-- function declarations
-------------------------------------------------------------------------------
library unisim;
use unisim.Vcomponents.all;

-------------------------------------------------------------------------------
-- Entity section
-------------------------------------------------------------------------------
entity uart16550 is
  generic (
    C_IS_A_16550          : BOOLEAN  := FALSE; -- UART mode
    C_HAS_EXTERNAL_XIN    : BOOLEAN  := FALSE; -- External XIN  
    C_S_AXI_CLK_FREQ_HZ   : integer  := 100_000_000; -- AXI Clock Frequency
    C_EXTERNAL_XIN_CLK_HZ : integer  := 50_000_000;  -- XIN Clock Frequency
    C_FAMILY              : string   := "virtex7"); -- XILINX FPGA family
  port (
    Din           : in  std_logic_vector (7 downto 0);  -- data bus in
    Dout          : out std_logic_vector (7 downto 0);  -- data bus out
    Sout          : out std_logic;   -- serial output
    BaudoutN      : out std_logic;   -- baud clock output
    BaudoutN_int  : out std_logic;   -- baud internal clock 
    Intr          : out std_logic;   -- interrupt
    Ddis          : out std_logic;   -- driver disable
    TxrdyN        : out std_logic;   -- transmitter DMA signal (active low)
    RxrdyN        : out std_logic;   -- receiver DMA signal (active low)
    Xout          : out std_logic;   -- external crystal output (xin_n)
    RtsN          : out std_logic;   -- request to send (active low)
    DtrN          : out std_logic;   -- data terminal ready (active low)
    Out1N         : out std_logic;   -- user controlled output (active low)
    Out2N         : out std_logic;   -- user controlled output (active low)
    Addr          : in  std_logic_vector (2 downto 0) := "000";  -- address bus
    Cs0           : in  std_logic;   -- chip select 0 (active high)
    Cs1           : in  std_logic;   -- chip select 1 (active high)
    Cs2N          : in  std_logic;   -- chip select 2 (active low)
    AdsN          : in  std_logic;   -- address/chip select strobe (active low)
    Sin           : in  std_logic;   -- serial in
    Rclk          : in  std_logic;   -- receiver clock (16 x baud rate)
    Xin           : in  std_logic;   -- external crystal input
    Rd            : in  std_logic;   -- read strobe (active high)
    RdN           : in  std_logic;   -- read strobe (active low)
    Wr            : in  std_logic;   -- write strobe (active high)
    WrN           : in  std_logic;   -- write stobe (active low)
    Rst           : in  std_logic;   -- master reset, active high
    CtsN          : in  std_logic;   -- clear to send (active low)
    DcdN          : in  std_logic;   -- data carrier detect (active low)
    DsrN          : in  std_logic;   -- data set ready (active low)
    RiN           : in  std_logic;   -- ring indicator (active low)
    Freeze        : in  std_logic;   -- Freezes UART for software debug
    Sys_clk       : in  std_logic);  -- Device interrupt output to processor


end uart16550;

-------------------------------------------------------------------------------
-- Architecture section
-------------------------------------------------------------------------------
architecture implementation of uart16550 is
-- Pragma Added to supress synth warnings
attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of implementation : architecture is "yes";


  -----------------------------------------------------------------------------
  -- Function: get_sel_baud
  -- Purpose: Get the baud reference clock to calculate the default baud rate. 
  -----------------------------------------------------------------------------
  function get_sel_baud return integer is
  variable sel_baud_clk : integer;
  begin

      if C_HAS_EXTERNAL_XIN = FALSE then 
         sel_baud_clk := C_S_AXI_CLK_FREQ_HZ;
      else
         sel_baud_clk := C_EXTERNAL_XIN_CLK_HZ;
      end if;
    
      return sel_baud_clk;
  end function get_sel_baud;

  constant BAUD_REF_CLOCK : integer := get_sel_baud;
  constant BAUD_DEFAULT   : integer := (BAUD_REF_CLOCK/(16 * 9600));
  constant BAUD_DEFAULT_X : std_logic_vector(15 downto 0)
                            := CONV_STD_LOGIC_VECTOR(BAUD_DEFAULT,16); 

  type  bo2sl_type is array(boolean) of std_logic;
  constant bo2sl          : bo2sl_type := (false => '0', true => '1');
 -- constant ODDR_IO        : boolean := supported(C_FAMILY, (u_ODDR));
 -- constant OSERDESE3_IO        : boolean := supported(C_FAMILY, (u_OSERDESE3));

-------------------------------------------------------------------------------
-- internal signals and registers
-------------------------------------------------------------------------------
  signal Rbr          : std_logic_vector (7 downto 0);  -- receiver buffer 
                                                        -- register
  signal Thr          : std_logic_vector (7 downto 0);  -- transmitter holding 
                                                       -- register(write only)
  signal Tsr          : std_logic_vector (7 downto 0);
  signal ier          : std_logic_vector (7 downto 0);  -- interrupt enable 
                                                        -- register
  signal iir          : std_logic_vector (7 downto 0);  -- interrupt 
                                                        -- identification reg
  signal thre_iir_set : std_logic;
  signal thre_iir_rst : std_logic;
  signal lsr5_d       : std_logic;
  signal ier1_d       : std_logic;
  signal Lcr          : std_logic_vector (7 downto 0); -- line control reg
  signal mcr          : std_logic_vector (7 downto 0); -- modem control reg
  signal mcr4_d       : std_logic;
  signal lsr          : std_logic_vector (7 downto 0); -- line status reg
  signal msr          : std_logic_vector (7 downto 0); -- modem status reg
  signal scr          : std_logic_vector (7 downto 0); -- scratch register
                                                       -- (user space)
  signal dll          : std_logic_vector (7 downto 0); -- divisor latch (least
                                                       -- significant byte)
  signal dlm          : std_logic_vector (7 downto 0); -- divisor latch 
                                                    -- (most significant byte)

  signal chipSelect           : std_logic;  -- Cs0 and Cs1 and (not Cs2N)
  signal readStrobe           : std_logic;  -- chipSelect and (Rd or (not RdN))
  signal writeStrobe          : std_logic;  -- chipSelect and (Wr or (not WrN))
  signal dlab                 : std_logic;  -- divisor latch access bit Lcr[7]
  signal addr_d               : std_logic_vector (2 downto 0);  
                                            -- internal address latch
  signal internalBus          : std_logic_vector (7 downto 0);  
                                            -- internal data bus
  signal baudCounter          : std_logic_vector (15 downto 0);  
                                            -- baud clock generator
  signal clockDiv             : std_logic_vector (15 downto 0);
  signal framing_error        : std_logic;  -- signals receiver framing error
  signal parity_error         : std_logic;
  signal data_ready           : std_logic;
  signal data_ready_interrupt : std_logic;  -- condition for a data
                                            -- ready interrupt
  signal break_interrupt      : std_logic;
  signal receiver_error       : std_logic;  -- any receiver error
  signal receiver_timeout     : std_logic;  -- receiver fifo timeout
  signal Thre                 : std_logic;  -- transmitter holding reg empty
  signal start_tx             : std_logic;  -- start transmission
  signal tx_empty             : std_logic;  -- transmitter empty
  signal Tsre                 : std_logic;  -- transmitter shift reg empty
  signal read_rbr             : std_logic;  -- high when reading Rbr
  signal writing_thr          : std_logic;  -- high when writing transmitter 
                                            -- holding register
  signal tsr_loaded           : std_logic;  -- signals Thr loaded into Tsr
  signal modem_prev_val       : std_logic_vector (3 downto 0);  
                                            -- holds last value of modem 
                                            -- control inputs
  signal modem_prev_rst_in    : std_logic_vector (3 downto 0);
  signal modem_status_changes : std_logic;  -- any change in modem input status
  signal tx_sout              : std_logic;  -- Sout from transmitter
  signal rx_sin               : std_logic;  -- Sin to receiver
  signal rx_rst               : std_logic;
  signal msr_rst              : std_logic;  -- resets msr
  signal lsr0_rst             : std_logic;  -- resets lsr(0)
  signal lsr5_rst             : std_logic;  -- resets lsr(5)
  signal lsr6_rst             : std_logic;  -- resets lsr(6)
  signal lsr7_rst             : std_logic;  -- resets lsr(7)
  signal lsr_rst              : std_logic;  -- resets rest of lsr
  signal lsr0_set             : std_logic;  -- sets lsr(0)
  signal lsr1_set             : std_logic;  -- sets lsr(1)
  signal lsr2_set             : std_logic;  -- sets lsr(2)
  signal lsr3_set             : std_logic;  -- sets lsr(3)
  signal lsr4_set             : std_logic;  -- sets lsr(4)
  signal lsr5_set             : std_logic;  -- sets lsr(5)
  signal lsr6_set             : std_logic;  -- sets lsr(6)
  signal lsr7_set             : std_logic;  -- sets lsr(7)
  signal iir_rst              : std_logic;  -- resets  iir

  signal rbr_sel              : std_logic;  -- selects rbr
  signal thr_sel              : std_logic;  -- selects Thr
  signal ier_sel              : std_logic;  -- selects ier
  signal iir_sel              : std_logic;  -- selects iir (read only)
  signal lcr_sel              : std_logic;  -- selects Lcr
  signal mcr_sel              : std_logic;  -- selects mcr
  signal lsr_sel              : std_logic;  -- selects lsr
  signal msr_sel              : std_logic;  -- selects msr
  signal scr_sel              : std_logic;  -- selects scr
  signal dll_sel              : std_logic;  -- selects dll
  signal dlm_sel              : std_logic;  -- selects dlm
  signal character_received   : std_logic;
  signal rxrdyN_int           : std_logic;
  signal txrdyN_int           : std_logic;
  signal rd_d                 : std_logic;
  signal rdN_d                : std_logic;
  signal wr_d                 : std_logic;
  signal wrN_d                : std_logic;
  signal ctsN_d               : std_logic;  -- clear to send (active low)
  signal dcdN_d               : std_logic;  -- data carrier detect (active low)
  signal dsrN_d               : std_logic;  -- data set ready (active low)
  signal riN_d                : std_logic;
  signal d_d                  : std_logic_vector(7 downto 0);
  signal load_baudlower       : std_logic;
  signal load_baudupper       : std_logic;
  signal divisor_latch_loaded : std_logic;
  signal baud_counter_loaded  : std_logic;
  signal baudoutN_int_i       : std_logic;
  signal baud_divisor_is_1    : std_logic;
  signal sys_clk_n            : std_logic;
  signal baud_int             : std_logic;
  signal baud_d0              : std_logic;
  signal baud_d1              : std_logic;
  


  -----------------------------------------------------------------------------
  -- these signals will synthesize away when C_IS_A_16550 = FALSE
  -----------------------------------------------------------------------------
  -- fifo related signals
  signal fifo_mode1 : std_logic;
  signal fcr        : std_logic_vector (7 downto 0);  -- fifo control register
  signal fcr_0_prev : std_logic;  -- register to hold previous value of fcr(0)
  signal fcr_w_sel  : std_logic;  -- selects fcr (write only)
  signal fcr_r_sel  : std_logic;  -- selcts fcr (read only, not in the spec)

  -- transmitter fifo signals
  signal tx_fifo_data_out  : std_logic_vector(7 downto 0 );
  signal tx_fifo_rd_en_int : std_logic;
  signal tx_fifo_full      : std_logic;
  signal tx_fifo_empty     : std_logic;

  -- receiver fifo signals
  signal rx_fifo_timeout      : std_logic;
  signal rx_fifo_trigger      : std_logic;
  signal rx_fifo_data_out     : std_logic_vector(10 downto 0 );
  signal rx_fifo_data_in      : std_logic_vector(10 downto 0 );
  signal rx_fifo_empty        : std_logic;
  signal rx_fifo_overrun      : std_logic;
  signal rx_error_in_fifo     : std_logic;
  signal rx_error_in_fifo_cnt : std_logic_vector(3 downto 0);
  signal rx_error_in_fifo_int : std_logic;
  signal rx_fifo_full         : std_logic;
  signal rx_fifo_rd_en        : std_logic;
  signal rx_fifo_rd_en_d      : std_logic;
  signal have_bi_in_fifo_n    : std_logic;
  signal rx_fifo_rd_en_d1     : std_logic;
  signal lsr2_rst             : std_logic;

  signal rx_error_in_fifo_lst : std_logic;
  signal rx_error_out_fifo    : std_logic;

begin  -- implementation

-------------------------------------------------------------------------------
-- NOTE: ANY LOGIC RELATED TO 16550 FUNCTIONALITY WILL SYNTHESIZE OR GENERATE
-- AWAY WHEN C_IS_A_16550 = FALSE
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- misc. combinational output signals
-------------------------------------------------------------------------------
  Xout <= not Xin;                      -- external crystal output (xin_n),
                                        -- duplicated in xuart.vhd to create a
                                        -- standalone uart

  DtrN  <= (not mcr(0)) or mcr(4);      -- data terminal ready
  RtsN  <= (not mcr(1)) or mcr(4);      -- request to send
  Out1N <= (not mcr(2)) or mcr(4);      -- user output 1
  Out2N <= (not mcr(3)) or mcr(4);      -- user output 2

-------------------------------------------------------------------------------
-- Sin/Sout loop back
-------------------------------------------------------------------------------  
  Sout     <= (tx_sout or mcr(4)) and (not Lcr(6));
  rx_sin   <= (((Sin and (not mcr(4))) or (tx_sout and mcr(4))) or Freeze);

-------------------------------------------------------------------------------
-- TxrdyN and RxrdyN
-------------------------------------------------------------------------------
  RxrdyN <= rxrdyN_int;
  TxrdyN <= txrdyN_int;

-------------------------------------------------------------------------------
-- PROCESS: RXRDYN_PROCESS
-- purpose: generarte RxrdyN
-------------------------------------------------------------------------------
  RXRDYN_PROCESS : process (Sys_clk) is
  begin  -- process RXRDYN_PROCESS
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                  -- synchronous reset (active high)
        rxrdyN_int <= '1';
      elsif fifo_mode1 = '1' then
        rxrdyN_int <= (((not rxrdyN_int) and (not lsr(0))) or
                       (rxrdyN_int and ((not rx_fifo_timeout) and
                                        (not rx_fifo_trigger))));
      else
        rxrdyN_int <= not lsr(0);
      end if;
    end if;
  end process RXRDYN_PROCESS;

-------------------------------------------------------------------------------
-- PROCESS: TXRDYN_PROCESS
-- purpose: generarte TxrdyN
-------------------------------------------------------------------------------
  TXRDYN_PROCESS : process (Sys_clk) is
  begin  -- process RXRDYN_PROCESS
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        txrdyN_int <= '0';
      elsif fifo_mode1 = '1' then
        txrdyN_int <= (((not txrdyN_int) and tx_fifo_full) or
                       (txrdyN_int and (not lsr(5))));
      else
        txrdyN_int <= not lsr(5);
      end if;
    end if;
  end process TXRDYN_PROCESS;

-------------------------------------------------------------------------------
-- PROCESS: INTR_PROCESS
-- purpose: Interrupt output generation
-------------------------------------------------------------------------------
  INTR_PROCESS : process (Sys_clk) is
  begin  -- process INTR_PROCESS
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        Intr <= '0';
      else
        Intr <= (not iir(0)) and (not Freeze);
      end if;
    end if;
  end process INTR_PROCESS;

-------------------------------------------------------------------------------
-- PROCESS: REGISTER_RW_PROCESS
-- purpose: register inputs
-------------------------------------------------------------------------------
  REGISTER_RW_PROCESS : process (Sys_clk) is
  begin
    if Sys_clk'EVENT and Sys_clk = '1' then
      rd_d  <= Rd;
      rdN_d <= RdN;
      wr_d  <= Wr;
      wrN_d <= WrN;
      d_d   <= Din;
      Ddis  <= not readStrobe;    --  driver disable
    end if;
  end process REGISTER_RW_PROCESS;

-------------------------------------------------------------------------------
-- PROCESS: REGISTER_RW_PROCESS
-- purpose: registers modem inputs
-------------------------------------------------------------------------------
  REGISTER_MODEM_INPUTS : process (Sys_clk) is
  begin  -- process REGISTER_MODEM_INPUTS
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      ctsN_d <= CtsN;
      dcdN_d <= DcdN;
      dsrN_d <= DsrN;
      riN_d  <= RiN;
    end if;
  end process REGISTER_MODEM_INPUTS;

-------------------------------------------------------------------------------  
-- PROCESS: LATCH_ADDRESS
-- purpose: latch address and chip selects
-------------------------------------------------------------------------------
  LATCH_ADDRESS : process (Sys_clk) is
  begin  -- process latchAddress
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        addr_d     <= "000";
        chipSelect <= '0';
      elsif AdsN = '0' then
        addr_d     <= Addr;
        chipSelect <= Cs0 and Cs1 and (not Cs2N);
      end if;
    end if;
  end process LATCH_ADDRESS;


                                        -- create readStrobe signal
  readStrobe <= chipSelect and (rd_d or (not rdN_d));

                                        -- create writeStrobe signal
  writeStrobe <= chipSelect and (wr_d or (not wrN_d));

  internalBus <= d_d;

-------------------------------------------------------------------------------
-- address decoder
-------------------------------------------------------------------------------

  rbr_sel   <= bo2sl( dlab & addr_d = "0000" ); -- Receiver Buffer Reg    (R)
  thr_sel   <= rbr_sel;                         -- Transmiter Holding Reg (W)
  ier_sel   <= bo2sl( dlab & addr_d = "0001" ); -- Interrupt Enable Reg   (RW)
  iir_sel   <= bo2sl( dlab & addr_d = "0010" ); -- Intr Identification Reg(R)
  fcr_r_sel <= bo2sl( dlab & addr_d = "1010" ); -- FIFO Control Reg (R)
  fcr_w_sel <= bo2sl(        addr_d =  "010" ); -- FIFO Control Reg (W)
  lcr_sel   <= bo2sl(        addr_d =  "011" ); -- Line Control Reg (RW)
  mcr_sel   <= bo2sl(        addr_d =  "100" ); -- Modem Control Reg (RW)
  lsr_sel   <= bo2sl(        addr_d =  "101" ); -- Line Status Reg (RW)
  msr_sel   <= bo2sl(        addr_d =  "110" ); -- Modem status Reg (RW)
  scr_sel   <= bo2sl(        addr_d =  "111" ); -- Scratch Reg (RW)
  dll_sel   <= bo2sl( dlab & addr_d = "1000" ); -- Divisor Latch Reg L (RW)
  dlm_sel   <= bo2sl( dlab & addr_d = "1001" ); -- Divisor Latch Reg M (RW)

-------------------------------------------------------------------------------
-- read internal registers
-------------------------------------------------------------------------------

  read_rbr <= '1' when (readStrobe = '1' and rbr_sel = '1') else '0';

-------------------------------------------------------------------------------  
-- PROCESS: READ_REGISTERS
-- purpose: latch address and chip selects
-------------------------------------------------------------------------------
  READ_REGISTERS : process (Sys_clk) is
  begin  -- process readRegisters
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        Dout <= "00000000";
      elsif readStrobe = '1' then
        if rbr_sel = '1' then
          if fcr(0) = '1' then
            Dout <= rx_fifo_data_out(7 downto 0);
          else
            Dout <= Rbr;
          end if;
        elsif ier_sel = '1' then
          Dout <= ier;
        elsif iir_sel = '1' then
          Dout <= iir;
        elsif fcr_r_sel = '1' then
          Dout <= fcr;
        elsif lcr_sel = '1' then
          Dout <= Lcr;
        elsif mcr_sel = '1' then
          Dout <= mcr;
        elsif lsr_sel = '1' then
          Dout <= lsr;
        elsif msr_sel = '1' then
          Dout <= msr;
        elsif scr_sel = '1' then
          Dout <= scr;
        elsif dll_sel = '1' then
          Dout <= dll;
        elsif dlm_sel = '1' then
          Dout <= dlm;
        -- coverage off
        else
          Dout <= (others => '0');
        -- coverage on  
        end if;
      end if;
    end if;
  end process READ_REGISTERS;

-------------------------------------------------------------------------------  
-- PROCESS: THR_WRITE
-- purpose: write Thr register
-------------------------------------------------------------------------------
  THR_WRITE : process (Sys_clk) is
  begin  -- process thrWrite
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        Thr             <= (others => '1');
        writing_thr     <= '0';
      elsif writeStrobe = '1' and thr_sel = '1' then
        Thr         <= internalBus;
        writing_thr <= '1';
      else
        writing_thr <= '0';
      end if;
    end if;
  end process THR_WRITE;

  xuart_tx_load_sm_1 : entity axi_uart16550_v2_0_8.xuart_tx_load_sm
    port map (
      Rst       => Rst,
      Sys_clk   => Sys_clk,
      Thr       => Thr,
      Write_thr => writing_thr,
      Load_tx   => tsr_loaded,
      Tsr       => Tsr,
      Thre      => Thre,
      Tsre      => Tsre);

-------------------------------------------------------------------------------  
-- PROCESS: IER_WRITE
-- purpose: write ier register
-------------------------------------------------------------------------------
  IER_WRITE : process (Sys_clk) is
  begin  -- process ierWrite
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        ier(3 downto 0) <= (others => '0');
      elsif writeStrobe = '1' and ier_sel = '1' then
        ier (3 downto 0)<= internalBus(3 downto 0);
      end if;
    end if;
  end process IER_WRITE;

        ier (7 downto 4)<= "0000"; 

-------------------------------------------------------------------------------  
-- PROCESS: DELAY_LSR5_AND_IER1_PROC
-- purpose: delay LSR5 bit
-------------------------------------------------------------------------------
  DELAY_LSR5_AND_IER1_PROC : process (Sys_clk) is
  begin  -- process DELAY_LSR5_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      lsr5_d <= lsr(5);
      ier1_d <= ier(1);
    end if;
  end process DELAY_LSR5_AND_IER1_PROC;


-------------------------------------------------------------------------------  
-- PROCESS: IER_WRITE
-- purpose: set THRE and IIR registers
-------------------------------------------------------------------------------
  SET_THRE_IIR_PROCESS : process (Sys_clk) is
  begin
    if Sys_clk'EVENT and Sys_clk = '1' then
      if thre_iir_rst = '1' then
        thre_iir_set <= '0';
      elsif Rst = '1' or
           (lsr5_d = '0' and lsr(5) = '1') or
           (lsr(5) = '1' and iir_rst = '1') or
           (ier(1) = '1' and ier1_d = '0' and lsr(5) = '1') then
        thre_iir_set <= '1';
      end if;
    end if;
  end process SET_THRE_IIR_PROCESS;

  -- THRE reset
  thre_iir_rst <= '1' when ((readStrobe = '1' and iir_sel = '1' and 
                         iir(3 downto 0) = "0010") or writing_thr = '1') else 
                  '0';

  -- Receiver Error
  receiver_error       <= '1' when (lsr(1) = '1' or lsr(2) = '1' or 
                                    lsr(3) = '1' or lsr(4) = '1') else '0';
                                    
  -- Modem status change
  modem_status_changes <= '1' when (msr(0) = '1' or msr(1) = '1' or 
                                    msr(2) = '1' or msr(3) = '1') else '0';
                                    

  -- IIR reset
  iir_rst <= '1' when ((lsr_rst = '1' and iir(3 downto 0) = "0110") or
                       (fcr(0) = '0'  and read_rbr = '1' and 
                                          iir(3 downto 0) = "0100") or 
                       (fcr(0) = '1'  and read_rbr = '1' and 
                                          iir(3 downto 0) = "1100") or
                       (fcr(0) = '1'  and rx_fifo_trigger = '0' and 
                                          iir(3 downto 0) = "0100") or 
                       thre_iir_rst = '1' or
                       (readStrobe = '1' and msr_sel = '1' 
                                         and iir(3 downto 0) = "0000"))
             else '0';

  -- Data ready interrupt generation
  data_ready_interrupt <= '1' when ((fcr(0) = '0' and lsr(0) = '1') or 
                                    (fcr(0) = '1' and rx_fifo_trigger = '1'))
             else '0';


-------------------------------------------------------------------------------  
-- PROCESS: IIR_WRITE
-- purpose: write iir register (iir is read only)
-------------------------------------------------------------------------------
  IIR_WRITE : process (Sys_clk) is
  begin
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' or iir_rst = '1' then
        iir(3 downto 0) <= "0001";
      elsif ier(2) = '1' and receiver_error = '1' then
        iir(3 downto 0) <= "0110";
      elsif ier(0) = '1' and receiver_timeout = '1' then
        iir(3 downto 0) <= "1100";
      elsif ier(0) = '1' and data_ready_interrupt = '1' then
        iir(3 downto 0) <= "0100";
      elsif ier(1) = '1' and thre_iir_set = '1' then
        iir(3 downto 0) <= "0010";
      elsif ier(3) = '1' and modem_status_changes = '1' then
        iir(3 downto 0) <= "0000";
      else
        iir(3 downto 0) <= "0001";
      end if;
      iir(7 downto 6) <= fcr(0) & fcr(0);  -- always 1 when fcr(0) is set
      iir(5 downto 4) <= "00";             -- always 0
    end if;
  end process IIR_WRITE;


-------------------------------------------------------------------------------  
-- PROCESS: LCR_WRITE
-- purpose: write Lcr register
-------------------------------------------------------------------------------
  LCR_WRITE : process (Sys_clk) is
  begin  -- process lcrWrite
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        Lcr  <= "00000011";
        dlab <= '0';
      elsif writeStrobe = '1' and lcr_sel = '1' then
        Lcr  <= internalBus;
      else
        dlab <= Lcr(7);
      end if;
    end if;
  end process LCR_WRITE;

-------------------------------------------------------------------------------  
-- PROCESS: MCR_WRITE
-- purpose: write mcr register
-------------------------------------------------------------------------------
  MCR_WRITE : process (Sys_clk) is
  begin  -- process mcrWrite
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        mcr <= (others => '0');
      elsif writeStrobe = '1' and mcr_sel = '1' then
        mcr <= "000" & internalBus(4 downto 0);
      end if;
    end if;
  end process MCR_WRITE;

-------------------------------------------------------------------------------  
-- PROCESS: IER_WRITE
-- purpose: delay mcr register
-------------------------------------------------------------------------------
  MCR4_DELAY_PROC: process (Sys_clk) is
  begin  -- process MCR4_DELAY_PROC
    if Sys_clk'event and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then                  -- synchronous reset (active high)
        mcr4_d <= '0';
      else
        mcr4_d <= mcr(4);
      end if;
    end if;
  end process MCR4_DELAY_PROC;


  -- LSR bit resets
  lsr0_rst <= '1' when ((fcr(0) = '0' and read_rbr = '1') or (fcr(0) = '1' and 
                         rx_fifo_empty = '1')) else '0';

  -- THRE reset
  lsr5_rst <= '1' when ((fcr(0) = '0' and Thre = '0') or (fcr(0) = '1' and
                         tx_fifo_empty = '0')) else '0';
                         
  -- Transmitter empty reset
  lsr6_rst <= '1' when ((fcr(0) = '1' and tsr_loaded = '1') or 
                        (fcr(0) = '0' and (Thre = '0' or Tsre = '0')) or
                         lsr(5) = '0') else '0';
                         
  -- Error in receive FIFO reset
  lsr7_rst <= '1' when ((fcr(0) = '1' and (lsr_rst = '1' or 
                                           rx_error_in_fifo_int = '0')) or 
                         fcr(0) = '0') else '0';
                         
  -- LSR reset
  lsr_rst  <= '1' when (readStrobe = '1' and lsr_sel = '1') else '0';


  -- LSR bit set
  -- Data ready set
  lsr0_set <= '1' when ((fcr(0) = '0' and data_ready = '1') or 
                        (fcr(0) = '1' and rx_fifo_empty = '0')) else '0';
                        
  -- Overrun error set
  lsr1_set <= '1' when ((fcr(0) = '0' and data_ready_interrupt = '1' and 
                         data_ready = '1') or rx_fifo_overrun = '1') else '0';
                         
  -- THRE empty set
  lsr5_set <= '1' when ((fcr(0) = '0' and Thre = '1') or 
                        (fcr(0) = '1' and tx_fifo_empty = '1')) else '0';
                        
  -- Transmitter empty set
  lsr6_set <= '1' when ((fcr(0) = '1' and tx_empty = '1' and lsr(5) = '1') or 
                        (fcr(0) = '0' and Tsre = '1' and Thre = '1')) else '0';
                        
  -- Error in Receive FIFO set
  lsr7_set <= '1' when (fcr(0) = '1' and rx_error_in_fifo_int = '1' and 
                        lsr_rst = '0') else '0';

  -- Modified for CR:440029
  -- LSR register is set as soon as error is detected in the received data when
  -- the data is available at the top of the FIFO. Doesn't wait for the data to
  -- read from the FIFO.
  lsr2_set <= '1' when (Lcr(3) = '1' and ((fcr(0) = '0' and parity_error = '1')  
                    or (fcr(0) = '1' and rx_fifo_data_out(10) = '1' and 
                        rx_fifo_empty = '0' and (rx_fifo_rd_en_d = '0' and 
                        rx_fifo_rd_en_d1 = '0' ) ))) else '0';

  
  -- Framing error set
  lsr3_set <= '1' when ((fcr(0) = '0' and framing_error = '1') or 
                        (fcr(0) = '1' and rx_fifo_data_out(9) = '1' and 
                         rx_fifo_empty = '0' and (rx_fifo_rd_en_d = '0' and 
                         rx_fifo_rd_en_d1 = '0' ))) else '0';

  -- Break Interrupt set
  lsr4_set <= '1' when ((fcr(0) = '0' and break_interrupt = '1') or 
                        (fcr(0) = '1' and rx_fifo_data_out(8) = '1' and 
                         rx_fifo_empty = '0' and (rx_fifo_rd_en_d = '0' and 
                         rx_fifo_rd_en_d1 = '0' ))) else '0';

-------------------------------------------------------------------------------  
-- PROCESS: LSR2_RST_GEN
-- purpose: Generated lsr2_rst for reseting parity error flag in the LSR
-- Modified for CR:481176
-------------------------------------------------------------------------------
  LSR2_RST_GEN : process (Sys_clk) is
  begin  -- process lsr2 reset gen
  
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        lsr2_rst <= '0';
      elsif lsr_rst = '1' and rx_fifo_empty = '0' then
        lsr2_rst <= '1';
      elsif rx_fifo_rd_en_d = '1' or writeStrobe = '1'  then
        lsr2_rst <= '0';
      end if;
    end if;
  end process LSR2_RST_GEN;

-------------------------------------------------------------------------------  
-- PROCESS: LSR_WRITE
-- purpose: write lsr register
-------------------------------------------------------------------------------
  LSR_WRITE : process (Sys_clk) is
  begin  -- process lsrWrite

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' or lsr0_rst = '1' then
        lsr(0) <= '0';
      elsif lsr0_set = '1' then
        lsr(0) <= '1';
      elsif writeStrobe = '1' and lsr_sel = '1' then
        lsr(0) <= internalBus(0);
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' or lsr_rst = '1' then
        lsr(1) <= '0';
      elsif lsr1_set = '1' then
        lsr(1) <= '1';
      elsif writeStrobe = '1' and lsr_sel = '1' then
        lsr(1) <= internalBus(1);
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' or lsr_rst = '1' or lsr2_rst='1' then
        lsr(2) <= '0';
      elsif lsr2_set = '1' then
        lsr(2) <= '1';
      elsif writeStrobe = '1' and lsr_sel = '1' then
        lsr(2) <= internalBus(2);
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' or lsr_rst = '1' or lsr2_rst='1' then
        lsr(3) <= '0';
      elsif lsr3_set = '1' then
        lsr(3) <= '1';
      elsif writeStrobe = '1' and lsr_sel = '1' then
        lsr(3) <= internalBus(3);
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' or lsr_rst = '1' or lsr2_rst='1' then
        lsr(4) <= '0';
      elsif lsr4_set = '1' then
        lsr(4) <= '1';
      elsif writeStrobe = '1' and lsr_sel = '1' then
        lsr(4) <= internalBus(4);
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if lsr5_rst = '1' then
        lsr(5) <= '0';
      elsif Rst = '1' or lsr5_set = '1' then
        lsr(5) <= '1';
      --elsif writeStrobe = '1' and lsr_sel = '1' then  --Since these lines won't be covering 
      --lsr(5) <= internalBus(5);
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if lsr6_rst = '1' then
        lsr(6) <= '0';
      elsif Rst = '1' or lsr6_set = '1' then
        lsr(6) <= '1';
      elsif writeStrobe = '1' and lsr_sel = '1' then
        lsr(6) <= internalBus(6);
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' or lsr7_rst = '1' then
        lsr(7) <= '0';
      elsif lsr7_set = '1' then
        lsr(7) <= '1';
     -- elsif writeStrobe = '1' and lsr_sel = '1' then --since these lines won't be covereing
     --   lsr(7) <= internalBus(7);
      end if;
    end if;
  end process LSR_WRITE;

  -- Modem status register reset
  msr_rst <= '1' when (readStrobe = '1' and msr_sel = '1') else '0';

-------------------------------------------------------------------------------  
-- PROCESS: MSR_WRITE
-- purpose: write msr register
-------------------------------------------------------------------------------
  MSR_WRITE : process (Sys_clk) is
  begin  -- process msrWrite
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' or msr_rst = '1' then
        msr(0) <= '0';
      elsif msr(0) = '0' and (modem_prev_val(0) /= msr(4)) then
        msr(0) <= '1';
      elsif writeStrobe = '1' and msr_sel = '1' then
        msr(0) <= internalBus(0);
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' or msr_rst = '1' then
        msr(1) <= '0';
      elsif msr(1) = '0' and (modem_prev_val(1) /= msr(5)) then
        msr(1) <= '1';
      elsif writeStrobe = '1' and msr_sel = '1' then
        msr(1) <= internalBus(1);
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' or msr_rst = '1' then
        msr(2) <= '0';
      elsif msr(2) = '0' and (modem_prev_val(2) /= msr(6)) then
        msr(2) <= '1';
      elsif writeStrobe = '1' and msr_sel = '1' then
        msr(2) <= internalBus(2);
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' or msr_rst = '1' then
        msr(3) <= '0';
      elsif msr(3) = '0' and (modem_prev_val(3) /= msr(7)) then
        msr(3) <= '1';
      elsif writeStrobe = '1' and msr_sel = '1' then
        msr(3) <= internalBus(3);
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        msr(4) <= not ctsN_d;
      elsif writeStrobe = '1' and msr_sel = '1' then
        msr(4) <= internalBus(4);
      elsif mcr(4) = '1' then
        msr(4) <= mcr(1);
      else
        msr(4) <= not ctsN_d;
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        msr(5) <= not dsrN_d;
      elsif writeStrobe = '1' and msr_sel = '1' then
        msr(5) <= internalBus(5);
      elsif mcr(4) = '1' then
        msr(5) <= mcr(0);
      else
        msr(5) <= not dsrN_d;
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        msr(6) <= not riN_d;
      elsif writeStrobe = '1' and msr_sel = '1' then
        msr(6) <= internalBus(5);
      elsif mcr(4) = '1' then
        msr(6) <= mcr(2);
      else
        msr(6) <= not riN_d;
      end if;
    end if;

    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        msr(7) <= not dcdN_d;
      elsif writeStrobe = '1' and msr_sel = '1' then
        msr(7) <= internalBus(5);
      elsif mcr(4) = '1' then
        msr(7) <= mcr(3);
      else
        msr(7) <= not dcdN_d;
      end if;
    end if;
  end process MSR_WRITE;

  modem_prev_rst_in(0) <= not ctsN_d;
  modem_prev_rst_in(1) <= not dsrN_d;
  modem_prev_rst_in(2) <= not riN_d;
  modem_prev_rst_in(3) <= not dcdN_d;


-------------------------------------------------------------------------------  
-- PROCESS: MODEM_PREV_VAL_PROC
-- purpose: loads previous value of modem control signals
-------------------------------------------------------------------------------
  MODEM_PREV_VAL_PROC : process (Sys_clk) is
  begin  -- process MSR_PREV_VAL_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then         -- asynchronous reset (active high)
        modem_prev_val <= modem_prev_rst_in(3 downto 0);
      elsif msr_rst = '1' then
        modem_prev_val <= msr(7 downto 4);
      end if;
    end if;
  end process MODEM_PREV_VAL_PROC;

-------------------------------------------------------------------------------  
-- PROCESS: SCR_WRITE
-- purpose: write scr register
-------------------------------------------------------------------------------
  SCR_WRITE : process (Sys_clk) is
  begin  -- process scrWrite
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        scr <= "00000000";
      elsif writeStrobe = '1' and scr_sel = '1' then
        scr <= internalBus;
      end if;
    end if;
  end process SCR_WRITE;

-------------------------------------------------------------------------------  
-- PROCESS: DLL_WRITE
-- purpose: write dll register
-------------------------------------------------------------------------------
  DLL_WRITE : process (Sys_clk) is
  begin  -- process dllWrite
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        --dll <= "00000000";
        dll <= BAUD_DEFAULT_X(7 downto 0);
      elsif writeStrobe = '1' and dll_sel = '1' then
        dll <= internalBus;
      end if;
    end if;
  end process DLL_WRITE;

-------------------------------------------------------------------------------  
-- PROCESS: DLM_WRITE
-- purpose: write dlm register
-------------------------------------------------------------------------------
  DLM_WRITE : process (Sys_clk) is
  begin  -- process dlmWrite
    if Sys_clk'EVENT and Sys_clk = '1' then
      if Rst = '1' then
        --dlm <= "00000000";
        dlm <= BAUD_DEFAULT_X(15 downto 8);
      elsif writeStrobe = '1' and dlm_sel = '1' then
        dlm <= internalBus;
      end if;
    end if;
  end process DLM_WRITE;


-------------------------------------------------------------------------------  
-- PROCESS: LOAD_BAUDCOUNTER_CONTROLS
-- purpose: load baud counter
-------------------------------------------------------------------------------
  LOAD_BAUDCOUNTER_CONTROLS : process (Sys_clk) is
  begin  -- process LOAD_BAUDCOUNTER_CONTROLS
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      load_baudlower <= (writeStrobe and dll_sel);
      load_baudupper <= (writeStrobe and dlm_sel);
    end if;
  end process LOAD_BAUDCOUNTER_CONTROLS;

-------------------------------------------------------------------------------  
-- PROCESS: DIVISOR_LATCH_LOADED_PROC
-- purpose: flags if dll or dlm have been loaded
-------------------------------------------------------------------------------
  DIVISOR_LATCH_LOADED_PROC : process (Sys_clk) is
  begin  -- process DIVISOR_LATCH_LOADED_PROC
    if Sys_clk'EVENT and Sys_clk = '1' then        -- rising clock edge
      if Rst = '1' or baud_counter_loaded = '1' then  -- asynchronous reset 
        divisor_latch_loaded <= '0';                 -- (active high)
      elsif load_baudlower = '1' or load_baudupper = '1' then
        divisor_latch_loaded <= '1';
      end if;
    end if;
  end process DIVISOR_LATCH_LOADED_PROC;



  clockDiv <= dlm & dll;

-------------------------------------------------------------------------------  
-- PROCESS: BAUD_COUNT
-- purpose: counts the baud sample based on the value from DLL and DLM
-------------------------------------------------------------------------------
  BAUD_COUNT : process (Sys_clk) is
  begin  -- process baudCount
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if Rst = '1' then         -- asynchronous reset (active high)
        --baudCounter         <= "0000000000000000";
        baudCounter         <= clockDiv;
        baud_counter_loaded <= '0';
      elsif Xin = '1' then
        if baudCounter = "0000000000000001" or divisor_latch_loaded = '1' then
          baudCounter         <= clockDiv;
          baud_counter_loaded <= '1';
        else
          baudCounter         <= baudCounter - "0000000000000001";
          baud_counter_loaded <= '0';
        end if;
      end if;
    end if;
  end process BAUD_COUNT;

-------------------------------------------------------------------------------  
-- PROCESS: BAUDRATE_GENERATOR
-- purpose: generate BaudoutN clock
-------------------------------------------------------------------------------
  BAUDRATE_GENERATOR : process (Sys_clk) is
  begin  -- process baudRateGenerator
    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
      if (Xin = '1' and baudCounter = "0000000000000001") then
        baudoutN_int_i <= '0';
      else
        baudoutN_int_i <= '1';
      end if;
    end if;
  end process BAUDRATE_GENERATOR;

  -- Check if baud divisor value is '1'
  baud_divisor_is_1 <= '1' when clockDiv = "0000000000000001" else
                       '0';

  -- Generating inverted clock
  sys_clk_n <= not Sys_clk;

-------------------------------------------------------------------------------
-- NO_EXTERNAL_XIN : External XIN is not present.
-- Added for Baud generator to accept value 0x01 as a devisor
-- For Divisor value = 1, BaudoutN_int is same as sys_clk.
-------------------------------------------------------------------------------
  NO_EXTERNAL_XIN : if C_HAS_EXTERNAL_XIN /= TRUE generate

     baud_int  <= '0' when baud_divisor_is_1 = '1' else
                  baudoutN_int_i;

-------------------------------------------------------------------------------  
-- PROCESS: BAUD Divisor=1 check 
-- purpose: Check if baud divisor value is '1'
-------------------------------------------------------------------------------
--  BAUD_DIVISOR : process (Sys_clk) is
--  begin  -- process baudRateGenerator
--    if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
--      baud_d0 <= baudoutN_int_i and not baud_divisor_is_1;
--      baud_d1 <= baudoutN_int_i or baud_divisor_is_1;
--    end if;
--  end process BAUD_DIVISOR;

     -- BaoudoutN Logic
     baud_d0 <= baudoutN_int_i and not baud_divisor_is_1;
     baud_d1 <= baudoutN_int_i or baud_divisor_is_1;

      --Generate BaudoutN using ODDR
   --         ODDR_GEN : if ODDR_IO = TRUE generate

   --          BAUD_FF: ODDR
   --            port map (
   --              Q   => BaudoutN,      --[out]
   --              C   => Sys_clk,       --[in]
   --              CE  => '1',           --[in]
   --              D1  => baud_d0,       --[in]
   --              D2  => baud_d1,       --[in]
   --              S   => '0',           --[in]
   --              R   => Rst);          --[in]

   --      end generate ODDR_GEN;
         

    --Generate BaudoutN using ODDR2
        ODDR2_GEN : if ( 
            (C_FAMILY = "virtex7") or
            (C_FAMILY = "kintex7") or
            (C_FAMILY = "zynq") or
            (C_FAMILY = "artix7")  
           ) generate

                  BAUD_FF: ODDR
                    port map (
                      Q   => BaudoutN,      --[out]
                      C   => Sys_clk,       --[in]
                      CE  => '1',           --[in]
                      D1  => baud_d0,       --[in]
                      D2  => baud_d1,       --[in]
                      S   => '0',           --[in]
                      R   => Rst);          --[in]

        end generate ODDR2_GEN;

        OSERDESE3_ODDR_GEN : if (
            (C_FAMILY /= "virtex7") and
            (C_FAMILY /= "kintex7") and
            (C_FAMILY /= "zynq") and
            (C_FAMILY /= "artix7")  
           ) generate

                 BAUD_FF: ODDRE1
                   port map (
                     Q   => BaudoutN,      --[out]
                     C   => Sys_clk,       --[in]
               --      CE  => '1',           --[in]
                     D1  => baud_d0,       --[in]
                     D2  => baud_d1,       --[in]
               --      S   => '0',           --[in]
                     SR   => Rst);          --[in]

     --             BAUD_FF:OSERDESE3 
     --   	  generic map(
     --             DATA_WIDTH => 4,
     --             INIT => '0',
     --             IS_CLKDIV_INVERTED => '0',
     --             IS_CLK_INVERTED => '0',
     --             ODDR_MODE => "TRUE",
     --             IS_RST_INVERTED => '0',
     --             OSERDES_D_BYPASS => "TRUE",
     --             OSERDES_T_BYPASS => "TRUE"
     --                         )
     --             port map (
     --               CLK => Sys_clk,
     --               CLKDIV => Sys_clk,
     --               D(7 downto 6) =>"00",
     --               D(5) => baud_d1,
     --               D(4) => baud_d1,
     --               D(3 downto 2) =>"00" ,
     --               D(1) => baud_d0,
     --               D(0) => baud_d0,
     --               OQ => BaudoutN,
     --               RST => '0',
     --               T => '0',
     --               T_OUT => open
     --             );

        end generate OSERDESE3_ODDR_GEN;
 
  end generate NO_EXTERNAL_XIN;

  BaudoutN_int <= baud_int;

-------------------------------------------------------------------------------
-- EXTERNAL_XIN : External XIN is used.
-- Added for Baud generator to accept value 0x01 as a devisor
-- For Divisor value = 1, BaudoutN_int is same as XIN.
-------------------------------------------------------------------------------
   EXTERNAL_XIN : if C_HAS_EXTERNAL_XIN = TRUE generate

      baud_int <= not Xin when baud_divisor_is_1 = '1' else
                      baudoutN_int_i;

      BaudoutN <= baud_int;

   end generate EXTERNAL_XIN;



-------------------------------------------------------------------------------
-- receiver instantiation
-------------------------------------------------------------------------------  
  rx16550_1 : entity axi_uart16550_v2_0_8.rx16550
    port map (
      Sys_clk            => Sys_clk,
      Rclk               => Rclk,
      Rst                => rx_rst,
      Lcr                => Lcr,
      Rbr                => Rbr,
      Fcr_0              => fcr(0),
      Sin                => rx_sin,
      Parity_error       => parity_error,
      Framing_error      => framing_error,
      Break_interrupt    => break_interrupt,
      Data_ready         => data_ready,
      Rx_fifo_data_in    => rx_fifo_data_in,
      Character_received => character_received,
      Have_bi_in_fifo_n  => have_bi_in_fifo_n);


  rx_rst <= '1' when ((mcr(4) /= mcr4_d) or Rst = '1') else '0';
  
-------------------------------------------------------------------------------
-- transmitter instantiation
-------------------------------------------------------------------------------
  tx16550_1 : entity axi_uart16550_v2_0_8.tx16550
    port map (
      Sys_clk          => Sys_clk,
      Rst              => Rst,
      BaudoutN         => baud_int,
      Lcr              => Lcr,
      Thr              => Tsr,
      Tx_empty         => tx_empty,
      Start_tx         => start_tx,
      Sout             => tx_sout,
      Tsr_loaded       => tsr_loaded,
      Tx_fifo_rd_en    => tx_fifo_rd_en_int,
      Fcr_0            => fcr(0),
      Tx_fifo_data_out => tx_fifo_data_out);

-------------------------------------------------------------------------------
-- PROCESS: START_TX_PROCESS
-- purpose: generate start_tx
-------------------------------------------------------------------------------
  START_TX_PROCESS : process (Freeze, fcr, lsr, Tsre) is
  begin  -- process START_TX_PROCESS
    if fcr(0) = '1' then
      start_tx <= lsr(5) or Freeze;
    else
      start_tx <= Tsre or Freeze;
    end if;
  end process START_TX_PROCESS;


-------------------------------------------------------------------------------
-- fifo related logic (will synthesize away when C_IS_A_16550 = FALSE
-------------------------------------------------------------------------------
  fifo_mode1           <= fcr(0) and fcr(3);
  receiver_timeout     <= '1' when (fcr(0) = '1' and rx_fifo_timeout = '1') 
                              else '0';
  rx_fifo_overrun      <= '1' when (fcr(0) = '1' and rx_fifo_full = '1' and
                                    character_received = '1') else '0';
  rx_error_in_fifo_int <= '0' when (rx_error_in_fifo_cnt = "0000")  else 
                          '1';
  rx_error_in_fifo_lst <= '1' when (rx_error_in_fifo_cnt = "0001" and 
                                    lsr_rst = '1')  else 
                          '0';
  rx_error_out_fifo    <=  rx_fifo_data_out(10) or rx_fifo_data_out(9) or
                           rx_fifo_data_out(8);
                          
  rx_fifo_rd_en        <= fcr(0) and read_rbr;

-------------------------------------------------------------------------------
-- Generate FIFOs or not, based on C_IS_A_16550
-------------------------------------------------------------------------------
  NOT_GENERATING_FIFOS : if C_IS_A_16550 /= TRUE generate
  begin
    fcr                  <= (others => '0');
    fcr_0_prev           <= '0';
    tx_fifo_data_out     <= (others => '0');
    tx_fifo_rd_en_int    <= '0';
    tx_fifo_full         <= '0';
    tx_fifo_empty        <= '0';
    rx_fifo_data_out     <= (others => '0');
    rx_fifo_empty        <= '0';
    rx_fifo_full         <= '0';
    rx_fifo_timeout      <= '0';
    rx_fifo_trigger      <= '0';
    rx_fifo_rd_en_d      <= '0';
    rx_error_in_fifo     <= '0';
    rx_error_in_fifo_cnt <= "0000";
  end generate NOT_GENERATING_FIFOS;

-------------------------------------------------------------------------------
   -- Generating FIFO 
-------------------------------------------------------------------------------
  GENERATING_FIFOS : if C_IS_A_16550 = TRUE generate
    
    signal fcr_0_changed : std_logic;   -- flags a change in fcr(0)

    signal tx_fifo_wr_en   : std_logic;
    signal tx_fifo_wr_en_d : std_logic;
    signal tx_fifo_rd_en   : std_logic;
    signal tx_fifo_rst     : std_logic;

    signal rx_fifo_wr_en : std_logic;
    signal rx_fifo_rst   : std_logic;

    signal rx_error_in_fifo_cnt_up : std_logic;
    signal rx_error_in_fifo_cnt_dn : std_logic;

    begin
    
    fcr_0_changed <= '1' when (writeStrobe = '1' and fcr_w_sel = '1' and 
                              (fcr(0) xor fcr_0_prev) = '1') else '0';
    rx_fifo_wr_en <= (fcr(0) and (character_received and (not rx_fifo_full) and
                                  have_bi_in_fifo_n));
    tx_fifo_wr_en <= (fcr(0) and writeStrobe and thr_sel);
    tx_fifo_rd_en <= (fcr(0) and tx_fifo_rd_en_int);

    ---------------------------------------------------------------------------
    -- PROCESS: FCR_0_WRITE
    -- purpose: write fcr register
    ---------------------------------------------------------------------------
    FCR_0_WRITE : process (Sys_clk) is
    begin  -- process fcrWrite
      if Sys_clk'EVENT and Sys_clk = '1' then
        if Rst = '1' then
          fcr(0) <= '0';
        elsif writeStrobe = '1' and fcr_w_sel = '1' then
          fcr(0) <= internalBus(0);
        end if;
      end if;
    end process FCR_0_WRITE;
    
    ---------------------------------------------------------------------------
    -- PROCESS: FCR_1_WRITE
    -- purpose: write fcr register
    ---------------------------------------------------------------------------
    FCR_1_WRITE : process (Sys_clk) is
    begin  -- process fcrWrite
      if Sys_clk'EVENT and Sys_clk = '1' then
        if Rst = '1' then  -- fcr(0) must be set to write fcr(7 downto 1)
          fcr(7 downto 1) <= (others => '0');
        elsif writeStrobe = '1' and fcr_w_sel = '1' and fcr_0_prev = '1' then
          fcr(7 downto 1) <= internalBus(7 downto 6) & "00" & 
                             internalBus(3 downto 1);
        else
          fcr(7 downto 1) <= fcr(7 downto 6) & "00" & fcr(3) & "00";
        end if;
      end if;
    end process FCR_1_WRITE;

    ---------------------------------------------------------------------------
    -- PROCESS: PREV_FCR_0_PROCESS
    -- purpose: generate fcr bit
    ---------------------------------------------------------------------------
    PREV_FCR_0_PROCESS : process (Sys_clk) is
    begin  -- process fcrWrite
      if Sys_clk'EVENT and Sys_clk = '1' then
        if Rst = '1' then
          fcr_0_prev <= '0';
        elsif writeStrobe = '0' and fcr_w_sel = '1' then
          fcr_0_prev <= fcr(0);
        end if;
      end if;
    end process PREV_FCR_0_PROCESS;

    ---------------------------------------------------------------------------
    -- transmitter fifo instantiation
    ---------------------------------------------------------------------------
    tx_fifo_block_1 : entity axi_uart16550_v2_0_8.tx_fifo_block
     generic map (
        C_FAMILY         => C_FAMILY )
      port map (
        Tx_fifo_data_in  => Thr,
        Tx_fifo_wr_en    => tx_fifo_wr_en_d,
        Tx_fifo_data_out => tx_fifo_data_out,
        Tx_fifo_clk      => Sys_clk,
        Tx_fifo_rd_en    => tx_fifo_rd_en,
        Tx_fifo_rst      => tx_fifo_rst,
        Tx_fifo_empty    => tx_fifo_empty,
        Tx_fifo_full     => tx_fifo_full);

    ---------------------------------------------------------------------------
        -- PROCESS: TX_FIFO_READ_EN
        -- purpose: delays tx_fifo_rd_en 1 clock cycle
    ---------------------------------------------------------------------------
    TX_FIFO_READ_EN : process (Sys_clk) is
    begin  -- process TX_FIFO_WRITE_EN
      if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
        if Rst = '1' then       -- asynchronous reset (active high)
          tx_fifo_wr_en_d <= '0';
        else
          tx_fifo_wr_en_d <= tx_fifo_wr_en;
        end if;
      end if;
    end process TX_FIFO_READ_EN;

    ---------------------------------------------------------------------------
    -- PROCESS: REGISTER_TX_FIFO_RST
    -- purpose: registers tx_fifo_rst
    ---------------------------------------------------------------------------
    REGISTER_TX_FIFO_RST : process (Sys_clk) is
    begin  -- process REGISTER_RX_FIFO_RST
      if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
        tx_fifo_rst <= (Rst or fcr(2) or fcr_0_changed);
      end if;
    end process REGISTER_TX_FIFO_RST;

    ---------------------------------------------------------------------------
    -- receiver fifo instantiation
    ---------------------------------------------------------------------------
    rx_fifo_block_1 : entity axi_uart16550_v2_0_8.rx_fifo_block
       generic map (
        C_FAMILY           =>  C_FAMILY )
       port map (
        Sys_clk            => Sys_clk,
        Rclk               => Rclk,
        Rst                => Rst,
        Rx_fifo_data_in    => rx_fifo_data_in,
        Rx_fifo_wr_en      => rx_fifo_wr_en,
        Rx_fifo_data_out   => rx_fifo_data_out,
        Rx_fifo_rd_en      => rx_fifo_rd_en_d,
        Rx_fifo_rst        => rx_fifo_rst,
        Rx_fifo_empty      => rx_fifo_empty,
        Fcr                => fcr,
        Rx_fifo_timeout    => rx_fifo_timeout,
        Rx_fifo_trigger    => rx_fifo_trigger,
        Rx_fifo_full       => rx_fifo_full,
        Rx_error_in_fifo   => rx_error_in_fifo);

    ---------------------------------------------------------------------------
    -- PROCESS: RX_FIFO_READ_EN
    -- purpose: delays rx_fifo_rd_en 1 clock cycle
    ---------------------------------------------------------------------------
    RX_FIFO_READ_EN : process (Sys_clk) is
    begin  -- process TX_FIFO_WRITE_EN
      if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
        if Rst = '1' then       -- asynchronous reset (active high)
          rx_fifo_rd_en_d  <= '0';
          rx_fifo_rd_en_d1 <= '0';
        else
          rx_fifo_rd_en_d  <= rx_fifo_rd_en;
          rx_fifo_rd_en_d1 <= rx_fifo_rd_en_d;
        end if;
      end if;
    end process RX_FIFO_READ_EN;

    ---------------------------------------------------------------------------
    -- PROCESS: RX_ERR_IN_FIFO_CNT_UP_PROC
    -- purpose: finds rising edge of rx_error_in_fifo
    ---------------------------------------------------------------------------
    RX_ERR_IN_FIFO_CNT_UP_PROC : process (Sys_clk) is
    begin  -- process RX_ERR_IN_FIFO_CNT_UP_PROC
      if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
        if Rst = '1' then       -- asynchronous reset (active high)
          rx_error_in_fifo_cnt_up <= '0';
        else
          rx_error_in_fifo_cnt_up <= rx_error_in_fifo;
        end if;
      end if;
    end process RX_ERR_IN_FIFO_CNT_UP_PROC;

    ---------------------------------------------------------------------------
    -- PROCESS: RX_ERR_IN_FIFO_CNT_UP_PROC
    -- purpose: tracks errors being removed from rx fifo
    ---------------------------------------------------------------------------
    RX_ERR_IN_FIFO_CNT_DN_PROC : process (Sys_clk) is
    begin  -- process RX_ERR_IN_FIFO_CNT_DN_PROC
      if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
        if Rst = '1' then       -- asynchronous reset (active high)
          rx_error_in_fifo_cnt_dn <= '0';
        else
          rx_error_in_fifo_cnt_dn <= (rx_error_out_fifo  and 
                                     (rx_fifo_rd_en_d or rx_error_in_fifo_lst));
        end if;
      end if;
    end process RX_ERR_IN_FIFO_CNT_DN_PROC;

    ---------------------------------------------------------------------------
    -- PROCESS: RX_ERR_IN_FIFO_CNT_PROC
    -- purpose: tracks number of rx errors in fifo
    ---------------------------------------------------------------------------
    RX_ERR_IN_FIFO_CNT_PROC : process (Sys_clk) is
    begin  -- process RX_ERR_IN_FIFO_CNT_PROC
      if Sys_clk'EVENT and Sys_clk = '1' then         -- rising clock edge
        if Rst = '1' or rx_fifo_rst = '1' then           -- asynchronous reset 
          rx_error_in_fifo_cnt <= "0000";               -- (active high)
        elsif (rx_error_in_fifo_cnt_up = '1' and 
                rx_error_in_fifo_cnt /= "1111")    then
          rx_error_in_fifo_cnt <= rx_error_in_fifo_cnt + "0001";
        elsif (rx_error_in_fifo_cnt_dn = '1' and 
                rx_error_in_fifo_cnt /= "0000")     then
          rx_error_in_fifo_cnt <= rx_error_in_fifo_cnt - "0001";
        end if;
      end if;
    end process RX_ERR_IN_FIFO_CNT_PROC;

    ---------------------------------------------------------------------------
    -- PROCESS: REGISTER_RX_FIFO_RST
    -- purpose: registers rx_fifo_rst
    ---------------------------------------------------------------------------
    REGISTER_RX_FIFO_RST : process (Sys_clk) is
    begin  -- process REGISTER_RX_FIFO_RST
      if Sys_clk'EVENT and Sys_clk = '1' then  -- rising clock edge
        rx_fifo_rst <= (Rst or fcr(1) or fcr_0_changed);
      end if;
    end process REGISTER_RX_FIFO_RST;
    
  end generate GENERATING_FIFOS;

end implementation;
