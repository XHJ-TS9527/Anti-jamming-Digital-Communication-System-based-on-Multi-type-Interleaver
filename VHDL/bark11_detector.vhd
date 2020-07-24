library ieee;
use ieee.std_logic_1164.all;
entity bark11_detector is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 DATA_IN:in std_logic_vector(7 downto 0);
		 SYNCHRONIZED_FLAG:out std_logic);
end bark11_detector;
architecture stru of bark11_detector is
component rising_D_trigger is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 D:in std_logic;
		 ENA:in std_logic;
		 Q:out std_logic;
		 Qbar:out std_logic);
end component;
signal sync:std_logic;
signal Ds:std_logic_vector(11 downto 0);
signal condition:std_logic_vector(10 downto 0);
constant right_bark:std_logic_vector(10 downto 0):="11100010010";
begin
	SYNCHRONIZED_FLAG<=sync;
	g:for idx in 0 to 10 generate
		d:rising_D_trigger port map(CLK=>CLK,RST=>RST,D=>Ds(idx),ENA=>'1',Q=>Ds(idx+1));
	end generate;
	Ds(0)<=DATA_IN(0);
	condition<=right_bark xnor Ds(11 downto 1);
	process(condition)
	variable num_of_1:integer range 0 to 11;
	begin
		num_of_1:=0;
		for idx in 0 to 10 loop
			if (condition(idx)='1') then num_of_1:=num_of_1+1;
			else num_of_1:=num_of_1+0;
			end if;
		end loop;
		if (num_of_1>10) then sync<='1';
		else sync<='0';
		end if;
	end process;
end stru;