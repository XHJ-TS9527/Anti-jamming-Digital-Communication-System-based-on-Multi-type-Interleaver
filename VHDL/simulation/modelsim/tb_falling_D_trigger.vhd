library ieee;
use ieee.std_logic_1164.all;
entity tb_falling_D_trigger is
end tb_falling_D_trigger;
architecture tb of tb_falling_D_trigger is
component falling_D_trigger is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 D:in std_logic;
		 ENA:in std_logic;
		 Q:out std_logic;
		 Qbar:out std_logic);
end component;
signal CLK,RST,D,ENA,Q,Qbar:std_logic;
begin
	test_trigger:falling_D_trigger port map(CLK=>CLK,RST=>RST,D=>D,ENA=>ENA,Q=>Q,Qbar=>Qbar);
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
	D_process:process
	begin
		D<='1';
		wait for 17ns;
		D<='0';
		wait for 17ns;
	end process;
	ENA_process:process
	begin
		ENA<='0';
		wait for 22ns;
		ENA<='1';
		wait;
	end process;
end tb;