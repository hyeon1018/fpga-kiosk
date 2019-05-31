----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:44:06 05/30/2019 
-- Design Name: 
-- Module Name:    init_screen_rom - Behavioral 
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

entity init_screen_rom is
    Port (	clk : in STD_LOGIC;
				text_addr : in  STD_LOGIC_VECTOR (7 downto 0);
				text_data : out  STD_LOGIC_VECTOR (7 downto 0));
end init_screen_rom;

architecture Behavioral of init_screen_rom is
signal text_data_t : STD_LOGIC_VECTOR(7 downto 0);
begin
	process(clk)
	begin
		if rising_edge(clk) then
			text_data <= text_data_t;
		end if;
	end process;
	
	text_data_t <= 
				x"80" when text_addr = x"20" else
				x"80" when text_addr = x"21" else
				x"80" when text_addr = x"22" else
				x"80" when text_addr = x"23" else
				x"80" when text_addr = x"24" else
				x"80" when text_addr = x"25" else
				x"80" when text_addr = x"26" else
				x"80" when text_addr = x"27" else
				x"80" when text_addr = x"28" else
				x"80" when text_addr = x"29" else
				x"80" when text_addr = x"2A" else
				x"80" when text_addr = x"2B" else
				x"80" when text_addr = x"2C" else
				x"A3" when text_addr = x"2D" else
				x"91" when text_addr = x"2E" else
				x"98" when text_addr = x"2F" else
				x"8F" when text_addr = x"30" else
				x"9B" when text_addr = x"31" else
				x"99" when text_addr = x"32" else
				x"91" when text_addr = x"33" else
				x"80" when text_addr = x"34" else
				x"80" when text_addr = x"35" else
				x"80" when text_addr = x"36" else
				x"80" when text_addr = x"37" else
				x"80" when text_addr = x"38" else
				x"80" when text_addr = x"39" else
				x"80" when text_addr = x"3A" else
				x"80" when text_addr = x"3B" else
				x"80" when text_addr = x"3C" else
				x"80" when text_addr = x"3D" else
				x"80" when text_addr = x"3E" else
				x"80" when text_addr = x"3F" else
				x"5C" when text_addr = x"8A" else
				x"5E" when text_addr = x"8B" else
				x"51" when text_addr = x"8C" else
				x"5F" when text_addr = x"8D" else
				x"5F" when text_addr = x"8E" else
				x"40" when text_addr = x"8F" else
				x"4D" when text_addr = x"90" else
				x"5A" when text_addr = x"91" else
				x"65" when text_addr = x"92" else
				x"40" when text_addr = x"93" else
				x"57" when text_addr = x"94" else
				x"51" when text_addr = x"95" else
				x"65" when text_addr = x"96" else			
				x"00";
		
end Behavioral;

