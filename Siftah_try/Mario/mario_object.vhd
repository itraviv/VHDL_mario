library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_ARITH.all;


entity mario_object is
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
end mario_object;

architecture arch_mario_object of mario_object is 

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
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"A9", x"CD", x"C9", x"CD", x"CD", x"C9", x"CD", x"CD", x"CD", x"D2", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"D2", x"A0", x"A0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"A0", x"D2", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"A8", x"C4", x"C0", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"C4", x"C8", x"A8", x"A9", x"A9", x"A8", x"D2", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"80", x"A0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"A0", x"A0", x"A0", x"80", x"80", x"80", x"89", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"80", x"A0", x"A0", x"A0", x"A0", x"C4", x"CC", x"CC", x"CC", x"C4", x"A0", x"C8", x"CC", x"D1", x"D5", x"D5", x"D2", x"D2", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"60", x"80", x"A0", x"A0", x"80", x"A8", x"D0", x"D0", x"D0", x"C8", x"80", x"CC", x"D0", x"D9", x"D9", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"64", x"88", x"D1", x"CC", x"80", x"A4", x"D0", x"D0", x"D0", x"D0", x"D0", x"A8", x"80", x"CC", x"D0", x"D0", x"D4", x"D0", x"D0", x"D5", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"40", x"84", x"D0", x"CC", x"80", x"A8", x"D0", x"D0", x"D0", x"D0", x"D0", x"A8", x"60", x"CC", x"D0", x"D0", x"D0", x"D0", x"D0", x"D5", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"60", x"84", x"D0", x"CC", x"80", x"84", x"84", x"A8", x"D0", x"D0", x"D0", x"D0", x"D0", x"A8", x"60", x"CC", x"D0", x"D0", x"D0", x"D0", x"D0", x"D5", x"FF"),
(x"FF", x"FF", x"FF", x"60", x"84", x"D1", x"CC", x"60", x"80", x"60", x"A8", x"D0", x"D0", x"D0", x"D0", x"D0", x"A8", x"80", x"CC", x"D0", x"D0", x"D0", x"D0", x"B0", x"B6", x"FF"),
(x"FF", x"FF", x"FF", x"40", x"64", x"60", x"84", x"D0", x"D0", x"D0", x"D0", x"D0", x"D0", x"D0", x"A8", x"60", x"80", x"80", x"80", x"80", x"60", x"60", x"AC", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"44", x"64", x"64", x"88", x"D0", x"D0", x"D0", x"D0", x"D0", x"D0", x"D0", x"A8", x"84", x"84", x"84", x"84", x"84", x"64", x"64", x"8D", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"D9", x"D0", x"D0", x"D0", x"D0", x"D0", x"D0", x"D0", x"D0", x"D0", x"D0", x"D0", x"D0", x"D0", x"D5", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"D9", x"CC", x"CC", x"CC", x"CC", x"CC", x"D0", x"CC", x"CC", x"CC", x"D0", x"D1", x"D0", x"D1", x"D5", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"40", x"60", x"80", x"A0", x"A0", x"A0", x"80", x"80", x"80", x"80", x"60", x"D5", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"D2", x"60", x"80", x"A0", x"A0", x"C0", x"A0", x"A0", x"80", x"80", x"A0", x"A0", x"D1", x"D2", x"D2", x"D2", x"D2", x"D2", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"40", x"60", x"80", x"80", x"A0", x"C0", x"C0", x"A0", x"A0", x"A0", x"A0", x"C0", x"A0", x"80", x"60", x"60", x"60", x"60", x"40", x"8D", x"FF", x"FF", x"FF"),
(x"FF", x"D2", x"D2", x"60", x"84", x"80", x"80", x"80", x"A0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"A0", x"80", x"80", x"80", x"80", x"80", x"A9", x"D2", x"FF", x"FF"),
(x"FF", x"40", x"60", x"80", x"80", x"80", x"80", x"A0", x"A0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"C0", x"A0", x"A0", x"80", x"80", x"80", x"80", x"80", x"40", x"8D", x"FF"),
(x"FF", x"88", x"A8", x"A8", x"A8", x"80", x"A0", x"A0", x"C0", x"C4", x"C0", x"E0", x"E0", x"E0", x"C4", x"C4", x"C0", x"A0", x"A0", x"80", x"84", x"A8", x"A8", x"88", x"D1", x"FF"),
(x"FF", x"D0", x"D0", x"D0", x"D0", x"80", x"A0", x"A0", x"C4", x"D0", x"C8", x"E0", x"E0", x"E0", x"C8", x"D0", x"C4", x"C0", x"A0", x"80", x"A4", x"D0", x"D0", x"D0", x"D5", x"FF"),
(x"D9", x"D0", x"D0", x"D0", x"D0", x"C8", x"C4", x"C0", x"C0", x"C4", x"C0", x"E0", x"E0", x"E0", x"C0", x"C4", x"E0", x"C0", x"C8", x"C8", x"CC", x"D0", x"D0", x"D0", x"D5", x"FF"),
(x"D9", x"D0", x"D0", x"D0", x"D0", x"D0", x"CC", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"CC", x"D0", x"D0", x"D0", x"D0", x"D0", x"D5", x"FF"),
(x"D9", x"D0", x"D0", x"D0", x"CC", x"C4", x"C4", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"C4", x"C8", x"D0", x"D0", x"D0", x"D5", x"FF"),
(x"FF", x"D0", x"D0", x"D0", x"CC", x"A0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"C0", x"C0", x"E0", x"E0", x"E0", x"E0", x"E0", x"C0", x"C4", x"D0", x"D0", x"D0", x"D5", x"FF"),
(x"FF", x"FF", x"FF", x"D9", x"D5", x"A0", x"C0", x"E0", x"E0", x"E0", x"C4", x"D2", x"D2", x"D2", x"C4", x"E0", x"E0", x"E0", x"E0", x"C0", x"C4", x"D9", x"D9", x"D9", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"A0", x"C0", x"C0", x"C0", x"A0", x"C9", x"FF", x"FF", x"FF", x"CD", x"A0", x"C0", x"C0", x"C0", x"C0", x"C8", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"64", x"A4", x"80", x"A0", x"A0", x"C8", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"C9", x"80", x"A0", x"A0", x"A4", x"84", x"AD", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"60", x"80", x"80", x"80", x"80", x"A9", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"AD", x"80", x"80", x"80", x"80", x"60", x"AD", x"FF", x"FF", x"FF"),
(x"FF", x"40", x"84", x"80", x"80", x"80", x"80", x"80", x"A9", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"AD", x"80", x"80", x"A0", x"80", x"80", x"80", x"64", x"B1", x"FF"),
(x"FF", x"40", x"40", x"60", x"60", x"60", x"60", x"40", x"89", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"89", x"40", x"60", x"60", x"60", x"60", x"60", x"40", x"8D", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF")

);


type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (

("11111111111111111111111111"),
("11111110000000000111111111"),
("11111110000000000011111111"),
("11111100000000000000000111"),
("11111100000000000001111111"),
("11111000000000000000111111"),
("11110000000000000000111111"),
("11110000000000000000001111"),
("11110000000000000000000111"),
("11110000000000000000000011"),
("11100000000000000000000011"),
("11100000000000000000000111"),
("11000110000000000000000111"),
("11111110000000000000001111"),
("11111100000000000111111111"),
("11111000000000000111111111"),
("11110000000000000111111111"),
("11100000000000000000001111"),
("11000000000000000000000111"),
("10000000000000000000000011"),
("10000000000000000000000011"),
("10000000000000000000000011"),
("10000000000000000000000011"),
("10000000000000000000000011"),
("10000000000000000000000011"),
("10000000000000000000000011"),
("11111000000000000000001111"),
("11111000000110000000001111"),
("11110000001111110000011111"),
("11100000011111110000001111"),
("10000000011111110000000011"),
("10000000011111110000000011"),
("11111111111111111111111111")
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