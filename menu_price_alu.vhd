----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:42:06 06/04/2019 
-- Design Name: 
-- Module Name:    menu_price_alu - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity menu_price_alu is
    Port ( menu_bit : in  STD_LOGIC_VECTOR (15 downto 0);
           price : out  STD_LOGIC_VECTOR (23 downto 0));
end menu_price_alu;

architecture Behavioral of menu_price_alu is
component excess3_6 is
    Port ( a : in  STD_LOGIC_VECTOR (23 downto 0);
           b : in  STD_LOGIC_VECTOR (23 downto 0);
           op : in  STD_LOGIC;
           sum : out  STD_LOGIC_VECTOR (23 downto 0));
end component;

type data_array is array (9 downto 0) of STD_LOGIC_VECTOR (23 downto 0);
signal submenu_price : data_array;
signal sum : data_array;

signal total_sum : STD_LOGIC_VECTOR (23 downto 0);

signal menu : STD_LOGIC_VECTOR(3 downto 0);

begin

	menu <= menu_bit(13 downto 10);
	with menu select sum(0) <=
		x"33A333" when x"0",
		x"33B333" when x"1",
		x"33B333" when x"2",
		x"33C333" when x"3",
		x"33C333" when x"4",
		x"343333" when x"5",
		x"343333" when x"6",
		x"345333" when x"7",
		x"345333" when x"8",
		x"348333" when x"9",
		x"333333" when others;
	
	submenu_price(0) <=
		x"334333" when menu_bit(9) = '1' else
		x"333333";
	submenu_price(1) <=
		x"333334" when menu_bit(8) = '1' else
		x"333333";
	submenu_price(2) <=
		x"333335" when menu_bit(7) = '1' else
		x"333333";
	submenu_price(3) <=
		x"333336" when menu_bit(6) = '1' else
		x"333333";
	submenu_price(4) <=
		x"333337" when menu_bit(5) = '1' else
		x"333333";
	submenu_price(5) <=
		x"333338" when menu_bit(4) = '1' else
		x"333333";
	submenu_price(6) <=
		x"333339" when menu_bit(3) = '1' else
		x"333333";
	submenu_price(7) <=
		x"33333A" when menu_bit(2) = '1' else
		x"333333";
	submenu_price(8) <=
		x"333342" when menu_bit(1) = '1' else
		x"333333";
	submenu_price(9) <=
		x"333344" when menu_bit(0) = '1' else
		x"333333";
		
	sum_gen : for K in 0 to 8 generate
		U_EX3_SUM : excess3_6 port map (sum(K), submenu_price(K), '0', sum(K+1));
	end generate;
	
	U_EX3_SUM2 : excess3_6 port map (sum(9), submenu_price(9), '0', total_sum);

	price <= total_sum when menu_bit(15) = '1' else
				x"333333";

end Behavioral;

