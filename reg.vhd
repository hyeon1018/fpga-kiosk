----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:32:31 05/21/2019 
-- Design Name: 
-- Module Name:    reg - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: generic size register.
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

entity reg is
	Generic ( size : integer := 8 );
   Port ( clk : in  STD_LOGIC;
			 rst : in  STD_LOGIC;
			 load_en : in  STD_LOGIC;
			 load_data : in  STD_LOGIC_VECTOR (size-1 downto 0);
			 out_data : out  STD_LOGIC_VECTOR (size-1 downto 0));
end reg;

architecture Behavioral of reg is
begin

	process (clk, rst)
	begin
		if rst = '1' then
			data <= (others => '0');
		elsif load_en = '1' and rising_edge(clk) then
			out_data <= load_data;
		end if;
	end process;
	
end Behavioral;

