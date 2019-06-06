----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:04:50 05/24/2019 
-- Design Name: 
-- Module Name:    memory_qu - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: memory module don't has empty space between data.
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

entity memory_qu is
    Port ( clk : in  STD_LOGIC;
			  rst : in  STD_LOGIC;
			  len : out STD_LOGIC_VECTOR(3 downto 0);
           load_en : in  STD_LOGIC;
           load_data : in  STD_LOGIC_VECTOR (15 downto 0);
           delete_addr : in  STD_LOGIC_VECTOR (3 downto 0);
           delete_en : in  STD_LOGIC; 
			  addr : in STD_LOGIC_VECTOR (3 downto 0);
           out_data : out  STD_LOGIC_VECTOR (15 downto 0));
end memory_qu;

architecture Behavioral of memory_qu is

component reg is
	Generic ( size : integer);
   Port ( clk : in  STD_LOGIC;
			 rst : in  STD_LOGIC;
			 load_en : in  STD_LOGIC;
			 load_data : in  STD_LOGIC_VECTOR (size-1 downto 0);
			 out_data : out  STD_LOGIC_VECTOR (size-1 downto 0));
end component;

signal get_prev : STD_LOGIC_VECTOR (16 downto 0);

type data_array is array (16 downto 0) of STD_LOGIC_VECTOR (15 downto 0);
signal reg_out : data_array;
signal reg_in : data_array;

begin
	get_prev(0) <= '0';
	regs : for K in 0 to 15 generate
		get_prev(K+1) <= '1' when get_prev(K) = '1' or reg_out(K) = x"0000" else
							  '0';
		reg_in(K) <= reg_out(K+1) when get_prev(K+1) = '1' else
						 x"0000" when delete_en = '1' and delete_addr = K else
						 reg_out(K);
		U_REG : reg generic map (16) 
					 port map(clk, rst, '1', reg_in(K), reg_out(K));
	end generate;
	reg_out(16) <= load_data when load_en = '1' else
						x"0000";
	
	len <=
		x"0" when reg_out(0) = x"0000" else
		x"0" when reg_out(1) = x"0000" else
		x"1" when reg_out(2) = x"0000" else
		x"2" when reg_out(3) = x"0000" else
		x"3" when reg_out(4) = x"0000" else
		x"4" when reg_out(5) = x"0000" else
		x"5" when reg_out(6) = x"0000" else
		x"6" when reg_out(7) = x"0000" else
		x"7" when reg_out(8) = x"0000" else
		x"8" when reg_out(9) = x"0000" else
		x"9" when reg_out(10) = x"0000" else
		x"A" when reg_out(11) = x"0000" else
		x"B" when reg_out(12) = x"0000" else
		x"C" when reg_out(13) = x"0000" else
		x"D" when reg_out(14) = x"0000" else
		x"E" when reg_out(15) = x"0000" else
		x"F";
	
	
	--set output.
	with addr select out_data <=
		reg_out(0) when "0000",
		reg_out(1) when "0001",
		reg_out(2) when "0010",
		reg_out(3) when "0011",
		reg_out(4) when "0100",
		reg_out(5) when "0101",
		reg_out(6) when "0110",
		reg_out(7) when "0111",
		reg_out(8) when "1000",
		reg_out(9) when "1001",
		reg_out(10) when "1010",
		reg_out(11) when "1011",
		reg_out(12) when "1100",
		reg_out(13) when "1101",
		reg_out(14) when "1110",
		reg_out(15) when "1111",
		x"0000" when others;
		
end Behavioral;

