----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:05:08 05/31/2019 
-- Design Name: 
-- Module Name:    screen_manage - Behavioral 
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

entity screen_manage is
    Port (
		clk : in  STD_LOGIC;
		--machine state.
		state : in STD_LOGIC_VECTOR(2 downto 0);
		sel : in STD_LOGIC_VECTOR(3 downto 0);
		max_sel : in STD_LOGIC_VECTOR(3 downto 0);
		--read_memory
		order : in STD_LOGIC_VECTOR(15 downto 0);
		mem_addr : out STD_LOGIC_VECTOR(3 downto 0);
		mem_data : in STD_LOGIC_VECTOR(15 downto 0);
		--lcd in/out data.
		text_addr : in  STD_LOGIC_VECTOR(7 downto 0);
		text_data : out  STD_LOGIC_VECTOR(7 downto 0));
end screen_manage;

architecture Behavioral of screen_manage is

component textROM is
    Port ( clk : in  STD_LOGIC;
           state : in  STD_LOGIC_VECTOR(2 downto 0);
           text_addr : in  STD_LOGIC_VECTOR(7 downto 0);
			  text_data : out STD_LOGIC_VECTOR(5 downto 0));
end component;

component submenuROM IS
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END component;

component menu_gen is
    Port ( clk : in  STD_LOGIC;
           menu_bit : in  STD_LOGIC_VECTOR (15 downto 0);
           addr : in  STD_LOGIC_VECTOR (4 downto 0);
           dout : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

signal rom_text_data_t : STD_LOGIC_VECTOR(5 downto 0);
signal menu_data_t, submenu_data_t : STD_LOGIC_VECTOR(7 downto 0);
signal text_addr_7_5 : STD_LOGIC_VECTOR(3 downto 0);
signal rom_addr_8_5 : STD_LOGIC_VECTOR(3 downto 0);
signal rom_addr : STD_LOGIC_VECTOR(8 downto 0);

signal cursor : STD_LOGIC;
signal selected, selected_t : STD_LOGIC;
signal menu_bit : STD_LOGIC_VECTOR(15 downto 0);

begin
	text_addr_7_5 <= "0" & text_addr(7 downto 5);

	select_data : process(clk)
	begin
		--select data source
		--1. rom_data process
		--2. menu_rom
		--3. topping_rom
	end process;
	
	selected_t <=
		order(9) when rom_addr_8_5 = x"0" else
		order(8) when rom_addr_8_5 = x"1" else
		order(7) when rom_addr_8_5 = x"2" else
		order(6) when rom_addr_8_5 = x"3" else
		order(5) when rom_addr_8_5 = x"4" else
		order(4) when rom_addr_8_5 = x"5" else
		order(3) when rom_addr_8_5 = x"6" else
		order(2) when rom_addr_8_5 = x"7" else
		order(1) when rom_addr_8_5 = x"8" else
		order(0) when rom_addr_8_5 = x"9" else
		'0';
		
	
	selected_row : process(state, sel, text_addr)
	begin
		if state = "010" and not (text_addr_7_5 = "000") then
			selected <= selected_t;
		else
			selected <= '0';
		end if;
	end process;
		
	cur : process(state, sel, text_addr_7_5)
	begin
		if state = "001" or state = "010" or state = "100" then
			if text_addr_7_5 = 1 then
				if sel = 0 then
					cursor <= '1';
				else
					cursor <= '0';
				end if;
			elsif text_addr_7_5 = 2 then
				if sel = 1 then
					cursor <= '1';
				else
					cursor <= '0';
				end if;
			elsif text_addr_7_5 = 3 then
				if sel >= 2 and sel <= max_sel - 2 then
					cursor <= '1';
				else
					cursor <= '0';
				end if;
			elsif text_addr_7_5 = 4 then
				if sel = max_sel-1 then
					cursor <= '1';
				else
					cursor <= '0';
				end if;
			elsif text_addr_7_5 = 5 then
				if sel = max_sel then
					cursor <= '1';
				else
					cursor <= '0';
				end if;
			else
				cursor <= '0';
			end if;
		end if;
	end process;
	
	offset : process(sel, text_addr_7_5)
	begin
		if sel < 3 then
			rom_addr_8_5 <= text_addr_7_5 -1;
		elsif sel > max_sel - 2 then
			rom_addr_8_5 <= max_sel + text_addr_7_5 - 6;
		else
			rom_addr_8_5 <= sel + text_addr_7_5 - 3;
		end if;
	end process;

	
	--rom.
	U_TEXTROM : textROM port map(
		clk => clk,
		state => state,
		text_addr => text_addr,
		text_data => rom_text_data_t
	);
	
	mem_addr <= rom_addr_8_5;
	
	menu_bit <=
		"10" & rom_addr_8_5 & "0000000000" when state = "001" else
		mem_data when state = "100";
	
	
	U_MENU_TEXT : menu_gen port map(
		clk => clk,
		menu_bit => menu_bit,
		addr => text_addr(4 downto 0),
		dout => menu_data_t
	);
	
	rom_addr <= rom_addr_8_5 & text_addr(4 downto 0);
	
	U_SUBMENUROM : submenuROM port map (
		clka => clk,
		addra => rom_addr,
		douta => submenu_data_t
	);
	
	--need to delay one clock for sync with character.
	text_data(7) <= selected;
	text_data(6) <= cursor;
	text_data(5 downto 0) <=
		rom_text_data_t when state = "000" or text_addr(7 downto 5) = "000" else
		menu_data_t(5 downto 0) when state = "001" or state = "100" else
		submenu_data_t(5 downto 0) when state = "010" else
		"000000";

end Behavioral;

