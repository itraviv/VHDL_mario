library ieee ;
use ieee.std_logic_unsigned.all ;
use ieee.std_logic_1164.all ;
use IEEE.std_logic_arith.all ;

entity stage_counter is
	port (CLK : in std_logic ;
			ResetN : in std_logic ;
			Q  : out std_logic_vector(4 downto 0)) ;
end entity ;

architecture arc_stage_counter of stage_counter is 
signal counter : std_logic_vector(4 downto 0) := "00000" ;
begin
	Q <= counter ;
	process(CLK,ResetN)
	begin
		if ResetN = '0' then
			counter <= (others => '0') ;
		elsif rising_edge(CLK) then
			if counter = "11111" then
				counter <= (others => '1') ; -- saturate
			else
				counter <= counter(3 downto 0) & '1'; --shift left with 1
			end if ;
		end if ;
	end process;

end architecture;