library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;
-- Alex Grinshpun March 24 2017 

entity smileyfacemove is
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
		hitObjMidLegs	: in std_logic;

		hitObjBottom    : in std_logic;
		hitObjYspeed    : in integer;
		hitObjXspeed    : in integer;
		
		ObjectStartX	: out integer ;
		ObjectStartY	: out integer
		
	);
end smileyfacemove;

architecture behav of smileyfacemove is 
--constants 
constant resetObjectStartX_t : integer :=512;
constant resetObjectStartY_t : integer :=450;

constant leftBorder : integer := 100;
constant rightBorder : integer := 550;
constant upBorder : integer := 5 ;
constant downBorder : integer := 450 ;

constant Y_jump_speed : integer :=15;
constant Y_gravity    : integer :=1;

constant X_move_speed1 : integer := 1 ;
constant X_inc_speed : integer := 1 ;
constant X_move_speed_max : integer := 5 ;



--state machine
type Y_state_t is (idle,onObject,jump,bump_from_object);
signal Y_state : Y_state_t;

type X_state_t is (normal,onObject,bump_from_object);
signal X_state : X_state_t;


--speed
signal Y_speed : integer;
signal X_speed : integer;

--signals
signal ObjectStartX_t : integer range 0 to 680;
signal ObjectStartY_t : integer range 0 to 512;
begin
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
				if ObjectStartX_t <= leftBorder then
					if X_speed < 0 then
						X_speed<= -X_speed ;
					end if;
				elsif ObjectStartX_t >= rightBorder then
					if X_speed > 0 then
						X_speed<= -X_speed ;
					end if;
				else
				-- X sm
				case X_state is
				when onObject => 
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
			end if;	
				
				if update_location='1' then
					ObjectStartX_t  <= ObjectStartX_t + X_speed;
				end if;

			end if;
		end if;
		end process;
	
		process ( RESETn,CLK)
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
					
					if ObjectStartY_t <= upBorder then
						ObjectStartY_t <= upBorder;
						Y_state <= jump;
						if Y_speed > 0 then
							Y_speed <= -Y_speed ;
						end if;
					elsif ObjectStartY_t >= downBorder and Y_state=jump and Y_speed < 0 then -- comming back from a fly
						ObjectStartY_t <= downBorder;
						Y_state <= idle;
						Y_speed <= 0;
					else
						-- Y sm
						case Y_state is
						when idle => 
						Y_speed <= 0;
						if upKeyPressed='1' then
							Y_state <= jump;
							Y_speed <= Y_jump_speed;
						end if;
						when jump =>
							Y_speed <= Y_speed-Y_gravity;
							if hitObjBottom='1' then
								update_location:='0';
								--Y_state<=onObject;
								if Y_speed > 0 then 
									Y_speed<=0;
									Y_state<=bump_from_object;
								else
									Y_speed<=0;
									Y_state<=onObject;
									if hitObjMid='1' then
										Y_state<=jump;
									end if;
								end if;
							end if;
							-- HEERERER
			  
						when onObject =>
							if hitObjBottom='0' then
								Y_state<=bump_from_object;
								Y_speed<=0;
							else
								Y_speed<=hitObjYspeed;
								if upKeyPressed='1' then
									Y_state <= bump_from_object;
									Y_speed <= hitObjYspeed+Y_jump_speed;
								end if;
							end if;

						when bump_from_object =>
							Y_speed <= Y_speed-Y_gravity;
							if hitObjBottom='0' then
								Y_state<=jump;
							end if;
						end case;
						-- update location
						if update_location='1' then --alwyas, except when hitting objects in jump mode
							ObjectStartY_t  <= ObjectStartY_t - Y_speed;
						end if;
					end if;
				end if;
			end if;
		end process ;
		
ObjectStartX	<= ObjectStartX_t;			
ObjectStartY	<= ObjectStartY_t;	

end behav;