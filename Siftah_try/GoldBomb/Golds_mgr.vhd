library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;

ENTITY Golds_mgr IS 
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
		drawing_request :  OUT  STD_LOGIC;
		hit :  OUT  STD_LOGIC;
		mVGA_RGB :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)	
	);
	
end entity;

architecture arch_Golds_mgr of Golds_mgr is


COMPONENT lpm_counter_cyclic
	PORT(clock : IN STD_LOGIC;
		 q : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
	);
END COMPONENT;


COMPONENT goldfull
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

COMPONENT clk_divider
GENERIC (Div : INTEGER
			);
	PORT(Clk_in : IN STD_LOGIC;
		 Resetn : IN STD_LOGIC;
		 Clk_out : OUT STD_LOGIC
	);
END COMPONENT;

-------------
-- Signals --
-------------
--for every out of a component, make sig


signal d_1_out : std_logic;
signal d_2_out : std_logic;
signal d_3_out : std_logic;
signal d_4_out : std_logic;
signal d_5_out : std_logic;
signal d_6_out : std_logic;
signal d_7_out : std_logic;
signal d_8_out : std_logic;
signal d_9_out : std_logic;
signal d_10_out : std_logic;
signal d_11_out : std_logic;
signal d_12_out : std_logic;
signal d_13_out : std_logic;
signal d_14_out : std_logic;
signal d_15_out : std_logic;
signal d_16_out : std_logic;

signal c_1_q : STD_LOGIC_VECTOR(8 DOWNTO 0);
signal c_2_q : STD_LOGIC_VECTOR(8 DOWNTO 0);
signal c_3_q : STD_LOGIC_VECTOR(8 DOWNTO 0);
signal c_4_q : STD_LOGIC_VECTOR(8 DOWNTO 0);
signal c_5_q : STD_LOGIC_VECTOR(8 DOWNTO 0);
signal c_6_q : STD_LOGIC_VECTOR(8 DOWNTO 0);
signal c_7_q : STD_LOGIC_VECTOR(8 DOWNTO 0);
signal c_8_q : STD_LOGIC_VECTOR(8 DOWNTO 0);
signal c_9_q : STD_LOGIC_VECTOR(8 DOWNTO 0);
signal c_10_q : STD_LOGIC_VECTOR(8 DOWNTO 0);
signal c_11_q : STD_LOGIC_VECTOR(8 DOWNTO 0);
signal c_12_q : STD_LOGIC_VECTOR(8 DOWNTO 0);
signal c_13_q : STD_LOGIC_VECTOR(8 DOWNTO 0);
signal c_14_q : STD_LOGIC_VECTOR(8 DOWNTO 0);
signal c_15_q : STD_LOGIC_VECTOR(8 DOWNTO 0);
signal c_16_q : STD_LOGIC_VECTOR(8 DOWNTO 0);


signal b_1_drawing_request : std_logic;
signal b_1_hit : std_logic;
signal b_1_mVGA_RGB : STD_LOGIC_VECTOR(7 DOWNTO 0);

signal b_2_drawing_request : std_logic;
signal b_2_hit : std_logic;
signal b_2_mVGA_RGB : STD_LOGIC_VECTOR(7 DOWNTO 0);

signal b_3_drawing_request : std_logic;
signal b_3_hit : std_logic;
signal b_3_mVGA_RGB : STD_LOGIC_VECTOR(7 DOWNTO 0);

signal b_4_drawing_request : std_logic;
signal b_4_hit : std_logic;
signal b_4_mVGA_RGB : STD_LOGIC_VECTOR(7 DOWNTO 0);

signal b_5_drawing_request : std_logic;
signal b_5_hit : std_logic;
signal b_5_mVGA_RGB : STD_LOGIC_VECTOR(7 DOWNTO 0);

signal b_6_drawing_request : std_logic;
signal b_6_hit : std_logic;
signal b_6_mVGA_RGB : STD_LOGIC_VECTOR(7 DOWNTO 0);

signal b_7_drawing_request : std_logic;
signal b_7_hit : std_logic;
signal b_7_mVGA_RGB : STD_LOGIC_VECTOR(7 DOWNTO 0);

