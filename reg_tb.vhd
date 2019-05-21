--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:44:02 05/21/2019
-- Design Name:   
-- Module Name:   /home/dohyeon/workspace/fpga_kiosk/reg_tb.vhd
-- Project Name:  fpga_kiosk
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: reg
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
 
ENTITY reg_tb IS
END reg_tb;
 
ARCHITECTURE behavior OF reg_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT reg
	 generic ( size : integer := 8);
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         load_en : IN  std_logic;
         load_data : IN  std_logic_vector(7 downto 0);
         out_data : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal load_en : std_logic := '0';
   signal load_data : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal out_data : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: reg PORT MAP (
          clk => clk,
          rst => rst,
          load_en => load_en,
          load_data => load_data,
          out_data => out_data
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
	en_process : process
	begin
		wait for 100 ns;
		
		load_en <= '1' after 50 ns,
				     '0' after 70 ns,
					  '1' after 500 ns,
					  '0' after 520 ns;
	
	
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
				 
		load_data <= x"4A" after 20 ns,
						 x"55" after 320 ns;

      wait;
   end process;

END;
