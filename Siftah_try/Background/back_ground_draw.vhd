library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity back_ground_draw is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   CLK  : in std_logic;
		RESETn	: in std_logic;
		oCoord_X 		: in std_logic_vector(9 downto 0);
		oCoord_Y 		: in std_logic_vector(9 downto 0);
		mVGA_RGB	      : out std_logic_vector(7 downto 0) --	,   						//	VGA Red[9:0]


	);
end back_ground_draw;

architecture behav of back_ground_draw is 

constant floor_object_X_size : integer := 30;
constant floor_object_Y_size : integer := 30;
constant cloud_object_X_size : integer := 20;
constant cloud_object_Y_size : integer := 15;

type floor_ram_array is array(0 to floor_object_Y_size - 1 , 0 to floor_object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant floor_colors: floor_ram_array := (
(x"B6", x"BA", x"B6", x"BA", x"BA", x"B6", x"B6", x"BA", x"BA", x"BA", x"BA", x"BA", x"BA", x"BA", x"BA", x"BA", x"BA", x"BA", x"BA", x"BA", x"BA", x"BA", x"BA", x"BA", x"BA", x"BA", x"BA", x"BA", x"BA", x"BA"),
(x"A4", x"A4", x"C4", x"C4", x"C4", x"C4", x"A4", x"A4", x"A4", x"C4", x"C4", x"A4", x"80", x"00", x"40", x"80", x"A4", x"A4", x"C4", x"C4", x"C4", x"C4", x"A4", x"A4", x"A4", x"C4", x"C4", x"A4", x"A0", x"20"),
(x"A4", x"C4", x"C8", x"C4", x"C4", x"C8", x"C8", x"C8", x"C4", x"C8", x"C8", x"C4", x"A4", x"00", x"40", x"A4", x"C4", x"C4", x"C8", x"C4", x"C4", x"C8", x"C8", x"C8", x"C4", x"C4", x"C8", x"C4", x"C4", x"20"),
(x"A4", x"C4", x"C4", x"C8", x"C4", x"C4", x"C8", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"00", x"40", x"A4", x"A4", x"C4", x"C4", x"C8", x"C4", x"C4", x"C8", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"20"),
(x"60", x"84", x"84", x"84", x"80", x"A4", x"84", x"84", x"84", x"A4", x"A4", x"A4", x"84", x"00", x"40", x"60", x"80", x"84", x"A4", x"84", x"80", x"A4", x"84", x"84", x"84", x"A4", x"A4", x"A4", x"84", x"20"),
(x"24", x"24", x"24", x"24", x"24", x"00", x"20", x"24", x"24", x"24", x"24", x"24", x"24", x"24", x"24", x"24", x"24", x"24", x"24", x"24", x"24", x"00", x"00", x"24", x"24", x"24", x"24", x"24", x"24", x"24"),
(x"C8", x"C4", x"C4", x"A4", x"A4", x"00", x"84", x"C4", x"C4", x"C8", x"C8", x"C4", x"C4", x"C4", x"C8", x"C4", x"C8", x"C4", x"C4", x"A4", x"A4", x"00", x"84", x"C4", x"C4", x"C8", x"C8", x"C4", x"C4", x"C4"),
(x"C4", x"C4", x"C4", x"A4", x"84", x"00", x"64", x"C4", x"C4", x"C8", x"C8", x"C4", x"C8", x"C8", x"C4", x"C8", x"C4", x"C4", x"C4", x"A4", x"84", x"00", x"64", x"C4", x"C4", x"C8", x"C8", x"C4", x"C8", x"C4"),
(x"C8", x"C4", x"C4", x"C4", x"A4", x"00", x"60", x"A4", x"C4", x"C8", x"C8", x"C8", x"C4", x"C4", x"C4", x"C8", x"C8", x"C4", x"C4", x"C4", x"A4", x"00", x"64", x"A4", x"C4", x"C8", x"C8", x"C8", x"C4", x"C4"),
(x"C8", x"C8", x"C4", x"C4", x"A4", x"00", x"64", x"A4", x"C4", x"C4", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C8", x"C4", x"C4", x"A4", x"00", x"64", x"A4", x"C4", x"C4", x"C8", x"C8", x"C8", x"C8"),
(x"C4", x"C8", x"C4", x"C4", x"A4", x"00", x"60", x"A4", x"C4", x"C4", x"C8", x"C4", x"C4", x"C8", x"C8", x"C4", x"C4", x"C4", x"C8", x"C4", x"A4", x"00", x"60", x"A4", x"C4", x"C4", x"C8", x"C4", x"C4", x"C8"),
(x"C8", x"C4", x"C4", x"C4", x"A4", x"00", x"64", x"A4", x"A4", x"C4", x"C4", x"C8", x"C4", x"C8", x"C8", x"C4", x"C8", x"C4", x"C4", x"C4", x"C4", x"00", x"64", x"A4", x"A4", x"C4", x"C4", x"C8", x"C4", x"C8"),
(x"C4", x"C8", x"C8", x"C4", x"C4", x"00", x"64", x"A4", x"A4", x"C4", x"C8", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C8", x"C8", x"C4", x"C4", x"20", x"64", x"84", x"A4", x"C4", x"C8", x"C4", x"C4", x"C4"),
(x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"),
(x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"CC", x"CC", x"CC", x"C8", x"C8", x"A8", x"A8", x"00", x"84", x"C8", x"CC", x"CC", x"CC", x"C8", x"C8", x"C8", x"C8", x"CC", x"CC", x"C8", x"C8", x"A8", x"A8", x"20"),
(x"C4", x"C4", x"C8", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"A4", x"84", x"00", x"64", x"C4", x"C4", x"C4", x"C8", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"A4", x"A4", x"20"),
(x"C4", x"C8", x"C8", x"C8", x"C8", x"C4", x"C4", x"C8", x"C8", x"C4", x"C4", x"C4", x"A4", x"00", x"60", x"A4", x"C4", x"C8", x"C8", x"C8", x"C8", x"C4", x"C4", x"C8", x"C8", x"C4", x"C4", x"C4", x"A4", x"20"),
(x"C4", x"C8", x"C8", x"C4", x"C4", x"C8", x"C8", x"C8", x"C8", x"C8", x"C4", x"C4", x"A4", x"00", x"60", x"A4", x"C4", x"C8", x"C8", x"C8", x"C4", x"C8", x"C8", x"C8", x"C8", x"C8", x"C4", x"C4", x"A4", x"20"),
(x"C4", x"C4", x"C8", x"C8", x"C8", x"C8", x"C4", x"C4", x"C4", x"C8", x"C4", x"C4", x"A4", x"00", x"40", x"A4", x"C4", x"C4", x"C8", x"C8", x"C8", x"C8", x"C8", x"C4", x"C4", x"C8", x"C4", x"C4", x"A4", x"20"),
(x"A4", x"C4", x"C4", x"C4", x"C4", x"C8", x"C8", x"C4", x"C8", x"C4", x"C4", x"C4", x"A4", x"00", x"40", x"A4", x"A4", x"C4", x"C4", x"C4", x"C4", x"C8", x"C8", x"C8", x"C8", x"C4", x"C4", x"C4", x"A4", x"20"),
(x"A4", x"C4", x"C8", x"C8", x"C4", x"C4", x"C8", x"C4", x"C4", x"C8", x"C8", x"C4", x"C4", x"00", x"64", x"A4", x"A4", x"C4", x"C8", x"C8", x"C4", x"C4", x"C8", x"C4", x"C4", x"C8", x"C8", x"C4", x"C4", x"20"),
(x"20", x"20", x"20", x"20", x"20", x"40", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"00", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"40", x"20", x"20", x"20", x"20", x"40", x"40", x"20", x"00"),
(x"88", x"88", x"88", x"88", x"88", x"00", x"64", x"A8", x"A8", x"A8", x"A8", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"88", x"00", x"64", x"A8", x"A8", x"A8", x"88", x"88", x"88", x"88"),
(x"C4", x"C4", x"C4", x"A4", x"A4", x"00", x"84", x"C4", x"C4", x"C4", x"C8", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"C4", x"A4", x"A4", x"00", x"84", x"C4", x"C4", x"C4", x"C8", x"C4", x"C4", x"C4"),
(x"C8", x"C4", x"C4", x"A4", x"84", x"00", x"64", x"C4", x"C4", x"C8", x"C8", x"C8", x"C8", x"C4", x"C4", x"C8", x"C8", x"C4", x"C4", x"C4", x"A4", x"00", x"64", x"C4", x"C4", x"C8", x"C8", x"C8", x"C8", x"C4"),
(x"C8", x"C4", x"C4", x"C4", x"A4", x"00", x"64", x"A4", x"C4", x"C8", x"C8", x"C8", x"C4", x"C8", x"C8", x"C8", x"C8", x"C4", x"C4", x"C4", x"A4", x"00", x"64", x"A4", x"C4", x"C8", x"C8", x"C8", x"C4", x"C8"),
(x"C8", x"C8", x"C4", x"C4", x"A4", x"00", x"64", x"A4", x"C4", x"C4", x"C8", x"C8", x"C8", x"C8", x"C8", x"C4", x"C4", x"C8", x"C4", x"C4", x"A4", x"00", x"64", x"A4", x"C4", x"C4", x"C8", x"C8", x"C8", x"C8"),
(x"C4", x"C8", x"C4", x"C4", x"A4", x"00", x"60", x"A4", x"C4", x"C4", x"C8", x"C4", x"C4", x"C8", x"C8", x"C8", x"C4", x"C4", x"C8", x"C4", x"A4", x"00", x"60", x"A4", x"C4", x"C4", x"C8", x"C4", x"C4", x"C8"),
(x"C4", x"C4", x"C4", x"C4", x"C4", x"00", x"60", x"A4", x"A4", x"C4", x"C4", x"C8", x"C4", x"C4", x"C8", x"C4", x"C4", x"C8", x"C4", x"C4", x"C4", x"00", x"64", x"A4", x"C4", x"C4", x"C4", x"C8", x"C4", x"C4"),
(x"64", x"84", x"84", x"84", x"84", x"00", x"40", x"40", x"60", x"64", x"84", x"64", x"60", x"64", x"64", x"84", x"84", x"84", x"84", x"84", x"84", x"00", x"40", x"60", x"60", x"64", x"84", x"64", x"60", x"64")

);


signal mVGA_R	: std_logic_vector(2 downto 0); --	,	 						//	VGA Red[9:0]
signal mVGA_G	: std_logic_vector(2 downto 0); --	,	 						//	VGA Green[9:0]
signal mVGA_B	:  std_logic_vector(1 downto 0); --	,  						//	VGA Blue[9:0]
	
begin



mVGA_R <= "010" when (oCoord_y >= 450) else
			 "010" ;	
mVGA_G <= "101" when (oCoord_Y >= 450) else
 		    "101" ;	
mVGA_B <= "11" when ( oCoord_Y < 450) else
			 "00";	 
			 
  mVGA_RGB <= floor_colors(conv_integer(oCoord_y) mod floor_object_Y_size ,conv_integer(oCoord_X) mod floor_object_X_size ) when (conv_integer(oCoord_Y)>450)
   else  (mVGA_R & mVGA_G &  mVGA_B );



		
end behav;		