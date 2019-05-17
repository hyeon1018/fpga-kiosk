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

signal price : STD_LOGIC_VECTOR(23 downto 0);
signal key_data : STD_LOGIC_VECTOR(3 downto 0);
signal key_event : STD_LOGIC;
signal led_out_t : STD_LOGIC_VECTOR(7 downto 0) := "10000000";
--test.
signal updown : STD_LOGIC_VECTOR(3 downto 0) := "0000";

begin 

U_KPD : Key_Matrix port map (clk, '0', key_matrix_in, key_matrix_scan, key_data, key_event);

U_7SEG : seven_segment port map(clk, '0', price, segment_data, segment_sel); 

--debugin
process(key_event)
begin
	if falling_edge(key_event) then
		if key_data = x"4" then
			led_out_t <= led_out_t(6 downto 0) & led_out_t(7);
		elsif key_data = x"6" then
			led_out_t <= led_out_t(0) & led_out_t(7 downto 1);
		elsif key_data = x"2" then
			updown <= updown + 1;
		elsif key_data = x"8" then
			updown <= updown - 1;
		end if;
	end if;
end process;

debug_led <= led_out_t;
price(23 downto 4) <= (others => '0');
price(3 downto 0) <= updown;


end Behavioral;

