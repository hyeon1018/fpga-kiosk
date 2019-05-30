----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:55:24 05/21/2019 
-- Design Name: 
-- Module Name:    TFT_LCD - Behavioral 
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

entity TFT_LCD is
    Port ( clk : in  STD_LOGIC;
           nrst : in  STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (15 downto 0);
           de : out  STD_LOGIC;
			  text_addr : out  STD_LOGIC_VECTOR(7 downto 0);
			  text_data : in  STD_LOGIC_VECTOR(7 downto 0));
end TFT_LCD;

architecture Behavioral of TFT_LCD is
component charROM IS
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
  );
END component;

	constant tHP  : integer := 928;   -- Hsync Period (tHP)
	constant tHW  : integer := 48;   -- Hsync Pulse Width (tHW)
	constant tHBP : integer := 40;   -- Hsync Back Porch (tHBP)
	constant tHV  : integer := 800;   -- Horizontal valid data width (tHV)
	constant tHFP : integer := 40; -- Horizontal Front Port (tHFP) = 40
                                           -- = (tHP-tHW-tHBP-tHV)   
	constant tVP  : integer := 525;   -- Vsync Period (tVP)
	constant tVW  : integer := 3;   -- Vsync Pulse Width (tVW)
	constant tVBP : integer := 29;   -- Vsync Back Portch (tVBP)
	constant tW   : integer := 480;   -- Vertical valid data width (tW)
	constant tVFP : integer := 13;  	-- Vertical Front Porch (tVFP) = 13
                                            	-- = (tVP-tVW-tVBP-tW); 
	constant BACK : STD_LOGIC_VECTOR(15 downto 0) := (others => '1');
	constant CHAR : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	constant CURSOR : STD_LOGIC_VECTOR(15 downto 0) := "1001111111110011";
	constant SELECTED : std_logic_vector(15 downto 0) := "1111100000011111";
															
	signal hsync_cnt  : STD_LOGIC_VECTOR(9 downto 0);
	signal vsync_cnt  : STD_LOGIC_VECTOR(9 downto 0);

	signal de_1: STD_LOGIC;
	signal char_en : STD_LOGIC;
	
	signal hpixel_c : STD_LOGIC_VECTOR(4 downto 0);
	signal vpixel_c : STD_LOGIC_VECTOR(6 downto 0);
	signal hchar_c, hchar_c_t : STD_LOGIC_VECTOR(4 downto 0);
	signal vchar_c, vchar_c_t : STD_LOGIC_VECTOR(2 downto 0);
	
	signal char_addr : STD_LOGIC_VECTOR(13 downto 0);
	signal char_data_t : STD_LOGIC_VECTOR(0 downto 0);
	signal char_data : STD_LOGIC;
	
	signal rgb_out_t : STD_LOGIC_VECTOR(15 downto 0);
	signal nclk : STD_LOGIC;
