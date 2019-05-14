----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:03:06 05/08/2019 
-- Design Name: 
-- Module Name:    clock_divider - Behavioral 
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

entity clock_divider is
	 Generic ( div_count : integer );
    Port ( clk_in : in  STD_LOGIC;
			  rst : in STD_LOGIC;
           clk_out : out  STD_LOGIC);
end clock_divider;

architecture Behavioral of clock_divider is
-- 1s = 100Mhz < 2^27
signal cnt : STD_LOGIC_VECTOR(27 downto 0) := (others => '0');
signal d_clk : STD_LOGIC := '0';
begin
	process(clk_in, rst)
	begin
		if rst = '1' then 
			cnt <= (others => '0');
			d_clk <= '0';
		elsif rising_edge(clk_in) then
			if cnt = div_count then
				cnt <= (others => '0');
				d_clk <= not d_clk;
			else
				cnt <= cnt+1;
			end if;
		end if;
	end process;
	clk_out <= d_clk;
end Behavioral;

