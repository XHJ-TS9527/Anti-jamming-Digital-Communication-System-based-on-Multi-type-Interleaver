library ieee;
use ieee.std_logic_1164.all;
entity demo_song_sender is
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
end demo_song_sender;
architecture stru of demo_song_sender is
component bark11_generator is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 START:in std_logic;
		 FINISH:in std_logic;
		 INTERWEAVE_READY:in std_logic;
		 READY:out std_logic;
		 FRAME_END:out std_logic;
		 BARK11:out std_logic_vector(7 downto 0));
end component;
component music_Ode_to_Joy_generator is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 BARK_READY:in std_logic;
		 FINISH:out std_logic;
		 SONG_DATA:out std_logic_vector(7 downto 0));
end component;
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
component synchronize_50Mto1Hz_divider is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 CLK_DIV:out std_logic);
end component;
component synchronize_50Mto2Hz_divider is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 CLK_DIV:out std_logic);
end component;
component synchronize_50Mto4Hz_divider is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 CLK_DIV:out std_logic);
end component;
component synchronize_50Mto8Hz_divider is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 CLK_DIV:out std_logic);
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
signal song_CLK,confirm_button,bark_ok,frame_end,song_finish,data_selection,second_CLK,enable_setting_mode:std_logic;
signal div1_CLK,div2_CLK,div4_CLK,div8_CLK,started,started_reset:std_logic;
signal clk_native_mode:std_logic_vector(1 downto 0);
signal bark_data,song_data:std_logic_vector(7 downto 0);
begin
	CLK_OUT<=CLK;
	START_OUT<=START;
	CONFIRM_OUT<=CONFIRM;
	CONV_SELECT_OUT<=CONV_SELECT;
	MODE_SELECT<=INTERWEAVE_MODE;
	CTRLER:demo_song_sender_controller port map(CLK=>CLK,RST=>RST,START=>START,INTERWEAVE_READY=>INTERWEAVE_READY,
		   BARK_READY=>bark_ok,SONG_FINISH=>song_finish,FRAME_END=>frame_end,DATA_SEL=>data_selection);
	BARK:bark11_generator port map(CLK=>CLK,RST=>RST,START=>START,FINISH=>song_finish,INTERWEAVE_READY=>INTERWEAVE_READY,
		 READY=>bark_ok,FRAME_END=>frame_end,BARK11=>bark_data);
	SONG:music_Ode_to_Joy_generator port map(CLK=>song_CLK,RST=>RST,BARK_READY=>bark_ok,FINISH=>song_finish,SONG_DATA=>song_data);
	started_reset<=RST and not(frame_end);
	start_flag:rising_D_trigger port map(CLK=>START,RST=>started_reset,D=>'1',ENA=>'1',Q=>started);
	enable_setting_mode<=not(started);
	mode_cache0:D_latch port map(D=>PACE_MODE_SELECT(0),RST=>RST,ENA=>enable_setting_mode,Q=>clk_native_mode(0));
	mode_cache1:D_latch port map(D=>PACE_MODE_SELECT(1),RST=>RST,ENA=>enable_setting_mode,Q=>clk_native_mode(1));
	divider1:synchronize_50Mto1Hz_divider port map(CLK=>CLK,RST=>RST,CLK_DIV=>div1_CLK);
	divider2:synchronize_50Mto2Hz_divider port map(CLK=>CLK,RST=>RST,CLK_DIV=>div2_CLK);
	divider3:synchronize_50Mto4Hz_divider port map(CLK=>CLK,RST=>RST,CLK_DIV=>div4_CLK);
	divider4:synchronize_50Mto8Hz_divider port map(CLK=>CLK,RST=>RST,CLK_DIV=>div8_CLK);
	--insight logic
	with clk_native_mode select
		second_CLK<=div1_CLK when "00",
					div2_CLK when "01",
					div4_CLK when "10",
					div8_CLK when "11",
					CLK when others;
	song_CLK<=CLK when (EXPERIMENT_MODE='0') else second_CLK;
	--output logic
	DATA<=bark_data when (data_selection='1') else song_data;
end stru;