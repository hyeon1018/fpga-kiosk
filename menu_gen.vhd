----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:18:27 06/05/2019 
-- Design Name: 
-- Module Name:    menu_gen - Behavioral 
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

entity menu_gen is
    Port ( clk : in  STD_LOGIC;
           menu_bit : in  STD_LOGIC_VECTOR (15 downto 0);
           addr : in  STD_LOGIC_VECTOR (4 downto 0);
           dout : out  STD_LOGIC_VECTOR (7 downto 0));
end menu_gen;

architecture Behavioral of menu_gen is

component menu_price_alu is
    Port ( menu_bit : in  STD_LOGIC_VECTOR (15 downto 0);
           price : out  STD_LOGIC_VECTOR (23 downto 0));
end component;

component menuROM IS
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END component;

signal price_t : STD_LOGIC_VECTOR(23 downto 0);
signal price_digit_6, price_digit_5, price_digit_4, price_digit_3, price_digit_2, price_digit_1 : STD_LOGIC_VECTOR(7 downto 0);
signal rom_addr : STD_LOGIC_VECTOR(8 downto 0);
signal menu_data_t : STD_LOGIC_VECTOR(7 downto 0);
begin
	U_PRICE_ALU : menu_price_alu port map ( menu_bit, price_t );
	
	price_digit_6 <= x"00" when price_t(23 downto 20) = x"3" else
							"0000" & price_t(23 downto 20);
	price_digit_5 <= x"00" when price_t(23 downto 16) = x"33" else
							"0000" & price_t(19 downto 16);
	price_digit_4 <= x"00" when price_t(23 downto 12) = x"333" else
							"0000" & price_t(15 downto 12);
	price_digit_3 <= x"00" when price_t(23 downto 8) = x"3333" else
							"0000" & price_t(11 downto 8);
	price_digit_2 <= x"00" when price_t(23 downto 4) = x"33333" else
							"0000" & price_t(7 downto 4);
	price_digit_1 <= "0000" & price_t(3 downto 0);

	
	rom_addr <= menu_bit(13 downto 10) & addr;
	
	U_MENUROM : menuROM port map(
		clka => clk,
		addra => rom_addr,
		douta => menu_data_t
	);
	
	dout <= 
		"00000000" when menu_bit(15) = '0' else
		price_digit_1 when addr = "11110" else
		price_digit_2 when addr = "11101" else
		price_digit_3 when addr = "11100" else
		price_digit_4 when addr = "11011" else
		price_digit_5 when addr = "11010" else
		price_digit_6 when addr = "11001" else
		menu_data_t;
		
end Behavioral;

