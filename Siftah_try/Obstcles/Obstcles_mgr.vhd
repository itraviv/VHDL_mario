library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;


ENTITY Obstcles_mgr IS 
	PORT
	(
		CLK :  IN  STD_LOGIC;
		RESETn :  IN  STD_LOGIC;
		timer_done :  IN  STD_LOGIC;
		ENABLE :  IN  STD_LOGIC;
		oCoord_X :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		oCoord_Y :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		player_X :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		player_Y :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		
		
		player2_X :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		player2_Y :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		
		rand 	  :  IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		
		drawing_request :  OUT  STD_LOGIC;
		hit_mid :  OUT  STD_LOGIC;
		hit :  OUT  STD_LOGIC;
		hit_leg :  OUT  STD_LOGIC;
		hit_head :  OUT  STD_LOGIC;
		
		hit_mid2 :  OUT  STD_LOGIC;
		hit2 :  OUT  STD_LOGIC;
		hit_leg2 :  OUT  STD_LOGIC;
		hit_head2 :  OUT  STD_LOGIC;
				
		
		mVGA_RGB :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		step_Y :  OUT  STD_LOGIC_VECTOR(9 DOWNTO 0);
		X_object_speed :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		Y_object_speed :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		
		
		step_Y2 :  OUT  STD_LOGIC_VECTOR(9 DOWNTO 0);
		X_object_speed2 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		Y_object_speed2 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0)
		
		
	);
END Obstcles_mgr;
	

architecture arch_Obstcles_mgr of Obstcles_mgr is
COMPONENT ObstcleFull is
	PORT
	(	
		CLK :  IN  STD_LOGIC;
		RESETn :  IN  STD_LOGIC;
		timer_done :  IN  STD_LOGIC;
		ENABLE :  IN  STD_LOGIC;
		oCoord_X :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		oCoord_Y :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		player_X :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		player_Y :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		
		-- ins for player 2 BEGIN
		player2_X :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		player2_Y :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		-- ins for player 2 END
				 		 
		rand :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);

		InSpeedX		: in std_logic_vector(1 downto 0);	-- initial X sppeed
		InSpeedY		: in std_logic_vector(1 downto 0); --initial Y spped
		resetObjectStartX_t : in STD_LOGIC_VECTOR(9 DOWNTO 0);  -- initial X position
		resetObjectStartY_t : in STD_LOGIC_VECTOR(9 DOWNTO 0); -- initial X position
		
		drawing_request :  OUT  STD_LOGIC;
		hit_mid :  OUT  STD_LOGIC;
		hit :  OUT  STD_LOGIC;
		hit_leg :  OUT  STD_LOGIC;
		hit_head :  OUT  STD_LOGIC;
		
		-- outs for player 2 BEGIN
		hit_mid2 :  OUT  STD_LOGIC;
		hit2 :  OUT  STD_LOGIC;
		hit_leg2 :  OUT  STD_LOGIC;
		hit_head2 :  OUT  STD_LOGIC;
		-- outs for player 2 END

		
		mVGA_RGB :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		
		step_Y :  OUT  STD_LOGIC_VECTOR(9 DOWNTO 0);
		X_object_speed :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		Y_object_speed :  OUT  STD_LOGIC_VECTOR( 6 DOWNTO 0);	
		
		
		step_Y2 : OUT  STD_LOGIC_VECTOR(9 DOWNTO 0)
	
		
	);
END COMPONENT;

-- S_1_
signal		s_1_drawing_request :   STD_LOGIC;
signal		s_1_hit_mid :    STD_LOGIC;
signal		s_1_hit :    STD_LOGIC;
signal		s_1_hit_leg :    STD_LOGIC;
signal		s_1_hit_head :    STD_LOGIC;

signal		s_1_hit_mid2 :    STD_LOGIC;
signal		s_1_hit2 :    STD_LOGIC;
signal		s_1_hit_leg2 :    STD_LOGIC;
signal		s_1_hit_head2 :    STD_LOGIC;