signal b_8_drawing_request : std_logic;
signal b_8_hit : std_logic;
signal b_8_mVGA_RGB : STD_LOGIC_VECTOR(7 DOWNTO 0);



-----------------
--clk dividers --
-----------------
begin
d_1 : clk_divider
GENERIC MAP(Div => 109
			)
PORT MAP(Clk_in => CLK,
		 Resetn => RESETn,
		 Clk_out => d_1_out);
		 
d_3 : clk_divider
GENERIC MAP(Div => 195
			)
PORT MAP(Clk_in => CLK,
		 Resetn => RESETn,
		 Clk_out => d_3_out);
		 
d_4 : clk_divider
GENERIC MAP(Div => 498
			)
PORT MAP(Clk_in => CLK,
		 Resetn => RESETn,
		 Clk_out => d_4_out);
		 
		 
d_5 : clk_divider
GENERIC MAP(Div => 89
			)
PORT MAP(Clk_in => CLK,
		 Resetn => RESETn,
		 Clk_out => d_5_out);
		 
		 
d_6 : clk_divider
GENERIC MAP(Div => 509
			)
PORT MAP(Clk_in => CLK,
		 Resetn => RESETn,
		 Clk_out => d_6_out);
		 
d_7 : clk_divider
GENERIC MAP(Div => 97
			)
PORT MAP(Clk_in => CLK,
		 Resetn => RESETn,
		 Clk_out => d_7_out);
		 
		 
d_8 : clk_divider
GENERIC MAP(Div => 213
			)
PORT MAP(Clk_in => CLK,
		 Resetn => RESETn,
		 Clk_out => d_8_out);
		 
		 
d_9 : clk_divider
GENERIC MAP(Div => 13
			)
PORT MAP(Clk_in => CLK,
		 Resetn => RESETn,
		 Clk_out => d_9_out);
		 
		 
d_10 : clk_divider
GENERIC MAP(Div => 777
			)
PORT MAP(Clk_in => CLK,
		 Resetn => RESETn,
		 Clk_out => d_10_out);
		 
d_11 : clk_divider
GENERIC MAP(Div => 111
			)
PORT MAP(Clk_in => CLK,
		 Resetn => RESETn,
		 Clk_out => d_11_out);


d_12 : clk_divider
GENERIC MAP(Div => 242
			)
PORT MAP(Clk_in => CLK,
		 Resetn => RESETn,
		 Clk_out => d_12_out);

d_13 : clk_divider
GENERIC MAP(Div => 571
			)
PORT MAP(Clk_in => CLK,
		 Resetn => RESETn,
		 Clk_out => d_13_out);
d_14 : clk_divider
GENERIC MAP(Div => 175
			)
PORT MAP(Clk_in => CLK,
		 Resetn => RESETn,
		 Clk_out => d_14_out);

d_15 : clk_divider
GENERIC MAP(Div => 971
			)
PORT MAP(Clk_in => CLK,
		 Resetn => RESETn,
		 Clk_out => d_15_out);
		 
d_16 : clk_divider
GENERIC MAP(Div => 71			)
PORT MAP(Clk_in => CLK,
		 Resetn => RESETn,
		 Clk_out => d_16_out);


-------------------
--cyclic counters--
-------------------
		 
c_1 : lpm_counter_cyclic PORT MAP(clock => d_1_out , q=> c_1_q );		 
c_2 : lpm_counter_cyclic PORT MAP(clock => d_2_out , q=> c_2_q );		 
c_3 : lpm_counter_cyclic PORT MAP(clock => d_3_out , q=> c_3_q );		 
c_4 : lpm_counter_cyclic PORT MAP(clock => d_4_out , q=> c_4_q );		 
c_5 : lpm_counter_cyclic PORT MAP(clock => d_5_out , q=> c_5_q );		 
c_6 : lpm_counter_cyclic PORT MAP(clock => d_6_out , q=> c_6_q );		 
c_7 : lpm_counter_cyclic PORT MAP(clock => d_7_out , q=> c_7_q );		 
c_8 : lpm_counter_cyclic PORT MAP(clock => d_8_out , q=> c_8_q );		 
c_9 : lpm_counter_cyclic PORT MAP(clock => d_9_out , q=> c_9_q );		 
c_10 : lpm_counter_cyclic PORT MAP(clock => d_10_out , q=> c_10_q );		 
c_11 : lpm_counter_cyclic PORT MAP(clock => d_11_out , q=> c_11_q );		 
c_12 : lpm_counter_cyclic PORT MAP(clock => d_12_out , q=> c_12_q );		 
c_13 : lpm_counter_cyclic PORT MAP(clock => d_13_out , q=> c_13_q );		 
c_14 : lpm_counter_cyclic PORT MAP(clock => d_14_out , q=> c_14_q );		 
c_15 : lpm_counter_cyclic PORT MAP(clock => d_15_out , q=> c_15_q );		 
c_16 : lpm_counter_cyclic PORT MAP(clock => d_16_out , q=> c_16_q );		 

