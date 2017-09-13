
LIBRARY ieee;
USE ieee.std_logic_1164.all;


--  Entity Declaration

ENTITY Clk_Divider IS
	GENERIC(Div : integer range 0 to 50000000 := 5);
	PORT
	(
		Clk_in : IN STD_LOGIC;
		Resetn : IN STD_LOGIC;
		Clk_out : OUT STD_LOGIC
	);
	
END Clk_Divider;


--  Architecture Body

ARCHITECTURE Clk_Divider_architecture OF Clk_Divider IS
	
	signal clk_in_sig	:	std_logic;
	signal clk_out_sig	:	std_logic;
	signal clk_div_param:	integer range 0 to 50000000;

	
BEGIN

	clk_in_sig		<=	Clk_in;

	process(clk_in_sig,Resetn)
		begin
			if (Resetn = '0') then
				clk_div_param	<=	Div;
			elsif (clk_in_sig = '1' and clk_in_sig'event) then
				if (clk_div_param >= Div) then
					clk_div_param <= 0;
					clk_out_sig <= '1';
				else
					clk_div_param <= clk_div_param + 1;
					clk_out_sig <= '0';
				end if;
			end if;
	end process;
	
	Clk_out	<=	clk_out_sig;	
			

	

END Clk_Divider_architecture;
