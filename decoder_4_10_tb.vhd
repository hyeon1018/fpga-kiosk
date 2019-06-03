--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:47:01 06/03/2019
-- Design Name:   
-- Module Name:   /home/dohyeon/workspace/fpga_kiosk/decoder_4_10_tb.vhd
-- Project Name:  fpga_kiosk
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: submenu_decoder
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
 
ENTITY decoder_4_10_tb IS
END decoder_4_10_tb;
 
ARCHITECTURE behavior OF decoder_4_10_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT submenu_decoder
    PORT(
         sel : IN  std_logic_vector(3 downto 0);
         dout : OUT  std_logic_vector(9 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal sel : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal dout : std_logic_vector(9 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: submenu_decoder PORT MAP (
          sel => sel,
          dout => dout
        );

   -- Clock process definitions

 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- insert stimulus here 
		
		sel <= x"0" after 20 ns,
				x"1" after 40 ns,
				x"2" after 60 ns,
				x"3" after 80 ns,
				x"4" after 100 ns,
				x"5" after 120 ns,
				x"6" after 140 ns,
				x"7" after 160 ns,
				x"8" after 180 ns,
				x"9" after 200 ns,
				x"A" after 220 ns,
				x"B" after 240 ns,
				x"C" after 260 ns,
				x"D" after 280 ns,
				x"E" after 300 ns,
				x"F" after 320 ns,
				x"0" after 340 ns;

      wait;
   end process;

END;
