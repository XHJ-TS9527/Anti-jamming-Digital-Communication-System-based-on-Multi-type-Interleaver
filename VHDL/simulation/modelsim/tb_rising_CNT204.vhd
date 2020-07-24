library ieee;
use ieee.std_logic_1164.all;
entity tb_rising_CNT204 is
end tb_rising_CNT204;
architecture tb of tb_rising_CNT204 is
component rising_CNT204 is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 ENA:in std_logic;
		 CNT:out std_logic_vector(7 downto 0));
end component;
signal CLK,RST,ENA:std_logic;
signal CNT:std_logic_vector(7 downto 0);
begin
	test_CNT:rising_CNT204 port map(CLK=>CLK,RST=>RST,ENA=>ENA,CNT=>CNT);
	CLK_process:process
	begin
		CLK<='1';
		wait for 10ns;
		CLK<='0';
		wait for 10ns;
	end process;
	ENA_process:process
	begin
		ENA<='0';
		wait for 230ns;
		ENA<='1';
		wait;
	end process;
	RST_process:process
	begin
		RST<='1';
		wait for 520ns;
		RST<='0';
		wait for 20ns;
		RST<='1';
		wait;
	end process;
end tb;