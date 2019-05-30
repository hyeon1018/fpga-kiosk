----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:25:56 05/23/2019 
-- Design Name: 
-- Module Name:    state_selector - Behavioral 
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

entity state_selector is
    Port ( clk : in  STD_LOGIC;
			  rst : in  STD_LOGIC;
           key_event : in  STD_LOGIC;
           key_data : in  STD_LOGIC_VECTOR (3 downto 0);
           state : out  STD_LOGIC_VECTOR (2 downto 0));
end state_selector;

architecture Behavioral of state_selector is

--000~011 idle, menu, submenu, cancel,
--100~110 order_type, payment, receipt
signal current : STD_LOGIC_VECTOR (2 downto 0);
signal next_state : STD_LOGIC_VECTOR (2 downto 0);

component reg is
	Generic ( size : integer := 3);
   Port ( clk : in  STD_LOGIC;
			 rst : in  STD_LOGIC;
			 load_en : in  STD_LOGIC;
			 load_data : in  STD_LOGIC_VECTOR (2 downto 0);
			 out_data : out  STD_LOGIC_VECTOR (2 downto 0));
end component;
	
begin
	--update current state.
	ss : process (key_data)
	begin
		if current = "000" then
			next_state <= "001";
		elsif current = "001" then
			if key_data = x"4" then
				next_state <= "011";
			elsif key_data = x"6" then
				next_state <= "010";
			end if;
		elsif current = "010" then
			if key_data = x"4" or key_data = x"5" or key_data = x"6" then
				next_state <= "001";
			end if;
		elsif current = "011" then
			if key_data = x"4" then
				next_state <= "100";
			end if;
		elsif current = "100" then
			if key_data = x"5" then
				next_state <= "101";
			end if;
		elsif current = "101" then
			if key_data = x"5" then
				next_state <= "110";
			end if;
		elsif current = "110" then
			next_state <= "000";
		else
			next_state <= current;
		end if;
	end process;
	
	U_STATE_REG : reg port map (clk, rst, key_event, next_state, current);
	
	--output
	state <= current;

end Behavioral;

