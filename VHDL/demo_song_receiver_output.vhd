library ieee;
use ieee.std_logic_1164.all;
entity demo_song_receiver_output is
	port(CLK:in std_logic;
		 DE_WORK:in std_logic;
		 MUSIC_DATA:in std_logic_vector(7 downto 0);
		 MUSIC_WAVE:out std_logic;
		 MUSIC_OUT:out std_logic_vector(2 downto 0));
end demo_song_receiver_output;
architecture stru of demo_song_receiver_output is
component kdCLK is
	port(clk:in std_logic;
		 k:in std_logic_vector(17 downto 0);
		 clk_div:out std_logic;
		 CNT:out std_logic_vector(17 downto 0));
end component;
signal music_1,music_2,music_3,music_4,music_5,music_waveform:std_logic;
signal music_num:std_logic_vector(2 downto 0);
begin
	v1:kdCLK port map(clk=>CLK,k=>"101110101010011011",clk_div=>music_1);
	v2:kdCLK port map(clk=>CLK,k=>"101001100100111100",clk_div=>music_2);
	v3:kdCLK port map(clk=>CLK,k=>"100101000010010011",clk_div=>music_3);
	v4:kdCLK port map(clk=>CLK,k=>"100010111101010000",clk_div=>music_4);
	v5:kdCLK port map(clk=>CLK,k=>"011111001000111111",clk_div=>music_5);
	MUSIC_OUT<=music_num when (DE_WORK='1') else (others=>'Z');
	MUSIC_WAVE<=music_waveform when (DE_WORK='1') else 'Z';
	with MUSIC_DATA select
		 music_waveform<=music_3 when "00000001",
						 music_3 when "00000011",
						 music_4 when "00000010",
						 music_5 when "00000110",
						 music_5 when "00000111",
						 music_4 when "00000101",
						 music_3 when "00000100",
						 music_2 when "00001100",
						 music_1 when "00001101",
						 music_1 when "00001111",
						 music_2 when "00001110",
						 music_3 when "00001010",
						 music_3 when "00001011",
						 music_2 when "00001001",
						 music_2 when "00001000",
						 music_3 when "00011000",
						 music_3 when "00011001",
						 music_4 when "00011010",
						 music_5 when "00011110",
						 music_5 when "00011111",
						 music_4 when "00011101",
						 music_3 when "00011100",
						 music_2 when "00010100",
						 music_1 when "00010101",
						 music_1 when "00010111",
						 music_2 when "00010110",
						 music_3 when "00010010",
						 music_2 when "00010011",
						 music_1 when "00010001",
						 music_1 when "00010000",
						 'Z' when others;
	with MUSIC_DATA select
		music_num<="001" when "00000001",
				   "011" when "00000011",
				   "100" when "00000010",
				   "101" when "00000110",
				   "101" when "00000111",
				   "100" when "00000101",
				   "011" when "00000100",
				   "010" when "00001100",
				   "001" when "00001101",
				   "001" when "00001111",
				   "010" when "00001110",
				   "011" when "00001010",
				   "011" when "00001011",
				   "010" when "00001001",
				   "010" when "00001000",
				   "011" when "00011000",
				   "011" when "00011001",
				   "100" when "00011010",
				   "101" when "00011110",
				   "101" when "00011111",
				   "100" when "00011101",
				   "011" when "00011100",
				   "010" when "00010100",
				   "001" when "00010101",
				   "001" when "00010111",
				   "010" when "00010110",
				   "011" when "00010010",
				   "010" when "00010011",
				   "001" when "00010001",
				   "001" when "00010000",
				   "ZZZ" when others;
end stru;