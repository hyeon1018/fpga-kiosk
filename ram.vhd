----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:47:33 05/21/2019 
-- Design Name: 
-- Module Name:    ram_16x16 - Behavioral 
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

entity ram_16x16 is
    Port ( clk : in  STD_LOGIC;
			  rst : in  STD_LOGIC;
           addr : in  STD_LOGIC_VECTOR (3 downto 0);
           load_en : in  STD_LOGIC;
           load_data : in  STD_LOGIC_VECTOR (15 downto 0);
           out_data : out  STD_LOGIC_VECTOR (15 downto 0));
end ram_16x16;

architecture Behavioral of ram_16x16 is

component reg is
	Generic ( size : integer);
   Port ( clk : in  STD_LOGIC;
			 rst : in  STD_LOGIC;
			 load_en : in  STD_LOGIC;
			 load_data : in  STD_LOGIC_VECTOR (size-1 downto 0);
			 out_data : out  STD_LOGIC_VECTOR (size-1 downto 0));
end component;

signal addr_en : STD_LOGIC_VECTOR (15 downto 0);

type data_array is array (15 downto 0) of std_logic_vector (15 downto 0);
signal reg_out : data_array;


begin
	regs : for K in 0 to 15 generate
		addr_en(K) <= load_en when addr = K else
						  '0';
		U_REG : reg generic map (16) 
					 port map(clk, rst, addr_en(K), load_data, reg_out(K));
	end generate;
	
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
		reg_out(15) when "1111";

end Behavioral;

