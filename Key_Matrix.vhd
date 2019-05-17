----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:42:45 05/07/2019 
-- Design Name: 
-- Module Name:    Key_Matrix - Behavioral 
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

entity Key_Matrix is
	Port ( clk : in  STD_LOGIC;
          reset : in  STD_LOGIC;
		-- from key pad
          key_in : in  STD_LOGIC_VECTOR (3 downto 0);
		-- to key pad
          key_scan : out  STD_LOGIC_VECTOR (3 downto 0);
		 -- to display module
			 key_data : out  STD_LOGIC_VECTOR (3 downto 0);
			 key_event : out STD_LOGIC);
end Key_Matrix;

architecture Behavioral of Key_Matrix is
	component clock_divider is
		Generic ( div_count : integer );
		Port ( clk_in : in  STD_LOGIC;
				 rst : in STD_LOGIC;
				 clk_out : out  STD_LOGIC);
	end component;
	signal key_clk : STD_LOGIC;
	signal scan_cnt : std_logic_vector (3 downto 0) := "1110";
	signal key_data_in, key_data_reg : std_logic_vector (3 downto 0);
	signal key_push_in, key_push_reg : std_logic_vector (3 downto 0);
	signal k_push : std_logic;
begin
	U_KM_CLK_DIV : clock_divider generic map(10000)
						 port map(clk, '0', key_clk);
	-- generate key_scan
	process(reset, key_clk)
	begin
		if reset = '1' then
			scan_cnt <= "1110";
		elsif rising_edge(key_clk) then
			scan_cnt <= scan_cnt(2 downto 0) & scan_cnt(3);
		end if;
	end process;	
	key_scan <= scan_cnt;
	
	-- register for key_data and key_push.
	kreg: process(reset, key_clk)	
	begin
		if reset = '1' then
			key_data_reg <= (others => '1');
			key_push_reg <= (others => '1');
		elsif rising_edge(key_clk) then
			key_data_reg <= key_data_in;
			key_push_reg <= key_push_in;
		end if;
	end process;
	key_data <= key_data_reg;
	
	-- check keypad push
	k_push <= key_in(0) and key_in(1) and key_in(2) and key_in(3);

	key_push_in(0) <= k_push when scan_cnt = "1110" else
							key_push_reg(0);
	key_push_in(1) <= k_push when scan_cnt = "1101" else
							key_push_reg(1);
	key_push_in(2) <= k_push when scan_cnt = "1011" else
							key_push_reg(2);
	key_push_in(3) <= k_push when scan_cnt = "0111" else
							key_push_reg(3);
	--not for 0->1 when pushed.	
	key_event <= key_push_reg(0) and key_push_reg(1) and key_push_reg(2) and key_push_reg(3);
	
	-- key_data_in
	key_data_in <= X"1" when scan_cnt = "1110" and key_in = "1110" else
						X"2" when scan_cnt = "1101" and key_in = "1110" else
						X"3" when scan_cnt = "1011" and key_in = "1110" else
						X"F" when scan_cnt = "0111" and key_in = "1110" else
						X"4" when scan_cnt = "1110" and key_in = "1101" else
						X"5" when scan_cnt = "1101" and key_in = "1101" else
						X"6" when scan_cnt = "1011" and key_in = "1101" else
						X"E" when scan_cnt = "0111" and key_in = "1101" else
						X"7" when scan_cnt = "1110" and key_in = "1011" else
						X"8" when scan_cnt = "1101" and key_in = "1011" else
						X"9" when scan_cnt = "1011" and key_in = "1011" else
						X"D" when scan_cnt = "0111" and key_in = "1011" else
						X"0" when scan_cnt = "1110" and key_in = "0111" else
						X"A" when scan_cnt = "1101" and key_in = "0111" else
						X"B" when scan_cnt = "1011" and key_in = "0111" else
						X"C" when scan_cnt = "0111" and key_in = "1110" else
						key_data_reg;
	
end Behavioral;

