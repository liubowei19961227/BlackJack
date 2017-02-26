library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity seven_segment_display_2bitdec is

port(sw: in std_logic_vector(5 downto 0);
	  hex0: out std_logic_vector(6 downto 0);
	  hex1: out std_logic_vector(6 downto 0));
end seven_segment_display_2bitdec;

architecture behavior of seven_segment_display_2bitdec is

component divide_num 
port(num: in std_logic_vector(5 downto 0);
	  s0: out std_logic_vector(3 downto 0);
	  s1: out std_logic_vector(3 downto 0));
end component divide_num;



component seven_segment_hex
port(sw: in std_logic_vector(3 downto 0);
	  hexn: out std_logic_vector(6 downto 0));
end component seven_segment_hex;



signal s0: std_logic_vector(3 downto 0);
signal s1: std_logic_vector(3 downto 0);

begin

get_s0_s1: divide_num port map(sw,s0,s1);
display_s0: seven_segment_hex port map(s0, hex1);
display_s1: seven_segment_hex port map(s1, hex0);


end behavior;



-------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity divide_num is 
port(num: in std_logic_vector(5 downto 0);
	  s0: out std_logic_vector(3 downto 0);
	  s1: out std_logic_vector(3 downto 0));
end divide_num;

architecture behavior of divide_num is
signal temp: std_logic_vector(5 downto 0);

begin

	process(num)
	begin
		if (num < 10) then
			s0 <= "0000";
			s1 <= num(3 downto 0);
			
		elsif num > 29 then
			s0 <= "0011";
			temp <= num - 30;
			s1 <= temp(3 downto 0);
			
		elsif num > 19 then
			s0 <= "0010";
			temp <= num - 20;
			s1 <= temp(3 downto 0);
		elsif num > 9 then
			s0 <= "0001";
			temp <= num - 10;
			s1 <= temp(3 downto 0);
		
		else
			s0 <= "0000";
			s1 <= "0000";
		
		end if;	
	
	end process;


end behavior;




---------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity seven_segment_hex is
port(sw: in std_logic_vector(3 downto 0);
	  hexn: out std_logic_vector(6 downto 0));
end seven_segment_hex;


architecture behavior of seven_segment_hex is
begin
	process(sw)
	begin
		case sw is
		when "0000" => hexn <="1000000";
		when "0001" => hexn <="1111001";
		when "0010" => hexn <="0100100";
		when "0011" => hexn <="0110000";
		when "0100" => hexn <="0011001";
		when "0101" => hexn <="0010010";
		when "0110" => hexn <="0000010";
		when "0111" => hexn <="1111000";
		when "1000" => hexn <="0000000";
		when "1001" => hexn <="0010000";
		when "1010" => hexn <="0001000";
		when "1011" => hexn <="0000011";
		when "1100" => hexn <="1000110";
		when "1101" => hexn <="0100001";
		when "1110" => hexn <="0000110";
		when others => hexn <="0001110";
	end case;
	end process;

end behavior;


