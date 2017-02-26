library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity BlackJack is 
port(CLOCK_50: in std_logic;
	  sw: in std_logic_vector(9 downto 0);
	  key: in std_logic_vector(3 downto 0);
	  ledr: out std_logic_vector(9 downto 0);
	  ledg: out std_logic_vector(7 downto 0);
	  hex0,hex1,hex2,hex3: out std_logic_vector(6 downto 0));

end BlackJack;




architecture structure of BlackJack is
signal sw_clk: std_logic;
signal start: std_logic;
signal CardValue: std_logic_vector(3 downto 0);
signal score: std_logic_vector(5 downto 0);
signal cardReady: std_logic;
signal newCard: std_logic;
signal lost,finished: std_logic;
signal Rsel: std_logic;

signal cmp11,cmp16,cmp21: std_logic;
signal EnableLoad,EnableAdd,EnableScore: std_logic;
signal status: std_logic_vector(5 downto 0); --this is for debugging



component seven_segment_display_2bitdec
port(sw: in std_logic_vector(5 downto 0);
	  hex0: out std_logic_vector(6 downto 0);
	  hex1: out std_logic_vector(6 downto 0));
end component;

component BlackJack_DataPath
port(clk: in std_logic;
	  rst: in std_logic;
	  CardValue: in std_logic_vector(3 downto 0);
	  Rsel: in std_logic;
	  EnableLoad,EnableAdd,EnableScore: in std_logic;
	  cmp11,cmp16,cmp21: out std_logic;
	  score: out std_logic_vector(5 downto 0)
	  );
end component;



component BlackJack_FSM
port(clk,rst: in std_logic;
	  cardReady: in std_logic;
	  cmp11,cmp16,cmp21: in std_logic;
	  newCard: out std_logic;
	  EnableAdd,EnableLoad,EnableScore: out std_logic;
	  finished,lost: out std_logic;
	  Rsel: out std_logic;
	  status: out std_logic_vector(5 downto 0)
	  );
end component;

begin

CardValue <= sw(3 downto 0);
CardReady <= sw(4);
start <= not key(0);
ledg(5) <= newCard;
ledg(6) <= lost;
ledg(7) <= finished;

data_path: BlackJack_DataPath port map(CLOCK_50,start,CardValue,Rsel,EnableLoad,EnableAdd,EnableScore,cmp11,cmp16,cmp21,score);
FSM: BlackJack_FSM port map(CLOCK_50,start,CardReady,cmp11,cmp16,cmp21,newCard,EnableAdd,EnableLoad,EnableScore,finished,lost,Rsel,status);
display: seven_segment_display_2bitdec port map(score,hex0,hex1);
--debug: seven_segment_display_2bitdec port map(counter,hex2,hex3);


end structure;