library ieee ; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;


entity mux_CASE is
-----------------------------------------------------
port (
in0  : in std_logic_vector(7 downto 0) ;
in1  : in std_logic_vector(7 downto 0) ;
in2  : in std_logic_vector(7 downto 0) ;
in3  : in std_logic_vector(7 downto 0) ;
sel  : in std_logic_vector(1 downto 0) ;
outd : out std_logic_vector(7 downto 0)
);
END mux_CASE;



architecture arch_mux_CASE of mux_CASE is
begin
	process(in0,in1,in2,in3,sel)
	begin
		case sel is 
			when "00" => outd <= in0 ;
			when "01" => outd <= in1 ; 
			when "10" => outd <= in2 ; 
			when "11" => outd <= in3 ;
		end case ;
	end process ;
end architecture ;