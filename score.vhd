-------------------------
--Module Name:
-- hit
--Description:
-- Hit detector
--------------------------

library ieee; 
use ieee.std_logic_1164.all; 
--use ieee.std_logic_signed.all; 
use ieee.std_logic_arith.all;

entity score is
	port( 
		resetN : in std_logic;
		clk : in std_logic;
		iHitMario : in std_logic ; -- tells if mario hits gold/bomb
		isGold : in std_logic;
		
		score_low : out std_logic_vector(3 downto 0);
		score_high : out std_logic_vector(3 downto 0);

		life : out std_logic_vector(2 downto 0) ;
		);
end entity;

architecture arch_hit of hit is
begin


end architecture;