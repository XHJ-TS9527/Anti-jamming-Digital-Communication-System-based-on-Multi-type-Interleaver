library ieee;
use ieee.std_logic_1164.all;
entity demo_sound_interweave_transfer_system is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 EXPERIMENT_MODE:in std_logic;
		 VOICE_ENABLE:in std_logic;
		 START:in std_logic;
		 STOP:in std_logic;
		 CONFIRM:in std_logic;
		 CONV_SELECT:in std_logic;
		 PACE_MODE_SELECT:in std_logic_vector(1 downto 0);
		 INTERWEAVE_MODE:in std_logic_vector(2 downto 0);
		 PCM_DATA:in std_logic_vector(7 downto 0);
		 TONE_WAVE:out std_logic;
		 TONE:out std_logic_vector(2 downto 0);
		 VOICE_RECORDING:out std_logic;
		 VOICE_PLAYING:out std_logic;
		 PCM_RESTORE_DATA:out std_logic_vector(7 downto 0));
end demo_sound_interweave_transfer_system;
architecture stru of demo_sound_interweave_transfer_system is
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
component real_voice_DSSS_sender is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 START:in std_logic;
		 STOP:in std_logic;
		 CONFIRM:in std_logic;
		 CONV_SELECT:in std_logic;
		 INTERWEAVE_READY:in std_logic;
		 INTERWEAVE_MODE:in std_logic_vector(2 downto 0);
		 PCM_DATA:in std_logic_vector(7 downto 0);
		 CLK_OUT:out std_logic;
		 START_OUT:out std_logic;
		 CONFIRM_OUT:out std_logic;
		 CONV_SELECT_OUT:out std_logic;
		 RECORDING:out std_logic;
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
component real_voice_DSSS_receiver is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 INTERWEAVE_EFFECTIVE:in std_logic;
		 DATA:in std_logic_vector(7 downto 0);
		 EFFECTIVE:out std_logic;
		 PCM_DATA:out std_logic_vector(7 downto 0));
end component;
component rising_D_trigger is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 D:in std_logic;
		 ENA:in std_logic;
		 Q:out std_logic;
		 Qbar:out std_logic);
end component;
component D_latch is
	port(D:in std_logic;
		 RST:in std_logic;
		 ENA:in std_logic;
		 Q:out std_logic;
		 Qbar:out std_logic);
