--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:59:55 05/24/2019
-- Design Name:   
-- Module Name:   /home/dohyeon/workspace/fpga_kiosk/memory_qu_tb.vhd
-- Project Name:  fpga_kiosk
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: memory_qu
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
 
ENTITY memory_qu_tb IS
END memory_qu_tb;
 
ARCHITECTURE behavior OF memory_qu_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT memory_qu
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         load_en : IN  std_logic;
         load_data : IN  std_logic_vector(15 downto 0);
         delete_addr : IN  std_logic_vector(3 downto 0);
         delete_en : IN  std_logic;
         addr : IN  std_logic_vector(3 downto 0);
         out_data : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal load_en : std_logic := '0';
   signal load_data : std_logic_vector(15 downto 0) := (others => '0');
   signal delete_addr : std_logic_vector(3 downto 0) := (others => '0');
   signal delete_en : std_logic := '0';
   signal addr : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal out_data : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: memory_qu PORT MAP (
          clk => clk,
          rst => rst,
          load_en => load_en,
          load_data => load_data,
          delete_addr => delete_addr,
          delete_en => delete_en,
          addr => addr,
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
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		
		rst <= '1' after 20 ns,
				 '0' after 30 ns;

      wait for clk_period*10;

      -- insert stimulus here 
			 
		load_data <= x"1239";
		load_en <= '1';
		wait for 10 ns;
		load_en <= '0';
		wait for 100 ns;
		
		load_data <= x"A2B9";
		load_en <= '1';
		wait for 10 ns;
		load_en <= '0';
		
		wait for 200 ns;
		delete_addr <= "0000";
		delete_en <= '1';
		wait for 10 ns;
		delete_en <= '0';
		
      wait;
   end process;

END;
