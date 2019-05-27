----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:03:42 03/29/2019 
-- Design Name: 
-- Module Name:    excess_3_alu - Behavioral 
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
use IEEE.MATH_REAL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity excess3_alu is
    Port ( a : in  STD_LOGIC_VECTOR (3 downto 0);
           b : in  STD_LOGIC_VECTOR (3 downto 0);
           cin : in  STD_LOGIC;
			  op : in STD_LOGIC;
           sum : out  STD_LOGIC_VECTOR (3 downto 0);
           cout : out  STD_LOGIC;
			  sign : out  STD_LOGIC);
end excess3_alu;
architecture Behavioral of excess3_alu is
component adder_4 is
    Port ( a : in  STD_LOGIC_VECTOR (3 downto 0);
           b : in  STD_LOGIC_VECTOR (3 downto 0);
           cin : in  STD_LOGIC;
           sum : out  STD_LOGIC_VECTOR (3 downto 0);
           cout : out  STD_LOGIC);
end component;
signal comp : STD_LOGIC_VECTOR (3 downto 0);
signal t_b : STD_LOGIC_VECTOR(3 downto 0); -- substractor signal.
signal t_carry : STD_LOGIC; -- carry temp signal
signal t_carry_not : STD_LOGIC;
signal t_sum : STD_LOGIC_VECTOR(3 downto 0); -- temp sum signal
signal adjust : STD_LOGIC_VECTOR(3 downto 0); -- 3-excess code adjust for +-3
begin
	--substract.
	comp <= op & op & op & op;
	t_b <= b xor comp;
	U1 : adder_4 port map(a, t_b, cin, t_sum, t_carry);
	t_carry_not <= not t_carry;
	
	-- +3 when carry, -3 when not carry;
	adjust <= t_carry_not & t_carry_not & t_carry &'1';
	U2 : adder_4 port map(t_sum, adjust, '0', sum, open);

	sign <= t_carry_not and op;
	cout <= t_carry;
	

end Behavioral;

