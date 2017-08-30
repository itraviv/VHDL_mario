library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity kbd_translate is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
		RESETn: in std_logic;
		clk : in std_logic;
	   dIN  : in std_logic_vector (8 downto 0);
	   make : in std_logic ;
	   break : in std_logic ;
	   left_press : out std_logic ;
	   right_press : out std_logic ;
	   up_press : out std_logic 
	);
end kbd_translate;

architecture behav of kbd_translate is 
begin
		
process(resetN,make,break,dIN)
begin

if RESETn = '0' then
left_press <= '0';
right_press <= '0';
up_press <= '0';
elsif clk'event and clk='1' then
	if (dIN(7 downto 0) = x"6B" and make = '1') then
			left_press <= '1' ;
			right_press <= '0' ;
	elsif (dIN(7 downto 0) = x"74" and make = '1') then
			right_press <= '1' ;
			left_press <= '0' ;
	elsif (dIN(7 downto 0) = x"6B" and break = '1') then
			left_press <= '0' ;
	elsif (dIN(7 downto 0) = x"74" and break = '1') then
			right_press <= '0' ;
	end if;
	
	if (dIN(7 downto 0) = x"75" and make = '1') then
		up_press <= '1';
	elsif (dIN(7 downto 0) = x"75" and break = '1') then
		up_press <= '0';
	end if;
end if;
end process;

		
end behav;		