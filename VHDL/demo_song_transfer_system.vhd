library ieee;
use ieee.std_logic_1164.all;
entity demo_song_transfer_system is
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
end demo_song_transfer_system;
architecture stru of demo_song_transfer_system is
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
component interweaver is
	port(CLK:in std_logic;
		 SENDER_RST:in std_logic;
		 START:in std_logic;
		 PAUSE:in std_logic;
		 CONV_SELECT:in std_logic;
		 CONFIRM:in std_logic;
		 MODE:in std_logic_vector(2 downto 0);
		 TO_SEND_DATA:in std_logic_vector(7 downto 0);
		 READY:out std_logic;
		 SEND_CLK:out std_logic;
		 WR_MODE:out std_logic_vector(2 downto 0);
		 SEND_INFO:out std_logic_vector(13 downto 0);
		 RECEIVE_CLK:in std_logic;
		 RECEIVER_RST:in std_logic;
		 RECEIVE_INFO:in std_logic_vector(13 downto 0);
		 RESTORE_CLK:out std_logic;
		 EFFECTIVE:out std_logic;
		 FAST_CONV_FLAG:out std_logic;
		 INTERWEAVE_MODE:out std_logic_vector(2 downto 0);
		 RESTORE_DATA:out std_logic_vector(7 downto 0));
end component;
component demo_song_receiver is
	port(CLK:in std_logic;
		 RST:in std_logic;
	 	 INTERWEAVE_READY:in std_logic;
		 DATA_IN:in std_logic_vector(7 downto 0);
		 MUSIC_TONE:out std_logic;
		 MUSIC_OUT:out std_logic_vector(2 downto 0));
end component;
signal SEND_CLK,MID_START,MID_CONV_SELECT,MID_CONFIRM,MID_READY,MID_CLK,EFFECTIVE,RESTORE_CLK:std_logic;
signal MID_MODE:std_logic_vector(2 downto 0);
signal SEND_DATA,RESTORE_DATA:std_logic_vector(7 downto 0);
signal MID_INFO:std_logic_vector(13 downto 0);
--signal OUTPUT:std_logic_vector(2 downto 0);
begin
	song_generator:demo_song_sender port map(CLK=>CLK,RST=>RST,EXPERIMENT_MODE=>EXPERIMENT_MODE,
				   START=>START,CONFIRM=>CONFIRM,CONV_SELECT=>CONV_SELECT,INTERWEAVE_READY=>MID_READY,
				   PACE_MODE_SELECT=>PACE_MODE_SELECT,INTERWEAVE_MODE=>INTERWEAVE_MODE,CLK_OUT=>SEND_CLK,
				   START_OUT=>MID_START,CONFIRM_OUT=>MID_CONFIRM,CONV_SELECT_OUT=>MID_CONV_SELECT,MODE_SELECT=>MID_MODE,
				   DATA=>SEND_DATA);
	interweaver_part:interweaver port map(CLK=>SEND_CLK,SENDER_RST=>RST,START=>MID_START,PAUSE=>'1',CONV_SELECT=>MID_CONV_SELECT,
					 CONFIRM=>MID_CONFIRM,MODE=>MID_MODE,TO_SEND_DATA=>SEND_DATA,READY=>MID_READY,SEND_CLK=>MID_CLK,
					 SEND_INFO=>MID_INFO,RECEIVE_CLK=>MID_CLK,RECEIVER_RST=>RST,RECEIVE_INFO=>MID_INFO,RESTORE_CLK=>RESTORE_CLK,
					 EFFECTIVE=>EFFECTIVE,RESTORE_DATA=>RESTORE_DATA);
	receiver:demo_song_receiver port map(CLK=>RESTORE_CLK,RST=>RST,INTERWEAVE_READY=>EFFECTIVE,DATA_IN=>RESTORE_DATA,
			 MUSIC_TONE=>TONE,MUSIC_OUT=>OUTPUT);
end stru;