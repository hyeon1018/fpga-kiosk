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
           update : in  STD_LOGIC;
           key_data : in  STD_LOGIC_VECTOR (3 downto 0);
           key_event : in  STD_LOGIC;
           enable_state : out  STD_LOGIC_VECTOR (7 downto 0);
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
	next_state <= "000" when current = "110" and key_data = "0100" else
					  current;
	
	U_STATE : reg port map (clk, rst, update, next_state, current);
	
	--output
	state <= current;
	
	with current select enable_state <=
		"00000001" when "000",
		"00000010" when "001",
		"00000100" when "010",
		"00001000" when "011",
		"00010000" when "100",
		"00100000" when "101",
		"01000000" when "110",
		"00000000" when others;

end Behavioral;
