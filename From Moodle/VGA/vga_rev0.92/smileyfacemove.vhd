library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
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



signal ObjectStartX_t : integer range 0 to 680;
signal ObjectStartY_t : integer range 0 to 512;
begin





		process ( RESETn,CLK)
		begin
		  if RESETn = '0' then
				ObjectStartX_t	<= 580;
				ObjectStartY_t	<= 385 ;
		elsif CLK'event  and CLK = '1' then
			if timer_done = '1' then
				if ObjectStartX_t <= 100 then
					ObjectStartX_t <= 580;
					ObjectStartY_t <= 385;
				else
					ObjectStartX_t  <= ObjectStartY_t*ObjectStartY_t/256;
					ObjectStartY_t  <= ObjectStartY_t - 1;
				end if;
			end if;
			
		end if;
		end process ;
ObjectStartX	<= ObjectStartX_t;			
ObjectStartY	<= ObjectStartY_t;	

--ObjectStartX	<= 100;			
--ObjectStartY	<= 100;		
end behav;