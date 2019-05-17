----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:14:43 05/15/2019 
-- Design Name: 
-- Module Name:    seven_segment - Behavioral 
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

entity seven_segment is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           bcd_input : in  STD_LOGIC_VECTOR (23 downto 0);
           segment_data : out  STD_LOGIC_VECTOR (7 downto 0);
           segment_select : out  STD_LOGIC_VECTOR (5 downto 0));
end seven_segment;

architecture Behavioral of seven_segment is
	component clock_divider is
		Generic ( div_count : integer );
		Port ( clk_in : in  STD_LOGIC;
				 rst : in STD_LOGIC;
				 clk_out : out  STD_LOGIC);
	end component;
	
	component bcd_to_7seg is
    Port ( bcd_in : in  STD_LOGIC_VECTOR (3 downto 0);
           seg_out : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
	
	signal seg_clk : STD_LOGIC;
	signal bcd : STD_LOGIC_VECTOR(3 downto 0);
	signal en : STD_LOGIC_VECTOR(6 downto 0);
	signal select_t : STD_LOGIC_VECTOR(5 downto 0) := "000001";
begin
	--check empty space;
	en(6) <= '0';
	ENABLE : for K in 1 to 5 generate
		en(K) <= '0' when en(K+1)='0' and bcd_input(4*k+3 downto 4*K) = "0000" else
					'1';
	end generate;
	en(0) <= '1';

	--select generate
	U_SEG_CLK_DIV : clock_divider generic map(10000)
						 port map(clk, '0', seg_clk);
						 
	select_generate : process(rst, seg_clk)
	begin
		if rst = '1' then
			select_t <= "000001";
		elsif rising_edge(seg_clk) then
			select_t <= select_t(4 downto 0) & select_t(5);
		end if;
	end process;
	segment_select <= select_t and en(5 downto 0);
	
	--segment select mux
	bcd <= bcd_input(23 downto 20) when select_t = "100000" else
			 bcd_input(19 downto 16) when select_t = "010000" else
			 bcd_input(15 downto 12) when select_t = "001000" else
			 bcd_input(11 downto 8) when select_t = "000100" else
			 bcd_input(7 downto 4) when select_t = "000010" else
			 bcd_input(3 downto 0) when select_t = "000001" else
			 "0000";
	
	U_BCD_SEG : bcd_to_7seg port map(bcd, segment_data);
	
end Behavioral;

