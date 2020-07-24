library ieee;
use ieee.std_logic_1164.all;
entity real_voice_system is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 START:in std_logic;
		 STOP:in std_logic;
		 CONFIRM:in std_logic;
		 CONV_SELECT:in std_logic;
		 INTERWEAVE_MODE:in std_logic_vector(2 downto 0);
		 PCM_DATA:in std_logic_vector(7 downto 0);
		 RECORDING:out std_logic;
		 EFFECTIVE:out std_logic;
		 PCM_RESTORE_DATA:out std_logic_vector(7 downto 0));
end real_voice_system;
architecture stru of real_voice_system is
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
component real_voice_DSSS_receiver is
	port(CLK:in std_logic;
		 RST:in std_logic;
		 INTERWEAVE_EFFECTIVE:in std_logic;
		 DATA:in std_logic_vector(7 downto 0);
		 EFFECTIVE:out std_logic;
		 PCM_DATA:out std_logic_vector(7 downto 0));
end component;
signal MID_CONFIRM,MID_CONV_SELECT,MID_READY,MID_SEND_CLK,MID_START,MID_CLK,MID_RECEIVE_CLK,MID_EFFECTIVE:std_logic;
signal MID_MODE_SELECT:std_logic_vector(2 downto 0);
signal SEND_DATA,RECEIVE_DATA:std_logic_vector(7 downto 0);
signal MID_INFO:std_logic_vector(13 downto 0);
begin
	SENDER:real_voice_DSSS_sender port map(CLK=>CLK,RST=>RST,START=>START,STOP=>STOP,CONFIRM=>CONFIRM,
		   CONV_SELECT=>CONV_SELECT,INTERWEAVE_READY=>MID_READY,INTERWEAVE_MODE=>INTERWEAVE_MODE,PCM_DATA=>PCM_DATA,
		   CLK_OUT=>MID_SEND_CLK,START_OUT=>MID_START,CONFIRM_OUT=>MID_CONFIRM,CONV_SELECT_OUT=>MID_CONV_SELECT,
		   RECORDING=>RECORDING,MODE_SELECT=>MID_MODE_SELECT,DATA=>SEND_DATA);
	INTERWEAVER0:interweaver port map(CLK=>MID_SEND_CLK,SENDER_RST=>RST,START=>MID_START,
				 PAUSE=>'1',CONV_SELECT=>MID_CONV_SELECT,CONFIRM=>MID_CONFIRM,MODE=>MID_MODE_SELECT,
				 TO_SEND_DATA=>SEND_DATA,READY=>MID_READY,SEND_CLK=>MID_CLK,SEND_INFO=>MID_INFO,
				 RECEIVE_CLK=>MID_CLK,RECEIVER_RST=>RST,RECEIVE_INFO=>MID_INFO,RESTORE_CLK=>MID_RECEIVE_CLK,
				 EFFECTIVE=>MID_EFFECTIVE,RESTORE_DATA=>RECEIVE_DATA);
	RECEIVER:real_voice_DSSS_receiver port map(CLK=>MID_RECEIVE_CLK,RST=>RST,INTERWEAVE_EFFECTIVE=>MID_EFFECTIVE,
			 DATA=>RECEIVE_DATA,EFFECTIVE=>EFFECTIVE,PCM_DATA=>PCM_RESTORE_DATA);
end stru;