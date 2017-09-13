library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.std_logic_unsigned.all;
--use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017

entity cloud_background_object is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   	CLK  		: in std_logic;
		RESETn		: in std_logic;
		oCoord_X	: in integer;
		oCoord_Y	: in integer;
		drawing_request	: out std_logic ;
		mVGA_RGB 	: out std_logic_vector(7 downto 0)

	);
end cloud_background_object;

architecture behav of cloud_background_object is 

constant cloud_object_X_size : integer := 60;
constant cloud_object_Y_size : integer := 45;
constant grass_object_X_size : integer := 50;
constant grass_object_y_size : integer := 76;

constant R_high		: integer := 7;
constant R_low		: integer := 5;
constant G_high		: integer := 4;
constant G_low		: integer := 2;
constant B_high		: integer := 1;
constant B_low		: integer := 0;

type cloud_ram_array is array(0 to cloud_object_Y_size - 1 , 0 to cloud_object_X_size - 1) of std_logic_vector(7 downto 0);  

constant cloud1_colors: cloud_ram_array :=(
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"6D", x"49", x"92", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"00", x"00", x"48", x"6D", x"92", x"49", x"00", x"24", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"6D", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"92", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"6D", x"00", x"B6", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"49", x"49", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"48", x"6D", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"B6", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"6D", x"49", x"FF", x"24", x"00", x"BA", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"BA", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"00", x"92", x"FF", x"00", x"92", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"6D", x"6D", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"92", x"FF", x"FF", x"FF", x"00", x"BA", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"24", x"B6", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"36", x"56", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"92", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"36", x"9B", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"6D", x"6D", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"92", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"9B", x"12", x"16", x"76", x"9B", x"FF", x"FF", x"FF", x"FF", x"FF", x"56", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"BA", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"92", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"56", x"56", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"6D", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"9B", x"9B", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"6D", x"49", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"6D", x"00", x"00", x"48", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"FF", x"FF", x"FF", x"FF", x"92", x"00", x"BA", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"00", x"92", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"49", x"6D", x"FF", x"FF", x"92", x"00", x"B6", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"B6", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"FF", x"B6", x"00", x"FF", x"FF", x"6D", x"6D", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"BA", x"00", x"BA", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"48", x"00", x"00", x"FF", x"FF", x"FF", x"BA", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"BA", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"49", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"48", x"92", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"BA", x"FF", x"49", x"B6", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"92", x"49", x"49", x"49", x"00", x"BA", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"92", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"00", x"FF", x"FF", x"00", x"FF"),
(x"FF", x"FF", x"48", x"00", x"24", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"48", x"92"),
(x"FF", x"00", x"92", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"92", x"49"),
(x"48", x"92", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"49"),
(x"24", x"B6", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"6D", x"6D"),
(x"BA", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"FF"),
(x"FF", x"6D", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"92", x"FF"),
(x"FF", x"FF", x"92", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"6D", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"92", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"56", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"48", x"6D", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"92", x"00", x"FF", x"FF", x"FF", x"FF", x"9B", x"36", x"FF", x"FF", x"FF", x"FF", x"FF", x"9B", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"56", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"6D", x"00", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"6D", x"00", x"FF", x"FF", x"FF", x"FF", x"36", x"36", x"FF", x"FF", x"FF", x"FF", x"9B", x"56", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"56", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"6D", x"00", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"92", x"00", x"FF", x"FF", x"FF", x"FF", x"12", x"36", x"9B", x"9B", x"9B", x"36", x"16", x"9B", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"56", x"36", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"6D", x"49", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"48", x"6D", x"FF", x"FF", x"FF", x"9B", x"36", x"12", x"12", x"12", x"16", x"16", x"36", x"9B", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"36", x"16", x"16", x"56", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"9B", x"9B", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"9B", x"FF", x"FF", x"36", x"16", x"32", x"9B", x"FF", x"FF", x"FF", x"FF", x"FF", x"9B", x"36", x"16", x"56", x"56", x"16", x"36", x"9B", x"FF", x"FF", x"FF", x"FF", x"FF", x"9B", x"56", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"24", x"92", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"36", x"16", x"16", x"16", x"16", x"16", x"16", x"16", x"16", x"16", x"9B", x"FF", x"FF", x"56", x"16", x"16", x"16", x"36", x"36", x"36", x"16", x"12", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"92", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"9B", x"56", x"36", x"36", x"16", x"16", x"36", x"56", x"BA", x"FF", x"FF", x"FF", x"FF", x"9B", x"36", x"16", x"16", x"16", x"16", x"16", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"B6", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"24", x"00", x"28", x"92", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"9B", x"9B", x"9B", x"9B", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"BA", x"24", x"00", x"B6", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"49", x"00", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"24", x"00", x"B6", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"92", x"00", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"92", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"48", x"FF", x"FF", x"FF", x"FF", x"B6", x"00", x"00", x"92", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"00", x"B6", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"6D", x"00", x"49", x"00", x"49", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"24", x"00", x"92", x"00", x"48", x"92", x"00", x"00", x"BA", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"24", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"24", x"00", x"FF", x"FF", x"FF", x"6D", x"00", x"92", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"24", x"00", x"92", x"FF", x"FF", x"FF", x"92", x"6D", x"B6", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"92", x"00", x"24", x"92", x"B6", x"6D", x"00", x"48", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"24", x"00", x"49", x"92", x"92", x"49", x"00", x"00", x"92", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"6D", x"49", x"6D", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"92", x"6D", x"6D", x"92", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF")
);

