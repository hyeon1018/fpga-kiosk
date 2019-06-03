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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

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
           state : out  STD_LOGIC_VECTOR (2 downto 0);
			  selected : out STD_LOGIC_VECTOR (3 downto 0));
end state_selector;

architecture Behavioral of state_selector is

--000~011 idle, menu, submenu, order_type,
--100~101 payment, receipt
signal current_state, next_state : STD_LOGIC_VECTOR (2 downto 0);

signal current_select, next_select : STD_LOGIC_VECTOR (3 downto 0);


component reg is
	Generic ( size : integer );
   Port ( clk : in  STD_LOGIC;
			 rst : in  STD_LOGIC;
			 load_en : in  STD_LOGIC;
			 load_data : in  STD_LOGIC_VECTOR (size-1 downto 0);
			 out_data : out  STD_LOGIC_VECTOR (size-1 downto 0));
end component;
	
begin
	--update current state.
	ss : process (key_data)
	begin
		if current_state= "000" then
			--idle -> press any key.
			next_state <= "001";
		elsif current_state= "001" then
			--menu -> right or ok to select menu.
			if key_data = x"4" then
				next_state <= "000";
			elsif key_data = x"6" or key_data = x"5" then
				next_state <= "010";
			else
				next_state <= current_state;
			end if;
		elsif current_state= "010" then
			--submenu -> right to select order type.
			if key_data = x"4" then
				next_state <= "001";
			elsif key_data = x"6" then
				next_state <= "011";
			else
				next_state <= current_state;
			end if;
		elsif current_state= "011" then
			--order_type -> right or ok to payment.
			if key_data = x"4" then
				next_state <= "010";
			elsif key_data = x"5" or key_data = x"6" then
				next_state <= "100";
			else
				next_state <= current_state;
			end if;
		elsif current_state= "100" then
			--payment -> right or ok to receipt.
			if key_data = x"4" then
				next_state <= "011";
			elsif key_data = x"5" or key_data = x"6" then
				next_state <= "101";
			else
				next_state <= current_state;
			end if;
		elsif current_state= "101" then
			--receipt -> press any key to init.
			next_state <= "000";
		end if;
	end process;
	
	process(key_data)
	begin
		if key_data = x"2" then
			next_select <= current_select - 1;
		elsif key_data = x"8" then
			next_select <= current_select + 1;
		else
			next_select <= current_select;
		end if;
	end process;
	
	U_STATE_REG : reg generic map (3) port map (clk, rst, key_event, next_state, current_state);
	U_SELECT_REG : reg generic map (4) port map (clk, rst, key_event, next_select, current_select);
	--output
	state <= current_state;
	selected <= current_select;

end Behavioral;

