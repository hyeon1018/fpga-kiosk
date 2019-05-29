library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


package pizza_package is

--type declaration
type char is array (0 to 27, 0 to 23) of std_logic;
type subline is array (0 to 27, integer range<>) of std_logic;
type line is array (0 to 79, 0 to 799) of std_logic;
type screen is array (0 to 479, 0 to 799) of std_logic;

--tft lcd constant
constant HP  : integer := 928;   -- Hsync Period (tHP)
constant HW  : integer := 48;   -- Hsync Pulse Width (tHW)
constant HBP : integer := 40;   -- Hsync Back Porch (tHBP)
constant HV  : integer := 800;   -- Horizontal valid data width (tHV)
constant HFP : integer := 40; -- Horizontal Front Port (tHFP) = 40 = (tHP-tHW-tHBP-tHV)   
constant VP  : integer := 525;   -- Vsync Period (tVP)
constant VW  : integer := 3;   -- Vsync Pulse Width (tVW)
constant VBP : integer := 29;   -- Vsync Back Portch (tVBP)
constant W   : integer := 480;   -- Vertical valid data width (tW)
constant VFP : integer := 13;  	-- Vertical Front Porch (tVFP) = 13 = (tVP-tVW-tVBP-tW); 

--color constant
constant BACK : std_logic_vector(15 downto 0) := (others => '1');
constant CHAR : std_logic_vector(15 downto 0) := (others => '0');
constant CURSOR : std_logic_vector(15 downto 0) := "1001111111110011";
constant SELECTED : std_logic_vector(15 downto 0) := "1111100000011111";

-- dsp0 : init
-- dsp1 : menu select
-- dsp2 : list view
-- dsp3 : takeout
-- dsp4 : payment
-- dsp5 : receipt


-- lcd
-- resolution : 800 * 480
-- real size : 15cm * 9cm
-- real size per pixel : 0.01875cm * 0.01875cm



end package;
