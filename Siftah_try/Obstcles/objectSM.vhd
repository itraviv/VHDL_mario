library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_ARITH.all;



entity objectSM is
port 	(
		--////////////////////	Clock Input	 	////////////////////	 
		CLK				: in std_logic; --						//	27 MHz
		RESETn			: in std_logic; --			//	50 MHz
		timer_done		: in std_logic;
		
		InSpeedX		: in std_logic_vector(1 downto 0);	-- initial X sppeed
		InSpeedY		: in std_logic_vector(1 downto 0); --initial Y spped
		
		resetObjectStartX_t : in STD_LOGIC_VECTOR(9 DOWNTO 0);  -- initial X position
		resetObjectStartY_t : in STD_LOGIC_VECTOR(9 DOWNTO 0); -- initial X position
		
		ObjectStartX	: out std_logic_vector(9 downto 0) ;
		ObjectStartY	: out std_logic_vector(9 downto 0);
		Y_speed			: out std_logic_vector(6 downto 0);
		X_speed			: out std_logic_vector(6 downto 0)
	);
end objectSM;

architecture behav of objectSM is 

signal ObjectStartX_t : integer;
signal ObjectStartY_t : integer;


signal Y_speed_sig : integer;
signal X_speed_sig : integer;

constant leftBorder : integer := 120;
constant rightBorder : integer := 500;
constant upBorder : integer := 120;
constant downBorder : integer := 317 ;


begin
X_speed <= conv_std_logic_vector(X_speed_sig,7);
Y_speed <= conv_std_logic_vector(Y_speed_sig,7);
		process ( RESETn,CLK)
		begin
		  if RESETn = '0' then
			ObjectStartX_t	<= conv_integer(resetObjectStartX_t);			
			X_speed_sig			<= conv_integer(InSpeedX);
		elsif CLK'event  and CLK = '1' then
			if timer_done = '1' then
			--handle my own borders.
				if ObjectStartX_t <= leftBorder then
					if X_speed_sig < 0 then
						X_speed_sig<= -X_speed_sig ;
					end if;
				elsif ObjectStartX_t >= rightBorder then
					if X_speed_sig > 0 then
						X_speed_sig<= -X_speed_sig ;
					end if;
				else
					--State machine , TODO
				end if;
				ObjectStartX_t	<= ObjectStartX_t + X_speed_sig ;
			end if; --timer done
		end if;
		end process ;
		
		process (RESETn,CLK)
		begin
		if RESETn='0' then
			ObjectStartY_t	<= conv_integer(resetObjectStartY_t);
			Y_speed_sig			<= conv_integer(InSpeedY);
		elsif CLK'event  and CLK = '1' then
			if timer_done = '1' then
			if ObjectStartY_t <= upBorder then
				if Y_speed_sig > 0 then
						Y_speed_sig<= -Y_speed_sig ;
					end if;
				elsif ObjectStartY_t >= downBorder then
					if Y_speed_sig < 0 then
						Y_speed_sig<= -Y_speed_sig ;
					end if;
				-- Y sm
				else
			end if;
				ObjectStartY_t	<= ObjectStartY_t - Y_speed_sig ;
		end if;
		end if; --timer_done
		end process;
		
		ObjectStartX	<= conv_std_logic_vector(ObjectStartX_t,10) ;
		ObjectStartY	<= conv_std_logic_vector(ObjectStartY_t,10) ;

end behav;