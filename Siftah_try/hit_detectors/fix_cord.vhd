library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;


entity fix_cord is 
port(


enable	: in std_logic;
mario_cord_Y : in integer;
mario_speed_Y : in integer;
Obj_cord_Y : in integer;
Obj_speed_Y : in integer;


mario_cord_X : in integer;
--mario_speed_X : in integer;
Obj_cord_X : in integer;
--Obj_speed_X : in integer;


fix : out std_logic;
mario_new_cord_Y : out integer

);

end entity;



architecture arch_fix_cord of fix_cord is
constant Y_margin : integer :=4;
constant gravity : integer:=1;
	signal obj_new_position : integer;
	signal mario_new_position : integer;
	signal async_hit :  std_logic;
	signal async_leg_mid :  std_logic;
	signal async_head_mid : std_logic;
	signal async_mario_mid :  std_logic;
	constant mario_y_size : integer:=26;

component async_hit_detector is
port 	(
		RESETn	: in std_logic;
		player_X 		: in integer;
		player_Y 		: in integer;
		step_X 			: in integer;
		step_Y 			: in integer;		
		hit	    : out std_logic; --indicate any hit
		leg_mid : out std_logic; -- indicate that mario legs are in the middle of the step. note: there must be  x speed!
		head_mid : out std_logic; -- indicate that mario legs are in the middle of the step. note: there must be  x speed!
		mario_mid : out std_logic);
		
end component;

begin
A1: async_hit_detector port map('1',mario_cord_X,mario_new_position,Obj_cord_X,obj_new_position,async_hit,async_leg_mid,async_head_mid,async_mario_mid);

	process(enable,mario_cord_Y,mario_speed_Y,Obj_cord_X)
	--variable mario_new_position : integer;
	variable mario_new_speed : integer;
	
	begin
	if enable='1' then
		mario_new_speed:=0;
		if mario_speed_Y >= 0 then 
			mario_new_speed := mario_speed_Y-gravity;
		else 
			mario_new_speed:=mario_speed_Y-gravity; --todo add saturation
		end if;
		
	
		obj_new_position<= Obj_cord_Y - Obj_speed_Y; --note - this is for Y
		mario_new_position<=mario_cord_Y-mario_new_speed;
	end if;

	end process;


	process(enable,async_hit,async_leg_mid,async_mario_mid)
	BEGIN
	if enable='1' and async_mario_mid='1' then
		mario_new_cord_Y<=obj_new_position-mario_y_size;
		fix<='1';
	else
		fix <= '0';
	end if;
	END process;

end architecture;