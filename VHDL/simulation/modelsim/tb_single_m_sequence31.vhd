library ieee;
use ieee.std_logic_1164.all;
entity tb_single_m_sequence31 is
end tb_single_m_sequence31;
architecture tb of tb_single_m_sequence31 is
component single_m_sequence31 is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 IN_BIT:in std_logic;
		 M:out std_logic);
end component;
signal CLK,RST,IN_BIT,M:std_logic;
begin
	test_component:single_m_sequence31 port map(CLK=>CLK,RST=>RST,IN_BIT=>IN_BIT,M=>M);
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
	IN_BIT_process:process
	begin
		IN_BIT<='0';
		wait for 10ns;
		IN_BIT<='1';
		wait for 20ns;
		IN_BIT<='0';
		wait;
	end process;
end tb;