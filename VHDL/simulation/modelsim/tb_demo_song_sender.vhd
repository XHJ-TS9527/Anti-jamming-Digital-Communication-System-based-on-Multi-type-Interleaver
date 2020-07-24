library ieee;
use ieee.std_logic_1164.all;
entity tb_demo_song_sender is
end tb_demo_song_sender;
architecture tb of tb_demo_song_sender is
component demo_song_sender is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 EXPERIMENT_MODE:in std_logic;
		 START:in std_logic;
		 CONFIRM:in std_logic;
		 CONV_SELECT:in std_logic;
		 INTERWEAVE_READY:in std_logic;
		 PACE_MODE_SELECT:in std_logic_vector(1 downto 0);
		 INTERWEAVE_MODE:in std_logic_vector(2 downto 0);
		 CLK_OUT:out std_logic;
		 START_OUT:out std_logic;
		 CONFIRM_OUT:out std_logic;
		 CONV_SELECT_OUT:out std_logic;
		 MODE_SELECT:out std_logic_vector(2 downto 0);
		 DATA:out std_logic_vector(7 downto 0));
end component;
signal CLK,RST,EXPERIMENT_MODE,START,CONFIRM,CONV_SELECT,INTERWEAVE_READY,CLK_OUT,START_OUT,CONFIRM_OUT,CONV_SELECT_OUT:std_logic;
signal PACE_MODE_SELECT:std_logic_vector(1 downto 0):="00";
signal INTERWEAVE_MODE:std_logic_vector(2 downto 0):="000";
signal MODE_SELECT:std_logic_vector(2 downto 0);
signal DATA:std_logic_vector(7 downto 0);
begin
	test_component:demo_song_sender port map(CLK=>CLK,RST=>RST,EXPERIMENT_MODE=>EXPERIMENT_MODE,START=>START,
				   CONFIRM=>CONFIRM,CONV_SELECT=>CONV_SELECT,INTERWEAVE_READY=>INTERWEAVE_READY,
				   PACE_MODE_SELECT=>PACE_MODE_SELECT,INTERWEAVE_MODE=>INTERWEAVE_MODE,CLK_OUT=>CLK_OUT,
				   START_OUT=>START_OUT,CONFIRM_OUT=>CONFIRM_OUT,CONV_SELECT_OUT=>CONV_SELECT_OUT,
				   MODE_SELECT=>MODE_SELECT,DATA=>DATA);
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
	EXPERIMENT_MODE_process:process
	begin
		EXPERIMENT_MODE<='0';
		wait;
	end process;
	CONV_SELECT_process:process
	begin
		CONV_SELECT<='1';
		wait;
	end process;
	START_process:process
	begin
		START<='1';
		wait for 7ns;
		START<='0';
		wait for 1ns;
		START<='1';
		wait for 4000ns;
		START<='0';
		wait for 1ns;
		START<='1';
		wait;
	end process;
	CONFIRM_process:process
	begin
		CONFIRM<='1';
		wait for 3ns;
		CONFIRM<='0';
		wait for 1ns;
		CONFIRM<='1';
		wait;
	end process;
	INTERWEAVE_READY_process:process
	begin
		INTERWEAVE_READY<='0';
		wait for 20ns;
		INTERWEAVE_READY<='1';
		wait;
	end process;
end tb;