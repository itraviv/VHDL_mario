-------------------------
--Module Name:
-- mario
--Description:
-- Mario state machine
--------------------------

library ieee; 
use ieee.std_logic_1164.all; 
--use ieee.std_logic_signed.all; 
use ieee.std_logic_arith.all;

entity mario is
	port( 
		resetN : in std_logic;
		clk : in std_logic;
		pressedKey : in std_logic_vector(8 downto 0);
		iHit : in std_logic ; -- tells if mario hits somthing
		iHitObj : in std_logic_vector(2 downto 0);  -- describing what mario hit
		imake : in std_logic;
		ibreak : in std_logic;
		X: out std_logic_vector(31 downto 0) ; 
		Y: out std_logic_vector(31 downto 0)	
		);
end entity;

architecture arch_mario of mario is
		signal iMarioState : std_logic_vector(2 downto 0);
begin
--TODO: 1. proccess1: compute new X,Y
--TODO: 2. proccess2: compute state

end architecture;
