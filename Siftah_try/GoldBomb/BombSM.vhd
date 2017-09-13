library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_signed.all;
use ieee.std_logic_arith.all;


entity BombSM is
port 	(
		--////////////////////	Clock Input	 	////////////////////	 
		CLK				: in std_logic; --						//	27 MHz
		RESETn			: in std_logic; --			//	50 MHz
		timer_done		: in std_logic;
		random			: in std_logic_vector(8 downto 0);
		random2			: in std_logic_vector(8 downto 0);
		allowedToMove   : in std_logic;
		hit				: in std_logic;
		IENABLE			: in std_logic;
		
		ObjectStartX	: out std_logic_vector(8 downto 0) ;
		ObjectStartY	: out std_logic_vector(8 downto 0);
		enable 			: out std_logic
	);
end BombSM;

architecture arch_BombSM of BombSM is 
--state machine
type bomb_state_t is (start,idle,rand_speeds,move,dead);
signal state : bomb_state_t;

signal ObjectStartX_t : std_logic_vector(8 downto 0);
signal ObjectStartY_t : std_logic_vector(8 downto 0);

signal Y_speed_sig : std_logic_vector(2 downto 0);
signal X_speed_sig : std_logic_vector(2 downto 0);

begin
	process ( RESETn,CLK,IENABLE)
		variable helper : std_logic_Vector( 8 downto 0);
		begin
		  if RESETn = '0' then
			Y_speed_sig <= (others => '0');
			X_speed_sig <=(others => '0');
			ObjectStartY_t <= (others => '0');
			ObjectStartX_t <= (others => '0');
			state<=start;
			enable <='1';
		elsif IENABLE ='0' then 
			state<=dead;
		elsif CLK'event  and CLK = '1' then
			if timer_done = '1' then
				if hit='1' then
					state <= dead;
					enable <= '0';
				else
					case state is
					when start =>
						ObjectStartX_t <= random ; 
						ObjectStartY_t <= random2 ; 
						if allowedToMove='1' then 
							state <= rand_speeds;
						else
							state <= idle;
						end if;
						
					when idle =>
						ObjectStartX_t	<= ObjectStartX_t;
						ObjectStartY_t	<= ObjectStartY_t;
					when rand_speeds =>
						Y_speed_sig(2 downto 0) <= random(2 downto 0);
						X_speed_sig(2 downto 0) <= random2(2 downto 0);
						state <= move;
						
					when move =>
						ObjectStartX_t	<= ObjectStartX_t + conv_integer(X_speed_sig) ;
						ObjectStartY_t	<= ObjectStartY_t - conv_integer(Y_speed_sig)  ;
					when dead =>
						enable <='0';
					end case;
				end if;
			end if; --timer done
		end if; --CLK'event
		end process ;
		
		--ObjectStartX	<= conv_std_logic_vector(ObjectStartX_t,9) ;
		--ObjectStartY	<= conv_std_logic_vector(ObjectStartY_t,9) ;
		ObjectStartY<=ObjectStartY_t;
		ObjectStartX<=ObjectStartX_t;

		
end arch_BombSM;