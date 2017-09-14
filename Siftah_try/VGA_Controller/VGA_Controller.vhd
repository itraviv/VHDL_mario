library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_ARITH.all;

entity	VGA_Controller is 
port 
(	--	Host Side
	iCLK 			: in std_logic;
	iRST_N 			: in std_logic;
	oAddress 		: out std_logic_vector(19 downto 0);
	oCoord_X 		: out std_logic_vector(9 downto 0);
	oCoord_Y 		: out std_logic_vector(9 downto 0);

	iRed 			: in std_logic_vector(9 downto 0);
	iGreen 			: in std_logic_vector(9 downto 0);
	iBlue 			: in std_logic_vector(9 downto 0);
	
	oVGA_R 			: out std_logic_vector(9 downto 0);
	oVGA_G 			: out std_logic_vector(9 downto 0);
	oVGA_B 			: out std_logic_vector(9 downto 0);
	oVGA_H_SYNC 	: out std_logic;
	oVGA_V_SYNC 	: out std_logic;
	oVGA_SYNC 		: out std_logic;
	oVGA_BLANK 		: out std_logic;
	oVGA_CLOCK 		: out std_logic) ;
end entity;
--	Control Signal
architecture behav of VGA_Controller is


--	Horizontal Parameter	( Pixel )
constant	H_SYNC_CYC	: integer :=	96;
constant	H_SYNC_BACK	: integer :=	45+3;
constant	H_SYNC_ACT	: integer :=	640;	--	646
-- algrin constant	H_SYNC_ACT	: integer :=	140;	--	646
constant	H_SYNC_FRONT: integer :=	13+3;
constant	H_SYNC_TOTAL: integer :=	800;
--	Virtical Parameter		( Line )
constant	V_SYNC_CYC	: integer :=	2;
constant	V_SYNC_BACK	: integer :=	30+2;
constant	V_SYNC_ACT	: integer :=	480;	--	484
--algrin constant	V_SYNC_ACT	: integer :=	180;	--	484
constant	V_SYNC_FRONT: integer :=	9+2;
constant	V_SYNC_TOTAL: integer :=	525;
--	Start Offset
constant	X_START		: integer :=	H_SYNC_CYC+H_SYNC_BACK+4;
constant	Y_START		: integer :=	V_SYNC_CYC+V_SYNC_BACK;



--	Internal Registers and Wires
signal H_Cont : std_logic_vector(9 downto 0);
signal V_Cont : std_logic_vector(9 downto 0);
signal Cur_Color_R : std_logic_vector(9 downto 0);
signal Cur_Color_G : std_logic_vector(9 downto 0);
signal Cur_Color_B : std_logic_vector(9 downto 0);
signal				mCursor_EN : std_logic;
signal				mRed_EN : std_logic;
signal				mGreen_EN : std_logic;
signal				mBlue_EN : std_logic;

signal oVGA_R_t : std_logic_vector ( 9 downto 0);
signal oVGA_G_t : std_logic_vector ( 9 downto 0);
signal oVGA_B_t : std_logic_vector ( 9 downto 0);

signal oVGA_H_SYNC_t : std_logic;
signal oVGA_V_SYNC_t : std_logic;

signal oCoord_X_t 		: std_logic_vector(9 downto 0);
signal oCoord_Y_t 		: std_logic_vector(9 downto 0);
signal	iCursor_RGB_EN 	: std_logic_vector(3 downto 0);
signal	iCursor_X 		: std_logic_vector(9 downto 0);
signal	iCursor_Y 		: std_logic_vector(9 downto 0);
signal	iCursor_R 		: std_logic_vector(9 downto 0);
signal	iCursor_G 		: std_logic_vector(9 downto 0);
signal	iCursor_B 		: std_logic_vector(9 downto 0);

begin
iCursor_RGB_EN	<= "0111";
iCursor_X		<= "0000000000";
iCursor_Y		<= "0000000000";
iCursor_R		<= "0000000000";
iCursor_G 		<= "0000000000";
iCursor_B		<= "0000000000";