type cloud_form is array (0 to cloud_object_Y_size - 1 , 0 to cloud_object_X_size - 1) of std_logic;
constant cloud : cloud_form := (
("111111111111111111111111111111011111111111111111111111111111"),
("111111111111111111111111110001000011111111111111111111111111"),
("111111111111111111111111100000000001111111111111111111111111"),
("111111111111111111111111000000000010111111111111111111111111"),
("111111111111111111111110000000000000011111111111111111111111"),
("111111111111111111110000000000000000011111111111111111111111"),
("111111111111111111100000000000000000001001111111111111111111"),
("111111111111111111100000000000000000000000111111111111111111"),
("111111111111111111100000000000000000000000011111111111111111"),
("111111111111111111000000000000000000000000001111111111111111"),
("111111111111111111000000000000000000000000001111111111111111"),
("111111111111111111000000000000000000000000011111111111111111"),
("111111111111111110000000000000000000000000000111111111111111"),
("111111111111111100000000000000000000000000000111111111111111"),
("111111111111111000000000000000000000000000000011111111111111"),
("111111111110000000000000000000000000000000000011111011111111"),
("111111111000000000000000000000000000000000000011110001111111"),
("111111110000000000000000000000000000000000000001100000111111"),
("111111100000000000000000000000000000000000000000000000111111"),
("111111000000000000000000000000000000000000000000000000111111"),
("111110000000000000000000000000000000000000000000000000011111"),
("111110000000000000000000000000000000000000000000000000000011"),
("111110000000000000000000000000000000000000000000000000000001"),
("110000000000000000000000000000000000000000000000000000000000"),
("101000000000000000000000000000000000000000000000000000000000"),
("010000000000000000000000000000000000000000000000000000000000"),
("000000000000000000000000000000000000000000000000000000000000"),
("100000000000000000000000000000000000000000000000000000000001"),
("110000000000000000000000000000000000000000000000000000000011"),
("111000000000000000000000000000000000000000000000000000000011"),
("111100000000000000000000000000000000000000000000000000000111"),
("111110000000000000000000000000000000000000000000000000000111"),
("111110000000000000000000000000000000000000000000000000000011"),
("111111000000000000000000000000000000000000000000000000000001"),
("111111100000000000000000000000000000000000000000000000000001"),
("111111110000000000000000000000000000000000000000000000000001"),
("111111110000000000000000000000000000000000000000000000000001"),
("111111111000000000000000000000000000000000000000000000000011"),
("111111111100000000000000000000000000000000000000000000000111"),
("111111111111100000000000000000000000000000000000000000011111"),
("111111111111111100000000000000000000000000000000000001111111"),
("111111111111111110000000000000000000000000000100100111111111"),
("111111111111111111000000000011100000000000011111011111111111"),
("111111111111111111110000000111111000000001111111111111111111"),
("111111111111111111111110111111111110001111111111111111111111"));



type grass_ram_array is array(0 to grass_object_Y_size - 1 , 0 to grass_object_X_size - 1) of std_logic_vector(7 downto 0);  

