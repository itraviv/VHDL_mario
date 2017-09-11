library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
-- Alex Grinshpun April 2017

entity coin_object is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   	CLK  		: in std_logic;
		RESETn		: in std_logic;
		oCoord_X	: in integer;
		oCoord_Y	: in integer;
		ObjectStartX	: in std_logic_vector(8 downto 0);
		ObjectStartY 	: in std_logic_vector(8 downto 0);
		enable			: in std_logic;
		drawing_request	: out std_logic ;
		mVGA_RGB 	: out std_logic_vector(7 downto 0) ;
		is_active 		: out std_logic
	);
end coin_object;

architecture behav of coin_object is 

constant object_X_size : integer := 20;
constant object_Y_size : integer := 24;
constant R_high		: integer := 7;
constant R_low		: integer := 5;
constant G_high		: integer := 4;
constant G_low		: integer := 2;
constant B_high		: integer := 1;
constant B_low		: integer := 0;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"D9", x"D8", x"D8", x"D8", x"D9", x"D9", x"D4", x"D9", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"D9", x"D8", x"D8", x"D8", x"D8", x"D8", x"D8", x"D9", x"D9", x"D4", x"D4", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"D9", x"D8", x"D8", x"D8", x"D4", x"D4", x"D8", x"D8", x"D8", x"D8", x"FF", x"D4", x"D4", x"D9", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"D9", x"D8", x"D8", x"D4", x"8C", x"B0", x"D4", x"D4", x"B0", x"D8", x"D8", x"D8", x"FF", x"D8", x"D8", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"D8", x"FC", x"8C", x"B0", x"D9", x"D9", x"D9", x"D9", x"D9", x"D4", x"D8", x"D8", x"D9", x"FF", x"D9", x"D9", x"FF", x"FF"),
(x"FF", x"D8", x"D8", x"B0", x"B0", x"D8", x"D8", x"AC", x"8C", x"B0", x"D9", x"D9", x"D4", x"D8", x"D8", x"FF", x"FF", x"D9", x"FF", x"FF"),
(x"FF", x"D8", x"D8", x"B0", x"D8", x"D8", x"D9", x"B0", x"B0", x"D8", x"D9", x"D9", x"D9", x"D4", x"D8", x"D9", x"D9", x"D9", x"D9", x"FF"),
(x"FF", x"D8", x"B0", x"D4", x"D8", x"D8", x"D9", x"B0", x"D4", x"D8", x"D9", x"D9", x"D9", x"D8", x"D8", x"D8", x"D9", x"D8", x"D8", x"FF"),
(x"D9", x"D8", x"8C", x"D8", x"D8", x"D8", x"D9", x"B0", x"B0", x"D8", x"D8", x"D9", x"D9", x"D9", x"D4", x"D8", x"D9", x"D4", x"D4", x"D9"),
(x"D8", x"D8", x"B0", x"D8", x"D8", x"D8", x"D8", x"B0", x"B0", x"D8", x"D8", x"D8", x"D9", x"D9", x"D8", x"FC", x"D9", x"B0", x"B0", x"D4"),
(x"D8", x"D8", x"D4", x"D8", x"D4", x"D8", x"D8", x"B0", x"B0", x"D8", x"D8", x"D8", x"D8", x"D8", x"D8", x"D8", x"D9", x"B0", x"B0", x"B0"),
(x"D4", x"D8", x"D4", x"D4", x"D4", x"D4", x"D8", x"B0", x"B0", x"D8", x"D8", x"D8", x"D8", x"D8", x"D8", x"D8", x"D9", x"8C", x"8C", x"8C"),
(x"D4", x"D9", x"D4", x"D4", x"D4", x"D4", x"D8", x"B0", x"B0", x"D8", x"D8", x"D8", x"D8", x"D8", x"D8", x"D8", x"D8", x"68", x"68", x"68"),
(x"D4", x"D8", x"D8", x"D4", x"D4", x"D4", x"D8", x"B0", x"B0", x"D8", x"D8", x"D8", x"D8", x"D8", x"D4", x"D8", x"FC", x"68", x"68", x"8C"),
(x"D8", x"D8", x"D9", x"D4", x"D4", x"D4", x"D8", x"B0", x"B0", x"D4", x"D8", x"D8", x"D8", x"D8", x"D4", x"D8", x"D4", x"44", x"68", x"8C"),
(x"D9", x"D4", x"FF", x"D4", x"D4", x"D4", x"D8", x"B0", x"B0", x"D4", x"D4", x"D4", x"D4", x"D8", x"D4", x"FC", x"B0", x"44", x"44", x"91"),
(x"BA", x"D4", x"D9", x"D8", x"D4", x"D4", x"D4", x"B0", x"B0", x"D4", x"D4", x"D4", x"D4", x"D4", x"D8", x"D8", x"68", x"44", x"44", x"BA"),
(x"FF", x"D4", x"D4", x"D9", x"D0", x"D0", x"D4", x"B0", x"B0", x"D4", x"D4", x"D4", x"D4", x"D4", x"D8", x"D4", x"44", x"44", x"44", x"FF"),
(x"FF", x"D8", x"D4", x"D9", x"D8", x"B0", x"D4", x"D9", x"D8", x"D4", x"D4", x"D4", x"D4", x"D8", x"FC", x"68", x"68", x"68", x"B1", x"FF"),
(x"FF", x"FF", x"D4", x"D4", x"D9", x"D4", x"B0", x"B0", x"B0", x"B0", x"D4", x"D4", x"D4", x"D8", x"B0", x"68", x"68", x"68", x"FF", x"FF"),
(x"FF", x"FF", x"D9", x"D4", x"D4", x"D8", x"D8", x"D4", x"D4", x"D4", x"D4", x"D4", x"D8", x"D4", x"68", x"8C", x"68", x"BA", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"D4", x"D4", x"D4", x"D4", x"D4", x"D8", x"D4", x"D4", x"D4", x"D4", x"68", x"B0", x"8C", x"D5", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"D5", x"D4", x"D4", x"D4", x"D4", x"D4", x"D4", x"B0", x"88", x"B0", x"AC", x"BA", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B5", x"B0", x"B0", x"B0", x"B0", x"B0", x"B5", x"BA", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF")

);

