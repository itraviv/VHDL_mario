library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun July 24 2017 

entity timer is
port 	(
		--////////////////////	Clock Input	 	////////////////////	 
		CLK	: in std_logic; --						//	27 MHz
		RESETn		: in std_logic; --			//	50 MHz
		VGA_VS	: in std_logic; --	,						//	VGA SYNC
		timer_done	: out std_logic
	);
end timer;

architecture behav of timer is 

signal VGA_VS_pulse : std_logic;
signal VGA_VS_d : std_logic;

signal VGA_VS_pulse_cnt : integer;
constant NUMBER_FRAMES : integer := 1;
begin



---- Timer -------
process ( RESETn,CLK)
begin
	if RESETn = '0' then
 		VGA_VS_d	<= '0';
	elsif CLK'event  and CLK = '1' then
		VGA_VS_d	<= VGA_VS;
	end if;
end process ;

--VGA_VS_pulse	<= VGA_VS and not VGA_VS_d;
VGA_VS_pulse	<= not  VGA_VS and VGA_VS_d;

process ( RESETn,CLK)
begin
  if RESETn = '0' then
    VGA_VS_pulse_cnt <= 0;
elsif CLK'event  and CLK = '1' then
	if VGA_VS_pulse = '1' then 
		if VGA_VS_pulse_cnt = NUMBER_FRAMES then
			VGA_VS_pulse_cnt <= 0;
		else
			VGA_VS_pulse_cnt  <= VGA_VS_pulse_cnt + 1;
		end if;
    
	end if;
end if;
end process ;
-- Goes up for 1 clock; can be used to slowdown the object
timer_done	<= '1' when VGA_VS_pulse_cnt = NUMBER_FRAMES and VGA_VS_pulse = '1' else '0';

end behav;
