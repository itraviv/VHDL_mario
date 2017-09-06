library ieee ; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;


entity mux_CASE is
-----------------------------------------------------
port (
ind  : in std_logic_vector(2 downto 0) ;
sel  : in std_logic_vector(1 downto 0) ;
outd : out std_logic );
END mux_CASE;



architecture arch_mux_CASE of mux_CASE is
begin
	process(ind,sel)
	begin
		case sel is 
			when "0" => outd <= ind(0) ;
			when "01" => outd <= ind(1) ; 
			when "10" => outd <= ind(2) ; 
			when others => outd <= 'X' ;
		end case ;
	end process ;
end architecture ;