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
           state : out  STD_LOGIC_VECTOR (2 downto 0);
			  selected : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component reg is
	Generic ( size : integer := 16);
   Port ( clk : in  STD_LOGIC;
			 rst : in  STD_LOGIC;
			 load_en : in  STD_LOGIC;
			 load_data : in  STD_LOGIC_VECTOR (15 downto 0);
			 out_data : out  STD_LOGIC_VECTOR (15 downto 0));
end component;

component submenu_decoder is
    Port ( sel : in  STD_LOGIC_VECTOR (3 downto 0);
           dout : out  STD_LOGIC_VECTOR (9 downto 0));
end component;

component menu_price_alu is
    Port ( menu_bit : in  STD_LOGIC_VECTOR (15 downto 0);
           price : out  STD_LOGIC_VECTOR (23 downto 0));
end component;

component price_reg is
   Port ( clk : in  STD_LOGIC;
			 rst : in  STD_LOGIC;
			 load_en : in  STD_LOGIC;
			 load_data : in  STD_LOGIC_VECTOR (23 downto 0);
			 out_data : out  STD_LOGIC_VECTOR (23 downto 0));
end component;

component excess3_6 is
    Port ( a : in  STD_LOGIC_VECTOR (23 downto 0);
           b : in  STD_LOGIC_VECTOR (23 downto 0);
           op : in  STD_LOGIC;
           sum : out  STD_LOGIC_VECTOR (23 downto 0));
end component;

component memory_qu is
    Port ( clk : in  STD_LOGIC;
			  rst : in  STD_LOGIC;
           load_en : in  STD_LOGIC;
           load_data : in  STD_LOGIC_VECTOR (15 downto 0);
           delete_addr : in  STD_LOGIC_VECTOR (3 downto 0);
           delete_en : in  STD_LOGIC;
			  addr : in STD_LOGIC_VECTOR (3 downto 0);
           out_data : out  STD_LOGIC_VECTOR (15 downto 0));
end component;

--display module
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

component screen_manage is
    Port (
		clk : in  STD_LOGIC;
		state : in STD_LOGIC_VECTOR(2 downto 0);
		sel : in STD_LOGIC_VECTOR(3 downto 0);
		order : in STD_LOGIC_VECTOR(15 downto 0);
		mem_addr : out STD_LOGIC_VECTOR(3 downto 0);
		mem_data : in STD_LOGIC_VECTOR(15 downto 0);
		text_addr : in  STD_LOGIC_VECTOR(7 downto 0);
		text_data : out  STD_LOGIC_VECTOR(7 downto 0));
end component;

signal rst : STD_LOGIC;

signal key_data : STD_LOGIC_VECTOR(3 downto 0);
signal key_event : STD_LOGIC;

signal kiosk_state : STD_LOGIC_VECTOR(2 downto 0);
signal kiosk_select : STD_LOGIC_VECTOR (3 downto 0);

--current
signal menu_price : STD_LOGIC_VECTOR(23 downto 0);

--subtotal
signal subtotal, subtotal_t, subtotal_mux : STD_LOGIC_VECTOR(23 downto 0);
signal submenu_bit : STD_LOGIC_VECTOR(9 downto 0);
signal subtotal_en : STD_LOGIC;

--discount
--signal discount_t, discount : STD_LOGIC_VECTOR(23 downto 0);
--signal menu_price_t, submenu_price_t : STD_LOGIC_VECTOR (23 downto 0);
--signal discount_en : STD_LOGIC;

--total.
signal total : STD_LOGIC_VECTOR(23 downto 0);

--save order
signal order, order_t : STD_LOGIC_VECTOR (15 downto 0);
signal submenu_sel : STD_LOGIC_VECTOR(9 downto 0);
signal mem_en, del_en : STD_LOGIC;


--display
signal lcd_25m_clk, clk0 : STD_LOGIC;
signal text_data, text_addr : STD_LOGIC_VECTOR (7 downto 0);
signal mem_addr : STD_LOGIC_VECTOR(3 downto 0);
signal mem_data : STD_LOGIC_VECTOR(15 downto 0);

begin 

	rst <= not (n_reset_btn(3) and n_reset_btn(2) and n_reset_btn(1) and n_reset_btn(0));

	U_KPD : Key_Matrix port map (clk0, rst, key_matrix_in, key_matrix_scan, key_data, key_event);

	U_7SEG : seven_segment port map(clk0, rst, total, segment_data, segment_sel); 

	U_STATE : state_selector port map(clk0, rst, key_event, key_data, kiosk_state, kiosk_select);

	
--price alu process
	--current order
	U_SUBMENU_DECODER : submenu_decoder port map (kiosk_select, submenu_sel);
	
	order_t <=
		"10" & kiosk_select & "0000000000" when kiosk_state = "001" else
		order(15 downto 10) & (order(9 downto 0) xor submenu_sel) when kiosk_state = "010" and key_data = x"5" else
		order;
	
	R_CURRENT_ORDER : reg port map (
		clk => clk0,
		rst => rst,
		load_en => key_event,
		load_data => order_t,
		out_data => order
	);
	
	--subtotal process
	U_CURRENT_ORDER_PRICE : menu_price_alu port map (order, menu_price);
	
	U_SUBTOTAL_ALU : excess3_6 port map (subtotal, menu_price, '0', subtotal_t);

	U_SUBTOTAL_REG : price_reg port map (clk0, rst, mem_en, subtotal_t, subtotal);	
	
	--discount process.

	--total process.
	--U_TOTAL_ALU : excess3_6 port map (subtotal, discount, '1', total);
	total <= subtotal;
	
	--orders memory.
	mem_en <=
		key_event when key_data=x"0" else
		'0';
	del_en <=
		key_event when key_data = x"D" else
		'0';
	
	U_ORDER_MEM : memory_qu port map (
		clk => clk0,
		rst => rst,
		load_en => mem_en,
		load_data => order,
		delete_addr => kiosk_select,
		delete_en => del_en,
		addr => mem_addr,
		out_data => mem_data
	);
	
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
		text_addr => text_addr,
		text_data => text_data
	);

	U_SCREEN_MGR : screen_manage port map (
		clk => lcd_25m_clk,
		state => kiosk_state,
		sel => kiosk_select,
		order => order,
		mem_addr => mem_addr,
		mem_data => mem_data,
		text_addr => text_addr,
		text_data => text_data
	);

	lcd_clk <= lcd_25m_clk;

	--test
	
	debug_led(7 downto 4) <= kiosk_select;
	debug_led(3) <= '0';
	debug_led(2 downto 0) <= kiosk_state;
	
end Behavioral;

