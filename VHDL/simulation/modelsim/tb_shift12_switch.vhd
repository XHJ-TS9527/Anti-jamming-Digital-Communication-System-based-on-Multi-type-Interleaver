library ieee;
use ieee.std_logic_1164.all;
entity tb_shift12_switch is
end tb_shift12_switch;
architecture tb of tb_shift12_switch is
component shift12_switch is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 ENA:in std_logic;
		 IN_BIT:in std_logic;
		 OUT_BIT:out std_logic;
		 CONTENT:out std_logic_vector(11 downto 0));
end component;
signal CLK,RST,ENA,IN_BIT,OUT_BIT:std_logic;
signal CONTENT:std_logic_vector(11 downto 0);
begin
	test_shift:shift12_switch port map(CLK=>CLK,RST=>RST,ENA=>ENA,IN_BIT=>IN_BIT,OUT_BIT=>OUT_BIT,CONTENT=>CONTENT);
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
	ENA_process:process
	begin
		ENA<='1';
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