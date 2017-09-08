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
		step_X 			: in integer;
		step_Y 			: in integer;		
		hit	    : out std_logic; --indicate any hit
		leg_mid : out std_logic; -- indicate that mario legs are in the middle of the step. note: there must be  x speed!
		head_mid : out std_logic; -- indicate that mario head  is in the middle of the step. note: there must be  x speed!
		mario_mid : out std_logic;
		step_Y_O : out integer
	);
end hit_detector;	
	
	
architecture arch_hit_detector of hit_detector is
constant step_size 		: integer := 40;
constant player_size_Y 	: integer := 26;
constant player_size_X 	: integer := 18;

constant hit_margin_Y		: integer := 10;
		begin
	process(CLK,RESETn)
	--variable all_hit : std_logic:=0;
	--variable falling_hit : std_logic:=0;
	--variable rising_hit : std_logic:=0;
	
	variable legs_up : std_logic;
	variable legs_down : std_logic;
	variable head_up : std_logic;
	variable head_down : std_logic;
	variable hit_x : std_logic;
	begin
	if RESETn = '0' then
		hit 	<= '0';
		leg_mid  <= '0';
		head_mid <= '0';
		mario_mid <= '0';
		--step_Y_O <= 0;
	elsif rising_edge (CLK ) then	
		hit <= '0';
		leg_mid  <= '0';
		head_mid <= '0';
		mario_mid <= '0';
		--step_Y_O <= 0;
		
		head_up :='0';
		head_down :='0';
		legs_up :='0';
		legs_down:='0';
		hit_x :='0';
		
		-- ///////////// checking if the player is in the hit zone  - BEGIN//////////////
		
		--first, check if player is in x_range
		if (player_X >= step_X) and (player_X < step_X + step_size) then 
			hit <= '1';
			hit_x:='1';
		end if;
		
		if (player_X + player_size_X >= step_X) and (player_X + player_size_X < step_X + step_size) then
			hit <= '1';
			hit_x:='1';
		end if;
		
		--then, check if Y is out of bound
		if player_Y > step_Y + hit_margin_Y then -- below step
			hit <= '0';
		end if;
		
		if player_Y < (step_Y - player_size_Y) then -- above step
			hit <= '0';
			legs_up:='1';
		end if;
		
		-- ///////////// checking if the player is in the hit zone  - END//////////////
		
		
		if player_Y + player_size_Y >= step_Y + hit_margin_Y then
			legs_down:='1' ; -- mario legs are bellow the Y margin of the step
		end if;
		if player_Y <= step_Y then
			head_up:='1';
		end if;
		if player_Y + player_size_Y > step_Y + hit_margin_Y then
			head_down:='1';
		end if;
				
				
				
		if hit_x='1' then 
			if legs_up='0' and legs_down='0' then --legs are in the middle of the step
			--TODO:
				leg_mid <= '1';
			end if;
			
			if head_up='0' and head_down='0' then -- head is in the middle of the step
				head_mid <='1';
			end if;
			
			if head_up='1' and legs_down='1' then --mario is in the middle of the object!
				mario_mid <='1';
			end if;
		end if;
	end if ;
	end process;	
	step_Y_O <= step_Y;
end architecture;


		--EXPERIMENTAL
		--if player_Y + player_size_Y > step_Y + hit_margin_Y and (player_Y <= step_Y or (player_Y <= step_Y+hit_margin_Y ) )  then
			--hit <= '0';
		--end if;
		
		