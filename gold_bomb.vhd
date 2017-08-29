-------------------------
--Module Name:
-- gold_bomb
--Description:
-- 
--------------------------

library ieee; 
use ieee.std_logic_1164.all; 
--use ieee.std_logic_signed.all; 
use ieee.std_logic_arith.all;

entity gold_bomb is
	port( 
		resetN : in std_logic;
		clk : in std_logic;
		isGold : in std_logic; -- '1' if gold, else bomb
		iHit : in std_logic ; -- tells if mario hits this bomb
		marioX: in std_logic_vector(31 downto 0) ; 
		marioY: in std_logic_vector(31 downto 0) ;
		randX: in std_logic_vector(31 downto 0) ; 
		randY: in std_logic_vector(31 downto 0) ;
		speed : in std_logic_vector(2 downto 0) ;
		
		X: out std_logic_vector(31 downto 0) ; 
		Y: out std_logic_vector(31 downto 0) ;
		oisGold : out std_logic -- '1' if gold, else bomb

		);
end entity;

architecture arch_gold_bomb of gold_bomb is
	type state_type is (off,exists,move_left,move_right,move_up,move_down,m_ru, m_rd, m_lu, m_ld );
	signal state :state_type;
begin
--TODO: 1. proccess1: compute new X,Y
--TODO: 2. proccess2: compute state

end architecture;