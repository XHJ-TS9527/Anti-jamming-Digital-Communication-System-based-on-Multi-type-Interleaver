library ieee;
use ieee.std_logic_1164.all;
entity real_voice_DSSS_sender is
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
end real_voice_DSSS_sender;
architecture stru of real_voice_DSSS_sender is
component real_voice_DSSS_sender_controller is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 START:in std_logic;
		 STOP:in std_logic;
		 INTERWEAVE_READY:in std_logic;
		 BARK_READY:in std_logic;
		 FRAME_END:in std_logic;
		 RST_M_ORDER:out std_logic;
		 FINISH:out std_logic;
		 START_ORDER:out std_logic;
		 DATA_SEL:out std_logic);
end component;
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
component single_m_sequence31 is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 IN_BIT:in std_logic;
		 M:out std_logic);
end component;
component rising_D_trigger is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 D:in std_logic;
		 ENA:in std_logic;
		 Q:out std_logic;
		 Qbar:out std_logic);
end component;
signal bark_ok,frame_end,m_reset,finish_flag,selection,m,ctrl_bit,rec_flag:std_logic;
signal bark_data,m_s,ds_data:std_logic_vector(7 downto 0);
begin
	CLK_OUT<=CLK;
	START_OUT<=START;
	CONFIRM_OUT<=CONFIRM;
	CONV_SELECT_OUT<=CONV_SELECT;
	MODE_SELECT<=INTERWEAVE_MODE;
	CTRLER:real_voice_DSSS_sender_controller port map(CLK=>CLK,RST=>RST,START=>START,STOP=>STOP,
		   INTERWEAVE_READY=>INTERWEAVE_READY,BARK_READY=>bark_ok,FRAME_END=>frame_end,RST_M_ORDER=>m_reset,
		   FINISH=>finish_flag,DATA_SEL=>selection);
	BARK:bark11_generator port map(CLK=>CLK,RST=>RST,START=>START,FINISH=>finish_flag,INTERWEAVE_READY=>INTERWEAVE_READY,
		 READY=>bark_ok,FRAME_END=>frame_end,BARK11=>bark_data);
	CTR_BIT:rising_D_trigger port map(CLK=>CLK,RST=>RST,D=>bark_ok,ENA=>'1',Q=>ctrl_bit);
	M_SEQ:single_m_sequence31 port map(CLK=>CLK,RST=>m_reset,IN_BIT=>ctrl_bit,M=>m);
	m_s<=(others=>m);
	ds_data<=PCM_DATA xor m_s;
	DATA<=bark_data when (selection='1') else ds_data;
	RECORDING<=rec_flag;
	process(RST,ctrl_bit,STOP)
	begin
		if (RST='0') then rec_flag<='0';
		elsif (ctrl_bit='1') then rec_flag<='1';
		elsif rising_edge(STOP) then rec_flag<='0';
		end if;
	end process;
end stru;