library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun Apr 2017

entity objects_mux is
port 	(
		--////////////////////	Clock Input	 	////////////////////	 
		CLK	: in std_logic; --						//	27 MHz
		b_drawing_request : in std_logic;
		b_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	, -- b signal 
		
		c_drawing_request : in std_logic;
		c_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	, -- c signal 
		
		
		d_drawing_request : in std_logic;
		d_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	, -- d signal 
		
		y_drawing_request : in std_logic;	
		y_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- y signal 		
		
		m_mVGA_R 	: out std_logic_vector(9 downto 0); --	,  
		m_mVGA_G 	: out std_logic_vector(9 downto 0); --	, 
		m_mVGA_B 	: out std_logic_vector(9 downto 0); --	, 
		RESETn : in std_logic

	);
end objects_mux;

architecture behav of objects_mux is 
signal m_mVGA_t 	: std_logic_vector(7 downto 0); --	,  


--signal VGA_CLK_t : std_logic;
--signal not_RESETn : std_logic;
--signal RESETn_tmp : std_logic;
--signal m_mVGA_R_t 	: std_logic_vector(2 downto 0); --	,  
--signal m_mVGA_G_t 	: std_logic_vector(2 downto 0); --	, 
--signal m_mVGA_B_t 	: std_logic_vector(1 downto 0); --	,
--signal  object1_draw_req : std_logic;
--signal  object2_draw_req : std_logic;
--
--signal b_mVGA_R 	: std_logic_vector(2 downto 0); --	,  
--signal b_mVGA_G 	: std_logic_vector(2 downto 0); --	, 
--signal b_mVGA_B 	: std_logic_vector(1 downto 0); --	,
--
--signal y_mVGA_R 	: std_logic_vector(2 downto 0); --	,  
--signal y_mVGA_G 	: std_logic_vector(2 downto 0); --	, 
--signal y_mVGA_B 	: std_logic_vector(1 downto 0); --	,


begin


-- priority encoder process

process ( RESETn, CLK)
begin 
	if RESETn = '0' then
			m_mVGA_t	<=  (others => '0') ; 	

	elsif CLK'event and CLK='1' then
		if (b_drawing_request = '1' ) then  
			m_mVGA_t <= b_mVGA_RGB;
		elsif (c_drawing_request = '1' ) then  
			m_mVGA_t <= c_mVGA_RGB;
		elsif (d_drawing_request = '1' ) then  
			m_mVGA_t <= d_mVGA_RGB;				
		else
			m_mVGA_t <= y_mVGA_RGB ;
		end if; 
	end if ; 

end process ;

m_mVGA_R	<= m_mVGA_t(7 downto 5)& "0000000"; -- expand to 10 bits 
m_mVGA_G	<= m_mVGA_t(4 downto 2)& "0000000";
m_mVGA_B	<= m_mVGA_t(1 downto 0)& "00000000";

end behav;