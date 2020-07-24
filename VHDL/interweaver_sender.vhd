library ieee;
use ieee.std_logic_1164.all;
entity interweaver_sender is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 START:in std_logic;
		 PAUSE:in std_logic;
		 CONV_SELECT:in std_logic;
		 CONFIRM:in std_logic;
		 MODE:in std_logic_vector(2 downto 0);
		 TO_SEND_DATA:in std_logic_vector(7 downto 0);
		 READY:out std_logic;
		 SEND_CLK:out std_logic;
		 WR_MODE:out std_logic_vector(2 downto 0);
		 SEND_INFO:out std_logic_vector(13 downto 0));
end interweaver_sender;
architecture stru of interweaver_sender is
component normal_sender is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 START:in std_logic;
		 PAUSE:in std_logic;
		 CONFIRM:in std_logic;
		 MODE:in std_logic_vector(2 downto 0);
		 TO_SEND_DATA:in std_logic_vector(7 downto 0);
		 READY:out std_logic;
		 SEND_CLK:out std_logic;
		 WR_MODE:out std_logic_vector(2 downto 0);
		 SEND_INFO:out std_logic_vector(12 downto 0));
end component;
component fast_conv_sender is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 START:in std_logic;
		 PAUSE:in std_logic;
		 TO_SEND_DATA:in std_logic_vector(7 downto 0);
		 SEND_CLK:out std_logic;
		 READY:out std_logic;
		 SEND_INFO:out std_logic_vector(12 downto 0));
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
component pause_processor is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 pause_cache:in std_logic;
		 analog_pause:out std_logic);
end component;
signal normal_CLK,fast_conv_CLK,normal_start,fast_conv_start,normal_pause,fast_conv_pause,normal_confirm:std_logic;
signal normal_ready,fast_conv_ready,normal_send_CLK,fast_conv_send_CLK,whether_conv,pause_flag,confirm_flag:std_logic;
signal starting,whether_conv_ena,pause_cache,anti_pause_cache:std_logic;
signal normal_WR_MODE:std_logic_vector(2 downto 0);
signal normal_data,fast_conv_data:std_logic_vector(7 downto 0);
signal normal_info,fast_conv_info,info:std_logic_vector(12 downto 0);
begin
	normal_send:normal_sender port map(CLK=>normal_CLK,RST=>RST,START=>normal_start,PAUSE=>normal_pause,
				CONFIRM=>CONFIRM,MODE=>MODE,TO_SEND_DATA=>normal_data,READY=>normal_ready,
				SEND_CLK=>normal_send_CLK,WR_MODE=>normal_WR_MODE,SEND_INFO=>normal_info);
	fast_conv_send:fast_conv_sender port map(CLK=>fast_conv_CLK,RST=>RST,START=>fast_conv_start,
				   PAUSE=>fast_conv_pause,TO_SEND_DATA=>fast_conv_data,SEND_CLK=>fast_conv_send_CLK,
				   READY=>fast_conv_ready,SEND_INFO=>fast_conv_info);
	confirm_cache:rising_D_trigger port map(CLK=>CONFIRM,RST=>RST,D=>'1',ENA=>'1',Q=>confirm_flag);
	start_cache:rising_D_trigger port map(CLK=>START,RST=>RST,D=>'1',ENA=>confirm_flag,Q=>starting);
	whether_conv_ena<=not(confirm_flag);
	whether_conv_cache:D_latch port map(D=>CONV_SELECT,RST=>RST,ENA=>whether_conv_ena,Q=>whether_conv);
	anti_pause_cache<=not(pause_cache);
	PAUSE_BUTTON_CACHE:rising_D_Trigger port map(CLK=>PAUSE,RST=>RST,D=>anti_pause_cache,ENA=>starting,Q=>pause_cache);
	PAUSE_PROCESSING:pause_processor port map(CLK=>CLK,RST=>RST,pause_cache=>pause_cache,analog_pause=>pause_flag);
	--insight logic
	normal_CLK<=CLK when (whether_conv='0') else 'Z';
	fast_conv_CLK<=CLK when (whether_conv='1') else 'Z';
	normal_pause<=pause_flag when (whether_conv='0') else 'Z';
	fast_conv_pause<=pause_flag when (whether_conv='1') else 'Z';
	normal_start<=starting when (whether_conv='0') else 'Z';
	fast_conv_start<=starting when (whether_conv='1') else 'Z';
	normal_data<=TO_SEND_DATA when (whether_conv='0') else (others=>'Z');
	fast_conv_data<=TO_SEND_DATA when (whether_conv='1') else (others=>'Z');
	--output logic
	READY<=fast_conv_ready when (whether_conv='1') else normal_ready;
	SEND_CLK<=fast_conv_send_CLK when (whether_conv='1') else normal_send_CLK;
	WR_MODE<="111" when (whether_conv='1') else normal_WR_MODE;
	info<=fast_conv_info when (whether_conv='1') else normal_info;
	SEND_INFO<=whether_conv&info;
end stru;