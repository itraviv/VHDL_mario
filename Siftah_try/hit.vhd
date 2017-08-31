-------------------------
--Module Name:
-- hit
--Description:
-- Hit detector for mario and obstacles
--------------------------

library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_signed.all; 
use ieee.std_logic_arith.all;

entity hit is
	port( 
		resetN : in std_logic;
		clk : in std_logic;
		idrawReqMario : in std_logic;
		idrawReqObscl : in std_logic;
		idraw_mario_bottom  : in std_logic;
		
		obj_speed_X : in integer ;
		obj_speed_Y : in integer ;
		
		oHitObj : out std_logic;  -- tells if mario hits obstcle
		hitBottom : out std_logic; --tells if the hit is in marios legs
		speed_X : out integer ;
		speed_Y : out integer 
		
		);
end entity;

architecture arch_hit of hit is
signal oHitObj_sig : std_logic;

begin

oHitObj_sig <= '1' when idrawReqMario='1' and idrawReqObscl='1' else '0';
oHitObj <=  oHitObj_sig;
speed_X <= obj_speed_X when oHitObj_sig='1' else 0;
speed_Y <= obj_speed_Y when oHitObj_sig='1' else 0;

hitBottom <= '1' when oHitObj_sig='1' and idraw_mario_bottom='1' else '0';

end architecture;