constant grass_colors: grass_ram_array :=(
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"92", x"49", x"24", x"24", x"24", x"48", x"92", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"24", x"00", x"0C", x"10", x"59", x"79", x"14", x"10", x"0C", x"04", x"24", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"00", x"30", x"14", x"14", x"10", x"79", x"10", x"10", x"10", x"18", x"59", x"10", x"00", x"B2", x"FF", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"8D", x"00", x"38", x"10", x"10", x"10", x"10", x"14", x"10", x"10", x"10", x"14", x"10", x"10", x"14", x"04", x"6D", x"FF", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"92", x"08", x"38", x"59", x"59", x"59", x"59", x"14", x"79", x"59", x"79", x"59", x"34", x"79", x"59", x"59", x"38", x"08", x"92", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"04", x"58", x"0C", x"59", x"59", x"59", x"10", x"10", x"59", x"59", x"58", x"10", x"14", x"59", x"59", x"34", x"10", x"59", x"00", x"FF", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"38", x"10", x"10", x"59", x"79", x"10", x"10", x"10", x"79", x"58", x"10", x"10", x"14", x"79", x"34", x"10", x"10", x"58", x"79", x"00", x"FF", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"04", x"10", x"10", x"10", x"58", x"10", x"10", x"10", x"10", x"58", x"10", x"10", x"10", x"14", x"34", x"10", x"10", x"10", x"38", x"10", x"04", x"B6", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"34", x"14", x"14", x"14", x"34", x"14", x"14", x"14", x"14", x"14", x"14", x"14", x"14", x"14", x"14", x"14", x"14", x"34", x"14", x"14", x"38", x"00", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"04", x"58", x"59", x"79", x"10", x"59", x"59", x"79", x"59", x"10", x"79", x"59", x"79", x"34", x"34", x"59", x"59", x"79", x"10", x"59", x"59", x"59", x"04", x"FF"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"8D", x"0C", x"59", x"58", x"10", x"10", x"59", x"59", x"58", x"10", x"10", x"59", x"58", x"34", x"10", x"14", x"59", x"59", x"10", x"10", x"58", x"59", x"58", x"0C", x"92"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"49", x"34", x"59", x"10", x"10", x"10", x"59", x"59", x"10", x"10", x"10", x"79", x"34", x"10", x"10", x"14", x"79", x"10", x"10", x"10", x"59", x"59", x"10", x"10", x"69"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"20", x"18", x"10", x"10", x"10", x"10", x"38", x"10", x"10", x"10", x"10", x"34", x"0C", x"10", x"10", x"34", x"10", x"10", x"10", x"10", x"38", x"10", x"10", x"10", x"24"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"38", x"58", x"58", x"59", x"38", x"38", x"59", x"58", x"58", x"34", x"59", x"58", x"58", x"58", x"14", x"58", x"58", x"58", x"38", x"34", x"59", x"58", x"59", x"24"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"34", x"59", x"59", x"59", x"0C", x"59", x"59", x"59", x"34", x"10", x"59", x"59", x"78", x"10", x"14", x"59", x"59", x"58", x"10", x"59", x"59", x"59", x"34", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"38", x"59", x"58", x"10", x"10", x"58", x"59", x"34", x"10", x"10", x"58", x"79", x"10", x"10", x"34", x"59", x"59", x"10", x"10", x"58", x"59", x"34", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"38", x"59", x"10", x"10", x"10", x"59", x"34", x"10", x"10", x"10", x"79", x"10", x"10", x"10", x"14", x"59", x"10", x"10", x"10", x"58", x"34", x"10", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"38", x"10", x"10", x"10", x"10", x"14", x"10", x"10", x"10", x"14", x"10", x"10", x"10", x"10", x"34", x"10", x"10", x"10", x"10", x"34", x"10", x"10", x"14", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"38", x"79", x"59", x"79", x"34", x"59", x"79", x"79", x"78", x"14", x"79", x"59", x"79", x"59", x"14", x"79", x"79", x"58", x"34", x"59", x"79", x"59", x"79", x"24"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"38", x"59", x"59", x"34", x"0C", x"59", x"59", x"59", x"10", x"10", x"59", x"59", x"58", x"10", x"34", x"59", x"59", x"34", x"0C", x"59", x"59", x"79", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"18", x"78", x"34", x"10", x"10", x"59", x"79", x"10", x"10", x"10", x"79", x"59", x"10", x"10", x"14", x"79", x"34", x"10", x"10", x"58", x"79", x"10", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"38", x"34", x"10", x"10", x"10", x"59", x"10", x"10", x"10", x"10", x"58", x"10", x"10", x"10", x"14", x"34", x"10", x"10", x"10", x"58", x"10", x"10", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"38", x"14", x"14", x"14", x"34", x"14", x"14", x"14", x"34", x"14", x"14", x"14", x"14", x"34", x"14", x"14", x"14", x"14", x"34", x"34", x"14", x"14", x"38", x"24"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"04", x"34", x"59", x"59", x"79", x"10", x"59", x"59", x"59", x"58", x"10", x"79", x"59", x"79", x"34", x"14", x"59", x"59", x"78", x"10", x"58", x"59", x"59", x"59", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"38", x"59", x"58", x"10", x"10", x"59", x"59", x"58", x"0C", x"10", x"59", x"59", x"34", x"10", x"34", x"59", x"59", x"10", x"10", x"58", x"59", x"58", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"58", x"59", x"10", x"10", x"10", x"59", x"59", x"10", x"10", x"10", x"79", x"34", x"10", x"10", x"14", x"79", x"10", x"10", x"10", x"58", x"58", x"10", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"48", x"00", x"00", x"00", x"00", x"04", x"08", x"10", x"10", x"38", x"0C", x"10", x"10", x"10", x"34", x"0C", x"10", x"10", x"14", x"10", x"10", x"10", x"10", x"38", x"0C", x"10", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B2", x"00", x"04", x"55", x"59", x"58", x"59", x"38", x"79", x"51", x"04", x"08", x"58", x"59", x"58", x"58", x"34", x"58", x"58", x"58", x"58", x"34", x"38", x"59", x"58", x"38", x"34", x"59", x"58", x"59", x"24"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"20", x"2C", x"38", x"10", x"59", x"59", x"59", x"10", x"14", x"59", x"59", x"79", x"0C", x"04", x"75", x"79", x"38", x"10", x"59", x"59", x"58", x"10", x"34", x"59", x"59", x"58", x"0C", x"59", x"59", x"59", x"38", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"55", x"38", x"10", x"10", x"59", x"59", x"10", x"10", x"34", x"59", x"58", x"10", x"10", x"59", x"00", x"34", x"10", x"10", x"59", x"58", x"10", x"10", x"14", x"59", x"59", x"10", x"10", x"58", x"59", x"14", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"59", x"14", x"10", x"10", x"10", x"58", x"10", x"10", x"10", x"34", x"39", x"10", x"10", x"10", x"59", x"38", x"00", x"10", x"10", x"78", x"10", x"10", x"10", x"14", x"58", x"10", x"10", x"10", x"58", x"14", x"10", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"49", x"08", x"34", x"10", x"10", x"10", x"14", x"10", x"10", x"10", x"10", x"14", x"10", x"10", x"10", x"10", x"34", x"10", x"14", x"00", x"14", x"10", x"10", x"10", x"10", x"34", x"10", x"10", x"10", x"10", x"34", x"10", x"10", x"14", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"04", x"18", x"59", x"59", x"58", x"59", x"14", x"79", x"59", x"79", x"38", x"34", x"78", x"59", x"79", x"14", x"58", x"59", x"58", x"34", x"08", x"79", x"59", x"58", x"58", x"34", x"59", x"59", x"58", x"14", x"59", x"59", x"58", x"59", x"24"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"20", x"34", x"0C", x"59", x"59", x"79", x"10", x"10", x"59", x"59", x"39", x"10", x"34", x"59", x"59", x"34", x"0C", x"59", x"59", x"59", x"14", x"04", x"79", x"59", x"59", x"10", x"34", x"59", x"59", x"34", x"0C", x"59", x"59", x"59", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"04", x"10", x"10", x"58", x"79", x"10", x"10", x"10", x"79", x"58", x"10", x"10", x"34", x"79", x"34", x"10", x"10", x"59", x"78", x"10", x"10", x"0C", x"2C", x"39", x"10", x"10", x"14", x"79", x"14", x"10", x"10", x"58", x"58", x"10", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"6D", x"0C", x"10", x"0C", x"58", x"10", x"10", x"10", x"10", x"38", x"0C", x"10", x"10", x"34", x"14", x"0C", x"10", x"10", x"59", x"10", x"10", x"10", x"14", x"04", x"10", x"10", x"10", x"34", x"34", x"0C", x"10", x"10", x"58", x"10", x"10", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"38", x"14", x"34", x"14", x"14", x"34", x"14", x"34", x"14", x"34", x"14", x"34", x"34", x"14", x"14", x"14", x"14", x"34", x"14", x"14", x"34", x"18", x"04", x"34", x"34", x"34", x"34", x"14", x"14", x"14", x"34", x"34", x"14", x"14", x"38", x"24"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"79", x"79", x"10", x"59", x"59", x"59", x"58", x"10", x"59", x"59", x"78", x"34", x"14", x"59", x"59", x"58", x"10", x"59", x"59", x"59", x"59", x"10", x"2C", x"50", x"79", x"14", x"14", x"59", x"59", x"58", x"10", x"59", x"59", x"59", x"59", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"04", x"79", x"10", x"10", x"59", x"59", x"39", x"10", x"10", x"59", x"59", x"14", x"0C", x"34", x"59", x"59", x"10", x"10", x"59", x"59", x"58", x"10", x"10", x"59", x"55", x"14", x"0C", x"14", x"59", x"59", x"10", x"10", x"58", x"59", x"58", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"BA", x"08", x"10", x"10", x"10", x"59", x"59", x"10", x"10", x"10", x"79", x"14", x"10", x"10", x"14", x"78", x"10", x"10", x"10", x"59", x"58", x"10", x"10", x"10", x"79", x"14", x"10", x"10", x"14", x"79", x"10", x"10", x"10", x"59", x"58", x"10", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"04", x"10", x"10", x"0C", x"38", x"0C", x"10", x"10", x"10", x"14", x"0C", x"10", x"10", x"34", x"10", x"10", x"10", x"10", x"39", x"0C", x"10", x"10", x"10", x"14", x"0C", x"10", x"10", x"14", x"10", x"10", x"10", x"10", x"38", x"0C", x"10", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"08", x"58", x"59", x"38", x"54", x"59", x"59", x"59", x"14", x"59", x"59", x"59", x"59", x"14", x"59", x"58", x"58", x"38", x"38", x"59", x"59", x"58", x"34", x"58", x"59", x"59", x"59", x"34", x"59", x"59", x"58", x"38", x"34", x"59", x"59", x"59", x"24"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"08", x"59", x"59", x"0C", x"59", x"59", x"58", x"14", x"10", x"59", x"59", x"58", x"10", x"34", x"59", x"59", x"58", x"0C", x"59", x"59", x"79", x"14", x"10", x"59", x"59", x"58", x"10", x"34", x"59", x"59", x"58", x"0C", x"59", x"59", x"59", x"38", x"00"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"28", x"58", x"10", x"10", x"59", x"59", x"14", x"10", x"10", x"59", x"59", x"10", x"10", x"34", x"59", x"59", x"10", x"10", x"59", x"79", x"14", x"10", x"10", x"59", x"59", x"10", x"10", x"14", x"59", x"58", x"10", x"10", x"58", x"79", x"34", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"08", x"10", x"10", x"10", x"59", x"14", x"10", x"10", x"10", x"79", x"10", x"10", x"10", x"14", x"58", x"10", x"10", x"10", x"59", x"14", x"10", x"10", x"10", x"79", x"10", x"10", x"10", x"14", x"59", x"10", x"10", x"10", x"58", x"14", x"10", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"BA", x"04", x"10", x"10", x"10", x"14", x"10", x"10", x"10", x"14", x"10", x"10", x"10", x"10", x"14", x"10", x"10", x"10", x"10", x"34", x"10", x"10", x"10", x"10", x"10", x"10", x"10", x"10", x"14", x"10", x"10", x"10", x"10", x"14", x"10", x"10", x"14", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"08", x"59", x"79", x"14", x"59", x"59", x"59", x"79", x"10", x"59", x"59", x"79", x"58", x"34", x"59", x"59", x"79", x"14", x"59", x"59", x"58", x"78", x"10", x"59", x"59", x"58", x"58", x"14", x"59", x"59", x"78", x"14", x"59", x"59", x"59", x"79", x"24"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"08", x"59", x"14", x"0C", x"59", x"59", x"59", x"10", x"10", x"58", x"59", x"59", x"10", x"34", x"59", x"59", x"14", x"0C", x"59", x"59", x"59", x"10", x"10", x"59", x"59", x"58", x"10", x"34", x"59", x"59", x"34", x"0C", x"59", x"59", x"59", x"14", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"0C", x"34", x"10", x"10", x"59", x"58", x"10", x"10", x"10", x"78", x"58", x"10", x"10", x"14", x"79", x"14", x"10", x"10", x"59", x"58", x"10", x"10", x"10", x"79", x"58", x"10", x"10", x"14", x"79", x"14", x"10", x"10", x"58", x"59", x"10", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"04", x"10", x"10", x"10", x"59", x"10", x"10", x"10", x"10", x"59", x"10", x"10", x"10", x"34", x"14", x"10", x"10", x"10", x"59", x"10", x"10", x"10", x"10", x"59", x"0C", x"10", x"10", x"14", x"34", x"10", x"10", x"10", x"58", x"10", x"10", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"BA", x"04", x"34", x"34", x"34", x"14", x"34", x"34", x"14", x"14", x"34", x"34", x"34", x"34", x"18", x"34", x"34", x"34", x"34", x"34", x"34", x"34", x"34", x"34", x"34", x"34", x"34", x"34", x"14", x"14", x"34", x"34", x"34", x"34", x"34", x"34", x"38", x"24"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"08", x"59", x"58", x"10", x"59", x"59", x"59", x"58", x"10", x"79", x"59", x"78", x"14", x"34", x"59", x"59", x"58", x"10", x"59", x"59", x"58", x"58", x"10", x"59", x"59", x"78", x"14", x"34", x"59", x"59", x"59", x"10", x"59", x"59", x"59", x"59", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"08", x"79", x"10", x"10", x"59", x"59", x"58", x"10", x"10", x"59", x"59", x"14", x"0C", x"34", x"59", x"59", x"10", x"10", x"59", x"59", x"58", x"10", x"10", x"59", x"79", x"14", x"10", x"34", x"59", x"59", x"10", x"10", x"58", x"59", x"59", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"BA", x"28", x"10", x"10", x"10", x"58", x"58", x"10", x"10", x"10", x"79", x"14", x"10", x"10", x"34", x"58", x"10", x"10", x"10", x"59", x"59", x"10", x"10", x"10", x"79", x"14", x"10", x"10", x"14", x"59", x"10", x"10", x"10", x"58", x"58", x"10", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"BA", x"04", x"10", x"10", x"0C", x"38", x"0C", x"10", x"10", x"10", x"14", x"0C", x"10", x"10", x"34", x"10", x"10", x"10", x"10", x"34", x"0C", x"10", x"10", x"10", x"14", x"0C", x"10", x"10", x"14", x"10", x"10", x"10", x"10", x"38", x"0C", x"10", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"08", x"58", x"59", x"38", x"34", x"59", x"59", x"59", x"34", x"59", x"59", x"59", x"59", x"14", x"59", x"59", x"59", x"34", x"38", x"59", x"59", x"59", x"14", x"59", x"59", x"59", x"59", x"34", x"59", x"59", x"59", x"39", x"34", x"59", x"59", x"59", x"24"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"08", x"59", x"58", x"0C", x"59", x"59", x"79", x"14", x"10", x"59", x"59", x"59", x"10", x"34", x"59", x"59", x"59", x"0C", x"59", x"59", x"79", x"14", x"10", x"59", x"59", x"59", x"10", x"34", x"59", x"59", x"59", x"0C", x"58", x"59", x"79", x"34", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"B6", x"28", x"58", x"10", x"10", x"59", x"59", x"14", x"10", x"10", x"58", x"59", x"10", x"10", x"34", x"58", x"58", x"10", x"10", x"59", x"79", x"14", x"10", x"10", x"59", x"59", x"10", x"10", x"14", x"59", x"59", x"10", x"10", x"58", x"59", x"34", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"BA", x"08", x"10", x"10", x"10", x"58", x"14", x"10", x"10", x"10", x"78", x"10", x"10", x"10", x"34", x"58", x"10", x"10", x"10", x"59", x"14", x"10", x"10", x"10", x"79", x"10", x"10", x"10", x"14", x"58", x"10", x"10", x"10", x"59", x"34", x"10", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"BA", x"04", x"10", x"10", x"10", x"14", x"10", x"10", x"10", x"10", x"10", x"10", x"10", x"10", x"34", x"10", x"10", x"10", x"10", x"34", x"10", x"10", x"10", x"14", x"10", x"10", x"10", x"10", x"14", x"10", x"10", x"10", x"10", x"34", x"10", x"10", x"14", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"BA", x"28", x"59", x"79", x"14", x"59", x"59", x"59", x"79", x"10", x"79", x"59", x"79", x"59", x"34", x"59", x"59", x"79", x"14", x"59", x"59", x"59", x"79", x"10", x"79", x"59", x"79", x"58", x"34", x"59", x"59", x"79", x"34", x"58", x"59", x"59", x"79", x"24"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"0C", x"59", x"14", x"0C", x"59", x"58", x"59", x"10", x"10", x"59", x"59", x"59", x"0C", x"34", x"59", x"59", x"14", x"0C", x"59", x"59", x"59", x"10", x"10", x"59", x"59", x"58", x"0C", x"14", x"59", x"59", x"14", x"0C", x"59", x"59", x"59", x"14", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"92", x"69", x"44", x"00", x"08", x"08", x"10", x"59", x"59", x"10", x"10", x"10", x"79", x"38", x"10", x"10", x"34", x"78", x"14", x"10", x"10", x"59", x"58", x"10", x"10", x"10", x"79", x"58", x"10", x"10", x"14", x"79", x"34", x"10", x"10", x"58", x"59", x"10", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"BA", x"00", x"00", x"08", x"0C", x"38", x"34", x"0C", x"08", x"04", x"04", x"10", x"10", x"10", x"10", x"59", x"10", x"10", x"10", x"34", x"14", x"10", x"10", x"10", x"59", x"10", x"10", x"10", x"10", x"58", x"10", x"10", x"10", x"34", x"34", x"10", x"10", x"10", x"58", x"10", x"10", x"10", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"FF", x"44", x"04", x"35", x"38", x"14", x"14", x"14", x"14", x"14", x"34", x"34", x"34", x"04", x"08", x"38", x"34", x"14", x"34", x"34", x"34", x"14", x"34", x"14", x"14", x"14", x"34", x"34", x"14", x"14", x"14", x"34", x"14", x"14", x"14", x"34", x"34", x"34", x"34", x"14", x"34", x"34", x"14", x"38", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"FF", x"00", x"34", x"10", x"58", x"59", x"79", x"14", x"14", x"59", x"59", x"59", x"10", x"59", x"79", x"2C", x"08", x"10", x"58", x"59", x"79", x"14", x"14", x"59", x"59", x"58", x"10", x"59", x"59", x"59", x"58", x"10", x"59", x"59", x"79", x"34", x"34", x"59", x"59", x"59", x"10", x"59", x"59", x"59", x"59", x"04"),
(x"FF", x"FF", x"FF", x"FF", x"00", x"58", x"10", x"10", x"59", x"59", x"14", x"0C", x"34", x"59", x"59", x"10", x"10", x"59", x"59", x"58", x"0C", x"04", x"79", x"59", x"14", x"10", x"34", x"59", x"59", x"10", x"10", x"58", x"59", x"39", x"10", x"10", x"59", x"59", x"34", x"10", x"34", x"59", x"59", x"10", x"10", x"59", x"59", x"38", x"10", x"04"),
(x"FF", x"FF", x"FF", x"24", x"34", x"10", x"10", x"10", x"79", x"14", x"10", x"10", x"34", x"58", x"10", x"10", x"10", x"58", x"59", x"10", x"14", x"04", x"50", x"18", x"10", x"10", x"34", x"59", x"10", x"10", x"10", x"59", x"59", x"10", x"10", x"10", x"79", x"34", x"10", x"10", x"14", x"58", x"10", x"10", x"10", x"58", x"58", x"10", x"10", x"04"),
(x"FF", x"FF", x"B6", x"08", x"10", x"10", x"10", x"10", x"14", x"0C", x"10", x"10", x"34", x"10", x"10", x"10", x"10", x"38", x"0C", x"10", x"10", x"14", x"04", x"10", x"10", x"10", x"14", x"10", x"10", x"10", x"10", x"38", x"0C", x"10", x"10", x"10", x"34", x"0C", x"10", x"10", x"14", x"10", x"10", x"10", x"10", x"38", x"0C", x"10", x"10", x"04"),
(x"FF", x"FF", x"00", x"59", x"59", x"58", x"59", x"34", x"58", x"58", x"58", x"58", x"34", x"59", x"58", x"59", x"34", x"34", x"59", x"58", x"59", x"14", x"55", x"04", x"59", x"58", x"34", x"59", x"58", x"58", x"34", x"35", x"58", x"58", x"59", x"14", x"58", x"59", x"58", x"58", x"34", x"59", x"59", x"58", x"38", x"55", x"59", x"58", x"59", x"24"),
(x"FF", x"B6", x"04", x"58", x"59", x"59", x"14", x"10", x"59", x"59", x"59", x"10", x"14", x"59", x"59", x"58", x"0C", x"59", x"59", x"59", x"14", x"10", x"79", x"04", x"79", x"10", x"34", x"59", x"59", x"58", x"0C", x"58", x"59", x"79", x"14", x"10", x"59", x"59", x"59", x"10", x"14", x"59", x"59", x"58", x"10", x"59", x"59", x"59", x"34", x"04"),
(x"FF", x"20", x"10", x"59", x"59", x"14", x"10", x"10", x"59", x"59", x"10", x"10", x"34", x"58", x"58", x"10", x"10", x"59", x"79", x"14", x"10", x"10", x"59", x"54", x"08", x"10", x"14", x"59", x"38", x"10", x"10", x"59", x"79", x"14", x"10", x"10", x"59", x"59", x"10", x"10", x"14", x"59", x"38", x"10", x"10", x"58", x"79", x"14", x"10", x"04"),
(x"FF", x"00", x"10", x"59", x"14", x"10", x"10", x"10", x"79", x"10", x"10", x"10", x"34", x"58", x"10", x"10", x"10", x"79", x"14", x"10", x"10", x"10", x"59", x"10", x"04", x"10", x"34", x"58", x"10", x"10", x"10", x"59", x"14", x"10", x"10", x"10", x"79", x"10", x"10", x"10", x"34", x"59", x"10", x"10", x"10", x"58", x"34", x"10", x"10", x"04"),
(x"FF", x"04", x"14", x"34", x"10", x"10", x"10", x"14", x"10", x"10", x"10", x"10", x"14", x"10", x"10", x"10", x"10", x"34", x"10", x"10", x"10", x"14", x"14", x"14", x"04", x"10", x"14", x"10", x"10", x"10", x"10", x"14", x"10", x"10", x"10", x"14", x"14", x"10", x"10", x"10", x"14", x"10", x"10", x"10", x"10", x"14", x"10", x"10", x"14", x"24"),
(x"92", x"30", x"14", x"58", x"59", x"59", x"59", x"14", x"79", x"59", x"79", x"58", x"14", x"79", x"59", x"79", x"14", x"58", x"59", x"59", x"59", x"14", x"59", x"79", x"04", x"54", x"34", x"59", x"59", x"59", x"34", x"59", x"59", x"59", x"59", x"10", x"79", x"59", x"79", x"38", x"34", x"59", x"59", x"79", x"14", x"59", x"59", x"58", x"59", x"04"),
(x"92", x"30", x"2C", x"79", x"75", x"79", x"30", x"30", x"79", x"79", x"59", x"2C", x"54", x"79", x"79", x"54", x"0C", x"79", x"75", x"79", x"30", x"30", x"79", x"79", x"51", x"2C", x"54", x"76", x"79", x"54", x"10", x"79", x"79", x"79", x"30", x"30", x"79", x"76", x"59", x"30", x"54", x"79", x"79", x"55", x"2C", x"79", x"79", x"76", x"30", x"28")
);

