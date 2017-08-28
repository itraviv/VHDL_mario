-------------------------
--Module Name:
-- sound
--Description:
-- Output sounds
--------------------------

library ieee; 
use ieee.std_logic_1164.all; 
--use ieee.std_logic_signed.all; 
use ieee.std_logic_arith.all;

entity sound is
	port( 
		resetN : in std_logic;
		clk : in std_logic;
		iHitMario : in std_logic ; -- tells if mario hits somthing
		iHitObj : in std_logic_vector(2 downto 0);  -- describing what mario hit , relevant if hit=1
		soundType : out std_logic_vector(2 downto 0)  -- describing sound type to play
		);
end entity;

architecture arch_sound of sound is
begin


end architecture;