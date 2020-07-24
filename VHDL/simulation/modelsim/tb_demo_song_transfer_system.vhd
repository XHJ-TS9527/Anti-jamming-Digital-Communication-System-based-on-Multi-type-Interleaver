library ieee;
use ieee.std_logic_1164.all;
entity tb_demo_song_transfer_system is
end tb_demo_song_transfer_system;
architecture tb of tb_demo_song_transfer_system is
component demo_song_transfer_system is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 EXPERIMENT_MODE:in std_logic;
		 START:in std_logic;
		 CONFIRM:in std_logic;
		 CONV_SELECT:in std_logic;
		 PACE_MODE_SELECT:in std_logic_vector(1 downto 0);
		 INTERWEAVE_MODE:in std_logic_vector(2 downto 0);
		 TONE:out std_logic;
		 OUTPUT:out std_logic_vector(2 downto 0));
end component;
signal CLK,RST,START,CONFIRM,RESTORE_CLK,EFFECTIVE,FAST_CONV_FLAG:std_logic;
signal EXPERIMENT_MODE:std_logic:='0';
signal CONV_SELECT:std_logic:='1';
signal PACE_MODE_SELECT:std_logic_vector(1 downto 0):="00";
signal INTERWEAVE_MODE:std_logic_vector(2 downto 0):="000";
signal OUTPUT:std_logic_vector(2 downto 0);
signal RESTORE_DATA:std_logic_vector(7 downto 0);
begin
	test_component:demo_song_transfer_system port map(CLK=>CLK,RST=>RST,EXPERIMENT_MODE=>EXPERIMENT_MODE,
				   START=>START,CONFIRM=>CONFIRM,CONV_SELECT=>CONV_SELECT,PACE_MODE_SELECT=>PACE_MODE_SELECT,
				   INTERWEAVE_MODE=>INTERWEAVE_MODE,OUTPUT=>OUTPUT);
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
end tb;