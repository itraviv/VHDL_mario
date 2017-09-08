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
-- CREATED		"Fri Sep 08 18:33:45 2017"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY obstclefull IS 
	PORT
	(
		CLK :  IN  STD_LOGIC;
		RESETn :  IN  STD_LOGIC;
		timer_done :  IN  STD_LOGIC;
		ENABLE :  IN  STD_LOGIC;
		oCoord_X :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		oCoord_Y :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		player_X :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		player_Y :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		rand :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		drawing_request :  OUT  STD_LOGIC;
		hit_mid :  OUT  STD_LOGIC;
		hit :  OUT  STD_LOGIC;
		hit_leg :  OUT  STD_LOGIC;
		hit_head :  OUT  STD_LOGIC;
		mVGA_RGB :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		step_Y :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		X_object_speed :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		Y_object_speed :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END obstclefull;

ARCHITECTURE bdf_type OF obstclefull IS 

COMPONENT hit_detector
	PORT(CLK : IN STD_LOGIC;
		 RESETn : IN STD_LOGIC;
		 player_X : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 player_Y : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 step_X : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 step_Y : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 hit : OUT STD_LOGIC;
		 leg_mid : OUT STD_LOGIC;
		 head_mid : OUT STD_LOGIC;
		 mario_mid : OUT STD_LOGIC;
		 step_Y_O : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT obstacle_object
	PORT(CLK : IN STD_LOGIC;
		 RESETn : IN STD_LOGIC;
		 ENABLE : IN STD_LOGIC;
		 hit : IN STD_LOGIC;
		 ObjectStartX : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 ObjectStartY : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 oCoord_X : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 oCoord_Y : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 rand : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 drawing_request : OUT STD_LOGIC;
		 mVGA_RGB : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT objectsm
	PORT(CLK : IN STD_LOGIC;
		 RESETn : IN STD_LOGIC;
		 timer_done : IN STD_LOGIC;
		 ObjectStartX : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 ObjectStartY : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 X_speed : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Y_speed : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	enble :  STD_LOGIC;
SIGNAL	hitObj :  STD_LOGIC;
SIGNAL	hitObjmid :  STD_LOGIC;
SIGNAL	midLeg :  STD_LOGIC;
SIGNAL	obstReq :  STD_LOGIC;
SIGNAL	obstRGB :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	ohit_head :  STD_LOGIC;
SIGNAL	XOS :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	YOS :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC_VECTOR(31 DOWNTO 0);


BEGIN 



b2v_inst11 : hit_detector
PORT MAP(CLK => CLK,
		 RESETn => RESETn,
		 player_X => player_X,
		 player_Y => player_Y,
		 step_X => SYNTHESIZED_WIRE_4,
		 step_Y => SYNTHESIZED_WIRE_5,
		 hit => hitObj,
		 leg_mid => midLeg,
		 head_mid => ohit_head,
		 mario_mid => hitObjmid,
		 step_Y_O => step_Y);


b2v_inst8 : obstacle_object
PORT MAP(CLK => CLK,
		 RESETn => RESETn,
		 ENABLE => enble,
		 hit => hitObj,
		 ObjectStartX => SYNTHESIZED_WIRE_4,
		 ObjectStartY => SYNTHESIZED_WIRE_5,
		 oCoord_X => oCoord_X,
		 oCoord_Y => oCoord_Y,
		 rand => rand,
		 drawing_request => obstReq,
		 mVGA_RGB => obstRGB);


b2v_inst9 : objectsm
PORT MAP(CLK => CLK,
		 RESETn => RESETn,
		 timer_done => timer_done,
		 ObjectStartX => SYNTHESIZED_WIRE_4,
		 ObjectStartY => SYNTHESIZED_WIRE_5,
		 X_speed => XOS,
		 Y_speed => YOS);

drawing_request <= obstReq;
enble <= ENABLE;
hit_mid <= hitObjmid;
hit <= hitObj;
hit_leg <= midLeg;
hit_head <= ohit_head;
mVGA_RGB <= obstRGB;
X_object_speed <= XOS;
Y_object_speed <= YOS;

END bdf_type;