begin
	nclk <= not clk;
	-- Hsync CNT
	process(clk, nrst)
		begin
			if(nrst = '0')then
				hsync_cnt <= (others => '0');
			elsif(rising_edge(CLK)) then
				if(hsync_cnt= tHP-1)then
					hsync_cnt <= (others => '0');
         	else
					hsync_cnt<= hsync_cnt + 1;
				end if;
			end if;   
	end process;
	
	-- Vsync CNT
	process(clk, nrst)         --  sync 
	begin
		if(nrst = '0')then
			--vsync_cnt<= 0;
			vsync_cnt <= (others => '0');
		elsif(rising_edge(CLK)) then
			if(hsync_cnt=tHP-1)then
				if(vsync_cnt=tVP-1)then
					--vsync_cnt<= 0;
					vsync_cnt <= (others => '0');
				else
					vsync_cnt<=vsync_cnt + 1;
				end if;
			else
				vsync_cnt <= vsync_cnt;
			end if;
		end if;   
	end process;
	
	--Data Enable
	process(clk, nrst,  vsync_cnt, hsync_cnt)
	begin
		if(nrst = '0')then
			de_1<='0';
		elsif rising_edge(CLK) then
			if ((vsync_cnt >= (tVW + tVBP)) and (vsync_cnt < (tVW + tVBP + tW ))) then  -- during tW
				if(hsync_cnt >= (tHW+tHBP)) and hsync_cnt < (tHW+tHBP+tHV) then
					de_1<='1';
				else
					de_1<='0';
				end if;
			else
				de_1<='0';
			end if;
		end if;		
	end process;
	de <= de_1;
	
	char_addr <= text_data(5 downto 0) & vpixel_c(6 downto 2) & hpixel_c(4 downto 2);
	
	U_CHAR : charROM port map(
								clka => clk,
								addra => char_addr,
								douta => char_data_t);
	
	
	
	-- check character
	process(clk, nrst, vsync_cnt, hsync_cnt)
	begin
		if(nrst = '0') then
			char_en <= '0';
		elsif rising_edge(CLK) then
			if ( (vsync_cnt >= (tVW + tVBP)) and (vsync_cnt < (tVW + tVBP + tW )) ) then
				if((hsync_cnt >= (tHW + tHBP + 16)) and (hsync_cnt < (tHW + tHBP + 784))) then
					char_en <= '1';
					char_data <= char_data_t(0);
				else
					char_en <= '0';
					char_data <= '0';
				end if;
			else
				char_en <= '0';
				char_data <= '0';
			end if;
		end if;
	end process;
	
	process(clk, nrst)
	begin
		if(nrst = '0') then
			hpixel_c <= (others => '0');
		elsif rising_edge(clk) then
			if(char_en = '1') then
				if(hpixel_c = "10111") then
					hpixel_c <= (others => '0');
				else
					hpixel_c <= hpixel_c + 1;
				end if;
			else
				hpixel_c <= hpixel_c;
			end if;
		end if;
	end process;
	
	process(clk, nrst)
	begin
		if(nrst = '0') then
			hchar_c_t <= (others => '0');
		elsif rising_edge(clk) then
			if(hpixel_c = "10111") then
				if(hchar_c_t = "11111") then
					hchar_c_t <= (others => '0');
				else
					hchar_c_t <= hchar_c_t + 1;
				end if;
			else
				hchar_c_t <= hchar_c_t;
			end if;
		end if;
	end process;
	hchar_c <= hchar_c_t;
	
	process(clk, nrst)
	begin
		if(nrst = '0') then
			vpixel_c <= (others => '0');
		elsif rising_edge(clk) then
			if(hchar_c_t = "11111" and hpixel_c = "10111") then
				if(vpixel_c = "1001111") then
					vpixel_c <= (others => '0');
				else
					vpixel_c <= vpixel_c + 1;
				end if;
			else
				vpixel_c <= vpixel_c;
			end if;
		end if;
	end process;
	
	process(clk, nrst)
	begin
		if(nrst = '0') then
			vchar_c_t <= (others => '0');
		elsif rising_edge(clk) then
			if(hchar_c_t = "11111" and hpixel_c = "10111" and vpixel_c = "1001111") then
				if(vchar_c_t = "101") then
					vchar_c_t <= (others => '0');
				else
					vchar_c_t <= vchar_c_t + 1;
				end if;
			else
				vchar_c_t <= vchar_c_t;
			end if;
		end if;
	end process;
	vchar_c <= vchar_c_t;

	
	data_out <= CHAR when char_data = '1' and text_data(6) = '0' else
					SELECTED when char_data = '1' and text_data(6) = '1' else
					BACK when char_data = '0' and text_data(7) = '0' else
					CURSOR when char_data = '0' and text_data(7) = '1' else
					(others => '1');
	
	text_addr <= vchar_c & hchar_c;
	
end Behavioral;

