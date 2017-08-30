-------------------------
--Module Name:
-- mario
--Description:
-- Mario state machine
--------------------------

library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_signed.all; 
use ieee.std_logic_arith.all;

entity mario is
	port( 
		resetN : in std_logic;
		clk : in std_logic;
		pressedKey : in std_logic_vector(8 downto 0);
		iHit : in std_logic ; -- tells if mario hits gold/bomb
		iHitObj : in std_logic;  -- tells if mario hits obstcle
		imake : in std_logic;
		ibreak : in std_logic;
		X_ObjSpeed : in integer;
		Y_ObjSpeed : in integer;
		
		--X: out std_logic_vector(31 downto 0) ; 
		--Y: out std_logic_vector(31 downto 0)	
		X: out integer ; 
		Y: out integer ;
		out_ledd : out std_logic

		);
end entity;

architecture arch_mario of mario is
constant up_in_jump : integer := -5;
constant x_speed_in_press : integer := 1;
constant gravity_const : integer :=-1;

type Y_state_t is (idle,onObject,jump);

signal Y_state : Y_state_t;
signal X_base_speed : integer;
signal Y_base_speed : integer;
signal sigX : integer;
signal sigY : integer;

constant rightKey : std_logic_vector(8 downto 0) :="101110100";
constant leftKey : std_logic_vector(8 downto 0) :="101101011";
constant upKey : std_logic_vector(8 downto 0) := "101110101" ;

constant groundLvl : integer := 460;

signal out_led : std_logic;
begin
out_ledd <=out_led;
--compute Y_state
process(clk,resetN)
variable X_speed : integer;
variable Y_speed : integer;
variable pressed : std_logic;
begin
	if resetN = '0' then 
		X_base_speed <= 0;
		Y_base_speed <= 0;
		X_speed := 0;
		Y_speed := 0;
		Y_state <= idle;
		pressed := '0';
		sigX <= 320;
		sigY <= groundLvl;
	elsif rising_edge(clk) then
		
		-- take care of pressed
		if pressed='0' and imake='1' then
			pressed := '1';
		elsif pressed='1' and ibreak='1' then
			pressed:='0';
		else
			pressed:='0';
		end if;
		
		case Y_state is
			--jump
			when jump =>
			
			if sigY = groundLvl then
				Y_speed :=0;
				X_speed :=0;
				Y_state <= idle;
			else
				Y_speed := Y_speed-gravity_const;
				if pressedKey = leftKey and pressed = '1' then --left key
					if X_speed <= 0 then --moving left or standing
						X_speed := X_speed - x_speed_in_press;
					else -- moving right
						X_speed := 0;	
					end if;
				elsif pressedKey = rightKey and pressed = '1'  then --right key
					if X_speed >= 0 then --moving right or standing
						X_speed := X_speed + x_speed_in_press;	
					else -- moving left
						X_speed := 0;
					end if;
				end if;
			end if;	
			-- on object, idle
			when others =>
				if pressedKey = upKey and pressed = '1' then -- up key
					Y_state <= jump;
					Y_speed := Y_speed+up_in_jump;
					X_base_speed <= 0;
					Y_base_speed <= 0;
					--handle pressed left or right while on object
				elsif pressedKey = leftKey and pressed ='1' then --left key
					if X_speed = 0 then --moving left or standing
						X_speed := X_speed - x_speed_in_press;
					else -- moving right
						X_speed := X_base_speed;	
					end if;
				elsif pressedKey = rightKey and pressed ='1' then --right key
					if X_speed >= 0 then --moving right or standing
						X_speed := X_speed + x_speed_in_press;	
					else -- moving left
						X_speed := X_base_speed;
					end if;
				end if;
		end case;
									--compute new X,Y
			if((sigX+X_speed) > 640) then
				sigX <= 640;
			elsif (sigX+X_speed < 0) then 
				sigX<=0;
			else
				sigX <= sigX+X_speed;
			end if;
	
			if((sigY+Y_speed) < 0) then
				sigY <= 0;
			elsif (sigY+Y_speed >460) then 
				sigY<=460;
			else
				sigY <= sigY+Y_speed;
			end if;			
	end if; --resetn
end process;
X<=sigX;
Y<=sigY;
end architecture;