type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
("11111100000000111111"),
("11111000000000001111"),
("11110000000000000111"),
("11100000000000000111"),
("11000000000000000011"),
("10000000000000000001"),
("10000000000000000001"),
("00000000000000000000"),
("00000000000000000000"),
("00000000000000000000"),
("00000000000000000000"),
("00000000000000000000"),
("00000000000000000000"),
("00000000000000000000"),
("00000000000000000000"),
("00000000000000000000"),
("00000000000000000000"),
("10000000000000000001"),
("10000000000000000001"),
("11000000000000000011"),
("11000000000000000011"),
("11100000000000000111"),
("11110000000000001111"),
("11111110000000111111")
);


signal bCoord_X : integer := 0;
signal bCoord_Y : integer := 0;

signal drawing_X : std_logic := '0';
signal drawing_Y : std_logic := '0';

signal obj_enabled: std_logic := '1';
--		
signal objectWestXboundary : integer;
signal objectSouthboundary : integer;
signal objectXboundariesTrue : boolean;
signal objectYboundariesTrue : boolean;
signal ObjectStartX_d : integer;

---
begin

-- Calculate object boundaries
objectWestXboundary	<= object_X_size+to_integer(unsigned(ObjectStartX));
objectSouthboundary	<= object_Y_size+to_integer(unsigned(ObjectStartY));

-- Signals drawing_X[Y] are active when obects coordinates are being crossed

	drawing_X	<= '1' when  (oCoord_X  >= to_integer(unsigned(ObjectStartX))) and  (oCoord_X < objectWestXboundary) and (obj_enabled='1') else '0';
    drawing_Y	<= '1' when  (oCoord_Y  >= to_integer(unsigned(ObjectStartY))) and  (oCoord_Y < objectSouthboundary) and (obj_enabled='1') else '0';

	bCoord_X 	<= (oCoord_X - to_integer(unsigned(ObjectStartX))) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 
	bCoord_Y 	<= (oCoord_Y - to_integer(unsigned(ObjectStartY))) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 
	
	is_active <= obj_enabled;

process ( RESETn, CLK)

  		
   begin
	if RESETn = '0' then
	    mVGA_RGB	<=  (others => '0') ; 	
		drawing_request	<=  '0' ;
		ObjectStartX_d <= 0;
		obj_enabled <= '1';
		elsif CLK'event and CLK='1' then
			if enable='0' then
				obj_enabled <= '0';
			else
				mVGA_RGB	<=  object_colors(bCoord_Y , bCoord_X);	
				drawing_request	<= (not object(bCoord_Y , bCoord_X)) and drawing_X and drawing_Y ;
				ObjectStartX_d <= to_integer(unsigned(ObjectStartX));
			end if;
	end if;

end process;

		
end behav;		
		