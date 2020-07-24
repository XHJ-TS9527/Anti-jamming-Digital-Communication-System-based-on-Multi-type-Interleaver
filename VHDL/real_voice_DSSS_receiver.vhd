library ieee;
use ieee.std_logic_1164.all;
entity real_voice_DSSS_receiver is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 INTERWEAVE_EFFECTIVE:in std_logic;
		 DATA:in std_logic_vector(7 downto 0);
		 EFFECTIVE:out std_logic;
		 PCM_DATA:out std_logic_vector(7 downto 0));
end real_voice_DSSS_receiver;
architecture stru of real_voice_DSSS_receiver is
component rising_D_trigger is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 D:in std_logic;
		 ENA:in std_logic;
		 Q:out std_logic;
		 Qbar:out std_logic);
end component;
component real_voice_DSSS_receiver_controller is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 INTERWEAVE_EFFECTIVE:in std_logic;
		 BARK_FLAG:in std_logic;
		 USEABLE:out std_logic;
		 CTRL_BIT:out std_logic;
		 M_RESET:out std_logic);
end component;
component single_m_sequence31 is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 IN_BIT:in std_logic;
		 M:out std_logic);
end component;
component bark11_detector is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 DATA_IN:in std_logic_vector(7 downto 0);
		 SYNCHRONIZED_FLAG:out std_logic);
end component;
signal bark_ok,m_reset,ctrl_bit,m:std_logic;
signal data_cache,m_s:std_logic_vector(7 downto 0);
begin
	CTRLER:real_voice_DSSS_receiver_controller port map(CLK=>CLK,RST=>RST,INTERWEAVE_EFFECTIVE=>INTERWEAVE_EFFECTIVE,
		   BARK_FLAG=>bark_ok,USEABLE=>EFFECTIVE,CTRL_BIT=>ctrl_bit,M_RESET=>m_reset);
	BARK:bark11_detector port map(CLK=>CLK,RST=>RST,DATA_IN=>DATA,SYNCHRONIZED_FLAG=>bark_ok);
	M_SEQ:single_m_sequence31 port map(CLK=>CLK,RST=>m_reset,IN_BIT=>ctrl_bit,M=>m);
	m_s<=(others=>m);
	g:for idx in 0 to 7 generate
		d:rising_D_trigger port map(CLK=>CLK,RST=>RST,D=>DATA(idx),ENA=>'1',Q=>data_cache(idx));
	end generate;
	PCM_DATA<=data_cache xor m_s;
end stru;