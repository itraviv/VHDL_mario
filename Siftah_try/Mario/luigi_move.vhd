library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_ARITH.all;


entity luigi_move is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   	CLK  		: in std_logic;
		RESETn		: in std_logic;
		oCoord_X	: in std_logic_vector(9 downto 0);
		oCoord_Y	: in std_logic_vector(9 downto 0);
		ObjectStartX	: in std_logic_vector(9 downto 0);
		ObjectStartY 	: in std_logic_vector(9 downto 0);
		drawing_request	: out std_logic ;
		mVGA_RGB 	: out std_logic_vector(7 downto 0) 
	);
end luigi_move;

architecture arch_luigi_object of luigi_move is 

constant object_X_size : integer := 26;
constant object_Y_size : integer := 33;
constant R_high		: integer := 7;
constant R_low		: integer := 5;
constant G_high		: integer := 4;
constant G_low		: integer := 2;
constant B_high		: integer := 1;
constant B_low		: integer := 0;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"BA", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"BA", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"58", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"59", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"24", x"24", x"24", x"24", x"24", x"B0", x"D0", x"D0", x"B0", x"24", x"D0", x"D0", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"24", x"24", x"24", x"24", x"24", x"AC", x"D0", x"D0", x"B0", x"24", x"D0", x"D0", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"24", x"AC", x"D0", x"24", x"24", x"D0", x"D0", x"D0", x"D0", x"B0", x"24", x"D0", x"D0", x"D0", x"D0", x"D0", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"24", x"AC", x"D4", x"24", x"24", x"D4", x"D0", x"D0", x"D0", x"AC", x"24", x"D0", x"D0", x"D0", x"D0", x"D0", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"24", x"AC", x"D4", x"24", x"24", x"24", x"D0", x"D0", x"D0", x"D0", x"D0", x"24", x"24", x"D0", x"D0", x"D0", x"D0", x"D0", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"24", x"AC", x"D4", x"24", x"24", x"24", x"B0", x"D0", x"D0", x"D0", x"D0", x"24", x"24", x"D0", x"D0", x"D0", x"D0", x"D0", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"24", x"6C", x"6C", x"D0", x"D0", x"D0", x"D0", x"D0", x"D0", x"D0", x"24", x"24", x"24", x"24", x"24", x"24", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"24", x"24", x"24", x"D0", x"D0", x"D0", x"D0", x"D0", x"D0", x"AC", x"24", x"24", x"24", x"24", x"24", x"24", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"B6", x"B6", x"D0", x"D0", x"D0", x"D0", x"D0", x"D0", x"D0", x"B0", x"B0", x"B0", x"B0", x"B0", x"B6", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"D4", x"D0", x"D0", x"D0", x"D0", x"D0", x"D0", x"D0", x"D0", x"D0", x"D0", x"D9", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"91", x"8C", x"70", x"58", x"70", x"8C", x"8C", x"8C", x"8C", x"D5", x"D9", x"D9", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"24", x"24", x"24", x"30", x"1C", x"30", x"24", x"24", x"24", x"24", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"24", x"24", x"24", x"24", x"30", x"1C", x"30", x"24", x"24", x"24", x"14", x"75", x"B1", x"B1", x"B1", x"91", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"24", x"24", x"24", x"24", x"50", x"1C", x"30", x"24", x"24", x"30", x"1C", x"4C", x"24", x"24", x"24", x"24", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"B6", x"B5", x"24", x"24", x"24", x"24", x"24", x"1C", x"14", x"30", x"30", x"18", x"1C", x"4C", x"24", x"24", x"24", x"24", x"B5", x"B6", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"24", x"24", x"24", x"24", x"24", x"24", x"24", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"4C", x"24", x"24", x"24", x"24", x"24", x"8C", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"B0", x"8C", x"24", x"24", x"24", x"30", x"34", x"78", x"38", x"1C", x"1C", x"18", x"78", x"34", x"30", x"24", x"24", x"24", x"8C", x"B0", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"D4", x"D0", x"D4", x"AC", x"24", x"1C", x"38", x"FC", x"98", x"1C", x"1C", x"58", x"FC", x"18", x"1C", x"24", x"AC", x"D4", x"D0", x"D4", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"D4", x"D0", x"D0", x"B0", x"24", x"1C", x"18", x"B8", x"58", x"1C", x"1C", x"58", x"FC", x"18", x"1C", x"24", x"B0", x"D0", x"D0", x"D4", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"D4", x"D0", x"D0", x"D0", x"D0", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"D0", x"D0", x"D0", x"D0", x"D4", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"D4", x"D0", x"D0", x"D4", x"D4", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"B4", x"B4", x"D0", x"D0", x"D4", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"D4", x"D0", x"D0", x"38", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"78", x"D0", x"D0", x"D4", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"D4", x"D4", x"D0", x"38", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"1C", x"78", x"D0", x"D0", x"D5", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"38", x"1C", x"1C", x"1C", x"1C", x"79", x"FF", x"FF", x"99", x"1C", x"1C", x"1C", x"1C", x"79", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"38", x"1C", x"1C", x"1C", x"1C", x"79", x"FF", x"FF", x"BA", x"1C", x"1C", x"1C", x"1C", x"58", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"24", x"68", x"68", x"68", x"8C", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"88", x"68", x"68", x"48", x"24", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"48", x"68", x"48", x"48", x"6C", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"6C", x"48", x"48", x"68", x"48", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"6C", x"48", x"48", x"48", x"48", x"48", x"6C", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"6C", x"48", x"48", x"48", x"48", x"48", x"6C", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"90", x"6C", x"6C", x"6C", x"6C", x"6C", x"90", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"90", x"6C", x"6C", x"6C", x"6C", x"6C", x"90", x"FF", x"FF", x"FF")

);


