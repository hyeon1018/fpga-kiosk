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
			  mem_len : in STD_LOGIC_VECTOR (3 downto 0);
           state : out  STD_LOGIC_VECTOR (2 downto 0);
			  selected : out STD_LOGIC_VECTOR (3 downto 0);
			  max_selected : out STD_LOGIC_VECTOR (3 downto 0);
			  mem_rst : out STD_LOGIC;
			  mem_load_en : out STD_LOGIC;
			  mem_del_en : out STD_LOGIC;
			  order_reg_rst : out STD_LOGIC;
			  order_reg_en : out STD_LOGIC;
			  order_reg_sel : out STD_LOGIC;
			  subtotal_en : out STD_LOGIC;
			  subtotal_op : out STD_LOGIC;
			  discount_en : out STD_LOGIC);
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
			  len : out STD_LOGIC_VECTOR(3 downto 0);
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
		max_sel : in STD_LOGIC_VECTOR(3 downto 0);
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

signal segment_price : STD_LOGIC_VECTOR(23 downto 0);

--current
signal menu_price : STD_LOGIC_VECTOR(23 downto 0);
signal order_reg_rst, order_reg_en, order_reg_sel : STD_LOGIC;
--subtotal
signal subtotal, subtotal_t : STD_LOGIC_VECTOR(23 downto 0);
signal subtotal_en, subtotal_op : STD_LOGIC;

--discount
signal discount_t, discount : STD_LOGIC_VECTOR(23 downto 0);
signal discount_en : STD_LOGIC;

--total.
signal total : STD_LOGIC_VECTOR(23 downto 0);

--save order
signal order, order_t, calc_order : STD_LOGIC_VECTOR (15 downto 0);
signal submenu_sel : STD_LOGIC_VECTOR(9 downto 0);
signal mem_len : STD_LOGIC_VECTOR(3 downto 0);
signal mem_rst, mem_load_en, mem_del_en : STD_LOGIC;

--display
signal lcd_25m_clk, clk0 : STD_LOGIC;
signal text_data, text_addr : STD_LOGIC_VECTOR (7 downto 0);
signal mem_addr, mem_addr_t : STD_LOGIC_VECTOR(3 downto 0);
signal mem_data : STD_LOGIC_VECTOR(15 downto 0);
signal max_sel : STD_LOGIC_VECTOR(3 downto 0);

begin 

	rst <= not (n_reset_btn(3) and n_reset_btn(2) and n_reset_btn(1) and n_reset_btn(0));

	U_KPD : Key_Matrix port map (clk0, rst, key_matrix_in, key_matrix_scan, key_data, key_event);

	U_7SEG : seven_segment port map(clk0, rst, segment_price, segment_data, segment_sel); 
	
	segment_price <=
		subtotal_t when kiosk_state = "010" else
		subtotal when kiosk_state = "001" or kiosk_state = "100" else
		total;
	
	U_STATE : state_selector port map(
		clk => clk0,
		rst => rst,
		key_event => key_event,
		key_data => key_data,
		mem_len => mem_len,
		state => kiosk_state,
		selected => kiosk_select,
		max_selected => max_sel,
		
		mem_rst => mem_rst,
		mem_load_en => mem_load_en,
		mem_del_en => mem_del_en,
		order_reg_rst => order_reg_rst,
		order_reg_en => order_reg_en,
		order_reg_sel => order_reg_sel,
		subtotal_en => subtotal_en,
		subtotal_op => subtotal_op,
		discount_en => discount_en
	);
	
--price alu process
	--current order
	U_SUBMENU_DECODER : submenu_decoder port map (kiosk_select, submenu_sel);
	
	--control--
	order_t <=
		order(15 downto 10) & (order(9 downto 0) xor submenu_sel) when order_reg_sel = '1' else
		"10" & kiosk_select & "0000000000";
	
	R_CURRENT_ORDER : reg port map (
		clk => clk0,
		rst => rst,
		load_en => order_reg_en,
		load_data => order_t,
		out_data => order
	);
	
	--subtotal process
	--ordre -> mux order / mem_data.
	calc_order <=
		mem_data when subtotal_op = '1' else
		order;

	U_CURRENT_ORDER_PRICE : menu_price_alu port map (calc_order, menu_price);
	
	U_SUBTOTAL_ALU : excess3_6 port map (subtotal, menu_price, subtotal_op, subtotal_t);

	U_SUBTOTAL_REG : price_reg port map (clk0, mem_rst, subtotal_en, subtotal_t, subtotal);	
	
	--discount process.
	
	discount_t <=
		x"334333" when discount_switch = "1000" else
		"0011" & subtotal(19 downto 0) when discount_switch = "0001" else
		x"333333";

	U_DISCOUNT_REG : price_reg port map (clk0 , mem_rst, discount_en, discount_t, discount);

	--total process.
	U_TOTAL_ALU : excess3_6 port map (subtotal, discount, '1', total);
	
	
	--orders memory.
	--addr -> mux / mem_addr or sel.
	mem_addr_t <=
		kiosk_select when subtotal_op = '1' else
		mem_addr;
	
	U_ORDER_MEM : memory_qu port map (
		clk => clk0,
		rst => mem_rst,
		len => mem_len,
		load_en => mem_load_en,
		load_data => order,
		delete_addr => kiosk_select,
		delete_en => mem_del_en,
		addr => mem_addr_t,
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
		max_sel => max_sel,
		order => order,
		mem_addr => mem_addr,
		mem_data => mem_data,
		text_addr => text_addr,
		text_data => text_data
	);

	lcd_clk <= lcd_25m_clk;

	--test
	debug_led(7 downto 0) <= max_sel & kiosk_select;
	
end Behavioral;

