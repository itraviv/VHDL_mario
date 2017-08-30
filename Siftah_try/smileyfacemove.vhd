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
		
		ObjectStartX	: out integer ;
		ObjectStartY	: out integer
		
	);
end smileyfacemove;

architecture behav of smileyfacemove is 
--constants 
constant resetObjectStartX_t : integer :=512;
constant resetObjectStartY_t : integer :=450;

constant leftBorder : integer := 100;
constant rightBorder : integer := 650;
constant upBorder : integer := 5 ;
constant downBorder : integer := 450 ;

constant Y_jump_speed : integer :=10;
constant Y_gravity    : integer :=1;

--state machine
type Y_state_t is (idle,onObject,jump);
signal Y_state : Y_state_t;


--speed
signal Y_speed : integer;
signal X_speed : integer;

--signals
signal ObjectStartX_t : integer range 0 to 680;
signal ObjectStartY_t : integer range 0 to 512;
begin
		process ( RESETn,CLK)
		begin
		  if RESETn = '0' then
				ObjectStartX_t	<= resetObjectStartX_t;
				X_speed <= 0;
		elsif CLK'event  and CLK = '1' then
			if timer_done = '1' then
				if ObjectStartX_t <= leftBorder then
					ObjectStartX_t <= leftBorder;
				elsif ObjectStartX_t >= rightBorder then
					ObjectStartX_t <= rightBorder;
				else
				-- X sm
				
				
				
				--
					--ObjectStartX_t  <= ObjectStartX_t - 1;					
				end if;		
			end if;
		end if;
		end process;
	
		process ( RESETn,CLK)
		begin
			if RESETn = '0' then
				ObjectStartY_t	<= resetObjectStartY_t ;
				Y_state <= idle;
				Y_speed <= 0;
			elsif CLK'event  and CLK = '1' then		
				if timer_done = '1' then			
					if ObjectStartY_t <= upBorder then
						ObjectStartY_t <= upBorder;
						Y_state <= jump;
						if Y_speed > 0 then
							Y_speed <= -Y_speed ;
						end if;
					elsif ObjectStartY_t >= downBorder and Y_state=jump and Y_speed < 0 then
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
						when others =>
						--todo
						end case;
						-- 
						ObjectStartY_t  <= ObjectStartY_t - Y_speed;
					end if;
				end if;
			end if;
		end process ;
		
ObjectStartX	<= ObjectStartX_t;			
ObjectStartY	<= ObjectStartY_t;	

end behav;