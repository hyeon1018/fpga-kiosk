----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:21:35 04/30/2019 
-- Design Name: 
-- Module Name:    bcd_to_7seg - Behavioral 
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

entity bcd_to_7seg is
    Port ( bcd_in : in  STD_LOGIC_VECTOR (3 downto 0);
           seg_out : out  STD_LOGIC_VECTOR (7 downto 0));
end bcd_to_7seg;

architecture Behavioral of bcd_to_7seg is
begin
	seg_out <= "00111111" when bcd_in = "0000" else
			  "00000110" when bcd_in = "0001" else
			  "01011011" when bcd_in = "0010" else
			  "01001111" when bcd_in = "0011" else
			  "01100110" when bcd_in = "0100" else
			  "01101101" when bcd_in = "0101" else
			  "01111101" when bcd_in = "0110" else
			  "00000111" when bcd_in = "0111" else
			  "01111111" when bcd_in = "1000" else
			  "01101111" when bcd_in = "1001" else
			  "01110111" when bcd_in = "1010" else
			  "01111100" when bcd_in = "1011" else
			  "00111001" when bcd_in = "1100" else
			  "01011110" when bcd_in = "1101" else
			  "01111001" when bcd_in = "1110" else
			  "01110001" when bcd_in = "1111" else
			  "00000000";
end Behavioral;

