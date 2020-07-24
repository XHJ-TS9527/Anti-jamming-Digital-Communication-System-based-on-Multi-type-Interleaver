library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity tb_shift187 is
end tb_shift187;
architecture tb of tb_shift187 is
component shift187 is
	port(CLK:in std_logic;
		 CLR:in std_logic;
		 ENA:in std_logic;
		 IN_DATA:in std_logic_vector(7 downto 0);
		 OUT_DATA:out std_logic_vector(7 downto 0));
end component;
signal CLK,CLR,ENA:std_logic;
signal IN_DATA:std_logic_vector(7 downto 0):=(others=>'0');
signal OUT_DATA:std_logic_vector(7 downto 0);
begin
	test_shift:shift187 port map(CLK=>CLK,CLR=>CLR,ENA=>ENA,IN_DATA=>IN_DATA,OUT_DATA=>OUT_DATA);
	CLK_process:process
	begin
		CLK<='0';
		wait for 10ns;
		CLK<='1';
		wait for 10ns;
	end process;
	CLR_process:process
	begin
		CLR<='1';
		wait for 1ns;
		CLR<='0';
		wait;
	end process;
	ENA_process:process
	begin
		ENA<='1';
		wait;
	end process;
	shift_in_process:process(CLK)
	begin
		if falling_edge(CLK) then
			if (ENA='1') then IN_DATA<=IN_DATA+'1';
			else IN_DATA<=IN_DATA;
			end if;
		end if;
	end process;
end tb;