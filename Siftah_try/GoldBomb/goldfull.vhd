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
-- CREATED		"Wed Sep 13 12:36:12 2017"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY goldfull IS 
	PORT
	(
		CLK :  IN  STD_LOGIC;
		RESETn :  IN  STD_LOGIC;
		timer_done :  IN  STD_LOGIC;
		allowed_to_move :  IN  STD_LOGIC;
		enable :  IN  STD_LOGIC;
		oCoord_X :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		oCoord_Y :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		Player_X :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		Player_Y :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		Random1 :  IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
		Random2 :  IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
		drawing_request :  OUT  STD_LOGIC;
		hit :  OUT  STD_LOGIC;
		mVGA_RGB :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END goldfull;

ARCHITECTURE bdf_type OF goldfull IS 

COMPONENT bombsm
	PORT(CLK : IN STD_LOGIC;
		 RESETn : IN STD_LOGIC;
		 timer_done : IN STD_LOGIC;
		 allowedToMove : IN STD_LOGIC;
		 hit : IN STD_LOGIC;
		 IENABLE : IN STD_LOGIC;
		 random : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		 random2 : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		 enable : OUT STD_LOGIC;
		 ObjectStartX : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
		 ObjectStartY : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
	);
END COMPONENT;

COMPONENT coin_object
	PORT(CLK : IN STD_LOGIC;
		 RESETn : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 ObjectStartX : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		 ObjectStartY : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		 oCoord_X : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 oCoord_Y : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 drawing_request : OUT STD_LOGIC;
		 is_active : OUT STD_LOGIC;
		 mVGA_RGB : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT object_hit_detector
	PORT(CLK : IN STD_LOGIC;
		 RESETn : IN STD_LOGIC;
		 is_object_active : IN STD_LOGIC;
		 MarioStartX : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 MarioStartY : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 ObjectStartX : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		 ObjectStartY : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		 hit : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	bomb_enable :  STD_LOGIC;
SIGNAL	bomb_hit :  STD_LOGIC;
SIGNAL	d_drawing_request :  STD_LOGIC;
SIGNAL	d_mVGA_RGB :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	en :  STD_LOGIC;
SIGNAL	is_obj_active :  STD_LOGIC;
SIGNAL	ObjectStartX :  STD_LOGIC_VECTOR(8 DOWNTO 0);
SIGNAL	ObjectStartY :  STD_LOGIC_VECTOR(8 DOWNTO 0);


BEGIN 



b2v_inst : bombsm
PORT MAP(CLK => CLK,
		 RESETn => RESETn,
		 timer_done => timer_done,
		 allowedToMove => allowed_to_move,
		 hit => bomb_hit,
		 IENABLE => en,
		 random => Random1,
		 random2 => Random2,
		 enable => bomb_enable,
		 ObjectStartX => ObjectStartX,
		 ObjectStartY => ObjectStartY);


b2v_inst1 : coin_object
PORT MAP(CLK => CLK,
		 RESETn => RESETn,
		 enable => bomb_enable,
		 ObjectStartX => ObjectStartX,
		 ObjectStartY => ObjectStartY,
		 oCoord_X => oCoord_X,
		 oCoord_Y => oCoord_Y,
		 drawing_request => d_drawing_request,
		 is_active => is_obj_active,
		 mVGA_RGB => d_mVGA_RGB);


b2v_inst18 : object_hit_detector
PORT MAP(CLK => CLK,
		 RESETn => RESETn,
		 is_object_active => is_obj_active,
		 MarioStartX => Player_X,
		 MarioStartY => Player_Y,
		 ObjectStartX => ObjectStartX,
		 ObjectStartY => ObjectStartY,
		 hit => bomb_hit);

drawing_request <= d_drawing_request;
en <= enable;
hit <= bomb_hit;
mVGA_RGB <= d_mVGA_RGB;

END bdf_type;