oCoord_X <= oCoord_X_t;
oCoord_Y <= oCoord_Y_t;
oVGA_H_SYNC	<= oVGA_H_SYNC_t;
oVGA_V_SYNC	<= oVGA_V_SYNC_t;

	oVGA_BLANK	<=	oVGA_H_SYNC_t and oVGA_V_SYNC_t;
	oVGA_SYNC	<=	'0';
	oVGA_CLOCK	<=	iCLK;
	mCursor_EN	<=	iCursor_RGB_EN(3);
	mRed_EN		<=	iCursor_RGB_EN(2);
	mGreen_EN	<=	iCursor_RGB_EN(1);
	mBlue_EN	<=	iCursor_RGB_EN(0);

	
	oVGA_R	<=	 oVGA_R_t when (H_Cont>=X_START+9 and
										 H_Cont<X_START+H_SYNC_ACT+9 and
										 V_Cont>=Y_START 	and 
										 V_Cont<Y_START+V_SYNC_ACT ) else
						"0000000000";	
	
	oVGA_R_t <= Cur_Color_R when mRed_EN = '1' else
					"0000000000";
					

					
					
	oVGA_G	<=	oVGA_G_t when 	(	H_Cont>=X_START+9 and
											H_Cont<X_START+H_SYNC_ACT+9 and
											V_Cont>=Y_START 	and 
											V_Cont<Y_START+V_SYNC_ACT ) else
					"0000000000";		
	oVGA_G_t <= Cur_Color_G when 	mGreen_EN = '1' else
					"0000000000";
						

	oVGA_B	<=	oVGA_B_t when 	(	H_Cont>=X_START+9 and
											H_Cont<X_START+H_SYNC_ACT+9 and
											V_Cont>=Y_START 	and 
											V_Cont<Y_START+V_SYNC_ACT ) else
					"0000000000";		
	oVGA_B_t <= Cur_Color_B when 	mBlue_EN = '1' else
					"0000000000";						
						

--	Pixel LUT Address Generator
process ( iCLK, iRST_N)
begin
	if ( iRST_N = '0' ) then
		oCoord_X_t	<=	(OTHERS => '0');
		oCoord_Y_t	<=	(OTHERS => '0');
		oAddress	<=	(OTHERS => '0');
	elsif rising_edge (iCLK) then
		if (	H_Cont>=X_START and H_Cont<X_START+H_SYNC_ACT and
			V_Cont>=Y_START and V_Cont<Y_START+V_SYNC_ACT ) then
				oCoord_X_t	<=	H_Cont-X_START;
				oCoord_Y_t	<=	V_Cont-Y_START;
				-- oAddress	<=	oCoord_Y_t*H_SYNC_ACT+oCoord_X_t-3;
		end	if;
	end if;
end process;


--	Cursor Generator	
process ( iCLK, iRST_N)
begin
	if ( iRST_N = '0' ) then
		Cur_Color_R	<=	(OTHERS => '0');
		Cur_Color_G	<=	(OTHERS => '0');
		Cur_Color_B	<=	(OTHERS => '0');
	elsif rising_edge (iCLK) then
		if(	H_Cont>=X_START+8 and H_Cont<X_START+H_SYNC_ACT+8 and
			V_Cont>=Y_START and V_Cont<Y_START+V_SYNC_ACT ) then
			if( 	((H_Cont=X_START + 8 + iCursor_X) 	or
					(H_Cont=X_START + 8 + iCursor_X+1) or
					(H_Cont=X_START + 8 + iCursor_X-1) or
			 		(V_Cont=Y_START + iCursor_Y)	or
					(V_Cont=Y_START + iCursor_Y+1)	or
					(V_Cont=Y_START + iCursor_Y-1)	 ) and mCursor_EN = '1') then
					Cur_Color_R	<=	iCursor_R;
				Cur_Color_G	<=	iCursor_G;
				Cur_Color_B	<=	iCursor_B;
			else
				Cur_Color_R	<=	iRed;
				Cur_Color_G	<=	iGreen;
				Cur_Color_B	<=	iBlue;
			end if;			
		else
			Cur_Color_R	<=	iRed;
			Cur_Color_G	<=	iGreen;
			Cur_Color_B	<=	iBlue;
		end if ;
	end if;
end process;



--	H_Sync Generator, Ref. 25.175 MHz Clock
process ( iCLK, iRST_N)
begin
	if ( iRST_N = '0' ) then
		H_Cont		<=	(OTHERS => '0');
		oVGA_H_SYNC_t	<=	'0';
	elsif rising_edge (iCLK) then
		--	H_Sync Counter
		if( H_Cont < H_SYNC_TOTAL ) then
			H_Cont	<=	H_Cont+1;
		else
			H_Cont	<=	(OTHERS => '0');
		end if;
		--	H_Sync Generator
		if( H_Cont < H_SYNC_CYC ) then
			oVGA_H_SYNC_t	<=	'0';
		else
			oVGA_H_SYNC_t	<=	'1';	
		end if;
	end if;
end process;	


--	V_Sync Generator, Ref. H_Sync
process ( iCLK, iRST_N)
begin
	if ( iRST_N = '0' ) then
		V_Cont		<=	(OTHERS => '0');
		oVGA_V_SYNC_t	<=	'0';
	elsif rising_edge (iCLK) then
		--	When H_Sync Re-start
		if(H_Cont=0) then
			--	V_Sync Counter
			if( V_Cont < V_SYNC_TOTAL ) then 
				V_Cont	<=	V_Cont+1;
			else
				V_Cont	<=	(OTHERS => '0');
			end if;
			--	V_Sync Generator
			if(	V_Cont < V_SYNC_CYC ) then 
				oVGA_V_SYNC_t	<=	'0';
			else
				oVGA_V_SYNC_t	<=	'1';
			end if;
		end if;
	end if;
	
end process;
	

end behav;