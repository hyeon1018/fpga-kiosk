----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:16:55 05/14/2019 
-- Design Name: 
-- Module Name:    fpga_kiosk - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fpga_kiosk is
    Port ( clk : in  STD_LOGIC;
           key_matrix_scan : out  STD_LOGIC_VECTOR (3 downto 0);
           key_matrix_in : in  STD_LOGIC_VECTOR (3 downto 0);
			  discount_switch : in STD_LOGIC_VECTOR (3 downto 0);
			  n_reset_btn : in STD_LOGIC_VECTOR (3 downto 0);
           segment_data : out  STD_LOGIC_VECTOR (7 downto 0);
           segment_sel : out  STD_LOGIC_VECTOR (5 downto 0);
			  lcd_clk : out STD_LOGIC;
			  lcd_de : out STD_LOGIC;
			  lcd_data : out STD_LOGIC_VECTOR (15 downto 0);
			  debug_led : out STD_LOGIC_VECTOR(7 downto 0));
end fpga_kiosk;

architecture Behavioral of fpga_kiosk is
component Key_Matrix is
	Port ( clk : in  STD_LOGIC;
          reset : in  STD_LOGIC;
          key_in : in  STD_LOGIC_VECTOR (3 downto 0);
          key_scan : out  STD_LOGIC_VECTOR (3 downto 0);
			 key_data : out  STD_LOGIC_VECTOR (3 downto 0);
			 key_event : out STD_LOGIC);
end component;

component seven_segment is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           bcd_input : in  STD_LOGIC_VECTOR (23 downto 0);
           segment_data : out  STD_LOGIC_VECTOR (7 downto 0);
           segment_select : out  STD_LOGIC_VECTOR (5 downto 0));
end component;

component state_selector is
    Port ( clk : in  STD_LOGIC;
			  rst : in  STD_LOGIC;
           key_event : in  STD_LOGIC;
           key_data : in  STD_LOGIC_VECTOR (3 downto 0);
           state : out  STD_LOGIC_VECTOR (2 downto 0));
end component;

component reg is
	Generic ( size : integer );
   Port ( clk : in  STD_LOGIC;
			 rst : in  STD_LOGIC;
			 load_en : in  STD_LOGIC;
			 load_data : in  STD_LOGIC_VECTOR (size-1 downto 0);
			 out_data : out  STD_LOGIC_VECTOR (size-1 downto 0));
end component;

component excess3_6 is
    Port ( a : in  STD_LOGIC_VECTOR (23 downto 0);
           b : in  STD_LOGIC_VECTOR (23 downto 0);
           op : in  STD_LOGIC;
           sum : out  STD_LOGIC_VECTOR (23 downto 0));
end component;

component clk_25m is
   port ( CLKIN_IN        : in    std_logic; 
          RST_IN          : in    std_logic; 
          CLKFX_OUT       : out   std_logic; 
          CLKIN_IBUFG_OUT : out   std_logic; 
          CLK0_OUT        : out   std_logic; 
          LOCKED_OUT      : out   std_logic);
end component;

component TFT_LCD is
    Port ( clk : in  STD_LOGIC;
           nrst : in  STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (15 downto 0);
           de : out  STD_LOGIC;
			  text_addr : out  STD_LOGIC_VECTOR(7 downto 0);
			  text_data : in  STD_LOGIC_VECTOR(7 downto 0));
end component;

signal rst : STD_LOGIC;

signal key_data : STD_LOGIC_VECTOR(3 downto 0);
signal key_event : STD_LOGIC;

signal kiosk_state : STD_LOGIC_VECTOR(2 downto 0);

signal menu_price, discount_price : STD_LOGIC_VECTOR (23 downto 0);
signal subtotal, subtotal_t, subtotal_mux : STD_LOGIC_VECTOR(23 downto 0);
signal total : STD_LOGIC_VECTOR(23 downto 0);

signal lcd_25m_clk, clk0 : STD_LOGIC;

signal text_data : STD_LOGIC_VECTOR (7 downto 0);

begin 

rst <= not (n_reset_btn(3) and n_reset_btn(2) and n_reset_btn(1) and n_reset_btn(0));

U_KPD : Key_Matrix port map (clk0, rst, key_matrix_in, key_matrix_scan, key_data, key_event);

U_7SEG : seven_segment port map(clk0, rst, total, segment_data, segment_sel); 

U_STATE : state_selector port map(clk0, rst, key_event, key_data, kiosk_state);

--price alu process
menu_price <= x"333333";

subtotal_mux <= 	x"333333" when subtotal = x"000000" else
						subtotal;

U_PRICE_ALU : excess3_6 port map (subtotal_mux, menu_price, '0', subtotal_t);

U_SUBTOTAL_REG : reg
					generic map (24)
					port map (clk0, rst, key_event, subtotal_t, subtotal);

discount_price <= x"333333" when kiosk_state < 5 else
						x"333343" when discount_switch = "1000" else
						x"333353" when discount_switch = "0100" else
						x"333383" when discount_switch = "0010" else
						x"333433" when discount_switch = "0001" else
						x"333333";

U_DISCOUNT_ALU : excess3_6 port map (subtotal, discount_price, '1', total);

--display

U_CLK_25M : clk_25m port map(
	CLKIN_IN => clk,
	RST_IN => rst,
	CLKFX_OUT => lcd_25m_clk,
	CLKIN_IBUFG_OUT => open,
	CLK0_OUT => clk0,
	LOCKED_OUT => open
);

U_TFT_LCD : TFT_LCD port map (
	CLK => lcd_25m_clk,
	nrst => n_reset_btn(3),
	data_out => lcd_data,
	de => lcd_de,
	text_addr => open,
	text_data => text_data
);

lcd_clk <= lcd_25m_clk;
text_data <= "0000" & key_data;

--test
debug_led <= "00000000";
end Behavioral;

