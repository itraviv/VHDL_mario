-- Copyright (C) 1991-2010 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II"
-- VERSION		"Version 9.1 Build 350 03/24/2010 Service Pack 2 SJ Full Version"
-- CREATED		"Wed Sep 13 10:45:11 2017"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY top_siftach IS 
	PORT
	(
		CLOCK_27 :  IN  STD_LOGIC;
		RESETn :  IN  STD_LOGIC;
		KBD_CLK :  IN  STD_LOGIC;
		KBD_DAT :  IN  STD_LOGIC;
		rand :  IN  STD_LOGIC;
		CLK_50 :  IN  STD_LOGIC;
		VGA_VS :  OUT  STD_LOGIC;
		VGA_HS :  OUT  STD_LOGIC;
		VGA_SYNC :  OUT  STD_LOGIC;
		VGA_BLANK :  OUT  STD_LOGIC;
		VGA_CLK :  OUT  STD_LOGIC;
		HEX0S :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX1S :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		VGA_B :  OUT  STD_LOGIC_VECTOR(9 DOWNTO 0);
		VGA_G :  OUT  STD_LOGIC_VECTOR(9 DOWNTO 0);
		VGA_R :  OUT  STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END top_siftach;

ARCHITECTURE bdf_type OF top_siftach IS 

COMPONENT misc
	PORT(CLOCK_27 : IN STD_LOGIC;
		 CLK : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT timer
	PORT(CLK : IN STD_LOGIC;
		 RESETn : IN STD_LOGIC;
		 VGA_VS : IN STD_LOGIC;
		 timer_done : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT lpm_counter_cyclic
	PORT(clock : IN STD_LOGIC;
		 q : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
	);
END COMPONENT;

COMPONENT kbd
	PORT(resetN : IN STD_LOGIC;
		 KBD_CLK : IN STD_LOGIC;
		 KBD_DAT : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 make : OUT STD_LOGIC;
		 break : OUT STD_LOGIC;
		 dout : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
	);
END COMPONENT;

COMPONENT back_ground_draw
	PORT(CLK : IN STD_LOGIC;
		 RESETn : IN STD_LOGIC;
		 oCoord_X : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 oCoord_Y : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 mVGA_RGB : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT score_module
	PORT(gold_hit : IN STD_LOGIC;
		 CLK : IN STD_LOGIC;
		 bomb_hit : IN STD_LOGIC;
		 RESETn : IN STD_LOGIC;
		 life : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		 score : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;

COMPONENT obstcles_mgr
	PORT(CLK : IN STD_LOGIC;
		 RESETn : IN STD_LOGIC;
		 timer_done : IN STD_LOGIC;
		 ENABLE : IN STD_LOGIC;
		 oCoord_X : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 oCoord_Y : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 player_X : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 player_Y : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 rand : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 drawing_request : OUT STD_LOGIC;
		 hit_mid : OUT STD_LOGIC;
		 hit : OUT STD_LOGIC;
		 hit_leg : OUT STD_LOGIC;
		 hit_head : OUT STD_LOGIC;
		 mVGA_RGB : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 step_Y : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 X_object_speed : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Y_object_speed : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT bombfull
	PORT(CLK : IN STD_LOGIC;
		 RESETn : IN STD_LOGIC;
		 timer_done : IN STD_LOGIC;
		 allowed_to_move : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 oCoord_X : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 oCoord_Y : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Player_X : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Player_Y : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Random1 : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		 Random2 : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		 drawing_request : OUT STD_LOGIC;
		 hit : OUT STD_LOGIC;
		 mVGA_RGB : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT smileyfacemove
	PORT(CLK : IN STD_LOGIC;
		 RESETn : IN STD_LOGIC;
		 timer_done : IN STD_LOGIC;
		 upKeyPressed : IN STD_LOGIC;
		 leftKeyPressed : IN STD_LOGIC;
		 rightKeyPressed : IN STD_LOGIC;
		 hitObjMid : IN STD_LOGIC;
		 hitObjWithMyBottomPixel : IN STD_LOGIC;
		 hitObjAny : IN STD_LOGIC;
		 hitObjXspeed : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 hitObjYpos : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 hitObjYspeed : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 ObjectStartX : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 ObjectStartY : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT kbd_translate
	PORT(RESETn : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 make : IN STD_LOGIC;
		 break : IN STD_LOGIC;
		 dIN : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		 left_press : OUT STD_LOGIC;
		 right_press : OUT STD_LOGIC;
		 up_press : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT objects_mux
	PORT(CLK : IN STD_LOGIC;
		 b_drawing_request : IN STD_LOGIC;
		 c_drawing_request : IN STD_LOGIC;
		 d_drawing_request : IN STD_LOGIC;
		 y_drawing_request : IN STD_LOGIC;
		 RESETn : IN STD_LOGIC;
		 b_mVGA_RGB : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 c_mVGA_RGB : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 d_mVGA_RGB : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 y_mVGA_RGB : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 m_mVGA_B : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		 m_mVGA_G : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		 m_mVGA_R : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END COMPONENT;

COMPONENT vga_controller
	PORT(iCLK : IN STD_LOGIC;
		 iRST_N : IN STD_LOGIC;
		 iBlue : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 iGreen : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 iRed : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 oVGA_H_SYNC : OUT STD_LOGIC;
		 oVGA_V_SYNC : OUT STD_LOGIC;
		 oVGA_SYNC : OUT STD_LOGIC;
		 oVGA_BLANK : OUT STD_LOGIC;
		 oVGA_CLOCK : OUT STD_LOGIC;
		 oAddress : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
		 oCoord_X : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 oCoord_Y : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 oVGA_B : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		 oVGA_G : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		 oVGA_R : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END COMPONENT;

COMPONENT smileyface_object
	PORT(CLK : IN STD_LOGIC;
		 RESETn : IN STD_LOGIC;
		 ObjectStartX : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 ObjectStartY : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 oCoord_X : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 oCoord_Y : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 drawing_request : OUT STD_LOGIC;
		 drawing_down_boarder : OUT STD_LOGIC;
		 mVGA_RGB : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT clk_divider
GENERIC (Div : INTEGER
			);
	PORT(Clk_in : IN STD_LOGIC;
		 Resetn : IN STD_LOGIC;
		 Clk_out : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	bottomDraw :  STD_LOGIC;
SIGNAL	break :  STD_LOGIC;
SIGNAL	CLK :  STD_LOGIC;
SIGNAL	d_drawing_request :  STD_LOGIC;
SIGNAL	d_mVGA_RGB :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	dout :  STD_LOGIC_VECTOR(8 DOWNTO 0);
SIGNAL	gold_hit :  STD_LOGIC;
SIGNAL	hitObj :  STD_LOGIC;
SIGNAL	hitObjmid :  STD_LOGIC;
SIGNAL	left :  STD_LOGIC;
SIGNAL	make :  STD_LOGIC;
SIGNAL	marioReq :  STD_LOGIC;
SIGNAL	midLeg :  STD_LOGIC;
SIGNAL	ObjectStartX :  STD_LOGIC_VECTOR(8 DOWNTO 0);
SIGNAL	ObjectStartY :  STD_LOGIC_VECTOR(8 DOWNTO 0);
SIGNAL	obstReq :  STD_LOGIC;
SIGNAL	obstRGB :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	oCoord_X :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	oCoord_Y :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	player_X :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	player_Y :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	Randomize :  STD_LOGIC;
SIGNAL	right :  STD_LOGIC;
SIGNAL	step_y :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	timer_done :  STD_LOGIC;
SIGNAL	up :  STD_LOGIC;
SIGNAL	VGA_VS_ALTERA_SYNTHESIZED :  STD_LOGIC;
SIGNAL	XOS :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	YOS :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC_VECTOR(9 DOWNTO 0);


BEGIN 
SYNTHESIZED_WIRE_2 <= '1';
SYNTHESIZED_WIRE_11 <= '1';
SYNTHESIZED_WIRE_5 <= '0';



b2v_inst : misc
PORT MAP(CLOCK_27 => CLOCK_27,
		 CLK => CLK);


b2v_inst1 : timer
PORT MAP(CLK => CLK,
		 RESETn => RESETn,
		 VGA_VS => VGA_VS_ALTERA_SYNTHESIZED,
		 timer_done => timer_done);


b2v_inst10 : lpm_counter_cyclic
PORT MAP(clock => CLK,
		 q => ObjectStartY);


b2v_inst11 : lpm_counter_cyclic
PORT MAP(clock => SYNTHESIZED_WIRE_0,
		 q => ObjectStartX);


b2v_inst12 : kbd
PORT MAP(resetN => RESETn,
		 KBD_CLK => KBD_CLK,
		 KBD_DAT => KBD_DAT,
		 clk => CLK,
		 make => make,
		 break => break,
		 dout => dout);




b2v_inst2 : back_ground_draw
PORT MAP(CLK => CLK,
		 RESETn => RESETn,
		 oCoord_X => oCoord_X,
		 oCoord_Y => oCoord_Y,
		 mVGA_RGB => SYNTHESIZED_WIRE_7);


b2v_inst20 : score_module
PORT MAP(gold_hit => gold_hit,
		 CLK => CLK,
		 bomb_hit => SYNTHESIZED_WIRE_1,
		 RESETn => RESETn,
		 life => HEX1S,
		 score => HEX0S);


b2v_inst21 : obstcles_mgr
PORT MAP(CLK => CLK,
		 RESETn => RESETn,
		 timer_done => timer_done,
		 ENABLE => SYNTHESIZED_WIRE_2,
		 oCoord_X => oCoord_X,
		 oCoord_Y => oCoord_Y,
		 player_X => player_X,
		 player_Y => player_Y,
		 drawing_request => obstReq,
		 hit_mid => hitObjmid,
		 hit => hitObj,
		 hit_leg => midLeg,
		 mVGA_RGB => obstRGB,
		 step_Y => step_y,
		 X_object_speed => XOS,
		 Y_object_speed => YOS);


b2v_inst22 : bombfull
PORT MAP(CLK => CLK,
		 RESETn => RESETn,
		 timer_done => timer_done,
		 allowed_to_move => SYNTHESIZED_WIRE_11,
		 enable => SYNTHESIZED_WIRE_11,
		 oCoord_X => oCoord_X,
		 oCoord_Y => oCoord_Y,
		 Player_X => player_X,
		 Player_Y => player_Y,
		 Random1 => ObjectStartX,
		 Random2 => ObjectStartY,
		 drawing_request => d_drawing_request,
		 hit => SYNTHESIZED_WIRE_1,
		 mVGA_RGB => d_mVGA_RGB);



b2v_inst3 : smileyfacemove
PORT MAP(CLK => CLK,
		 RESETn => RESETn,
		 timer_done => timer_done,
		 upKeyPressed => up,
		 leftKeyPressed => left,
		 rightKeyPressed => right,
		 hitObjMid => hitObjmid,
		 hitObjWithMyBottomPixel => midLeg,
		 hitObjAny => hitObj,
		 hitObjXspeed => XOS,
		 hitObjYpos => step_y,
		 hitObjYspeed => YOS,
		 ObjectStartX => player_X,
		 ObjectStartY => player_Y);


b2v_inst4 : kbd_translate
PORT MAP(RESETn => RESETn,
		 clk => CLK,
		 make => make,
		 break => break,
		 dIN => dout,
		 left_press => left,
		 right_press => right,
		 up_press => up);


b2v_inst5 : objects_mux
PORT MAP(CLK => CLK,
		 b_drawing_request => marioReq,
		 c_drawing_request => obstReq,
		 d_drawing_request => d_drawing_request,
		 y_drawing_request => SYNTHESIZED_WIRE_5,
		 RESETn => RESETn,
		 b_mVGA_RGB => SYNTHESIZED_WIRE_6,
		 c_mVGA_RGB => obstRGB,
		 d_mVGA_RGB => d_mVGA_RGB,
		 y_mVGA_RGB => SYNTHESIZED_WIRE_7,
		 m_mVGA_B => SYNTHESIZED_WIRE_8,
		 m_mVGA_G => SYNTHESIZED_WIRE_9,
		 m_mVGA_R => SYNTHESIZED_WIRE_10);


b2v_inst6 : vga_controller
PORT MAP(iCLK => CLK,
		 iRST_N => RESETn,
		 iBlue => SYNTHESIZED_WIRE_8,
		 iGreen => SYNTHESIZED_WIRE_9,
		 iRed => SYNTHESIZED_WIRE_10,
		 oVGA_H_SYNC => VGA_HS,
		 oVGA_V_SYNC => VGA_VS_ALTERA_SYNTHESIZED,
		 oVGA_SYNC => VGA_SYNC,
		 oVGA_BLANK => VGA_BLANK,
		 oVGA_CLOCK => VGA_CLK,
		 oCoord_X => oCoord_X,
		 oCoord_Y => oCoord_Y,
		 oVGA_B => VGA_B,
		 oVGA_G => VGA_G,
		 oVGA_R => VGA_R);


b2v_inst7 : smileyface_object
PORT MAP(CLK => CLK,
		 RESETn => RESETn,
		 ObjectStartX => player_X,
		 ObjectStartY => player_Y,
		 oCoord_X => oCoord_X,
		 oCoord_Y => oCoord_Y,
		 drawing_request => marioReq,
		 mVGA_RGB => SYNTHESIZED_WIRE_6);



b2v_inst9 : clk_divider
GENERIC MAP(Div => 100
			)
PORT MAP(Clk_in => CLK,
		 Resetn => RESETn,
		 Clk_out => SYNTHESIZED_WIRE_0);

VGA_VS <= VGA_VS_ALTERA_SYNTHESIZED;

gold_hit <= '0';
END bdf_type;