library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

entity bomb_object is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   	CLK  		: in std_logic;
		RESETn		: in std_logic;
		oCoord_X	: in std_logic_vector(9 downto 0);
		oCoord_Y	: in std_logic_vector(9 downto 0);
		ObjectStartX	: in std_logic_vector(8 downto 0);
		ObjectStartY 	: in std_logic_vector(8 downto 0);
		enable			: in std_logic;
		drawing_request	: out std_logic ;
		mVGA_RGB 	: out std_logic_vector(7 downto 0) ;
		is_active 		: out std_logic
	);
end bomb_object;

architecture behav of bomb_object is 

constant object_X_size : integer := 31;
constant object_Y_size : integer := 31;
constant R_high		: integer := 7;
constant R_low		: integer := 5;
constant G_high		: integer := 4;
constant G_low		: integer := 2;
constant B_high		: integer := 1;
constant B_low		: integer := 0;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"92", x"6D", x"48", x"92", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"BA", x"6D", x"24", x"49", x"B6", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"48", x"49", x"B6", x"92", x"49", x"B6", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"92", x"FF", x"6D", x"6D", x"BA", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"6D", x"B6", x"92", x"48", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"6D", x"6D", x"24", x"00", x"00", x"00", x"00", x"24", x"BA", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"49", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"49", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"BA", x"FF", x"FF", x"FF", x"FF", x"48", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"24", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"48", x"92", x"00", x"92", x"FF", x"92", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"B6", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"6D", x"BA", x"48", x"FF", x"00", x"FF", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"49", x"00", x"00", x"00", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"6D", x"6D", x"FF", x"6D", x"00", x"B6", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"92", x"FF", x"24", x"00", x"FF", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"BA", x"6D", x"49", x"FF", x"24", x"49", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"FF", x"FF", x"92", x"00", x"FF", x"00", x"B6", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"6D", x"FF", x"FF", x"24", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"FF", x"FF", x"B6", x"00", x"FF", x"00", x"92", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"6D", x"FF", x"FF", x"24", x"24", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"FF", x"FF", x"92", x"00", x"FF", x"00", x"B6", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"92", x"92", x"6D", x"92", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"6D", x"FF", x"00", x"00", x"00", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"BA", x"92", x"92", x"6D", x"FF", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"20", x"FF", x"48", x"48", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"6D", x"92", x"6D", x"B6", x"48", x"B6", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"6D", x"24", x"FF", x"FF", x"00", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"BA", x"6D", x"92", x"24", x"FF", x"FF", x"24", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"48", x"FF", x"FF", x"FF", x"48", x"BA", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"48", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"FF", x"FF", x"FF", x"24", x"92", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"6D", x"BA", x"FF", x"00", x"B6", x"00", x"00", x"00", x"00", x"00", x"00", x"FF", x"00", x"B6", x"FF", x"92", x"00", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"6D", x"FF", x"FF", x"24", x"FF", x"FF", x"BA", x"BA", x"FF", x"FF", x"FF", x"24", x"FF", x"00", x"49", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"24", x"FF", x"FF", x"92", x"92", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"BA", x"49", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"FF", x"FF", x"FF", x"24", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"6D", x"92", x"FF", x"FF", x"24", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"6D", x"00", x"24", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF")
);

type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
("0000000000000000000000000000000"),
("0000000000000000000000000000000"),
("0000000000000000000000000000000"),
("0000000000110000000000000000000"),
("0000000001100000000000000000000"),
("0000000000011000000000000000000"),
("0000000000100100000000000000000"),
("0000000000000010000000000000000"),
("0000000000000100100000000000000"),
("0000000000001111111100000000000"),
("0000000000001111111111000000000"),
("0000000000011111111111100000000"),
("0000010110011111111111100000000"),
("0000001010111111111111110000000"),
("0000100011111111111111110000000"),
("0000010011111111111111110000000"),
("0000000011111111111111110000000"),
("0000000011111111111111110000000"),
("0000000001111111111111110000000"),
("0000010101111111111111110000000"),
("0000010001011111111111111001000"),
("0000001110011111111111110001000"),
("0000000000111111111111100010000"),
("0000000000001111111101000100000"),
("0000000000000100000000111000000"),
("0000000000100000000000000000000"),
("0000000000100000000000000000000"),
("0000000000111000000000000000000"),
("0000000000111100000000000000000"),
("0000000000000000000000000000000"),
("0000000000000000000000000000000")
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

---
begin

-- Calculate object boundaries
objectWestXboundary	<= object_X_size+conv_integer(ObjectStartX);
objectSouthboundary	<= object_Y_size+conv_integer(ObjectStartY);

-- Signals drawing_X[Y] are active when obects coordinates are being crossed

	drawing_X	<= '1' when  (oCoord_X  >= ObjectStartX) and  (oCoord_X < objectWestXboundary) and (obj_enabled='1') else '0';
    drawing_Y	<= '1' when  (oCoord_Y  >= ObjectStartY) and  (oCoord_Y < objectSouthboundary) and (obj_enabled='1') else '0';

	bCoord_X 	<= conv_integer(oCoord_X - (ObjectStartX)) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 
	bCoord_Y 	<= conv_integer(oCoord_Y - (ObjectStartY)) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 
	
	is_active <= obj_enabled;

process ( RESETn, CLK, enable)

  		
   begin
	if RESETn = '0' then
	    mVGA_RGB	<=  (others => '0') ; 	
		drawing_request	<=  '0' ;
		obj_enabled <= '1';
		elsif CLK'event and CLK='1' then
			if enable='0' then
				obj_enabled <= '0';
			else
				mVGA_RGB	<=  object_colors(bCoord_Y , bCoord_X);	
				drawing_request	<= object(bCoord_Y , bCoord_X) and drawing_X and drawing_Y;
			end if;
	end if;

end process;

		
end behav;		
		