signal		s_1_mVGA_RGB :    STD_LOGIC_VECTOR(7 DOWNTO 0);
signal		s_1_step_Y :    STD_LOGIC_VECTOR(9 DOWNTO 0);
signal		s_1_X_object_speed :    STD_LOGIC_VECTOR(6 DOWNTO 0);
signal		s_1_Y_object_speed :    STD_LOGIC_VECTOR(6 DOWNTO 0);


signal		s_1_step_Y2 :    STD_LOGIC_VECTOR(9 DOWNTO 0);

-- S_2_
signal		s_2_drawing_request :   STD_LOGIC;
signal		s_2_hit_mid :    STD_LOGIC;
signal		s_2_hit :    STD_LOGIC;
signal		s_2_hit_leg :    STD_LOGIC;
signal		s_2_hit_head :    STD_LOGIC;

signal		s_2_hit_mid2 :    STD_LOGIC;
signal		s_2_hit2 :    STD_LOGIC;
signal		s_2_hit_leg2 :    STD_LOGIC;
signal		s_2_hit_head2 :    STD_LOGIC;

signal		s_2_mVGA_RGB :    STD_LOGIC_VECTOR(7 DOWNTO 0);
signal		s_2_step_Y :    STD_LOGIC_VECTOR(9 DOWNTO 0);
signal		s_2_X_object_speed :    STD_LOGIC_VECTOR(6 DOWNTO 0);
signal		s_2_Y_object_speed :    STD_LOGIC_VECTOR(6 DOWNTO 0);

signal		s_2_step_Y2 :    STD_LOGIC_VECTOR(9 DOWNTO 0);


-- S_3_
signal		s_3_drawing_request :   STD_LOGIC;
signal		s_3_hit_mid :    STD_LOGIC;
signal		s_3_hit :    STD_LOGIC;
signal		s_3_hit_leg :    STD_LOGIC;
signal		s_3_hit_head :    STD_LOGIC;

signal		s_3_hit_mid2 :    STD_LOGIC;
signal		s_3_hit2 :    STD_LOGIC;
signal		s_3_hit_leg2 :    STD_LOGIC;
signal		s_3_hit_head2 :    STD_LOGIC;

signal		s_3_mVGA_RGB :    STD_LOGIC_VECTOR(7 DOWNTO 0);
signal		s_3_step_Y :    STD_LOGIC_VECTOR(9 DOWNTO 0);
signal		s_3_X_object_speed :    STD_LOGIC_VECTOR(6 DOWNTO 0);
signal		s_3_Y_object_speed :    STD_LOGIC_VECTOR(6 DOWNTO 0);

signal		s_3_step_Y2 :    STD_LOGIC_VECTOR(9 DOWNTO 0);


-- S_4_
signal		s_4_drawing_request :   STD_LOGIC;
signal		s_4_hit_mid :    STD_LOGIC;
signal		s_4_hit :    STD_LOGIC;
signal		s_4_hit_leg :    STD_LOGIC;
signal		s_4_hit_head :    STD_LOGIC;

signal		s_4_hit_mid2 :    STD_LOGIC;
signal		s_4_hit2 :    STD_LOGIC;
signal		s_4_hit_leg2 :    STD_LOGIC;
signal		s_4_hit_head2 :    STD_LOGIC;

signal		s_4_mVGA_RGB :    STD_LOGIC_VECTOR(7 DOWNTO 0);
signal		s_4_step_Y :    STD_LOGIC_VECTOR(9 DOWNTO 0);
signal		s_4_X_object_speed :    STD_LOGIC_VECTOR(6 DOWNTO 0);
signal		s_4_Y_object_speed :    STD_LOGIC_VECTOR(6 DOWNTO 0);

signal		s_4_step_Y2 :    STD_LOGIC_VECTOR(9 DOWNTO 0);



