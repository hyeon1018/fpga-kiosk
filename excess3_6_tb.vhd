--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:32:21 05/27/2019
-- Design Name:   
-- Module Name:   /home/dohyeon/workspace/fpga_kiosk/excess3_6_tb.vhd
-- Project Name:  fpga_kiosk
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: excess3_6
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY excess3_6_tb IS
END excess3_6_tb;
 
ARCHITECTURE behavior OF excess3_6_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT excess3_6
    PORT(
         a : IN  std_logic_vector(23 downto 0);
         b : IN  std_logic_vector(23 downto 0);
         op : IN  std_logic;
         sum : OUT  std_logic_vector(23 downto 0);
         cout : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal a : std_logic_vector(23 downto 0) := (others => '0');
   signal b : std_logic_vector(23 downto 0) := (others => '0');
   signal op : std_logic := '0';

 	--Outputs
   signal sum : std_logic_vector(23 downto 0);
   signal cout : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: excess3_6 PORT MAP (
          a => a,
          b => b,
          op => op,
          sum => sum,
          cout => cout
        );

 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- insert stimulus here 
		a <= x"55A641";
		b <= x"385634";
		op <= '1';
		
		wait for 100 ns;

      wait;
   end process;

END;
