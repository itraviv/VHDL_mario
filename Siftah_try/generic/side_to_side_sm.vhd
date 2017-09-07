

entity side_to_side_sm is

port(
resetObjectStartX_t : in integer;
StartSpeed : in integer;
XY : in std_logic; -- indicates if this dude is for x or for y.
randAgain : in std_logic; --option to randomize again.
ObjectStartX : out integer;
);

end entity;


architecture  arch_side_to_side_sm of side_to_side_sm is

signal leftBorder : integer ;
signal rightBorder : integer ;

signal ObjectStartX_t : integer;


begin 

--process to know borders.
process(randAgain)
begin
	if randAgain='1' then 
			
end process;




	process ( RESETn,CLK)
		begin
		if RESETn = '0' then
			ObjectStartX_t	<= resetObjectStartX_t;			
			X_speed_sig			<= StartSpeed;
		elsif CLK'event  and CLK = '1' then
				if ObjectStartX_t <= leftBorder then
					if X_speed_sig < 0 then
						X_speed_sig<= -X_speed_sig ;
					end if;
				elsif ObjectStartX_t >= rightBorder then
					if X_speed_sig > 0 then
						X_speed_sig<= -X_speed_sig ;
					end if;
				ObjectStartX	<= ObjectStartX_t ;
		end if;
end architecture;