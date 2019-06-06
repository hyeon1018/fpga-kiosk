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

--init select_menu, select_submenu, delete menu
--pay reciept.
signal current_state, next_state : STD_LOGIC_VECTOR (2 downto 0);

signal sel_rst, sel_rst_1, sel_rst_2 : STD_LOGIC;
signal current_select, next_select, max_select : STD_LOGIC_VECTOR (3 downto 0);
	
begin
	--update current state.
	SYNC_STATE : process(clk, rst)
	begin
		if rst = '1' then
			current_state <= "000";
		elsif rising_edge(clk) then
			current_state <= next_state;
		end if;
	end process;
	
	-- 2 clock delayed reset signal.
	sel_rst <= '0' when current_state = next_state else
					'1';
	DELAY_SEL_RST : process(clk)
	begin
		if rising_edge(clk) then
			sel_rst_2 <= sel_rst_1;
			sel_rst_1 <= sel_rst;
		end if;
	end process;
	
	SYNC_SELECT : process(clk, rst, sel_rst_2)
	begin
		if rst = '1' or sel_rst_2 = '1' then
			current_select <= "0000";
		elsif rising_edge(clk) then
			current_select <= next_select;
		end if;
	end process;
	
	NEXT_STATE_DEC : process(key_data, current_state)
	begin
		next_state <= current_state;
		if key_event = '1' then
			case current_state is
				when "000" =>
					next_state <= "001";
				when "001" =>
					if key_data = x"5" or key_data = x"6" then
						next_state <= "010";
					elsif key_data = x"4" then
						next_state <= "000";
					end if;
				when "010" =>
					if key_data = x"6" then
						next_state <= "011";
					elsif key_data = x"4" then
						next_state <= "001";
					end if;
				when "011" =>
					next_state <= current_state;
				when "100" =>
					if key_data = x"6" then
						next_state <= "101";
					elsif key_data = x"4" then
						next_state <= "001";
					end if;
				when "101" =>
					if key_data = x"4" then
						next_state <= "100";
					elsif key_data = x"5" or key_data = x"6" then
						next_state <= "110";
					end if;
				when "110" =>
					next_state <= "000";
				when others =>
					next_state <= "000";
			end case;
		else
			if current_state = "011" then
				next_state <= "100";
			end if;
		end if;
	end process;
		
	NEXT_SELECT_DECODER : process(key_data, current_select)
	begin
		next_select <= current_select;
		if key_event = '1' then
			if key_data = x"2" then
				if current_select = x"0" then
					next_select <= current_select;
				else
					next_select <= current_select - 1;
				end if;
			elsif key_data = x"8" then
				if current_select >= x"9" then
					next_select <= max_select;
				else
					next_select <= current_select + 1;
				end if;
			end if;
		end if;
	end process;
	--output
	state <= current_state;
	selected <= current_select;

end Behavioral;

