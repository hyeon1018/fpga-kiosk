----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:17:27 06/03/2019 
-- Design Name: 
-- Module Name:    menu_price_rom - Behavioral 
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

entity menu_price_rom is
    Port ( menu_sel : in  STD_LOGIC_VECTOR (3 downto 0);
           menu_price : out  STD_LOGIC_VECTOR (23 downto 0));
end menu_price_rom;

architecture Behavioral of menu_price_rom is

begin
menu_price <=
	x"33B333" when menu_sel = "0000" else
	x"333333";

end Behavioral;

