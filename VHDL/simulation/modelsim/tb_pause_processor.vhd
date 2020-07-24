library ieee;
use ieee.std_logic_1164.all;
entity tb_pause_processor is
end tb_pause_processor;
architecture tb of tb_pause_processor is
component pause_processor is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 pause_cache:in std_logic;
		 analog_pause:out std_logic);
end component;
signal CLK,RST,pause_cache,analog_pause:std_logic;
begin
	test_component:pause_processor port map(CLK=>CLK,RST=>RST,pause_cache=>pause_cache,analog_pause=>analog_pause);
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
	pause_cache_process:process
	begin
		pause_cache<='0';
		wait for 22ns;
		pause_cache<=not(pause_cache);
		wait for 80ns;
		pause_cache<=not(pause_cache);
		wait for 100ns;
		pause_cache<=not(pause_cache);
		wait for 70ns;
		pause_cache<=not(pause_cache);
		wait;
	end process;
end tb;