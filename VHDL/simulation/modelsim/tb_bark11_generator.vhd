library ieee;
use ieee.std_logic_1164.all;
entity tb_bark11_generator is
end tb_bark11_generator;
architecture tb of tb_bark11_generator is
component bark11_generator is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 START:in std_logic;
		 FINISH:in std_logic;
		 INTERWEAVE_READY:in std_logic;
		 READY:out std_logic;
		 FRAME_END:out std_logic;
		 BARK11:out std_logic_vector(7 downto 0));
end component;
signal CLK,RST,START,FINISH,INTERWEAVE_READY,READY,FRAME_END:std_logic;
signal BARK11:std_logic_vector(7 downto 0);
begin
	test_component:bark11_generator port map(CLK=>CLK,RST=>RST,START=>START,FINISH=>FINISH,INTERWEAVE_READY=>INTERWEAVE_READY,
				   READY=>READY,FRAME_END=>FRAME_END,BARK11=>BARK11);
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
	START_process:process
	begin
		START<='1';
		wait for 2ns;
		START<='0';
		wait for 1ns;
		START<='1';
		wait for 3000ns;
		START<='0';
		wait for 1ns;
		START<='1';
		wait;
	end process;
	INTERWEAVE_READY_process:process
	begin
		INTERWEAVE_READY<='0';
		wait for 20ns;
		INTERWEAVE_READY<='1';
		wait;
	end process;
	FINISH_process:process
	begin
		FINISH<='0';
		wait for 2000ns;
		FINISH<='1';
		wait for 20ns;
		FINISH<='0';
		wait;
	end process;
end tb;