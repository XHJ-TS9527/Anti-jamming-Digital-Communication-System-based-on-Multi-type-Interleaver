library ieee;
use ieee.std_logic_1164.all;
entity tb_real_voice_DSSS_sender_controller is
end tb_real_voice_DSSS_sender_controller;
architecture tb of tb_real_voice_DSSS_sender_controller is
component real_voice_DSSS_sender_controller is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 START:in std_logic;
		 STOP:in std_logic;
		 INTERWEAVE_READY:in std_logic;
		 BARK_READY:in std_logic;
		 FRAME_END:in std_logic;
		 RST_M_ORDER:out std_logic;
		 FINISH:out std_logic;
		 START_ORDER:out std_logic;
		 DATA_SEL:out std_logic);
end component;
signal CLK,RST,START,STOP,INTERWEAVE_READY,BARK_READY,FRAME_END,RST_M_ORDER,START_ORDER,DATA_SEL,FINISH:std_logic;
begin
	test_component:real_voice_DSSS_sender_controller port map(CLK=>CLK,RST=>RST,START=>START,STOP=>STOP,
				   INTERWEAVE_READY=>INTERWEAVE_READY,BARK_READY=>BARK_READY,FRAME_END=>FRAME_END,RST_M_ORDER=>RST_M_ORDER,
				   START_ORDER=>START_ORDER,DATA_SEL=>DATA_SEL,FINISH=>FINISH);
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
		wait for 7ns;
		START<='0';
		wait for 1ns;
		START<='1';
		wait for 4001ns;
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
	FRAME_END_process:process
	begin
		FRAME_END<='0';
		wait for 2500ns;
		FRAME_END<='1';
		wait;
	end process;
	BARK_READY_process:process
	begin
		BARK_READY<='0';
		wait for 80ns;
		BARK_READY<='1';
		wait until(STOP='0');
		BARK_READY<='1';
		wait for 20ns;
		BARK_READY<='0';
		wait until(START='0');
		BARK_READY<='0';
		wait until (START='1');
		BARK_READY<='0';
		wait until(CLK='1');
		BARK_READY<='0';
		wait for 10ns;
		BARK_READY<='0';
		wait for 80ns;
		BARK_READY<='1';
		wait;
	end process;
	STOP_process:process
	begin
		STOP<='1';
		wait for 1001ns;
		STOP<='0';
		wait for 1ns;
		STOP<='1';
		wait;
	end process;
end tb;