type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (

("11111111000000000111111111"),
("11111111000000000111111111"),
("11111100000000000000011111"),
("11111100000000000000011111"),
("11111100000000000011111111"),
("11111100000000000011111111"),
("11111000000000000000011111"),
("11111000000000000000011111"),
("11111000000000000000000111"),
("11111000000000000000000111"),
("11111000000000000000011111"),
("11111000000000000000011111"),
("11111000000000000000011111"),
("11111111000000000000111111"),
("11111100000000000001111111"),
("11111100000000001111111111"),
("11111000000000000000011111"),
("11111000000000000000011111"),
("11100000000000000000000111"),
("11100000000000000000000111"),
("11100000000000000000000111"),
("11100000000000000000000111"),
("11100000000000000000000111"),
("11100000000000000000000111"),
("11100000000000000000000111"),
("11100000000000000000000111"),
("11100000000000000000000111"),
("11111100000011000000111111"),
("11111100000011000000111111"),
("11111000001111110000011111"),
("11111000001111110000011111"),
("11100000001111110000000111"),
("11100000001111110000000111")
);

signal bCoord_X : integer := 0;
signal bCoord_Y : integer := 0;

signal drawing_X : std_logic := '0';
signal drawing_Y : std_logic := '0';

--		
signal objectWestXboundary : std_logic_vector(9 downto 0);
signal objectSouthboundary : std_logic_vector(9 downto 0);
signal objectXboundariesTrue : boolean;
signal objectYboundariesTrue : boolean;

---
begin

-- Calculate object boundaries
objectWestXboundary	<= object_X_size+ObjectStartX;
objectSouthboundary	<= object_Y_size+ObjectStartY;

-- Signals drawing_X[Y] are active when obects coordinates are being crossed

	drawing_X	<= '1' when  (oCoord_X  >= ObjectStartX) and  (oCoord_X < objectWestXboundary) else '0';
    drawing_Y	<= '1' when  (oCoord_Y  >= ObjectStartY) and  (oCoord_Y < objectSouthboundary) else '0';

	bCoord_X 	<= conv_integer(oCoord_X - ObjectStartX) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 
	bCoord_Y 	<= conv_integer(oCoord_Y - ObjectStartY) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 
	


process ( RESETn, CLK)

  		
   begin
	if RESETn = '0' then
	    mVGA_RGB	<=  (others => '0') ; 	
		drawing_request	<=  '0' ;

		elsif CLK'event and CLK='1' then
			mVGA_RGB	<=  object_colors(bCoord_Y , bCoord_X);	
			drawing_request	<= (not object(bCoord_Y , bCoord_X)) and drawing_X and drawing_Y ;
			

	end if;

end process;

		
end architecture;