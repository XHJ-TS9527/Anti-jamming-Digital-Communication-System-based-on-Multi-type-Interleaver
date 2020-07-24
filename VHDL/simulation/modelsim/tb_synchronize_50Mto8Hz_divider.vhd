library ieee;
use ieee.std_logic_1164.all;
entity tb_synchronize_50Mto8Hz_divider is
end tb_synchronize_50Mto8Hz_divider;
architecture tb of tb_synchronize_50Mto8Hz_divider is
component synchronize_50Mto8Hz_divider is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 CLK_DIV:out std_logic);
end component;
signal CLK,RST,CLK_DIV:std_logic;
begin
	test_divider:synchronize_50Mto8Hz_divider port map(CLK=>CLK,RST=>RST,CLK_DIV=>CLK_DIV);
	CLK_process:process
	begin
		CLK<='0';
		wait for 10ns;
		CLK<='1';
		wait for 10ns;
	end process;
	RST_process:process
	begin
		RST<='0';
		wait for 1ns;
		RST<='1';
		wait;
	end process;
end tb;