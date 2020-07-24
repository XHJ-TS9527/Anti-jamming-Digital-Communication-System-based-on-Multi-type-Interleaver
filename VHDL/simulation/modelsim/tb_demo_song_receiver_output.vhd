library ieee;
use ieee.std_logic_1164.all;
entity tb_demo_song_receiver_output is
end entity;
architecture tb of tb_demo_song_receiver_output is
component demo_song_receiver_output is
port(
	CLK:in std_logic;
	MUSIC_DATA:in std_logic_vector(7 downto 0);
	DE_WORK:in std_logic;
	MUSIC_WAVE:out std_logic;
	MUSIC_OUT:out std_logic_vector(2 downto 0)
	);
end component;
signal CLK,DE_WORK,MUSIC_WAVE:std_logic;
signal MUSIC_DATA:std_logic_vector(7 downto 0);
signal MUSIC_OUT:std_logic_vector(2 downto 0);
begin
test:demo_song_receiver_output port map(CLK=>CLK,MUSIC_DATA=>MUSIC_DATA,DE_WORK=>DE_WORK,MUSIC_WAVE=>MUSIC_WAVE,MUSIC_OUT=>MUSIC_OUT);
process
begin
	CLK<='0';
	wait for 10 ns;
	CLK<='1';
	wait for 10 ns;
end process;
process
begin
	DE_WORK<='1';
	wait;
end process;
process
begin
	MUSIC_DATA<="00000001" ;
	wait for 20 ns;
	MUSIC_DATA<="00000011" ;
	wait for 20 ns;
	MUSIC_DATA<="00000110" ;
	wait for 20 ns;
	MUSIC_DATA<="00000101" ;
	wait for 20 ns;
end process;
end architecture;