type grass_form is array (0 to grass_object_Y_size - 1 , 0 to grass_object_X_size - 1) of std_logic;
constant grass : grass_form := (
("11111111111111111111111111111111110000000111111111"),
("11111111111111111111111111111110000000000001111111"),
("11111111111111111111111111111100000000000000011111"),
("11111111111111111111111111111000000000000000001111"),
("11111111111111111111111111110000000000000000000111"),
("11111111111111111111111111100000000000000000000111"),
("11111111111111111111111111100000000000000000000011"),
("11111111111111111111111111000000000000000000000001"),
("11111111111111111111111111000000000000000000000001"),
("11111111111111111111111110000000000000000000000001"),
("11111111111111111111111110000000000000000000000000"),
("11111111111111111111111110000000000000000000000000"),
("11111111111111111111111110000000000000000000000000"),
("11111111111111111111111110000000000000000000000000"),
("11111111111111111111111110000000000000000000000000"),
("11111111111111111111111110000000000000000000000000"),
("11111111111111111111111110000000000000000000000000"),
("11111111111111111111111110000000000000000000000000"),
("11111111111111111111111110000000000000000000000000"),
("11111111111111111111111110000000000000000000000000"),
("11111111111111111111111110000000000000000000000000"),
("11111111111111111111111110000000000000000000000000"),
("11111111111111111111111110000000000000000000000000"),
("11111111111111111111111110000000000000000000000000"),
("11111111111111111111111110000000000000000000000000"),
("11111111111111111111111110000000000000000000000000"),
("11111111111111111111100000000000000000000000000000"),
("11111111111111111110000000000000000000000000000000"),
("11111111111111111100000000000000000000000000000000"),
("11111111111111111000000000000000000000000000000000"),
("11111111111111110000000000000000000000000000000000"),
("11111111111111100000000000000000000000000000000000"),
("11111111111111100000000000000000000000000000000000"),
("11111111111111000000000000000000000000000000000000"),
("11111111111111000000000000000000000000000000000000"),
("11111111111110000000000000000000000000000000000000"),
("11111111111110000000000000000000000000000000000000"),
("11111111111100000000000000000000000000000000000000"),
("11111111111100000000000000000000000000000000000000"),
("11111111111100000000000000000000000000000000000000"),
("11111111111100000000000000000000000000000000000000"),
("11111111111100000000000000000000000000000000000000"),
("11111111111100000000000000000000000000000000000000"),
("11111111111100000000000000000000000000000000000000"),
("11111111111100000000000000000000000000000000000000"),
("11111111111100000000000000000000000000000000000000"),
("11111111111100000000000000000000000000000000000000"),
("11111111111100000000000000000000000000000000000000"),
("11111111111100000000000000000000000000000000000000"),
("11111111111100000000000000000000000000000000000000"),
("11111111111100000000000000000000000000000000000000"),
("11111111111100000000000000000000000000000000000000"),
("11111111111100000000000000000000000000000000000000"),
("11111111111100000000000000000000000000000000000000"),
("11111111111100000000000000000000000000000000000000"),
("11111111111100000000000000000000000000000000000000"),
("11111111111100000000000000000000000000000000000000"),
("11111111111100000000000000000000000000000000000000"),
("11111111111100000000000000000000000000000000000000"),
("11111111111100000000000000000000000000000000000000"),
("11111111111100000000000000000000000000000000000000"),
("11111111111100000000000000000000000000000000000000"),
("11111111110000000000000000000000000000000000000000"),
("11111110000000000000000000000000000000000000000000"),
("11111100000000000000000000000000000000000000000000"),
("11111000000000000000000000000000000000000000000000"),
("11110000000000000000000000000000000000000000000000"),
("11100000000000000000000000000000000000000000000000"),
("11000000000000000000000000000000000000000000000000"),
("11000000000000000000000000000000000000000000000000"),
("10000000000000000000000000000000000000000000000000"),
("10000000000000000000000000000000000000000000000000"),
("10000000000000000000000000000000000000000000000000"),
("00000000000000000000000000000000000000000000000000"),
("00000000000000000000000000000000000000000000000000"),
("00000000000000000000000000000000000000000000000000"));

