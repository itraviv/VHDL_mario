-------------------------
--Module Name:
-- obstacles
--Description:
-- 
--------------------------

library ieee; 
use ieee.std_logic_1164.all; 
--use ieee.std_logic_signed.all; 
use ieee.std_logic_arith.all;

entity obstacles is
	port( 
		resetN : in std_logic;
		clk : in std_logic;
		X: out std_logic_vector(31 downto 0) ; 
		Y: out std_logic_vector(31 downto 0) 
		);
end entity;

architecture arch_obstacles of obstacles is
begin
--TODO: 1. proccess1: compute new X,Y
--TODO: 2. proccess2: compute state

end architecture;
