library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity char2morseTable is
port(
		clk, resetN, ena: in std_logic;
		enqueue			: out std_logic;
		ADDR   			: in std_logic_vector(7 downto 0);
		q	    		: out std_logic_vector(7 downto 0)
	);
end char2morseTable;

architecture arc_char2morseTable of char2morseTable is

type table_type is array(0 to 255) of std_logic_vector(7 downto 0);
signal char2morse_table: table_type;
begin
  SinTable_proc: process(resetN, clk)
    constant char2morse_table: table_type:= (
		22=> "01111101",	--1
		30=> "00111101",	--2
		38=> "00011101",	--3
		37=> "00001101",	--4
		46=> "00000101",	--5
		54=> "10000101",	--6
		61=> "11000101",	--7
		62=> "11100101",	--8
		70=> "11110101",	--9
		69=> "11111101", 	--0
		
		28=> "01000010",	--A
		50=> "10000100",	--B
		33=> "10100100",	--C
		35=> "10000011",	--D
		36=> "00000001",	--E
		43=> "00100100",	--F
		52=> "11000011",	--G
		51=> "00000100",	--H
		67=> "00000010",	--I
		59=> "01110100",	--J
		66=> "10100011",	--K
		75=> "01000100",	--L
		58=> "11000010",	--M
		49=> "10000010",	--N
		68=> "11100011",	--O
		77=> "01100100",	--P
		21=> "11010100",	--Q
		45=> "01000011",	--R
		27=> "00000011",	--S
		44=> "10000001",	--T
		60=> "00100011",	--U
		42=> "00010100",	--V
		29=> "01100011",	--W
		34=> "10010100",	--X
		53=> "10110100",	--Y
		26=> "11000100",	--Z
		
		90=> "01011010",    --enter 
		others=> "00000000"
		);
  
  begin
   if (resetN='0') then
      q <= char2morse_table(0);
	  enqueue<='0';
   elsif(rising_edge(clk)) then
	  enqueue<=ena;
      if (ena='1') then
          q <= char2morse_table(to_integer(unsigned(ADDR)));
      end if;
   end if;
 end process;
end arc_char2morseTable;