signal bCoord_X : integer := 0;
signal bCoord_Y : integer := 0;

signal bCoord_X2 : integer := 0;
signal bCoord_Y2 : integer := 0;

signal bCoord_X3 : integer := 0;
signal bCoord_Y3 : integer := 0;

signal bCoord_X4 : integer := 0;
signal bCoord_Y4 : integer := 0;

signal drawing_X : std_logic := '0';
signal drawing_Y : std_logic := '0';

signal drawing_X2 : std_logic := '0';
signal drawing_Y2 : std_logic := '0';

signal drawing_X3 : std_logic := '0';
signal drawing_Y3 : std_logic := '0';

signal drawing_X4 : std_logic := '0';
signal drawing_Y4 : std_logic := '0';

--		
signal ObjectStartX : integer := 150;
signal ObjectStartY : integer := 80;

signal ObjectStart2X : integer := 280;
signal ObjectStart2Y : integer := 90;

signal ObjectStart3X : integer := 400;
signal ObjectStart3Y : integer := 100;

signal ObjectStart4X : integer := 500;
signal ObjectStart4Y : integer := 374;
--
signal objectSouthboundary : integer;
signal objectWestXboundary : integer;

signal object2Southboundary : integer;
signal object2WestXboundary : integer;

signal object3Southboundary : integer;
signal object3WestXboundary : integer;