-- S_5_
signal		s_5_drawing_request :   STD_LOGIC;
signal		s_5_hit_mid :    STD_LOGIC;
signal		s_5_hit :    STD_LOGIC;
signal		s_5_hit_leg :    STD_LOGIC;
signal		s_5_hit_head :    STD_LOGIC;

signal		s_5_hit_mid2 :    STD_LOGIC;
signal		s_5_hit2 :    STD_LOGIC;
signal		s_5_hit_leg2 :    STD_LOGIC;
signal		s_5_hit_head2 :    STD_LOGIC;

signal		s_5_mVGA_RGB :    STD_LOGIC_VECTOR(7 DOWNTO 0);
signal		s_5_step_Y :    STD_LOGIC_VECTOR(9 DOWNTO 0);
signal		s_5_X_object_speed :    STD_LOGIC_VECTOR(6 DOWNTO 0);
signal		s_5_Y_object_speed :    STD_LOGIC_VECTOR(6 DOWNTO 0);

signal		s_5_step_Y2 :    STD_LOGIC_VECTOR(9 DOWNTO 0);



---------------------
--    COMPONENTs   --
---------------------
begin

s_1_F : ObstcleFull 			port map (CLK,RESETn,timer_done,ENABLE,oCoord_X,oCoord_Y,player_X,player_Y,
player2_X,player2_Y,
rand,

		"01",	--InSpeedX=>: in std_logic_vector(1 downto 0);	-- initial X sppeed
		"00",	--InSpeedY=>: in std_logic_vector(1 downto 0); --initial Y spped
		conv_std_logic_vector(300,10),--resetObjectStartX_t : in integer;  -- initial X position
		conv_std_logic_vector(300,10),--resetObjectStartY_t : in integer; -- initial X position

s_1_drawing_request,
s_1_hit_mid,s_1_hit,
s_1_hit_leg,
s_1_hit_head,

s_1_hit_mid2,
s_1_hit2,
s_1_hit_leg2,
s_1_hit_head2


,s_1_mVGA_RGB
,s_1_step_Y
,s_1_X_object_speed
,s_1_Y_object_speed
,s_1_step_Y2

);

s_2_F : ObstcleFull 			port map (CLK,RESETn,timer_done,ENABLE,oCoord_X,oCoord_Y,player_X,player_Y,player2_X,player2_Y,rand,

		"11",	--InSpeedX=>: in std_logic_vector(1 downto 0);	-- initial X sppeed
		"00",	--InSpeedY=>: in std_logic_vector(1 downto 0); --initial Y spped
		conv_std_logic_vector(200,10),--resetObjectStartX_t : in integer;  -- initial X position
		conv_std_logic_vector(400,10),--resetObjectStartY_t : in integer; -- initial X position
s_2_drawing_request,

s_2_hit_mid,s_2_hit,
s_2_hit_leg,
s_2_hit_head,

s_2_hit_mid2,s_2_hit2,
s_2_hit_leg2,
s_2_hit_head2


,s_2_mVGA_RGB
,s_2_step_Y
,s_2_X_object_speed
,s_2_Y_object_speed
,s_2_step_Y2
);

s_3_F : ObstcleFull 			port map (CLK,RESETn,timer_done,ENABLE,oCoord_X,oCoord_Y,player_X,player_Y,player2_X,player2_Y,rand,

		"00",	--InSpeedX=>: in std_logic_vector(1 downto 0);	-- initial X sppeed
		"01",	--InSpeedY=>: in std_logic_vector(1 downto 0); --initial Y spped
		conv_std_logic_vector(360,10),--resetObjectStartX_t : in integer;  -- initial X position
		conv_std_logic_vector(200,10),--resetObjectStartY_t : in integer; -- initial X position
s_3_drawing_request,

s_3_hit_mid,s_3_hit,
s_3_hit_leg,
s_3_hit_head,

s_3_hit_mid2,s_3_hit2,
s_3_hit_leg2,
s_3_hit_head2

,s_3_mVGA_RGB
,s_3_step_Y
,s_3_X_object_speed
,s_3_Y_object_speed
,s_3_step_Y2
);

