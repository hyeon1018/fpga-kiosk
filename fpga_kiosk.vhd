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
           segment_data : out  STD_LOGIC_VECTOR (7 downto 0);
           segment_sel : out  STD_LOGIC_VECTOR (5 downto 0);
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

signal price, price_t : STD_LOGIC_VECTOR(23 downto 0);
signal key_data : STD_LOGIC_VECTOR(3 downto 0);
signal key_event : STD_LOGIC;

signal kiosk_state : STD_LOGIC_VECTOR(2 downto 0);

--test;
signal test_out, test_out_t : STD_LOGIC_VECTOR(7 downto 0);

begin 

U_KPD : Key_Matrix port map (clk, '0', key_matrix_in, key_matrix_scan, key_data, key_event);

U_7SEG : seven_segment port map(clk, '0', price, segment_data, segment_sel); 

U_STATE : state_selector port map(clk, '0', key_event, key_data, kiosk_state);

--test;
U_PRICE_REG : reg
					generic map (24)
					port map (clk, '0', key_event, price_t, price);

price_t <=	price + 1 when key_data = x"3" else
				price - 1 when key_data = x"9" else
				price + x"10" when key_data = x"2" else
				price - x"10" when key_data = x"8" else
				price + x"100" when key_data = x"1" else
				price - x"100" when key_data = x"7" else
				price;				


U_TEST_REG : reg
				 generic map (8)
				 port map (clk, '0', key_event, test_out_t, test_out);
			
test_out_t <= test_out(0) & test_out(7 downto 1) when key_data = x"6" else
				  test_out or "10000000" when key_data = x"5" else
				  test_out(6 downto 0) & test_out(7) when key_data = x"4" else
				  "10000000" when key_data = x"A" else
				  "11111111" when key_data = x"B" else
				  "00000" & kiosk_state when key_data = x"C" else
				  test_out;
				  
debug_led <= test_out;

end Behavioral;

