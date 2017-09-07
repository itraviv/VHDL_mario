library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun July 24 2017 


entity back_ground_draw is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   CLK  : in std_logic;
		RESETn	: in std_logic;
		oCoord_X 		: in integer;
		oCoord_Y 		: in integer;
		mVGA_RGB	      : out std_logic_vector(7 downto 0) --	,   						//	VGA Red[9:0]


	);
end back_ground_draw;

architecture behav of back_ground_draw is 



signal mVGA_R	: std_logic_vector(2 downto 0); --	,	 						//	VGA Red[9:0]
signal mVGA_G	: std_logic_vector(2 downto 0); --	,	 						//	VGA Green[9:0]
signal mVGA_B	:  std_logic_vector(1 downto 0); --	,  						//	VGA Blue[9:0]
	
begin

mVGA_RGB <=  mVGA_R & mVGA_G &  mVGA_B ;

mVGA_R <= "111" when (oCoord_y >= 450) else
			 "001" ;	
mVGA_G <= "100" when (oCoord_Y >= 450) else
 		    "110" ;	
mVGA_B <= "11" when ( oCoord_Y < 450) else
			 "00";	 




		
end behav;		