library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity hit_detector is
port 	(
		CLK  : in std_logic;
		RESETn	: in std_logic;
		player_X 		: in integer;
		player_Y 		: in integer;
		player_up		: in std_logic;
		step_X 			: in integer;
		step_Y 			: in integer;		
		hit	    : out std_logic
	);
end hit_detector;	
	
	
architecture arch_hit_detector of hit_detector is
constant step_size 		: integer := 40;
constant player_size_Y 	: integer := 26;
constant player_size_X 	: integer := 18;

constant hit_margin_Y		: integer := 4;
		begin
	process(CLK,RESETn)
	begin
	if RESETn = '0' then
		hit 	<= '0';
	elsif rising_edge (CLK ) then	
		hit <= '0';
		-- ///////////// checking if the player is in the hit zone  - BEGIN//////////////
		
		--first, check if player is in x_range
		if (player_X >= step_X) and (player_X < step_X + step_size) then 
			hit <= '1';
		end if;
		
		if (player_X + player_size_X >= step_X) and (player_X + player_size_X < step_X + step_size) then
			hit <= '1';
		end if;
		
		--then, check if Y is out of bound
		if player_Y > step_Y + hit_margin_Y then
			hit <= '0';
		end if;
		
		if player_Y < (step_Y - player_size_Y) then
			hit <= '0';
		end if;
		
		-- ///////////// checking if the player is in the hit zone  - END//////////////
		
	end if ;
	end process;
	
end architecture;