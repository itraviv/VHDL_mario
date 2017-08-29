library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity	Reset_Delay is 
port (
	iCLK	: in std_logic;
	oRESET	: out std_logic);
end entity;

architecture behav of Reset_Delay is

signal Cont : std_logic_vector(19 downto 0) := "11111111111110000000";
begin

process(iCLK)
begin
	if rising_edge (iCLK) then
		if ( Cont = "11111111111111111111" ) then
			oRESET	<=	'1';
		else
			Cont	<=	Cont+1;
			oRESET	<=	'0';
		end if;
	end if;
end process;

end behav;