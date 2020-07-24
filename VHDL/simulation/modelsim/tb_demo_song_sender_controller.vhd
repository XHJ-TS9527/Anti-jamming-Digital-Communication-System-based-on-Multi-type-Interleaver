library ieee;
use ieee.std_logic_1164.all;
entity tb_demo_song_sender_controller is
end tb_demo_song_sender_controller;
architecture tb of tb_demo_song_sender_controller is
component demo_song_sender_controller is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 START:in std_logic;
		 INTERWEAVE_READY:in std_logic;
		 BARK_READY:in std_logic;
		 SONG_FINISH:in std_logic;
		 FRAME_END:in std_logic;
		 SONG_START_ORDER:out std_logic;
		 DATA_SEL:out std_logic);
end component;
signal CLK,RST,START,INTERWEAVE_READY,BARK_READY,SONG_FINISH,FRAME_END,SONG_START_ORDER,DATA_SEL:std_logic;
begin
	test_state_machine:demo_song_sender_controller port map(CLK=>CLK,RST=>RST,START=>START,INTERWEAVE_READY=>INTERWEAVE_READY,
					   BARK_READY=>BARK_READY,SONG_FINISH=>SONG_FINISH,FRAME_END=>FRAME_END,SONG_START_ORDER=>SONG_START_ORDER,
					   DATA_SEL=>DATA_SEL);
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
		wait for 3001ns;
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
		wait until(SONG_FINISH='1');
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
	SONG_FINISH_process:process
	begin
		SONG_FINISH<='0';
		wait for 1000ns;
		SONG_FINISH<='1';
		wait for 20ns;
		SONG_FINISH<='0';
		wait;
	end process;
end tb;