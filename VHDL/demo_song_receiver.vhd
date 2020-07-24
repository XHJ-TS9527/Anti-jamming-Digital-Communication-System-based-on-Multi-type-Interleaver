library ieee;
use ieee.std_logic_1164.all;
entity demo_song_receiver is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 INTERWEAVE_READY:in std_logic;
		 DATA_IN:in std_logic_vector(7 downto 0);
		 MUSIC_TONE:out std_logic;
		 MUSIC_OUT:out std_logic_vector(2 downto 0));
end demo_song_receiver;
architecture stru of demo_song_receiver is
component demo_song_receiver_output is
	port(CLK:in std_logic;
		 DE_WORK:in std_logic;
		 MUSIC_DATA:in std_logic_vector(7 downto 0);
		 MUSIC_WAVE:out std_logic;
		 MUSIC_OUT:out std_logic_vector(2 downto 0));
end component;
component bark11_detector is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 DATA_IN:in std_logic_vector(7 downto 0);
		 SYNCHRONIZED_FLAG:out std_logic);
end component;
component DSSS_decoder is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 SYNCHRONIZED_FLAG:in std_logic;
		 DATA_IN:in std_logic_vector(7 downto 0);
		 DATA_OUT:out std_logic_vector(7 downto 0));
end component;
component demo_song_receiver_controller is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 INTERWEAVE_EFFECTIVE:in std_logic;
		 BARK_READY:in std_logic;
		 DE_WORK:out std_logic);
end component;
signal bark_ready,de_work:std_logic;
signal decode_data:std_logic_vector(7 downto 0);
begin
	bark11:bark11_detector port map(CLK=>CLK,RST=>RST,DATA_IN=>DATA_IN,SYNCHRONIZED_FLAG=>bark_ready);
	dsss:DSSS_decoder port map(CLK=>CLK,RST=>RST,SYNCHRONIZED_FLAG=>bark_ready,DATA_IN=>DATA_IN,DATA_OUT=>decode_data);
	controller:demo_song_receiver_controller port map(CLK=>CLK,RST=>RST,INTERWEAVE_EFFECTIVE=>INTERWEAVE_READY,
			   BARK_READY=>bark_ready,DE_WORK=>de_work);
	output:demo_song_receiver_output port map(CLK=>CLK,MUSIC_DATA=>decode_data,DE_WORK=>de_work,MUSIC_WAVE=>MUSIC_TONE,
		   MUSIC_OUT=>MUSIC_OUT);
end stru;