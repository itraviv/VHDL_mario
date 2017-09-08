library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity object_hit_detector is 
	port( 
		ObjectStartX	: in std_logic_vector(8 downto 0);
		ObjectStartY 	: in std_logic_vector(8 downto 0);
		MarioStartX		: in integer;
		MarioStartY		: in integer;
		CLK				: in std_logic;
		RESETn			: in std_logic;
		hit				: out std_logic
		);
		
		
end object_hit_detector;
		
architecture arch_hit_detector of object_hit_detector is
constant object_size_x	: integer := 31;
constant player_size_Y 	: integer := 26;
constant player_size_X 	: integer := 18;
constant object_size_y	: integer := 31;
		
	begin
	process(CLK,RESETn)
	begin
	if RESETn = '0' then
		hit 	<= '0';
	elsif rising_edge (CLK ) then	
		hit <= '0';
		-- ///////////// checking if the player is in the hit zone  - BEGIN//////////////
		
		--first, check if player is in x_range
		if (MarioStartX >= ObjectStartX) and (MarioStartX < ObjectStartX + object_size_x) then 
			hit <= '1';
		end if;
		
		if (MarioStartX + player_size_X >= ObjectStartX) and (MarioStartX + player_size_X < ObjectStartX + object_size_x) then
			hit <= '1';
		end if;
		
		--then, check if Y is out of bound
		if MarioStartY > ObjectStartY + object_size_y then
			hit <= '0';
		end if;
		
		if MarioStartY < (ObjectStartY - player_size_Y) then
			hit <= '0';
		end if;
		
		-- ///////////// checking if the player is in the hit zone  - END//////////////
		
	end if ;
	end process;
	
end architecture;
		
		
		
		
		
		
		