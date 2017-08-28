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

entity hit is
	port( 
		resetN : in std_logic;
		clk : in std_logic;
		idrawReqMario : in std_logic;
		idrawReqGoldBomb : in std_logic;
		idrawReqObscl : in std_logic;
		
		oHitMario : out std_logic ; -- tells if mario hits somthing
		oHitObj : out std_logic_vector(2 downto 0)  -- describing what mario hit , relevant if hit=1
		);
end entity;

architecture arch_hit of hit is
begin


end architecture;