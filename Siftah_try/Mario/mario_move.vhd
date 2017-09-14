library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_ARITH.all;

entity mario_move is
port 	(
		--////////////////////	Clock Input	 	////////////////////	 
		CLK				: in std_logic; --						//	27 MHz
		RESETn			: in std_logic; --			//	50 MHz
		timer_done		: in std_logic;
		--//////////////////  Key Presses ////////////////////////
		upKeyPressed    : in std_logic;		
		leftKeyPressed  : in std_logic;
		rightKeyPressed : in std_logic;
		
		hitObjMid		: in std_logic;
		hitObjWithMyBottomPixel	: in std_logic;
		hitObjAny   	 : in std_logic;
		
		hitObjYspeed    : in std_logic_vector(6 downto 0);
		hitObjXspeed    : in std_logic_vector(6 downto 0);
		hitObjYpos		: in std_logic_vector(9 downto 0);
		
		
		ObjectStartX	: out std_logic_vector(9 downto 0) ;
		ObjectStartY	: out std_logic_vector(9 downto 0)
		
	);
end mario_move;

architecture arch_mario_move of mario_move is 
--constants 
constant resetObjectStartX_t : integer :=550; -- reset x : in the safe zone!
constant resetObjectStartY_t : integer :=417;

constant leftBorder : integer := 10;
constant rightBorder : integer := 600;
constant upBorder : integer := 5 ;
constant downBorder : integer := 417 ;

constant Y_jump_speed : integer :=15;
constant Y_gravity    : integer :=1;
constant Y_move_speed_min : integer := -15 ;

constant X_move_speed1 : integer := 1 ;
constant X_inc_speed : integer := 1 ;
constant X_move_speed_max : integer := 5 ;
constant mario_Y_size :integer :=33;


--state machine
type Y_state_t is (idle,onObject,jump,bump_from_object);
signal Y_state : Y_state_t;

type X_state_t is (normal,bump_from_object); --onObjec? decided to remove this.
signal X_state : X_state_t;


--speed
signal Y_speed : integer;
signal X_speed : integer;

--signals
signal ObjectStartX_t : integer range 0 to 680;
signal ObjectStartY_t : integer range 0 to 512;
begin

-----------------------------
-- This proccess is for Y ---
-----------------------------
		process ( RESETn,CLK,hitObjMid)
		variable update_location : std_logic;
		
		begin
			if RESETn = '0' then
				ObjectStartY_t	<= resetObjectStartY_t ;
				Y_state <= idle;
				Y_speed <= 0;
				update_location:='0';
			elsif CLK'event  and CLK = '1' then		
				if timer_done = '1' then		
				
				update_location:='1'; -- default	
						-- Y sm
						case Y_state is
-----------------------------------------------------------------------------------------------------------						
						when idle => 
						Y_speed <= 0;
						if upKeyPressed='1' then
							Y_state <= jump;
							Y_speed <= Y_jump_speed;
						end if;
-----------------------------------------------------------------------------------------------------------						
						when jump =>
							if Y_speed-Y_gravity <= Y_move_speed_min then -- saturation in Y speed.
								Y_speed <= Y_move_speed_min;
							else
								Y_speed <= Y_speed-Y_gravity;
							end if;
							if hitObjAny='1' then
								update_location:='0';
								if Y_speed > 0 then --hiting object from below
									Y_speed<=0;
									Y_state<=bump_from_object;
								elsif Y_speed <= 0 then --hitting object from above
									Y_speed<=conv_integer(hitObjYspeed);
									Y_state<=onObject;
									ObjectStartY_t <= conv_integer(hitObjYpos) - mario_Y_size - conv_integer(hitObjYspeed); -- stand on object
								end if;
							end if;
-----------------------------------------------------------------------------------------------------------
						when onObject =>
							Y_speed<=conv_integer(hitObjYspeed);
							if hitObjAny='0' then 		-- no more contact
								Y_state<=bump_from_object;
								Y_speed<=0;
							else						--contact
								Y_speed<=conv_integer(hitObjYspeed); -- move with object
								if upKeyPressed='1' then
									Y_state <= bump_from_object;
									Y_speed <= conv_integer(hitObjYspeed)+Y_jump_speed;
								end if;
							end if;
							if hitObjMid='1' then		--object is in the middle of mario! fix
								ObjectStartY_t <= conv_integer(hitObjYpos) - mario_Y_size - conv_integer(hitObjYspeed);	
							end if;
-----------------------------------------------------------------------------------------------------------
						when bump_from_object => 
							Y_speed <= Y_speed-Y_gravity;
							if hitObjAny='0' then
								Y_state<=jump;
							end if;
-----------------------------------------------------------------------------------------------------------							
						end case;
						-- update location
						if update_location='1' then --alwyas, except when hitting objects in jump mode
						-- staturation in location
							if ObjectStartY_t - Y_speed > downBorder then
								ObjectStartY_t  <= downBorder;
								Y_state <= idle;
								Y_speed <= 0;
							elsif ObjectStartY_t - Y_speed <  upBorder then
								ObjectStartY_t  <= upBorder;
								Y_state <= jump;
								if Y_speed > 0 then
									Y_speed <= -Y_speed ;
								end if;
							else
								ObjectStartY_t  <= ObjectStartY_t - Y_speed;
							end if;
							
						end if;
				end if;
			end if;
		end process ;


-----------------------------
-- This proccess is for X ---
-----------------------------
		process ( RESETn,CLK)
		variable update_location : std_logic;
		begin
		  if RESETn = '0' then
				ObjectStartX_t	<= resetObjectStartX_t;
				X_speed <= 0;
				X_state <= normal;
				update_location:='0';
		elsif CLK'event  and CLK = '1' then
			update_location:='1';
			if timer_done = '1' then
				-- X sm
				case X_state is
				--when onObject => 
				--todo
				when normal =>
					if rightKeyPressed='1' then
						if X_speed = 0 then
							X_speed <= X_move_speed1;
						elsif X_speed < 0 then
							X_speed <=0 ;
						elsif X_speed < X_move_speed_max then
							X_speed <= X_speed + X_inc_speed;
						end if;
					elsif leftKeyPressed='1' then
						if X_speed = 0 then
							X_speed <= -X_move_speed1;
						elsif X_speed > 0 then
							X_speed <= 0;
						elsif X_speed > -X_move_speed_max then
							X_speed <= X_speed - X_inc_speed;
						end if;
					end if;
					if hitObjMid='1' then -- bump
						update_location:='0';
						X_speed <= -X_speed;
						X_state <= bump_from_object;
					end if;
				when bump_from_object=>
					if hitObjMid ='0' then
						X_state <= normal;
					end if;
				end case;	
				
				if update_location='1' then
			--saturation in location
					if ObjectStartX_t + X_speed > rightBorder then
						ObjectStartX_t  <=rightBorder;
						if X_speed > 0 then
							X_speed<= -X_speed ;
						end if;
					elsif ObjectStartX_t + X_speed <  leftBorder then
						ObjectStartX_t  <=leftBorder;
						if X_speed < 0 then
							X_speed<= -X_speed ;
						end if;
					else
						ObjectStartX_t  <= ObjectStartX_t + X_speed;
					end if;
				end if;
			end if;	-- timer_done

		end if;
		end process;
	

		
ObjectStartX	<= conv_std_logic_vector(ObjectStartX_t,10);			
ObjectStartY	<= conv_std_logic_vector(ObjectStartY_t,10);	

end architecture;