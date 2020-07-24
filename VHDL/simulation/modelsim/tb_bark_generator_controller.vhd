library ieee;
use ieee.std_logic_1164.all;
entity tb_bark_generator_controller is
end tb_bark_generator_controller;
architecture tb of tb_bark_generator_controller is
component bark_generator_controller is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 START:in std_logic;
		 FINISH:in std_logic;
		 INTERWEAVE_READY:in std_logic;
		 LAST_BIT:in std_logic;
		 READY:out std_logic;
		 CTRL_BIT:out std_logic;
		 FRAME_END:out std_logic);
end component;
signal CLK,RST,START,FINISH,INTERWEAVE_READY,LAST_BIT,READY,CTRL_BIT,FRAME_END:std_logic;
begin
	test_state_machine:bark_generator_controller port map(CLK=>CLK,RST=>RST,START=>START,FINISH=>FINISH,
					   INTERWEAVE_READY=>INTERWEAVE_READY,LAST_BIT=>LAST_BIT,READY=>READY,CTRL_BIT=>CTRL_BIT,
					   FRAME_END=>FRAME_END);
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
		wait for 2500ns;
		START<='0';
		wait for 1ns;
		START<='1';
		wait for 2ns;
		START<='0';
		wait for 1ns;
		START<='1';
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
		wait for 1600ns;
		FINISH<='1';
		wait for 20ns;
		FINISH<='0';
		wait;
	end process;
	LAST_BIT_process:process
	begin
		LAST_BIT<='0';
		wait for 270ns;
		LAST_BIT<='1';
		wait for 20ns;
		LAST_BIT<='0';
		wait until (FINISH='1');
		LAST_BIT<='0';
		wait for 290ns;
		LAST_BIT<='1';
		wait for 20ns;
		LAST_BIT<='0';
		wait until (CTRL_BIT='1');
		LAST_BIT<='0';
		wait for 270ns;
		LAST_BIT<='1';
		wait for 20ns;
		LAST_BIT<='0';
		wait;
	end process;
end tb;