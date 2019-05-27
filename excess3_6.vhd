----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:12:27 05/27/2019 
-- Design Name: 
-- Module Name:    excess3_6 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Adder and Substractor.
-- This result is 0 when substract value is negative.
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

entity excess3_6 is
    Port ( a : in  STD_LOGIC_VECTOR (23 downto 0);
           b : in  STD_LOGIC_VECTOR (23 downto 0);
           op : in  STD_LOGIC;
           sum : out  STD_LOGIC_VECTOR (23 downto 0);
           cout : out  STD_LOGIC);
end excess3_6;

architecture Behavioral of excess3_6 is

component excess3_alu is
    Port ( a : in  STD_LOGIC_VECTOR (3 downto 0);
           b : in  STD_LOGIC_VECTOR (3 downto 0);
           cin : in  STD_LOGIC;
			  op : in STD_LOGIC;
           sum : out  STD_LOGIC_VECTOR (3 downto 0);
           cout : out  STD_LOGIC;
			  sign : out  STD_LOGIC);
end component;

signal t_sum : STD_LOGIC_VECTOR (23 downto 0);
signal t_sign : STD_LOGIC_VECTOR(5 downto 0);
signal t_carry : STD_LOGIC_VECTOR(6 downto 0);

begin

	alus : for K in 0 to 5 generate
	begin
		U_ALU : excess3_alu port map(a(4*K+3 downto 4*K), b(4*K+3 downto 4*K), t_carry(K), op, t_sum(4*K+3 downto 4*K), t_carry(K+1), t_sign(K));
	end generate;
	sum <= 	t_sum when t_sign(5) = '0' else
				x"333333";
	t_carry(0) <= op and not t_sign(5);
	
end Behavioral;

