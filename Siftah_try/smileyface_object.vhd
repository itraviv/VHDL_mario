library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.std_logic_unsigned.all;
--use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017

entity smileyface_object is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   	CLK  		: in std_logic;
		RESETn		: in std_logic;
		oCoord_X	: in integer;
		oCoord_Y	: in integer;
		ObjectStartX	: in integer;
		ObjectStartY 	: in integer;
		drawing_request	: out std_logic ;
		mVGA_RGB 	: out std_logic_vector(7 downto 0) ;
		drawing_down_boarder : out std_logic
	);
end smileyface_object;

architecture behav of smileyface_object is 

constant object_X_size : integer := 18;
constant object_Y_size : integer := 26;
constant R_high		: integer := 7;
constant R_low		: integer := 5;
constant G_high		: integer := 4;
constant G_low		: integer := 2;
constant B_high		: integer := 1;
constant B_low		: integer := 0;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"20", x"20", x"20", x"20", x"D9", x"D9", x"D9", x"00", x"D9", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"20", x"FF", x"20", x"20", x"FF", x"D5", x"D9", x"D9", x"00", x"D9", x"D5", x"D5", x"D5", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"20", x"FF", x"20", x"20", x"FF", x"D5", x"D9", x"D9", x"00", x"D9", x"D5", x"D5", x"D5", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"20", x"FF", x"20", x"20", x"20", x"D9", x"D5", x"D5", x"FF", x"00", x"D9", x"D9", x"D9", x"D0", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"00", x"D9", x"D9", x"D9", x"D5", x"D9", x"D9", x"00", x"00", x"00", x"00", x"00", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"D9", x"D9", x"D9", x"D9", x"D9", x"D9", x"D9", x"D9", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"03", x"03", x"03", x"E0", x"03", x"03", x"03", x"03", x"03", x"03", x"03", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"03", x"03", x"03", x"E0", x"03", x"03", x"03", x"03", x"03", x"03", x"03", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"03", x"03", x"03", x"03", x"E0", x"03", x"03", x"03", x"E0", x"03", x"03", x"03", x"03", x"FF", x"FF", x"FF"),
( x"FF", x"03", x"03", x"03", x"03", x"03", x"E0", x"E0", x"E0", x"E0", x"E0", x"03", x"03", x"03", x"03", x"03", x"FF", x"FF"),
( x"FF", x"D9", x"D9", x"03", x"E0", x"E0", x"FC", x"E0", x"E0", x"E0", x"FC", x"E0", x"03", x"03", x"D9", x"D9", x"FF", x"FF"),
( x"FF", x"D9", x"D9", x"03", x"E0", x"E0", x"FC", x"E0", x"E0", x"E0", x"FC", x"E0", x"03", x"03", x"D9", x"D9", x"FF", x"FF"),
( x"FF", x"D5", x"D5", x"D9", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"D9", x"D9", x"D5", x"D5", x"FF", x"FF"),
( x"FF", x"D5", x"D9", x"E0", x"E0", x"E0", x"E0", x"FF", x"FF", x"FF", x"E0", x"E0", x"E0", x"E0", x"D9", x"D5", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"E0", x"E0", x"E0", x"E0", x"FF", x"FF", x"FF", x"E0", x"E0", x"E0", x"E0", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"E0", x"E0", x"E0", x"E0", x"FF", x"FF", x"FF", x"E0", x"E0", x"E0", x"E0", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"20", x"20", x"20", x"20", x"FF", x"FF", x"FF", x"FF", x"FF", x"20", x"20", x"20", x"20", x"FF", x"FF", x"FF"),
( x"FF", x"00", x"20", x"20", x"20", x"20", x"FF", x"FF", x"FF", x"FF", x"FF", x"20", x"20", x"20", x"20", x"00", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
( x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"));

type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
("000000000000000000"),
("000011111111000000"),
("000011111111000000"),
("000011111111111000"),
("000011111111110000"),
("000111111111111000"),
("000111111111111110"),
("001011111111111110"),
("001011111111111110"),
("001011111111111100"),
("000111111111111000"),
("000011111111110000"),
("000111111111110000"),
("000111111111110000"),
("001111111111111000"),
("011111111111111100"),
("000111011101110000"),
("000111011101110000"),
("000011111111000000"),
("000111100011110000"),
("000111100011110000"),
("000111100011110000"),
("001111000001111000"),
("000000000000000000"),
("000000000000000000"),
("000000000000000000"));


signal bCoord_X : integer := 0;
signal bCoord_Y : integer := 0;

signal drawing_X : std_logic := '0';
signal drawing_Y : std_logic := '0';

--		
signal objectWestXboundary : integer;
signal objectSouthboundary : integer;
signal objectXboundariesTrue : boolean;
signal objectYboundariesTrue : boolean;
signal ObjectStartX_d : integer;

---
begin

-- Calculate object boundaries
objectWestXboundary	<= object_X_size+ObjectStartX;
objectSouthboundary	<= object_Y_size+ObjectStartY;

-- Signals drawing_X[Y] are active when obects coordinates are being crossed

	drawing_X	<= '1' when  (oCoord_X  >= ObjectStartX) and  (oCoord_X < objectWestXboundary) else '0';
    drawing_Y	<= '1' when  (oCoord_Y  >= ObjectStartY) and  (oCoord_Y < objectSouthboundary) else '0';

	bCoord_X 	<= (oCoord_X - ObjectStartX) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 
	bCoord_Y 	<= (oCoord_Y - ObjectStartY) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 
	


process ( RESETn, CLK)

  		
   begin
	if RESETn = '0' then
	    mVGA_RGB	<=  (others => '0') ; 	
		drawing_request	<=  '0' ;
		ObjectStartX_d <= 0;
		drawing_down_boarder <='0';

		elsif CLK'event and CLK='1' then
			mVGA_RGB	<=  object_colors(bCoord_Y , bCoord_X);	
			drawing_request	<= object(bCoord_Y , bCoord_X) and drawing_X and drawing_Y ;
			ObjectStartX_d <= ObjectStartX;
			
			
			if oCoord_Y=objectSouthboundary-1 or oCoord_Y=objectSouthboundary-2 then
			drawing_down_boarder <= '1' ;
			else
			drawing_down_boarder <= '0' ;
			end if;
	end if;

end process;

		
end behav;		
		