-----------------
--golds fulls-- --
-----------------

b_1_F : goldfull
PORT MAP(CLK => CLK,
		 RESETn => RESETn,
		 timer_done => timer_done,
		 allowed_to_move => '1',
		 enable => '1',
		 oCoord_X => oCoord_X,
		 oCoord_Y => oCoord_Y,
		 Player_X => player_X,
		 Player_Y => player_Y,
		 Random1 => c_1_q,
		 Random2 => c_2_q,
		 drawing_request => b_1_drawing_request,
		 hit => b_1_hit,
		 mVGA_RGB => b_1_mVGA_RGB);
		 
b_2_F : goldfull
PORT MAP(CLK => CLK,
		 RESETn => RESETn,
		 timer_done => timer_done,
		 allowed_to_move => '1',
		 enable => '1',
		 oCoord_X => oCoord_X,
		 oCoord_Y => oCoord_Y,
		 Player_X => player_X,
		 Player_Y => player_Y,
		 Random1 => c_3_q,
		 Random2 => c_4_q,
		 drawing_request => b_2_drawing_request,
		 hit => b_2_hit,
		 mVGA_RGB => b_2_mVGA_RGB);

b_3_F : goldfull
PORT MAP(CLK => CLK,
		 RESETn => RESETn,
		 timer_done => timer_done,
		 allowed_to_move => '1',
		 enable => '1',
		 oCoord_X => oCoord_X,
		 oCoord_Y => oCoord_Y,
		 Player_X => player_X,
		 Player_Y => player_Y,
		 Random1 => c_5_q,
		 Random2 => c_6_q,
		 drawing_request => b_3_drawing_request,
		 hit => b_3_hit,
		 mVGA_RGB => b_3_mVGA_RGB);

		 
b_4_F : goldfull
PORT MAP(CLK => CLK,
		 RESETn => RESETn,
		 timer_done => timer_done,
		 allowed_to_move => '1',
		 enable => '1',
		 oCoord_X => oCoord_X,
		 oCoord_Y => oCoord_Y,
		 Player_X => player_X,
		 Player_Y => player_Y,
		 Random1 => c_7_q,
		 Random2 => c_8_q,
		 drawing_request => b_4_drawing_request,
		 hit => b_4_hit,
		 mVGA_RGB => b_4_mVGA_RGB);

		 
		 
b_5_F : goldfull
PORT MAP(CLK => CLK,
		 RESETn => RESETn,
		 timer_done => timer_done,
		 allowed_to_move => '1',
		 enable => '1',
		 oCoord_X => oCoord_X,
		 oCoord_Y => oCoord_Y,
		 Player_X => player_X,
		 Player_Y => player_Y,
		 Random1 => c_9_q,
		 Random2 => c_10_q,
		 drawing_request => b_5_drawing_request,
		 hit => b_5_hit,
		 mVGA_RGB => b_5_mVGA_RGB);
		 
b_6_F : goldfull
PORT MAP(CLK => CLK,
		 RESETn => RESETn,
		 timer_done => timer_done,
		 allowed_to_move => '1',
		 enable => '1',
		 oCoord_X => oCoord_X,
		 oCoord_Y => oCoord_Y,
		 Player_X => player_X,
		 Player_Y => player_Y,
		 Random1 => c_11_q,
		 Random2 => c_12_q,
		 drawing_request => b_6_drawing_request,
		 hit => b_6_hit,
		 mVGA_RGB => b_6_mVGA_RGB);
		 
