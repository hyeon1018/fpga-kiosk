--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:39:15 05/15/2019
-- Design Name:   
-- Module Name:   /home/dohyeon/workspace/fpga_kiosk/seven_segment_tb.vhd
-- Project Name:  fpga_kiosk
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: seven_segment
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
 
ENTITY seven_segment_tb IS
END seven_segment_tb;
 
ARCHITECTURE behavior OF seven_segment_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT seven_segment
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         bcd_input : IN  std_logic_vector(23 downto 0);
         segment_data : OUT  std_logic_vector(7 downto 0);
         segment_select : OUT  std_logic_vector(5 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal bcd_input : std_logic_vector(23 downto 0) := (others => '0');

 	--Outputs
   signal segment_data : std_logic_vector(7 downto 0);
   signal segment_select : std_logic_vector(5 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: seven_segment PORT MAP (
          clk => clk,
          rst => rst,
          bcd_input => bcd_input,
          segment_data => segment_data,
          segment_select => segment_select
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here
		rst <= '1' after 10 ns,
				 '0' after 20 ns;
		
		bcd_input <= "000000000000000000000000" after 200 ns,
						 "000000000000111111111111" after 400 ns,
						 "000011110000111100001111" after 600 ns;
      wait;
   end process;

END;
