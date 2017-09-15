library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_signed.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;


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
		
		
		-- chase
		marioX			: in std_logic_vector ( 9 downto 0);
		marioY			: in std_logic_vector ( 9 downto 0);
		
		
		luigiX			: in std_logic_vector ( 9 downto 0);
		luigiY			: in std_logic_vector ( 9 downto 0);
		
		chase			: in std_logic; -- determined if a bomb will chase mario
		
		ObjectStartX	: out std_logic_vector(8 downto 0) ;
		ObjectStartY	: out std_logic_vector(8 downto 0);
		enable 			: out std_logic
	);
end BombSM;

architecture arch_BombSM of BombSM is 
--state machine
type bomb_state_t is (start,idle,rand_speeds,move,chase_mario,chase_luigi,dead);
signal state : bomb_state_t;

signal ObjectStartX_t : std_logic_vector(8 downto 0);
signal ObjectStartY_t : std_logic_vector(8 downto 0);

signal Y_speed_sig : std_logic_vector(2 downto 0);
signal X_speed_sig : std_logic_vector(2 downto 0);


begin
	process ( RESETn,CLK,IENABLE)
		variable helperM : std_logic_Vector( 10 downto 0);
		variable helperPos : std_logic_Vector( 10 downto 0);

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
						Y_speed_sig(1 downto 0) <= random(1 downto 0);
						X_speed_sig(1 downto 0) <= random2(1 downto 0);
						
						if chase='0' then
							state <= move;
							--allow higher speeds
							X_speed_sig(2) <= random(2);
							Y_speed_sig(2) <= random2(2);
						else
						-- allow lower speeds only
							X_speed_sig(2) <= random(1);
							Y_speed_sig(2) <= random2(1);
							
							if random(4) = '0' then 
								state <= chase_mario;
							else
								state <= chase_luigi;
							end if;
						end if;
						
					when move =>
					if chase='0' then
						ObjectStartX_t	<= ObjectStartX_t + conv_integer(X_speed_sig)  ;
						ObjectStartY_t	<= ObjectStartY_t - conv_integer(Y_speed_sig)  ;
					else
						state <= rand_speeds;
					end if;
					when chase_mario | chase_luigi =>
						if chase = '1' then
							helperPos := "00" & ObjectStartX_t;
							
							if state = chase_mario then
							helperM   := "0" & marioX;
							else 
							helperM   := "0" & luigiX;
							end if;

						
							if helperPos > helperM then
								ObjectStartX_t	<= ObjectStartX_t - abs(conv_integer(X_speed_sig));
							elsif  helperPos < helperM then
								ObjectStartX_t	<= ObjectStartX_t + abs(conv_integer(X_speed_sig));
							end if;
							
							helperPos := "00" & ObjectStartY_t;
							
							if state = chase_mario then
							helperM   := "0" & marioY;
							else 
							helperM   := "0" & luigiY;
							end if;
														
							
							if helperPos > helperM then
								ObjectStartY_t	<= ObjectStartY_t - abs(conv_integer(Y_speed_sig));
								elsif  helperPos < helperM then
								ObjectStartY_t	<= ObjectStartY_t + abs(conv_integer(Y_speed_sig));
							end if;			
						else -- chase = '0'
							state <= rand_speeds;
						end if;
						
					when dead =>
						enable <='0';
					end case;
				end if;
			end if; --timer done
		end if; --CLK'event
		end process ;
		
		ObjectStartY<=ObjectStartY_t;
		ObjectStartX<=ObjectStartX_t;

		
end arch_BombSM;