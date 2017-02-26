library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity BlackJack_DataPath is 
port(clk: in std_logic;
	  rst: in std_logic;
	  CardValue: in std_logic_vector(3 downto 0);
	  Rsel: in std_logic;
	  EnableLoad,EnableAdd,EnableScore: in std_logic;
	  cmp11,cmp16,cmp21: out std_logic;
	  score: out std_logic_vector(5 downto 0)
	  );


end BlackJack_DataPath;

architecture structure of BlackJack_DataPath is

signal loadValue: std_logic_vector(5 downto 0);
signal addValue: std_logic_vector(5 downto 0);

begin

datapath: process(rst,clk)
begin
	if rst = '1' then
		loadValue <= "000000";
		addValue <= "000000";
		score <= "000000";
	elsif clk'event and clk = '1' then
		if enableLoad = '1' then
			if Rsel = '1' then loadValue <= "00" & CardValue;
			else loadValue <= "110110"; end if;
		end if;
		
		if enableAdd = '1' then
			addValue <= addValue + loadValue;
		end if;
		
		if enableScore = '1' then
			score <= addValue;
		end if;
		
	end if;

end process;



compare: process(loadValue,addValue,rst)
begin
	if rst = '1' then
		cmp11 <= '0';
		cmp16 <= '0';
		cmp21 <= '0';
	else 
		if loadValue = 11 then
			cmp11 <= '1';
		else 
			cmp11 <= '0';
		end if;
		
		if addValue > 21 then
			cmp21 <= '1';
		else 
			cmp21 <= '0';
		end if;
		
		if addValue > 16 then
			cmp16 <= '1';
		else
			cmp16 <= '0';
		end if;
		
	end if;

end process;


		


end structure;