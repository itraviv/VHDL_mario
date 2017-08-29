library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LCD_Table is
port(
	clk, resetN, ena : in std_logic;
	ADDR   			 : in std_logic_vector(7 downto 0);
	enable_LCD		 : out std_logic;
	dout     		 : out std_logic_vector(7 downto 0)
	);
end LCD_Table;

architecture arch of LCD_Table is

type table_type is array(0 to 255) of std_logic_vector(7 downto 0);
signal LCD_table : table_type;

begin

  LCD_Table_proc: process(resetN, clk)
    constant LCD_table : table_type := (
		125=> "00110001",	--1
		61=>  "00110010",	--2
		29=>  "00110011",	--3
		13=>  "00110100",	--4
		5=>   "00110101",	--5
		133=> "00110110",	--6
		197=> "00110111",	--7
		229=> "00111000",	--8
		245=> "00111001",	--9
		253=> "00110000", 	--0
		
		66=>  "01000001",	--A
		132=> "01000010",	--B
		164=> "01000011",	--C
		131=> "01000100",	--D
		1=>   "01000101",	--E
		36=>  "01000110",	--F
		195=> "01000111",	--G
		4=>   "01001000",	--H
		2=>   "01001001",	--I
		116=> "01001010",	--J
		163=> "01001011",	--K
		68=>  "01001100",	--L
		194=> "01001101",	--M
		130=> "01001110",	--N
		227=> "01001111",	--O
		100=> "01010000",	--P
		212=> "01010001",	--Q
		67=>  "01010010",	--R
		3=>   "01010011",	--S
		129=> "01010100",	--T
		35=>  "01010101",	--U
		20=>  "01010110",	--V
		99=>  "01010111",	--W
		148=> "01011000",	--X
		180=> "01011001",	--Y
		196=> "01011010",	--Z
		
		others=> "00000000"        );
  begin

    if (resetN='0') then
      dout <= LCD_table(0);
	  enable_LCD<='0';
    elsif(rising_edge(CLK)) then
	  enable_LCD<=ena;
      if (ena='1') then
          dout <= LCD_table(to_integer(unsigned(ADDR)));
	  else
		  dout <= LCD_table(0);	
      end if;
    end if;
  end process;
end arch;