signal object4Southboundary : integer;
signal object4WestXboundary : integer;


signal drawing_request1 : std_logic;
signal drawing_request2 : std_logic;
signal drawing_request3 : std_logic;
signal drawing_request4 : std_logic;



signal mVGA_RGB1 	:  std_logic_vector(7 downto 0);
signal mVGA_RGB2 	:  std_logic_vector(7 downto 0);
signal mVGA_RGB3 	:  std_logic_vector(7 downto 0);
signal mVGA_RGB4 	:  std_logic_vector(7 downto 0);

---
begin

-- Calculate object boundaries
objectWestXboundary	<= cloud_object_X_size+ObjectStartX;
objectSouthboundary	<= cloud_object_Y_size+ObjectStartY;

object2WestXboundary	<= cloud_object_X_size+ObjectStart2X;
object2Southboundary	<= cloud_object_Y_size+ObjectStart2Y;

object3WestXboundary	<= cloud_object_X_size+ObjectStart3X;
object3Southboundary	<= cloud_object_Y_size+ObjectStart3Y;

object4WestXboundary	<= grass_object_X_size+ObjectStart4X;
object4Southboundary	<= grass_object_Y_size+ObjectStart4Y;

-- Signals drawing_X[Y] are active when obects coordinates are being crossed

	drawing_X	<= '1' when  ((oCoord_X  >= ObjectStartX) and  (oCoord_X < objectWestXboundary)) else '0';
					
	drawing_X2	<= '1' when  ((oCoord_X  >= ObjectStart2X) and  (oCoord_X < object2WestXboundary)) else '0';
	
	drawing_X3	<= '1' when  ((oCoord_X  >= ObjectStart3X) and  (oCoord_X < object3WestXboundary)) else '0';
	
	drawing_X4	<= '1' when  ((oCoord_X  >= ObjectStart4X) and  (oCoord_X < object4WestXboundary)) else '0';
	
    drawing_Y	<= '1' when  ((oCoord_Y  >= ObjectStartY) and  (oCoord_Y < objectSouthboundary)) else '0';
    
    drawing_Y2	<= '1' when  ((oCoord_Y  >= ObjectStart2Y) and  (oCoord_Y < object2Southboundary)) else '0';
        
    drawing_Y3	<= '1' when  ((oCoord_Y  >= ObjectStart3Y) and  (oCoord_Y < object3Southboundary)) else '0';
    
    drawing_Y4	<= '1' when  ((oCoord_Y  >= ObjectStart4Y) and  (oCoord_Y < object4Southboundary)) else '0';

	bCoord_X 	<= (oCoord_X - ObjectStartX) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 
	bCoord_Y 	<= (oCoord_Y - ObjectStartY) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 
	
	bCoord_X2 	<= (oCoord_X - ObjectStart2X) when ( drawing_X2 = '1' and  drawing_Y2 = '1'  ) else 0 ; 
	bCoord_Y2 	<= (oCoord_Y - ObjectStart2Y) when ( drawing_X2 = '1' and  drawing_Y2 = '1'  ) else 0 ; 
	
	bCoord_X3 	<= (oCoord_X - ObjectStart3X) when ( drawing_X3 = '1' and  drawing_Y3 = '1'  ) else 0 ; 
	bCoord_Y3 	<= (oCoord_Y - ObjectStart3Y) when ( drawing_X3 = '1' and  drawing_Y3 = '1'  ) else 0 ; 
	
	bCoord_X4 	<= (oCoord_X - ObjectStart4X) when ( drawing_X4 = '1' and  drawing_Y4 = '1'  ) else 0 ; 
	bCoord_Y4 	<= (oCoord_Y - ObjectStart4Y) when ( drawing_X4 = '1' and  drawing_Y4 = '1'  ) else 0 ; 

