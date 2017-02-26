library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity BlackJack_FSM is 

port(clk,rst: in std_logic;
	  cardReady: in std_logic;
	  cmp11,cmp16,cmp21: in std_logic;
	  newCard: out std_logic;
	  EnableAdd,EnableLoad,EnableScore: out std_logic;
	  finished,lost: out std_logic;
	  Rsel: out std_logic;
	  status: out std_logic_vector(5 downto 0)
	  );

end BlackJack_FSM;


architecture behavior of BlackJack_FSM is
type state_type is (newCard_state,load_state,add_state,score_state,transition_state,finish_state,lost_state);
signal y: state_type;

begin

FSM: process(rst,clk)
begin

	if rst = '1' then
		newCard <= '0';
		EnableAdd <= '0'; EnableLoad <= '0'; EnableScore <= '0';
		finished <= '0'; lost <= '0'; status <= "000000";
		Rsel <= '0';
		y <= newCard_state;
		
	elsif clk'event and clk = '1' then
		case y is
			when newCard_state=>
				status <= "000001";
				newCard <= '1';
				Rsel <= '1';
				--debug
				
				--debug
				if cardReady = '0' then
					y <= newCard_state;
				else
					y <= load_state;
				end if;
				
			when load_state=>
				status <= "000010";
				newCard <= '0';
				EnableLoad <= '1';
				if cardReady = '1' then
					y <= load_state;
				else 
					y <= add_state;
				end if;
		
			when add_state =>
				status <= "000011";
				EnableAdd <= '1';
				EnableLoad <= '0';
				y <= score_state;
			
			when score_state =>
				status <= "000100";
				EnableAdd <= '0';
				EnableLoad <= '0';
				
				y <= transition_state;
			
				
			when transition_state =>
				status <= "000101";
				--debug
			
				--debug
				if (cmp21 = '1' and cmp11 = '1') then
					Rsel <= '0';
					y <= load_state;
				elsif (cmp21 = '1' and cmp11 = '0') then
					EnableScore <= '1';
					y <= lost_state;
				elsif (cmp21 = '0' and cmp16 = '1') then
					EnableScore <= '1';
					y <= finish_state;
				elsif (cmp21 = '0' and cmp16 = '0') then
					EnableScore <= '1';
					y <= newCard_state;
				end if;
				
			when finish_state =>
				status <= "000110";
				finished <= '1';
				EnableAdd <= '0';
				EnableLoad <= '0';
				EnableScore <= '0'; --------?
				y <= finish_state;
			
			when lost_state =>
				status <= "000111";
				lost <= '1';
				EnableAdd <= '0';
				EnableLoad <= '0';
				EnableScore <= '0'; --------?
				y <= lost_state;
				
		
		end case;
	
	end if;
	


end process;



end behavior;



