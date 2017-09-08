library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mux_int is
port(
in1 : in integer;
in2 : in integer;
sel : in std_logic;
dout : out integer
);
end entity;


architecture arch_mux_int of mux_int is 
begin


dout <= in1 when sel='0' else in2;


end architecture; 