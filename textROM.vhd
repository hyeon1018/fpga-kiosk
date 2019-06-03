----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:51:19 06/03/2019 
-- Design Name: 
-- Module Name:    textROM - Behavioral 
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

entity textROM is
    Port ( clk : in  STD_LOGIC;
           state : in  STD_LOGIC_VECTOR(2 downto 0);
           text_addr : in  STD_LOGIC_VECTOR(7 downto 0);
			  text_data : out STD_LOGIC_VECTOR(5 downto 0));
end textROM;

architecture Behavioral of textROM is

begin
	rom_data : process(clk)
	begin	
		if rising_edge(clk) then
			if state = "000" then
				case text_addr is
					--welcom
					when x"2D" => text_data <= "100011";
					when x"2E" => text_data <= "010001";
					when x"2F" => text_data <= "011000";
					when x"30" => text_data <= "001111";
					when x"31" => text_data <= "011011";
					when x"32" => text_data <= "011001";
					when x"33" => text_data <= "010001";
					--press any key
					when x"8A" => text_data <= "011100";
					when x"8B" => text_data <= "011110";
					when x"8C" => text_data <= "010001";
					when x"8D" => text_data <= "011111";
					when x"8E" => text_data <= "011111";
					when x"8F" => text_data <= "000000";
					when x"90" => text_data <= "001101";
					when x"91" => text_data <= "011010";
					when x"92" => text_data <= "100101";
					when x"93" => text_data <= "000000";
					when x"94" => text_data <= "010111";
					when x"95" => text_data <= "010001";
					when x"96" => text_data <= "100101";
					when others => text_data <= "000000";
				end case;
			elsif state = "001" then
				case text_addr is
					--menu
					when x"0E" => text_data <= "011001";
					when x"0F" => text_data <= "010001";
					when x"10" => text_data <= "011010";
					when x"11" => text_data <= "100001";
					when others => text_data <= "000000";
				end case;
			elsif state = "010" then
				case text_addr is
					--topping
					when x"0D" => text_data <= "100000";
					when x"0E" => text_data <= "011011";
					when x"0F" => text_data <= "011100";
					when x"10" => text_data <= "011100";
					when x"11" => text_data <= "010101";
					when x"12" => text_data <= "011010";
					when x"13" => text_data <= "010011";
					when others => text_data <= "000000";
				end case;
			elsif state = "011" then
				case text_addr is
					--where to eat
					when x"0A" => text_data <= "100011";
					when x"0B" => text_data <= "010100";
					when x"0C" => text_data <= "010001";
					when x"0D" => text_data <= "011110";
					when x"0E" => text_data <= "010001";
					when x"0F" => text_data <= "000000";
					when x"10" => text_data <= "100000";
					when x"11" => text_data <= "011011";
					when x"12" => text_data <= "000000";
					when x"13" => text_data <= "010001";
					when x"14" => text_data <= "001101";
					when x"15" => text_data <= "100000";
					when x"16" => text_data <= "101000";
					-- -> FOR HERE
					when x"61" => text_data <= "000010";
					when x"62" => text_data <= "100111";
					when x"63" => text_data <= "000000";
					when x"64" => text_data <= "010010";
					when x"65" => text_data <= "011011";
					when x"66" => text_data <= "011110";
					when x"67" => text_data <= "000000";
					when x"68" => text_data <= "010100";
					when x"69" => text_data <= "010001";
					when x"6A" => text_data <= "011110";
					when x"6B" => text_data <= "010001";
					-- -> TO GO
					when x"81" => text_data <= "000010";
					when x"82" => text_data <= "100111";
					when x"83" => text_data <= "000000";
					when x"84" => text_data <= "100000";
					when x"85" => text_data <= "011011";
					when x"86" => text_data <= "000000";
					when x"87" => text_data <= "010011";
					when x"88" => text_data <= "000011";
					when others => text_data <= "000000";
				end case;
			elsif state = "100" then
				case text_addr is
					--header payment
					when x"0D" => text_data <= "011100";
					when x"0E" => text_data <= "001101";
					when x"0F" => text_data <= "100101";
					when x"10" => text_data <= "011001";
					when x"11" => text_data <= "010001";
					when x"12" => text_data <= "011010";
					when x"13" => text_data <= "100000";
					when others => text_data <= "000000";
					--?press and key to continue
				end case;
			elsif state = "101" then
				case text_addr is
					--receipt
					when x"0D" => text_data <= "011110";
					when x"0E" => text_data <= "010001";
					when x"0F" => text_data <= "001111";
					when x"10" => text_data <= "010001";
					when x"11" => text_data <= "010101";
					when x"12" => text_data <= "011100";
					when x"13" => text_data <= "100000";
					when others => text_data <= "000000";
				end case;
			end if;
		end if;
	end process;

end Behavioral;

