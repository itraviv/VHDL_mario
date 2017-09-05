library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_signed.all; 
use ieee.std_logic_arith.all;



entity TCtoOB is
	port( 
	TC : in std_logic_vector(7 downto 0);
	OB : out std_logic_vector(7 downto 0));
end entity;


architecture arch_TCtoOB of TCtoOB is
begin
	OB <= ((not(TC(7))) & TC(6 downto 0)); 

end architecture;