process ( RESETn, CLK)

  		
   begin
	if RESETn = '0' then
	    mVGA_RGB	<=  (others => '0') ; 	
		drawing_request	<=  '0' ;

		elsif CLK'event and CLK='1' then
			mVGA_RGB1	<=  cloud1_colors(bCoord_Y , bCoord_X);	
			mVGA_RGB2   <=  cloud1_colors(bCoord_Y2 , bCoord_X2);
			mVGA_RGB3   <=  cloud1_colors(bCoord_Y3 , bCoord_X3);
			mVGA_RGB4   <=  grass_colors(bCoord_Y4 , bCoord_X4);
			
			mVGA_RGB <= mVGA_RGB1 or mVGA_RGB2 or mVGA_RGB3 or mVGA_RGB4;
			
			drawing_request1	<= (not cloud(bCoord_Y , bCoord_X)) and drawing_X and drawing_Y ;
			
			drawing_request2	<= (not cloud(bCoord_Y2 , bCoord_X2)) and drawing_X2 and drawing_Y2 ;
			
			drawing_request3	<= (not cloud(bCoord_Y3 , bCoord_X3)) and drawing_X3 and drawing_Y3 ;
			
			drawing_request4	<= (not grass(bCoord_Y4 , bCoord_X4)) and drawing_X4 and drawing_Y4 ;
						
			if (drawing_request1='1') then
				drawing_request <= drawing_request1;
				mVGA_RGB <= mVGA_RGB1;
				
			elsif (drawing_request2='1') then
				drawing_request <= drawing_request2;
				mVGA_RGB <= mVGA_RGB2;
				
			elsif (drawing_request3='1') then
				drawing_request <= drawing_request3;
				mVGA_RGB <= mVGA_RGB3;
			
			elsif (drawing_request4='1') then
				drawing_request <= drawing_request4;
				mVGA_RGB <= mVGA_RGB4;
				
			else 
				drawing_request <= '0';
				mVGA_RGB <= "00000000";
			end if;
			
	end if;

end process;

		
end behav;