library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;
-- Alex Grinshpun March 24 2017 

entity objectSM is
port 	(
		--////////////////////	Clock Input	 	////////////////////	 
		CLK				: in std_logic; --						//	27 MHz
		RESETn			: in std_logic; --			//	50 MHz
		timer_done		: in std_logic;
		
		InSpeedX		: in std_logic_vector(1 downto 0);	-- initial X sppeed
		InSpeedY		: in std_logic_vector(1 downto 0); --initial Y spped
		
		resetObjectStartX_t : in integer;  -- initial X position
		resetObjectStartY_t : in integer; -- initial X position
		
		ObjectStartX	: out integer ;
		ObjectStartY	: out integer;
		Y_speed			: out integer;
		X_speed			: out integer
	);
end objectSM;

architecture behav of objectSM is 

signal ObjectStartX_t : integer;
signal ObjectStartY_t : integer;


signal Y_speed_sig : integer;
signal X_speed_sig : integer;

--constant resetObjectStartX_t : integer :=300;
--constant resetObjectStartY_t : integer :=420;

constant leftBorder : integer := 120;
constant rightBorder : integer := 500;
constant upBorder : integer := 300;
constant downBorder : integer := 440 ;


begin
--X_speed_sig<=0;
X_speed <= X_speed_sig;
Y_speed <= Y_speed_sig;
		process ( RESETn,CLK)
		begin
		  if RESETn = '0' then
			ObjectStartX_t	<= resetObjectStartX_t;			
			X_speed_sig			<= conv_integer(InSpeedX);
		elsif CLK'event  and CLK = '1' then
			if timer_done = '1' then
			--handle my own borders.
				if ObjectStartX_t <= leftBorder then
					if X_speed_sig < 0 then
						X_speed_sig<= -X_speed_sig ;
					end if;
				elsif ObjectStartX_t >= rightBorder then
					if X_speed_sig > 0 then
						X_speed_sig<= -X_speed_sig ;
					end if;
				else
					--State machine , TODO
				end if;
				ObjectStartX_t	<= ObjectStartX_t + X_speed_sig ;
			end if; --timer done
		end if;
		end process ;
		
		process (RESETn,CLK)
		begin
		if RESETn='0' then
			ObjectStartY_t	<= resetObjectStartY_t;
			Y_speed_sig			<= conv_integer(InSpeedY);
		elsif CLK'event  and CLK = '1' then
			if timer_done = '1' then
			if ObjectStartY_t <= upBorder then
				if Y_speed_sig > 0 then
						Y_speed_sig<= -Y_speed_sig ;
					end if;
				elsif ObjectStartY_t >= downBorder then
					if Y_speed_sig < 0 then
						Y_speed_sig<= -Y_speed_sig ;
					end if;
				-- Y sm
				else
			end if;
				ObjectStartY_t	<= ObjectStartY_t - Y_speed_sig ;
		end if;
		end if; --timer_done
		end process;
		
		ObjectStartX	<= ObjectStartX_t ;
		ObjectStartY	<= ObjectStartY_t ;
--ObjectStartX	<= 300;
--ObjectStartY	<= 420;
end behav;