s_4_F : ObstcleFull 			port map (CLK,RESETn,timer_done,ENABLE,oCoord_X,oCoord_Y,player_X,player_Y,player2_X,player2_Y,rand,
		"00",	--InSpeedX=>: in std_logic_vector(1 downto 0);	-- initial X sppeed
		"11",	--InSpeedY=>: in std_logic_vector(1 downto 0); --initial Y spped
		conv_std_logic_vector(260,10),--resetObjectStartX_t : in integer;  -- initial X position
		conv_std_logic_vector(200,10),--resetObjectStartY_t : in integer; -- initial X position
s_4_drawing_request,

s_4_hit_mid,
s_4_hit,
s_4_hit_leg,
s_4_hit_head,

s_4_hit_mid2,
s_4_hit2,
s_4_hit_leg2,
s_4_hit_head2

,s_4_mVGA_RGB
,s_4_step_Y
,s_4_X_object_speed
,s_4_Y_object_speed
,s_4_step_Y2
);



s_5_F : ObstcleFull 			port map (CLK,RESETn,timer_done,ENABLE,oCoord_X,oCoord_Y,player_X,player_Y,player2_X,player2_Y,rand,
		"01",	--InSpeedX=>: in std_logic_vector(1 downto 0);	-- initial X sppeed
		"01",	--InSpeedY=>: in std_logic_vector(1 downto 0); --initial Y spped
		conv_std_logic_vector(150,10),--resetObjectStartX_t : in integer;  -- initial X position
		conv_std_logic_vector(150,10),--resetObjectStartY_t : in integer; -- initial X position
s_5_drawing_request,

s_5_hit_mid,s_5_hit,
s_5_hit_leg,
s_5_hit_head,

s_5_hit_mid2,s_5_hit2,
s_5_hit_leg2,
s_5_hit_head2

,s_5_mVGA_RGB
,s_5_step_Y
,s_5_X_object_speed
,s_5_Y_object_speed
,s_5_step_Y2
);


---------------
--    Hits   --
---------------
hit <= '1' when s_1_hit = '1' else
			'1' when s_2_hit = '1' else
			'1' when s_3_hit = '1' else
			'1' when s_4_hit = '1' else
			'1' when s_5_hit = '1' else
			'0';
			
hit_mid <= '1' when s_1_hit_mid = '1' else
			'1' when s_2_hit_mid = '1' else
			'1' when s_3_hit_mid = '1' else
			'1' when s_4_hit_mid = '1' else
			'1' when s_5_hit_mid = '1' else
			
			'0';
hit_leg <= '1' when s_1_hit_leg = '1' else
			'1' when s_2_hit_leg = '1' else
			'1' when s_3_hit_leg = '1' else
			'1' when s_4_hit_leg = '1' else
			'1' when s_5_hit_leg = '1' else
			
			'0';
			
hit_head <= '1' when s_1_hit_head = '1' else
			'1' when s_2_hit_head = '1' else
			'1' when s_3_hit_head = '1' else
			'1' when s_4_hit_head = '1' else
			'1' when s_5_hit_head = '1' else
			'0';
			
------------------------
--    Hits  - player2 --
------------------------
hit2 <= '1' when s_1_hit2 = '1' else
			'1' when s_2_hit2 = '1' else
			'1' when s_3_hit2 = '1' else
			'1' when s_4_hit2 = '1' else
			'1' when s_5_hit2 = '1' else
			'0';
			
hit_mid2 <= '1' when s_1_hit_mid2 = '1' else
			'1' when s_2_hit_mid2 = '1' else
			'1' when s_3_hit_mid2 = '1' else
			'1' when s_4_hit_mid2 = '1' else
			'1' when s_5_hit_mid2 = '1' else
			'0';
			
