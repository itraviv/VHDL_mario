-------------------------
--Module Name:
-- Random XY
--Description:
-- generates random XY for creating gold/bomb,
-- gets obstcl X,Y in order to not create a bomb on it.
--------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity RandomXY is
port (	
		--////////////////////	Clock Input	 	////////////////////	
	   	CLK  		: in std_logic;
		RESETn		: in std_logic;
		obstcl_X: in std_logic_vector(31 downto 0) ; 
		obstcl_Y: in std_logic_vector(31 downto 0) ;
		ObjectStartX	: out integer;
		ObjectStartY 	: out integer
	);
end entity;

architecture arch_RandomXY of RandomXY is

begin
end architecture;