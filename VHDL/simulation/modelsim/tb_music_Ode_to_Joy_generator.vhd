library ieee;
use ieee.std_logic_1164.all;
entity tb_music_Ode_to_Joy_generator is
end tb_music_Ode_to_Joy_generator;
architecture tb of tb_music_Ode_to_Joy_generator is
component music_Ode_to_Joy_generator is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 BARK_READY:in std_logic;
		 FINISH:out std_logic;
		 SONG_DATA:out std_logic_vector(7 downto 0));
end component;
signal CLK,RST,BARK_READY,FINISH:std_logic;
signal SONG_DATA:std_logic_vector(7 downto 0);
begin
	test_component:music_Ode_to_Joy_generator port map(CLK=>CLK,RST=>RST,BARK_READY=>BARK_READY,FINISH=>FINISH,
				   SONG_DATA=>SONG_DATA);
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
	BARK_READY_process:process
	begin
		BARK_READY<='0';
		wait for 20ns;
		BARK_READY<='1';
		wait until (FINISH='1');
		BARK_READY<='1';
		wait for 20ns;
		BARK_READY<='0';
		wait;
	end process;
end tb;