hit_leg2 <= '1' when s_1_hit_leg2 = '1' else
			'1' when s_2_hit_leg2 = '1' else
			'1' when s_3_hit_leg2 = '1' else
			'1' when s_4_hit_leg2 = '1' else
			'1' when s_5_hit_leg2 = '1' else
			'0';
			
hit_head2 <= '1' when s_1_hit_head2 = '1' else
			'1' when s_2_hit_head2 = '1' else
			'1' when s_3_hit_head2 = '1' else
			'1' when s_4_hit_head2 = '1' else
			'1' when s_5_hit_head2 = '1' else
			'0';

---------------------------
--    Drawing_requests   --
---------------------------		
drawing_request <= '1' when s_1_drawing_request = '1' else
			'1' when s_2_drawing_request = '1' else
			'1' when s_3_drawing_request = '1' else
			'1' when s_4_drawing_request = '1' else
			'1' when s_5_drawing_request = '1' else
			'0';
			

---------------------------
--    Priority for RGB   --
---------------------------
mVGA_RGB   <= s_1_mVGA_RGB when s_1_drawing_request = '1' else
			     s_2_mVGA_RGB when s_2_drawing_request = '1' else
			     s_3_mVGA_RGB when s_3_drawing_request = '1' else
				 s_4_mVGA_RGB when s_4_drawing_request = '1' else
			     s_5_mVGA_RGB;


--------------------------------------------
--    Singals according to hits  Player 1 --
--------------------------------------------
X_object_speed <= s_1_X_object_speed when s_1_hit = '1' else
				s_2_X_object_speed when s_2_hit = '1' else
				s_3_X_object_speed when s_3_hit = '1' else
				s_4_X_object_speed when s_4_hit = '1' else
				s_5_X_object_speed when s_5_hit = '1' else

				(others => '0');

Y_object_speed <= s_1_Y_object_speed when s_1_hit = '1' else
				s_2_Y_object_speed when s_2_hit = '1' else
				s_3_Y_object_speed when s_3_hit = '1' else
				s_4_Y_object_speed when s_4_hit = '1' else
				s_5_Y_object_speed when s_5_hit = '1' else

				(others => '0');				 
				
step_Y 		<= 	s_1_step_Y when s_1_hit = '1' else
				s_2_step_Y when s_2_hit = '1' else
				s_3_step_Y when s_3_hit = '1' else
				s_4_step_Y when s_4_hit = '1' else
				s_5_step_Y when s_5_hit = '1' else
				(others => '0');

--------------------------------------------
--    Singals according to hits  Player 2 --
--------------------------------------------
X_object_speed2 <= s_1_X_object_speed when s_1_hit2 = '1' else
				s_2_X_object_speed when s_2_hit2 = '1' else
				s_3_X_object_speed when s_3_hit2 = '1' else
				s_4_X_object_speed when s_4_hit2 = '1' else
				s_5_X_object_speed when s_5_hit2 = '1' else

				(others => '0');

Y_object_speed2 <= s_1_Y_object_speed when s_1_hit2 = '1' else
				s_2_Y_object_speed when s_2_hit2 = '1' else
				s_3_Y_object_speed when s_3_hit2 = '1' else
				s_4_Y_object_speed when s_4_hit2 = '1' else
				s_5_Y_object_speed when s_5_hit2 = '1' else

				(others => '0');				 
				
step_Y2 		<= 	s_1_step_Y2 when s_1_hit2 = '1' else
				s_2_step_Y2 when s_2_hit2 = '1' else
				s_3_step_Y2 when s_3_hit2 = '1' else
				s_4_step_Y2 when s_4_hit2 = '1' else
				s_5_step_Y2 when s_5_hit2 = '1' else
				(others => '0');


end architecture;