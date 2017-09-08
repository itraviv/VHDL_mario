-- HEX to Seven-Segment (active low) – vector out 
library ieee ; 
use ieee.std_logic_1164.all ; 

entity hexss is    
port ( din : in  std_logic_vector(3 downto 0) ;               
	   blinkN : in std_logic;
	   LAMP_TEST : in std_logic;
	   ss  : out std_logic_vector(6 downto 0) ); 
  
end hexss ; 

architecture arch_hexss of hexss is 
begin
	process(blinkN,LAMP_TEST,din)
		begin
			if blinkN = '0' then
				ss <= "1111111";
			else 
				case din is
					when "0000" => ss <= "0000001" ;
					when "0001" => ss <= "1001111" ;
					when "0010" => ss <= "0010010" ;
					when "0011" => ss <= "0000110" ;
					when "0100" => ss <= "1001100" ;
					when "0101" => ss <= "0100100" ;
					when "0110" => ss <= "0100000" ;
					when "0111" => ss <= "0001111" ;
					when "1000" => ss <= "0000000" ;
					when "1001" => ss <= "0000100" ;
					when "1010" => ss <= "0001000" ;
					when "1011" => ss <= "1100000" ;
					when "1100" => ss <= "0110001" ;
					when "1101" => ss <= "1000010" ;
					when "1110" => ss <= "0110000" ;
					when "1111" => ss <= "0111000" ;
				end case;
			end if;
	end process;
end architecture;
