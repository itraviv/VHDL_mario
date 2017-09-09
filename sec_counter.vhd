library ieee ; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;


entity sec_counter is 
port( RESETN: in std_logic;
		CLK: in std_logic;
		bomb_hit : in std_logic;
		gold_hit : in std_logic;
		jump : in std_logic;
		OneSec: out std_logic;
		soundSel: out std_logic_vector (1 downto 0) );
end entity;

architecture behavior of sec_counter is
signal one_sec_flag : std_logic ;
signal sound_choice : std_logic_vector(1 downto 0);
signal sound_active : std_logic;
begin

process(CLK,RESETN)
    variable one_sec: integer ;
	constant sec: integer := 25000000 ; -- for Real operation - its half sec
 --   constant sec: integer := 10 ; -- for simulation 
begin
    if RESETN = '0' then
        one_sec := 0 ;
        one_sec_flag <= '0' ;
        sound_active <= '0';
        sound_choice <= "11";
    elsif rising_edge(CLK) then
        one_sec := one_sec + 1 ;
        if (one_sec  <= sec) and (sound_active = '1')  then
            one_sec_flag <= '1' ;
        elsif (one_sec = 2*sec) then
			one_sec:= 0;
			sound_active <= '0';
			else
				one_sec_flag <= '0';
        end if;
        
		if ((gold_hit='1') and (jump='1')) or (gold_hit='1') then
			sound_choice <= "01";
			sound_active <= '1';
			one_sec:= 0;
		elsif ((bomb_hit='1') and (jump='1')) or (bomb_hit='1') then
			sound_choice <= "00";
			sound_active <= '1';
			one_sec:= 0;
		elsif (jump='1') and (sound_active='0') then
			sound_choice <= "10";
			sound_active <= '1';
			one_sec:= 0;
		end if;
    end if;
end process;
OneSec <= one_sec_flag;
soundSel <= sound_choice;
end architecture;
