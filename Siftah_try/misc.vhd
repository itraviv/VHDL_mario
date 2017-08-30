library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity misc is
port 	(
		--////////////////////	Clock Input	 	////////////////////	 
		CLOCK_27	: in std_logic; --						//	27 MHz
--		CLOCK_50	: in std_logic; --			//	50 MHz
--		VGA_CLK 	: out std_logic; --	,   						//	VGA Clock
		CLK : out std_logic
--		DLY_RST : out std_logic

	);
end misc;

architecture behav of misc is 
component	Reset_Delay port
(
	iCLK : in std_logic;
	oRESET : out std_logic);
end component;

component VGA_Audio_PLL port 
(
	areset : in std_logic;
	inclk0 : in std_logic;
	c0 : out std_logic;
	c1 : out std_logic;
	c2 : out std_logic);
end component;
signal VGA_CLK_t : std_logic;
signal not_DLY_RST : std_logic;
signal DLY_RST_tmp : std_logic;
begin

not_DLY_RST <= not DLY_RST_tmp;
--DLY_RST	<= DLY_RST_tmp;

r0 :	Reset_Delay port map
(
	--iCLK	=> CLOCK_50,
	iCLK	=> CLOCK_27,
	oRESET	=> DLY_RST_tmp);
	

p1 :  VGA_Audio_PLL port map
(
	areset	=> not_DLY_RST,
	inclk0	=> CLOCK_27,
	c0			=> CLK,
	c1			=> open,
	c2			=> VGA_CLK_t);

--	VGA_CLK <= VGA_CLK_t;
end behav;