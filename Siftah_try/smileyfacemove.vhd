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
constant downBorder : integer := 460 ;



--signals
signal ObjectStartX_t : integer range 0 to 680;
signal ObjectStartY_t : integer range 0 to 512;
begin
		process ( RESETn,CLK)
		begin
		  if RESETn = '0' then
				ObjectStartX_t	<= resetObjectStartX_t;
		elsif CLK'event  and CLK = '1' then
			if timer_done = '1' then
				if ObjectStartX_t <= leftBorder then
					ObjectStartX_t <= leftBorder;
				elsif ObjectStartX_t >= rightBorder then
					ObjectStartX_t <= rightBorder;
				else
					ObjectStartX_t  <= ObjectStartX_t - 1;					
				end if;		
			end if;
		end if;
		end process;
	
		process ( RESETn,CLK)
		begin
			if RESETn = '0' then
				ObjectStartY_t	<= resetObjectStartY_t ;
			elsif CLK'event  and CLK = '1' then		
				if timer_done = '1' then			
					if ObjectStartY_t <= upBorder then
						ObjectStartY_t <= upBorder;
					elsif ObjectStartY_t >= downBorder then
						ObjectStartY_t <= downBorder;
					else
						ObjectStartY_t  <= ObjectStartY_t - 1;
					end if;
				end if;
			end if;
		end process ;
		
ObjectStartX	<= ObjectStartX_t;			
ObjectStartY	<= ObjectStartY_t;	

end behav;