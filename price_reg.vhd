----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:50:32 06/03/2019 
-- Design Name: 
-- Module Name:    price_reg - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: register for price which is 3-excess code.
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

entity price_reg is
    Port ( clk : in  STD_LOGIC;
			  rst : in  STD_LOGIC;
           load_en : in  STD_LOGIC;
           load_data : in  STD_LOGIC_VECTOR (23 downto 0);
           out_data : out  STD_LOGIC_VECTOR (23 downto 0));
end price_reg;

architecture Behavioral of price_reg is

begin
	process(clk, rst)
	begin
		if rst = '1' then
			out_data <= x"333333";
		elsif load_en = '1' and rising_edge(clk) then
			out_data <= load_data;
		end if;
	end process;
end Behavioral;