end component;
signal song_sender_CLK,song_start,song_confirm,song_interweave_ready,mid_ready,song_sender_clk_out:std_logic;
signal song_start_out,song_confirm_out,song_conv_select_out,voice_sender_CLK,song_conv_select:std_logic;
signal voice_start,voice_confirm,voice_interweave_ready,voice_sender_clk_out:std_logic;
signal voice_conv_select,voice_conv_select_out,voice_start_out,voice_confirm_out:std_logic;
signal send_CLK,send_start,send_confirm,send_conv_select,mid_clk,receive_CLK,mid_effective:std_logic;
signal song_receiver_CLK,song_effective,voice_receiver_CLK,voice_effective,VOICE_ENA,not_start_lock,start_lock:std_logic;
signal song_mode_select,voice_mode_select,send_mode:std_logic_vector(2 downto 0);
signal song_sender_data,voice_sender_data,send_data,receive_data,song_receiver_data,voice_receiver_data:std_logic_vector(7 downto 0);
signal mid_info:std_logic_vector(13 downto 0);
begin
	start_cache:rising_D_trigger port map(CLK=>START,RST=>RST,D=>'1',ENA=>'1',Q=>not_start_lock);
	start_lock<=not(not_start_lock);
	voice_ok:D_latch port map(D=>VOICE_ENABLE,RST=>RST,ENA=>start_lock,Q=>VOICE_ENA);
	song_sender_CLK<=CLK when (VOICE_ENA='0') else 'Z';
	song_start<=START when (VOICE_ENA='0') else 'Z';
	song_confirm<=CONFIRM when (VOICE_ENA='0') else 'Z';
	song_conv_select<=CONV_SELECT when (voice_ENA='0') else 'Z';
	song_interweave_ready<=mid_ready when (VOICE_ENA='0') else 'Z';
	song_sender:demo_song_sender port map(CLK=>song_sender_CLK,RST=>RST,EXPERIMENT_MODE=>EXPERIMENT_MODE,
				START=>song_start,CONFIRM=>song_confirm,CONV_SELECT=>song_conv_select,INTERWEAVE_READY=>song_interweave_ready,
				PACE_MODE_SELECT=>PACE_MODE_SELECT,INTERWEAVE_MODE=>INTERWEAVE_MODE,CLK_OUT=>song_sender_clk_out,
				START_OUT=>song_start_out,CONFIRM_OUT=>song_confirm_out,CONV_SELECT_OUT=>song_conv_select_out,
				MODE_SELECT=>song_mode_select,DATA=>song_sender_data);
	voice_sender_CLK<=CLK when (VOICE_ENA='1') else 'Z';
	voice_start<=START when (VOICE_ENA='1') else 'Z';
	voice_confirm<=CONFIRM when (VOICE_ENA='1') else 'Z';
	voice_conv_select<=CONV_SELECT when (VOICE_ENA='1') else 'Z';
	voice_interweave_ready<=mid_ready when (VOICE_ENA='1') else 'Z';
	voice_sender:real_voice_DSSS_sender port map(CLK=>voice_sender_CLK,RST=>RST,START=>voice_start,
				 STOP=>STOP,CONFIRM=>voice_confirm,CONV_SELECT=>voice_conv_select,INTERWEAVE_READY=>voice_interweave_ready,
				 INTERWEAVE_MODE=>INTERWEAVE_MODE,PCM_DATA=>PCM_DATA,CLK_OUT=>voice_sender_clk_out,START_OUT=>voice_start_out,
				 CONFIRM_OUT=>voice_confirm_out,CONV_SELECT_OUT=>voice_conv_select_out,RECORDING=>VOICE_RECORDING,
				 MODE_SELECT=>voice_mode_select,DATA=>voice_sender_data);
	send_CLK<=voice_sender_clk_out when (VOICE_ENA='1') else song_sender_clk_out;
	send_start<=voice_start_out when (VOICE_ENA='1') else song_start_out;
	send_conv_select<=voice_conv_select_out when (VOICE_ENA='1') else song_conv_select_out;
	send_confirm<=voice_confirm_out when (VOICE_ENA='1') else song_confirm_out;
	send_mode<=voice_mode_select when (VOICE_ENA='1') else song_mode_select;
	send_data<=voice_sender_data when (VOICE_ENA='1') else song_sender_data;
	TRANS:interweaver port map(CLK=>send_CLK,SENDER_RST=>RST,START=>send_start,PAUSE=>'1',CONV_SELECT=>send_conv_select,
		  CONFIRM=>send_confirm,MODE=>send_mode,TO_SEND_DATA=>send_data,READY=>mid_ready,SEND_CLK=>mid_clk,SEND_INFO=>mid_info,
		  RECEIVE_CLK=>mid_clk,RECEIVER_RST=>RST,RECEIVE_INFO=>mid_info,RESTORE_CLK=>receive_CLK,EFFECTIVE=>mid_effective,
		  RESTORE_DATA=>receive_data);
	song_receiver_CLK<=receive_CLK when (VOICE_ENA='0') else 'Z';
	song_effective<=mid_effective when (VOICE_ENA='0') else 'Z';
	song_receiver_data<=receive_data when (VOICE_ENA='0') else (others=>'Z');
	song_receiver:demo_song_receiver port map(CLK=>song_receiver_CLK,RST=>RST,INTERWEAVE_READY=>song_effective,
				  DATA_IN=>song_receiver_data,MUSIC_TONE=>TONE_WAVE,MUSIC_OUT=>TONE);
	voice_receiver_CLK<=receive_CLK when (VOICE_ENA='1') else 'Z';
	voice_effective<=mid_effective when (VOICE_ENA='1') else 'Z';
	voice_receiver_data<=receive_data when (VOICE_ENA='1') else (others=>'Z');
	voice_receiver:real_voice_DSSS_receiver port map(CLK=>voice_receiver_CLK,RST=>RST,INTERWEAVE_EFFECTIVE=>voice_effective,
				   DATA=>voice_receiver_data,EFFECTIVE=>VOICE_PLAYING,PCM_DATA=>PCM_RESTORE_DATA);
end stru;