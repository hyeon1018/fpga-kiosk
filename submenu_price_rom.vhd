----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:56:30 06/04/2019 
-- Design Name: 
-- Module Name:    submenu_price_rom - Behavioral 
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

entity submenu_price_rom is
    Port ( submenu_sel : in  STD_LOGIC_VECTOR (3 downto 0);
           submenu_price : out  STD_LOGIC_VECTOR (23 downto 0));
end submenu_price_rom;

architecture Behavioral of submenu_price_rom is

begin

submenu_price <=
	x"334333" when submenu_sel = "0000" else
	x"333334" when submenu_sel = "0001" else
	x"333335" when submenu_sel = "0010" else
	x"333336" when submenu_sel = "0011" else
	x"333337" when submenu_sel = "0100" else
	x"333338" when submenu_sel = "0101" else
	x"333339" when submenu_sel = "0110" else
	x"333330" when submenu_sel = "0111" else
	x"33333A" when submenu_sel = "1000" else
	x"33333B" when submenu_sel = "1001" else
	x"333333";

end Behavioral;

