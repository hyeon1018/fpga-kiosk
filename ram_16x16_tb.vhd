--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:37:32 05/21/2019
-- Design Name:   
-- Module Name:   /home/dohyeon/workspace/fpga_kiosk/ram_16x16_tb.vhd
-- Project Name:  fpga_kiosk
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ram_16x16
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
 
ENTITY ram_16x16_tb IS
END ram_16x16_tb;
 
ARCHITECTURE behavior OF ram_16x16_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ram_16x16
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         addr : IN  std_logic_vector(3 downto 0);
         load_en : IN  std_logic;
         load_data : IN  std_logic_vector(15 downto 0);
         out_data : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal addr : std_logic_vector(3 downto 0) := (others => '0');
   signal load_en : std_logic := '0';
   signal load_data : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal out_data : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ram_16x16 PORT MAP (
          clk => clk,
          rst => rst,
          addr => addr,
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
	
	en_process :process
	begin
		load_en <= '0';
		wait for 100 ns;
		load_en <= '1';
		wait for 200 ns;
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
		
		load_data <= x"1018";
		addr <= "0001";
		
		wait for 482 ns;
		
		load_data <= x"2841";
		addr <= "0100";
		
		wait for 182 ns;
		
		load_data <= x"81A1";
		addr <= "1101";
		
		wait for 29 ns;
		
		addr <= "0001";
		
		wait for 284 ns;
		
		
		
      wait;
   end process;

END;
