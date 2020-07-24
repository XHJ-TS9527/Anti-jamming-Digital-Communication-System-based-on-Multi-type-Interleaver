library ieee;
use ieee.std_logic_1164.all;
entity interweaver_receiver is
	port(RECEIVE_CLK:in std_logic;
		 RST:in std_logic;
		 RECEIVE_INFO:in std_logic_vector(13 downto 0);
		 RESTORE_CLK:out std_logic;
		 EFFECTIVE:out std_logic;
		 FAST_CONV_FLAG:out std_logic;
		 INTERWEAVE_MODE:out std_logic_vector(2 downto 0);
		 RESTORE_DATA:out std_logic_vector(7 downto 0));
end interweaver_receiver;
architecture stru of interweaver_receiver is
component normal_receiver is
	port(RECEIVE_CLK:in std_logic;
		 RST:in std_logic;
		 RECEIVE_INFO:in std_logic_vector(12 downto 0);
		 RESTORE_CLK:out std_logic;
		 EFFECTIVE:out std_logic;
		 INTERWEAVE_MODE:out std_logic_vector(2 downto 0);
		 RESTORE_DATA:out std_logic_vector(7 downto 0));
end component;
component fast_conv_receiver is
	port(RECEIVE_CLK:in std_logic;
		 RST:in std_logic;
		 RECEIVE_INFO:in std_logic_vector(12 downto 0);
		 RESTORE_CLK:out std_logic;
		 EFFECTIVE:out std_logic;
		 RESTORE_DATA:out std_logic_vector(7 downto 0));
end component;
signal normal_receive_CLK,fast_conv_receive_CLK,normal_restore_CLK,fast_conv_restore_CLK,whether_fast_conv:std_logic;
signal normal_effect,fast_conv_effect:std_logic;
signal normal_info,fast_conv_info:std_logic_vector(12 downto 0);
signal normal_data,fast_conv_data:std_logic_vector(7 downto 0);
signal normal_mode:std_logic_vector(2 downto 0);
begin
	normal_receive:normal_receiver port map(RECEIVE_CLK=>normal_receive_CLK,RST=>RST,RECEIVE_INFO=>normal_info,
				   RESTORE_CLK=>normal_restore_CLK,EFFECTIVE=>normal_effect,INTERWEAVE_MODE=>normal_mode,
				   RESTORE_DATA=>normal_data);
	fast_conv_receive:fast_conv_receiver port map(RECEIVE_CLK=>fast_conv_receive_CLK,RST=>RST,RECEIVE_INFO=>fast_conv_info,
					  RESTORE_CLK=>fast_conv_restore_CLK,EFFECTIVE=>fast_conv_effect,RESTORE_DATA=>fast_conv_data);
	--insight logic
	whether_fast_conv<=RECEIVE_INFO(13);
	normal_receive_CLK<=RECEIVE_CLK when (whether_fast_conv='0') else 'Z';
	fast_conv_receive_CLK<=RECEIVE_CLK when (whether_fast_conv='1') else 'Z';
	normal_info<=RECEIVE_INFO(12 downto 0) when (whether_fast_conv='0') else (others=>'Z');
	fast_conv_info<=RECEIVE_INFO(12 downto 0) when (whether_fast_conv='1') else (others=>'Z');
	--output logic
	RESTORE_CLK<=fast_conv_restore_CLK when (whether_fast_conv='1') else normal_restore_CLK;
	EFFECTIVE<=fast_conv_effect when (whether_fast_conv='1') else normal_effect;
	FAST_CONV_FLAG<=whether_fast_conv;
	INTERWEAVE_MODE<="111" when (whether_fast_conv='1') else normal_mode;
	RESTORE_DATA<=fast_conv_data when (whether_fast_conv='1') else normal_data;
end stru;