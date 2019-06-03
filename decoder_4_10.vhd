----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:43:10 06/03/2019 
-- Design Name: 
-- Module Name:    submenu_decoder - Behavioral 
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

entity submenu_decoder is
    Port ( sel : in  STD_LOGIC_VECTOR (3 downto 0);
           dout : out  STD_LOGIC_VECTOR (9 downto 0));
end submenu_decoder;

architecture Behavioral of submenu_decoder is
signal notsel : STD_LOGIC_VECTOR(3 downto 0);
begin
	notsel <= not sel;

	dout(9) <= notsel(3) and notsel(2) and notsel(1) and notsel(0);
	dout(8) <= notsel(3) and notsel(2) and notsel(1) and sel(0);
	dout(7) <= notsel(3) and notsel(2) and sel(1) and notsel(0);
	dout(6) <= notsel(3) and notsel(2) and sel(1) and sel(0);
	dout(5) <= notsel(3) and sel(2) and notsel(1) and notsel(0);
	dout(4) <= notsel(3) and sel(2) and notsel(1) and sel(0);
	dout(3) <= notsel(3) and sel(2) and sel(1) and notsel(0);
	dout(2) <= notsel(3) and sel(2) and sel(1) and sel(0);
	dout(1) <= sel(3) and notsel(2) and notsel(1) and notsel(0);
	dout(0) <= sel(3) and notsel(2) and notsel(1) and sel(0);

end Behavioral;