b_7_F : goldfull
PORT MAP(CLK => CLK,
		 RESETn => RESETn,
		 timer_done => timer_done,
		 allowed_to_move => '1',
		 enable => '1',
		 oCoord_X => oCoord_X,
		 oCoord_Y => oCoord_Y,
		 Player_X => player_X,
		 Player_Y => player_Y,
		 Random1 => c_13_q,
		 Random2 => c_14_q,
		 drawing_request => b_7_drawing_request,
		 hit => b_7_hit,
		 mVGA_RGB => b_7_mVGA_RGB);
b_8_F : goldfull
PORT MAP(CLK => CLK,
		 RESETn => RESETn,
		 timer_done => timer_done,
		 allowed_to_move => '1',
		 enable => '1',
		 oCoord_X => oCoord_X,
		 oCoord_Y => oCoord_Y,
		 Player_X => player_X,
		 Player_Y => player_Y,
		 Random1 => c_15_q,
		 Random2 => c_16_q,
		 drawing_request => b_8_drawing_request,
		 hit => b_8_hit,
		 mVGA_RGB => b_8_mVGA_RGB);
		 
		 
		 
--b_6_F : goldfull
--PORT MAP(CLK => CLK,
--		 RESETn => RESETn,
--		 timer_done => timer_done,
--		 allowed_to_move => '1',
--		 enable => '1',
--		 oCoord_X => oCoord_X,
--		 oCoord_Y => oCoord_Y,
--		 Player_X => player_X,
--		 Player_Y => player_Y,
--		 Random1 => c_3_q,
--		 Random2 => c_4_q,
--		 drawing_request => b_6_drawing_request,
--		 hit => b_6_hit,
--		 mVGA_RGB => b_6_mVGA_RGB);
--
--		 
--b_7_F : bombfull
--PORT MAP(CLK => CLK,
--		 RESETn => RESETn,
--		 timer_done => timer_done,
--		 allowed_to_move => '1',
--		 enable => '1',
--		 oCoord_X => oCoord_X,
--		 oCoord_Y => oCoord_Y,
--		 Player_X => player_X,
--		 Player_Y => player_Y,
--		 Random1 => c_3_q,
--		 Random2 => c_4_q,
--		 drawing_request => b_7_drawing_request,
--		 hit => b_7_hit,
--		 mVGA_RGB => b_7_mVGA_RGB);


---------------------------
--    Drawing_requests   --
---------------------------		
drawing_request <= '1' when b_1_drawing_request = '1' else
			'1' when b_2_drawing_request = '1' else
			'1' when b_3_drawing_request = '1' else
			'1' when b_4_drawing_request = '1' else
			'1' when b_5_drawing_request = '1' else
			'1' when b_6_drawing_request = '1' else
			'1' when b_7_drawing_request = '1' else
			'1' when b_8_drawing_request = '1' else
			'0';
			

---------------------------
--    Priority for RGB   --
---------------------------
mVGA_RGB   <= b_1_mVGA_RGB when b_1_drawing_request = '1' else
			     b_2_mVGA_RGB when b_2_drawing_request = '1' else
			     b_3_mVGA_RGB when b_3_drawing_request = '1' else
				 b_4_mVGA_RGB when b_4_drawing_request = '1' else
				 b_5_mVGA_RGB when b_5_drawing_request = '1' else
				 b_6_mVGA_RGB when b_6_drawing_request = '1' else
				 b_7_mVGA_RGB when b_7_drawing_request = '1' else
			     b_8_mVGA_RGB;
				 
---------------
--    Hits   --
---------------
hit <= '1' when b_1_hit = '1' else
			'1' when b_2_hit = '1' else
			'1' when b_3_hit = '1' else
			'1' when b_4_hit = '1' else
			'1' when b_5_hit = '1' else
			'1' when b_6_hit = '1' else
			'1' when b_7_hit = '1' else
			'1' when b_8_hit = '1' else
			'0';

end architecture;