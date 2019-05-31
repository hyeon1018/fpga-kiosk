----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:05:08 05/31/2019 
-- Design Name: 
-- Module Name:    screen_manage - Behavioral 
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

entity screen_manage is
    Port (
		clk : in  STD_LOGIC;
		--machine state.
		state : in STD_LOGIC_VECTOR(2 downto 0);
		sel : in STD_LOGIC_VECTOR(3 downto 0);
		--lcd in/out data.
		text_addr : in  STD_LOGIC_VECTOR(7 downto 0);
		text_data : out  STD_LOGIC_VECTOR(7 downto 0));
end screen_manage;

architecture Behavioral of screen_manage is
signal rom_text_data_t : STD_LOGIC_VECTOR(5 downto 0);

begin
	rom_data : process(clk)
	begin	
		if rising_edge(clk) then
			if state = "000" then
				case text_addr is
					--welcom
					when x"2D" => rom_text_data_t <= "100011";
					when x"2E" => rom_text_data_t <= "010001";
					when x"2F" => rom_text_data_t <= "011000";
					when x"30" => rom_text_data_t <= "001111";
					when x"31" => rom_text_data_t <= "011011";
					when x"32" => rom_text_data_t <= "011001";
					when x"33" => rom_text_data_t <= "010001";
					--press any key
					when x"8A" => rom_text_data_t <= "011100";
					when x"8B" => rom_text_data_t <= "011110";
					when x"8C" => rom_text_data_t <= "010001";
					when x"8D" => rom_text_data_t <= "011111";
					when x"8E" => rom_text_data_t <= "011111";
					when x"8F" => rom_text_data_t <= "000000";
					when x"90" => rom_text_data_t <= "001101";
					when x"91" => rom_text_data_t <= "011010";
					when x"92" => rom_text_data_t <= "100101";
					when x"93" => rom_text_data_t <= "000000";
					when x"94" => rom_text_data_t <= "010111";
					when x"95" => rom_text_data_t <= "010001";
					when x"96" => rom_text_data_t <= "100101";
					when others => rom_text_data_t <= "000000";
				end case;
			elsif state = "001" then
				case text_addr is
					--menu
					when x"0E" => rom_text_data_t <= "011001";
					when x"0F" => rom_text_data_t <= "010001";
					when x"10" => rom_text_data_t <= "011010";
					when x"11" => rom_text_data_t <= "100001";
					when others => rom_text_data_t <= "000000";
				end case;
			elsif state = "010" then
				case text_addr is
					--topping
					when x"0D" => rom_text_data_t <= "100000";
					when x"0E" => rom_text_data_t <= "011011";
					when x"0F" => rom_text_data_t <= "011100";
					when x"10" => rom_text_data_t <= "011100";
					when x"11" => rom_text_data_t <= "010101";
					when x"12" => rom_text_data_t <= "011010";
					when x"13" => rom_text_data_t <= "010011";
					when others => rom_text_data_t <= "000000";
				end case;
			elsif state = "011" then
				case text_addr is
					--where to eat
					when x"0A" => rom_text_data_t <= "100011";
					when x"0B" => rom_text_data_t <= "010100";
					when x"0C" => rom_text_data_t <= "010001";
					when x"0D" => rom_text_data_t <= "011110";
					when x"0E" => rom_text_data_t <= "010001";
					when x"0F" => rom_text_data_t <= "000000";
					when x"10" => rom_text_data_t <= "100000";
					when x"11" => rom_text_data_t <= "011011";
					when x"12" => rom_text_data_t <= "000000";
					when x"13" => rom_text_data_t <= "010001";
					when x"14" => rom_text_data_t <= "001101";
					when x"15" => rom_text_data_t <= "100000";
					when x"16" => rom_text_data_t <= "101000";
					when others => rom_text_data_t <= "000000";
				end case;
			elsif state = "100" then
				case text_addr is
					--header payment
					when x"0D" => rom_text_data_t <= "011100";
					when x"0E" => rom_text_data_t <= "001101";
					when x"0F" => rom_text_data_t <= "100101";
					when x"10" => rom_text_data_t <= "011001";
					when x"11" => rom_text_data_t <= "010001";
					when x"12" => rom_text_data_t <= "011010";
					when x"13" => rom_text_data_t <= "100000";
					when others => rom_text_data_t <= "000000";
					--?press and key to continue
				end case;
			elsif state = "101" then
				case text_addr is
					--receipt
					when x"0D" => rom_text_data_t <= "011110";
					when x"0E" => rom_text_data_t <= "010001";
					when x"0F" => rom_text_data_t <= "001111";
					when x"10" => rom_text_data_t <= "010001";
					when x"11" => rom_text_data_t <= "010101";
					when x"12" => rom_text_data_t <= "011100";
					when x"13" => rom_text_data_t <= "100000";
					when others => rom_text_data_t <= "000000";
				end case;
			end if;
		end if;
	end process;
	
	text_data(5 downto 0) <=
		rom_text_data_t when state = "000" or text_addr(7 downto 5) = "000" else
		"000000";

end Behavioral;

